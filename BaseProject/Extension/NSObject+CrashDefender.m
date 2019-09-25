//
//  NSObject+CrashDefender.m
//  BaseProject
//
//  Created by 沙庭宇 on 2019/9/24.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

#import "NSObject+CrashDefender.h"
#import <objc/runtime.h>

#pragma mark - BPKVOProxy(KVO代理)

@interface BPKVOProxy : NSObject

/// 获得所有被观察的KeyPaths
- (NSArray<NSString *> *)getAllKeyPaths;

@end

@implementation BPKVOProxy
{
@private NSMutableDictionary<NSString *, NSHashTable<NSObject *> *> *_kvoInfoMap;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _kvoInfoMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSArray<NSString *> *)getAllKeyPaths {
    NSArray<NSString *> *keyPaths = _kvoInfoMap.allKeys;
    return keyPaths;
}

/// 添加KVO
/// @param observer 接收通知对象
/// @param keyPath 通知时的路径名,不可为空
/// @param options 观察的选项值的组合
/// @param context 通知时传递的内容
/// @returns 是否添加成功
- (BOOL)addInfoToMapWithObserver: (NSObject *)observer
                      forKeyPath: (NSString *)keyPath
                         options: (NSKeyValueObservingOptions)options
                         context: (void *)context {
    @synchronized (_kvoInfoMap) {
        // 过滤无效observer和keyPath
        if (!observer || !keyPath || ([keyPath isKindOfClass:[NSString class]] && keyPath.length <= 0)) {
            return NO;
        }
        NSHashTable<NSObject *> *info = _kvoInfoMap[keyPath];
        if (info.count == 0) {
            info = [[NSHashTable alloc] initWithOptions:(NSPointerFunctionsWeakMemory) capacity:0];
            [info addObject:observer];
            _kvoInfoMap[keyPath] = info;
        }
        if (![info containsObject:observer]) {
            [info addObject:observer];
        } else {
            NSString *className = NSStringFromClass(self.class) == nil ? @"Not Found Class" : NSStringFromClass(self.class);
            NSString *reason    = [NSString stringWithFormat:@"KVO Error: Repeated additions to the observer [%@] for the key path [%@] from class [%@]", observer, keyPath, className];
            NSLog(@"%@", reason);
            return NO;
        }
        return YES;
    }
}

/// 移除KVO通知对象
/// @param observer 需要移除的通知对象
/// @param keyPath 通知时的路径名,不可为空
/// @returns 是否移除成功
- (BOOL)removeInfoInMapWithObserver: (NSObject *)observer
                         forKeyPath: (NSString *)keyPath {
    @synchronized (_kvoInfoMap) {
        // 过滤无效observer和keyPath
        if (!observer || !keyPath || ([keyPath isKindOfClass:[NSString class]] && keyPath.length <= 0)) {
            return NO;
        }
        NSHashTable<NSObject *> *info = _kvoInfoMap[keyPath];
        if ([info containsObject:observer]) {
            [info removeObject:observer];
        } else {
            NSString *className = NSStringFromClass(self.class) == nil ? @"Not Found Class" : NSStringFromClass(self.class);
            NSString *reason    = [NSString stringWithFormat:@"KVO Error: Cannot remove an observer [%@] for the key path [%@] from class [%@], because it is not registered as an observer", observer, keyPath, className];
            NSLog(@"%@", reason);
            return NO;
        }
        // 如果keyPath没有对应的通知对象,则从哈希表中移除
        if (info.count == 0) {
            [_kvoInfoMap removeObjectForKey:keyPath];
        }
        return YES;
    }
}

/// 移除KVO通知对象
/// @param observer 需要移除的通知对象
/// @param keyPath 通知时的路径名,不可为空
/// @param context 通知时传递的内容
/// @returns 是否移除成功
- (BOOL)removeInfoInMapWithObserver: (NSObject *)observer
                         forKeyPath: (NSString *)keyPath
                            context: (void *)context {
    @synchronized (_kvoInfoMap) {
        // 过滤无效observer和keyPath
        if (!observer || !keyPath || ([keyPath isKindOfClass:[NSString class]] && keyPath.length <= 0)) {
            return NO;
        }
        NSHashTable<NSObject *> *info = _kvoInfoMap[keyPath];
        if ([info containsObject:observer]) {
            [info removeObject:observer];
        } else {
            NSString *className = NSStringFromClass(self.class) == nil ? @"Not Found Class" : NSStringFromClass(self.class);
            NSString *reason    = [NSString stringWithFormat:@"KVO Error: Cannot remove an observer [%@] for the key path [%@] from class [%@], because it is not registered as an observer", observer, keyPath, className];
            NSLog(@"%@", reason);
            return NO;
        }
        // 如果keyPath没有对应的通知对象,则从哈希表中移除
        if (info.count == 0) {
            [_kvoInfoMap removeObjectForKey:keyPath];
        }
        return YES;
    }
}

