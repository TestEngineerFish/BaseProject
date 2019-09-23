//
//  NSObject+SelectorDefender.m
//  BaseProject
//
//  Created by 沙庭宇 on 2019/9/23.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

#import "NSObject+SelectorDefender.h"
#import <objc/runtime.h>

@implementation NSObject (SelectorDefender)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 交换类函数
        [NSObject bpDefenderSwizzlingClassMethod:@selector(forwardingTargetForSelector:)
                                      withMethod:@selector(bpForwardingTargetForSelect:)
                                       withClass:[NSObject class]];
        // 交换实例函数
        [NSObject bpDefenderSwizzlingInstanceMethod:@selector(forwardingTargetForSelector:)
                                         withMethod:@selector(bpForwardingTargetForSelect:)
                                          withClass:[NSObject class]];
    });
}

/// 解决找不到实例函数的具体实现而发生的崩溃
/// @param aSelector 方法对象
+ (id)bpForwardingTargetForSelect:(SEL)aSelector {

    // 第一步: 判断是否实现了消息接收者重定向
    SEL forwardingSel = @selector(forwardingTargetForSelector:);
    Method originalForwardingMethod = class_getClassMethod([NSObject class], forwardingSel);
    Method newForwardingMethod      = class_getClassMethod([self class], forwardingSel);
    BOOL isRewrite = method_getImplementation(originalForwardingMethod) != method_getImplementation(newForwardingMethod);
    if (!isRewrite) {
        // 第二步: 判断是否实现了消息重定向
        SEL methodSignatureSel = @selector(methodSignatureForSelector:);
        Method originalMethodSignatureMethod = class_getClassMethod([NSObject class], methodSignatureSel);
        Method newMethodSignatureMethod      = class_getClassMethod([self class], methodSignatureSel);
        isRewrite = method_getImplementation(originalMethodSignatureMethod) != method_getImplementation(newMethodSignatureMethod);
    }
    if (!isRewrite) {
        // 第三步: 都没有实现,则动态添加函数到目标类
        NSString *errorClassName = NSStringFromClass([self class]);
        NSString *errorSel       = NSStringFromSelector(aSelector);
        NSLog(@"出错类: %@, \n未处理类函数: %@", errorClassName, errorSel);

        NSString *className = @"BPCrashClass";
        Class bpCrashClass = NSClassFromString(className);
        if (!bpCrashClass) {
            Class objClass = [NSObject class];
            bpCrashClass = objc_allocateClassPair(objClass, className.UTF8String, 0);
            objc_registerClassPair(bpCrashClass);
        }
        // 将动态添加的函数添加到目标类上
        if (!class_getClassMethod(bpCrashClass, aSelector)) {
            class_addMethod(bpCrashClass, aSelector, (IMP)Crash, "@@:@");
        }
        return [[bpCrashClass alloc] init];
    }

    return [self bpForwardingTargetForSelect:aSelector];
}

/// 解决找不到实例函数的具体实现而发生的崩溃
/// @param aSelector 方法对象
- (id)bpForwardingTargetForSelect:(SEL)aSelector {

    // 第一步: 判断是否实现了消息接收者重定向
    SEL forwardingSel = @selector(forwardingTargetForSelector:);
    Method originalForwardingMethod = class_getInstanceMethod([NSObject class], forwardingSel);
    Method newForwardingMethod      = class_getInstanceMethod([self class], forwardingSel);
    BOOL isRewrite = method_getImplementation(originalForwardingMethod) != method_getImplementation(newForwardingMethod);
    if (!isRewrite) {
        // 第二步: 判断是否实现了消息重定向
        SEL methodSignatureSel = @selector(methodSignatureForSelector:);
        Method originalMethodSignatureMethod = class_getInstanceMethod([NSObject class], methodSignatureSel);
        Method newMethodSignatureMethod      = class_getInstanceMethod([self class], methodSignatureSel);
        isRewrite = method_getImplementation(originalMethodSignatureMethod) != method_getImplementation(newMethodSignatureMethod);
    }
    if (!isRewrite) {
        // 第三步: 都没有实现,则动态添加函数到目标类
        NSString *errorClassName = NSStringFromClass([self class]);
        NSString *errorSel       = NSStringFromSelector(aSelector);
        NSLog(@"出错类: %@, \n未处理实例函数: %@", errorClassName, errorSel);

        NSString *className = @"BPCrashClass";
        Class bpCrashClass = NSClassFromString(className);
        if (!bpCrashClass) {
            Class objClass = [NSObject class];
            bpCrashClass = objc_allocateClassPair(objClass, className.UTF8String, 0);
            objc_registerClassPair(bpCrashClass);
        }
        // 将动态添加的函数添加到目标类上
        if (!class_getInstanceMethod(bpCrashClass, aSelector)) {
            class_addMethod(bpCrashClass, aSelector, (IMP)Crash, "@@:@");
        }
        return [[bpCrashClass alloc] init];
    }
    
    return [self bpForwardingTargetForSelect:aSelector];
}

/// 动态添加的函数实现,防止Crash
/// @param selector 函数选择器
static int Crash(id self, SEL selector) {
    return 0;
}

// MARK: 工具函数

/// 交换类函数
+ (void)bpDefenderSwizzlingClassMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector withClass:(Class)targetClass {
    swizzlingClassMethod(targetClass, originalSelector, swizzledSelector);
}

/// 交换实例函数
+ (void)bpDefenderSwizzlingInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector withClass:(Class)targetClass {
    swizzlingInstanceMethod(targetClass, originalSelector, swizzledSelector);
}

/// 交换类函数
/// @param class 目标类
/// @param originalSelector 原始函数
/// @param swizzledSelector 目标函数
void swizzlingClassMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    // 添加函数
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        // 覆盖掉原函数的实现和属性
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

/// 交换实例函数
/// @param class 目标类
/// @param originalSelector 原始函数
/// @param swizzledSelector 目标函数
void swizzlingInstanceMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    // 添加函数
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        // 覆盖i掉原函数的实现和属性
        class_replaceMethod(class, originalSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


@end
