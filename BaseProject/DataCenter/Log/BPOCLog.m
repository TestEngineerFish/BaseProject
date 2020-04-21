//
//  BPOCLog.m
//  BaseProject
//
//  Created by 沙庭宇 on 2020/4/20.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

#import "BPOCLog.h"
#import "DDLegacyMacros.h"
#import "BPLogFormatter.h"

@implementation BPOCLog

- (void)requestLog:(NSString *)msg {
    BPRequestLog(@"*\n%@", msg);
}

- (void)eventLog:(NSString *)msg {
    BPLog(@"%@", msg);
}

+ (instancetype)shared {
    static BPOCLog *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[BPOCLog alloc]init];
    });
    return shared;
}

- (void)launch {
    NSString *logsDirectory = [[DDFileLogger alloc] init].logFileManager.logsDirectory;
    // 网络请求
    DDLogFileManagerDefault *fileManagerForRequest = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:[logsDirectory stringByAppendingPathComponent:@"Request"]];
    self.loggerFoRequest = [[DDFileLogger alloc] initWithLogFileManager:fileManagerForRequest];
    BPLogFormatter *formatterForRequest = [[BPLogFormatter alloc] init];
    [formatterForRequest addToWhitelist:LOG_CONTEXT_REQUEST];
    [self.loggerFoRequest setLogFormatter:formatterForRequest];
    self.loggerFoRequest.maximumFileSize = 1024 * 1024 * 1;
    self.loggerFoRequest.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:self.loggerFoRequest withLevel:DDLogLevelVerbose | LOG_FLAG_REQUEST];
    // 普通日志
    DDLogFileManagerDefault *fileManagerForEvent = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:[logsDirectory stringByAppendingPathComponent:@"Event"]];
    self.loggerForEvent = [[DDFileLogger alloc] initWithLogFileManager:fileManagerForEvent];
    BPLogFormatter *formatterForEvent = [[BPLogFormatter alloc] init];
    [formatterForEvent addToWhitelist:LOG_CONTEXT_EVENT];
    [self.loggerForEvent setLogFormatter:formatterForEvent];
    self.loggerForEvent.maximumFileSize = 1024 * 1024 * 1;
    self.loggerForEvent.logFileManager.maximumNumberOfLogFiles = 5;
    [DDLog addLogger:self.loggerForEvent withLevel:DDLogLevelVerbose | LOG_FLAG_EVENT];
    // 控制台输出
    [DDLog addLogger:[DDOSLogger sharedInstance] withLevel:DDLogLevelInfo | LOG_FLAG_EVENT];
}

@end