// 实际观察者,在NSObject的分类中,会通过Runtime进行函数替换系统的KVO通知函数
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSHashTable<NSObject *> *info = _kvoInfoMap[keyPath];
    for (NSObject *observer in info) {
        @try {
            [observer observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        } @catch (NSException *exception) {
            NSString *reason = [NSString stringWithFormat:@"KVO Error: %@", [exception description]];
            NSLog(@"%@", reason);
        }
    }
}

@end

@implementation NSObject (CrashDefender)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

//        // ---- 交换消息转发函数 ----
        [NSObject bpDefenderSwizzlingClassMethod:@selector(forwardingTargetForSelector:)
                                      withMethod:@selector(bpForwardingClassTargetForSelect:)
                                       withClass:[NSObject class]];
        [NSObject bpDefenderSwizzlingInstanceMethod:@selector(forwardingTargetForSelector:)
                                         withMethod:@selector(bpForwardingInstanceTargetForSelect:)
                                          withClass:[NSObject class]];
        // ---- 交换KVO函数 ----
        [NSObject bpDefenderSwizzlingInstanceMethod:@selector(addObserver:forKeyPath:options:context:)
                                         withMethod:@selector(bpAddObserver:forKeyPath:options:context:)
                                          withClass:[NSObject class]];
        [NSObject bpDefenderSwizzlingInstanceMethod:@selector(removeObserver:forKeyPath:)
                                         withMethod:@selector(bpRemoveObserver:forKeyPath:)
                                          withClass:[NSObject class]];
        [NSObject bpDefenderSwizzlingInstanceMethod:@selector(removeInfoInMapWithObserver:forKeyPath:context:)
                                         withMethod:@selector(bpRemoveObserver:forKeyPath:context:)
                                          withClass:[NSObject class]];
        // ---- 交换KVC函数 ----
        [NSObject bpDefenderSwizzlingInstanceMethod:@selector(setValue:forKey:)
                                         withMethod:@selector(bpSetValue:forKey:)
                                          withClass:[NSObject class]];
    });
}

#pragma mark - KVO相关

static void *BPKVOProxyKey  = &BPKVOProxyKey;
static void *KVODefenderKey = &KVODefenderKey;
static NSString *const KVODefenderValue = @"BP_KVODefender";

