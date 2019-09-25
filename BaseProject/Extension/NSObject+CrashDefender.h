//
//  NSObject+CrashDefender.h
//  BaseProject
//
//  Created by 沙庭宇 on 2019/9/24.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CrashDefender)

/// 交换类函数
+ (void)bpDefenderSwizzlingClassMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector withClass:(Class)targetClass;

/// 交换实例函数
+ (void)bpDefenderSwizzlingInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector withClass:(Class)targetClass;

@end

NS_ASSUME_NONNULL_END
