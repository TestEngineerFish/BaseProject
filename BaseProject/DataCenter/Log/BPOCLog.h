//
//  BPOCLog.h
//  BaseProject
//
//  Created by 沙庭宇 on 2020/4/20.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaLumberjack/CocoaLumberjack.h"
@interface BPOCLog : NSObject

@property (nonatomic, strong) DDFileLogger *loggerFoRequest;
@property (nonatomic, strong) DDFileLogger *loggerForEvent;

+ (instancetype)shared;
// 启动日志
- (void)launch;
// 提供给Swift函数调用
- (void)requestLog:(NSString *)msg;
- (void)eventLog:(NSString *)msg;

@end