- (void)setBpKVOProxy: (BPKVOProxy *)bpKVOProxy {
    objc_setAssociatedObject(self, BPKVOProxyKey, bpKVOProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BPKVOProxy *)bpKVOProxy {
    id proxy = objc_getAssociatedObject(self, BPKVOProxyKey);
    if (proxy == nil) {
        proxy = [[BPKVOProxy alloc] init];
        [self setBpKVOProxy:proxy];
    }
    return proxy;
}

/// 自定义添加通知,在添加前,会先通过 BPKVOProxy 里的哈希表检查是否有效
- (void)bpAddObserver:(NSObject *)observer
         forKeyPath:(NSString *)keyPath
            options:(NSKeyValueObservingOptions)options
            context:(void *)context {
    // 如果是系统类,则直接调用系统函数
    if (isSystemClass(self.class)) {
        [self bpAddObserver:observer forKeyPath:keyPath options:options context:context];
    } else {
        objc_setAssociatedObject(self, KVODefenderKey, KVODefenderValue, OBJC_ASSOCIATION_RETAIN);
        BOOL issucceed = [[self bpKVOProxy] addInfoToMapWithObserver:observer forKeyPath:keyPath options:options context:context];
        if (issucceed) {
            // 如果添加成功,则再调用系统函数,防止重复添加
            [self bpAddObserver:observer forKeyPath:keyPath options:options context:context];
        }
    }
}

/// 自定义移除通知,在移除前,会先通过 BPKVOProxy 里的哈希表检查是否有效
- (void)bpRemoveObserver:(NSObject *)observer
            forKeyPath:(NSString *)keyPath {
    // 如果是系统类,则直接调用系统函数
    if (isSystemClass(self.class)) {
        [self bpRemoveObserver:observer forKeyPath:keyPath];
    } else {
        BOOL isSucceed = [[self bpKVOProxy] removeInfoInMapWithObserver:observer forKeyPath:keyPath];
        if (isSucceed) {
            // 如果删除成功,则再调用系统函数,防止删除未注册的通知
            [self bpRemoveObserver:observer forKeyPath:keyPath];
        }
    }
}

/// 自定义移除通知,在移除前,会先通过 BPKVOProxy 里的哈希表检查是否有效
- (void)bpRemoveObserver:(NSObject *)observer
            forKeyPath:(NSString *)keyPath
               context:(void *)context {
    // 如果是系统类,则直接调用系统函数
    if (isSystemClass(self.class)) {
        [self bpRemoveObserver:observer forKeyPath:keyPath context:context];
    } else {
        BOOL isSucceed = [[self bpKVOProxy] removeInfoInMapWithObserver:observer forKeyPath:keyPath context:context];
        if (isSucceed) {
            // 如果删除成功,则再调用系统函数,防止删除未注册的通知
            [self bpRemoveObserver:observer forKeyPath:keyPath context:context];
        }
    }
}

/// 自定义 dealloc 函数,注销前判断是否有未移除的KVO对象
- (void)dpDealloc
{
    @autoreleasepool {
        if (!isSystemClass(self.class)) {
            NSString *value = objc_getAssociatedObject(self, KVODefenderKey);
            if ([value isEqualToString:KVODefenderValue]) {
                NSArray *keyPaths = [[self bpKVOProxy] getAllKeyPaths];
                // 如果 dealloc 前,仍然有注册的 Observer,则移除
                if (keyPaths.count > 0) {
                    NSString *reason = [NSString stringWithFormat:@"KVO Error: An instance [%@] was deallocated while key value observers were still registered with it. The keyPaths is [%@]", self, [keyPaths componentsJoinedByString:@","]];
                    NSLog(@"%@", reason);
                }
                for (NSString *keyPath in keyPaths) {
                    [self bpRemoveObserver:[self bpKVOProxy] forKeyPath:keyPath];
                }
            }
        }
        // 最后别忘了调用系统函数
        [self dpDealloc];
    }
}

#pragma mark - KVC相关

/// 自定义setValue函数,检测key不为空
- (void)bpSetValue:(id)value forKey:(NSString *)key {
    if (key == nil) {
        NSString *reason = [NSString stringWithFormat:@"KVC Error: Could not set nil as the value for key, from class [%@]", NSStringFromClass([self class])];
        NSLog(@"%@", reason);
        return;
    }
    [self bpSetValue:value forKey:key];
}

/// 覆写函数,防止Crash
- (void)setNilValueForKey:(NSString *)key {
    NSString *reason = [NSString stringWithFormat:@"KVC Error: Could not set nil as the value for value, from class [%@]", NSStringFromClass([self class])];
    NSLog(@"%@", reason);
}

/// 覆写函数,防止Crash
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSString *reason = [NSString stringWithFormat:@"KVC Error: This class [%@] did not find matching key [%@], with set value function", NSStringFromClass([self class]), key];
    NSLog(@"%@", reason);
}

/// 覆写函数,防止Crash
- (id)valueForUndefinedKey:(NSString *)key {
    NSString *reason = [NSString stringWithFormat:@"KVC Error: This class [%@] did not find matching key [%@], with get value function", NSStringFromClass([self class]), key];
    NSLog(@"%@", reason);
    return self;
}

#pragma mark - 消息转发相关

/// 解决找不到类函数的具体实现而发生的崩溃
/// @param aSelector 方法对象
+ (id)bpForwardingClassTargetForSelect:(SEL)aSelector {

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

    return [self bpForwardingClassTargetForSelect:aSelector];
}

/// 解决找不到实例函数的具体实现而发生的崩溃
/// @param aSelector 方法对象
+ (id)bpForwardingInstanceTargetForSelect:(SEL)aSelector {

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
        NSLog(@"出错类: %@, \n未处理类函数: %@", errorClassName, errorSel);

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

    return [self bpForwardingInstanceTargetForSelect:aSelector];
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
        // 覆盖掉原函数的实现和属性
        class_replaceMethod(class, originalSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

/// 判断是否是系统类
/// @param cls 类对象
static inline BOOL isSystemClass(Class cls) {
    BOOL isSystom = NO;
    NSString *className = NSStringFromClass(cls);
    if ([className hasPrefix:@"NS"] || [className hasPrefix:@"__NS"] || [className hasPrefix:@"OS_xpc"]) {
        isSystom = YES;
    } else {
        NSBundle *mainBundle = [NSBundle bundleForClass:cls];
        if (mainBundle == [NSBundle mainBundle]) {
            isSystom = NO;
        } else {
            isSystom = YES;
        }
    }
    return isSystom;
}


@end
