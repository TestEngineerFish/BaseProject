//
//  NSArray+CrashDefender.m
//  BaseProject
//
//  Created by 沙庭宇 on 2019/9/24.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

#import "NSArray+CrashDefender.h"
#import <objc/runtime.h>
#import "NSObject+CrashDefender.h"
#import "NSObject+CrashDefender.h"

@implementation NSArray (CrashDefender)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 替换 OC 中的 objectAtIndex: 函数
        [NSObject bpDefenderSwizzlingInstanceMethod:@selector(objectAtIndex:)
                                         withMethod:@selector(bpObjectAtIndex:)
                                          withClass:NSClassFromString(@"__NSArrayI")];
        // 替换 OC 中的 objectAtIndexedSubscript: 函数
        [NSObject bpDefenderSwizzlingInstanceMethod:@selector(objectAtIndexedSubscript:)
                                         withMethod:@selector(bpOCObjectAtIndexedSubscript:)
                                          withClass:NSClassFromString(@"__NSArrayI")];
        // 替换 Swift 中使用下标取值的函数 (Swift中通过索引也是该函数,所以不用定义两个)
        [NSObject bpDefenderSwizzlingInstanceMethod:@selector(objectAtIndex:)
                                                withMethod:@selector(bpSwiftObjectAtIndexedSubscript:)
                                                 withClass:NSClassFromString(@"__NSSingleObjectArrayI")];
    });
}

///  自定义 OC 通过索引值获取值函数
/// @param index 索引值
- (id)bpObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self bpObjectAtIndex:index];
    } else {
        NSLog(@"Array out of bounds, index is [%zu], current array max count is [%zu]", index, self.count);
    }
    return nil;
}

/// 自定义 OC 通过下标获取值函数
/// @param idx 下标索引值
- (id)bpOCObjectAtIndexedSubscript:(NSUInteger)idx {
    if (idx < self.count) {
        return [self bpOCObjectAtIndexedSubscript:idx];
    } else {
        NSLog(@"Array out of bounds, index is [%zu], current array max count is [%zu]", idx, self.count);
    }
    return nil;
}

/// 自定义 Swift 通过下标获取值函数
/// @param index 下标索引值
- (id)bpSwiftObjectAtIndexedSubscript:(NSUInteger)index {
    if (index < self.count) {
        return [self bpSwiftObjectAtIndexedSubscript:index];
    } else {
        NSLog(@"Array out of bounds, index is [%zu], current array max count is [%zu]", index, self.count);
    }
    return nil;
}
@end
