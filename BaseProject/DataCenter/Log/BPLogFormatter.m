//
//  BPLogFormatter.m
//  BaseProject
//
//  Created by 沙庭宇 on 2020/4/20.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

#import "BPLogFormatter.h"
#import "NSDate+Extension.h"

@implementation BPLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {

    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"❌Error";     break;
        case DDLogFlagWarning  : logLevel = @"Warning";     break;
        case DDLogFlagInfo     : logLevel = @"Info";        break;
        case DDLogFlagDebug    : logLevel = @"Debug";       break;
        case DDLogFlagVerbose  : logLevel = @"Verbose";     break;
        default                : logLevel = @"Default";     break;
    }

    NSDate *date         = logMessage->_timestamp;
//    NSTimeZone *zone     = [NSTimeZone systemTimeZone];
//    NSTimeInterval time  = [zone secondsFromGMTForDate:date];
//    NSDate *nowDate      = [date dateByAddingTimeInterval:time];
    NSString *newDate = [date stringWithFormat:NSDate.ymdHmsFormat];

    NSString *message = [NSString stringWithFormat:@"%@ | 【%@】%@", newDate, logLevel, logMessage->_message];
    DDLogMessage *newLogMessage = [[DDLogMessage alloc] initWithMessage:message level:logMessage.level flag:logMessage.flag context:logMessage.context file:logMessage.file function:logMessage.function line:logMessage.line tag:logMessage.tag options:logMessage.options timestamp:logMessage.timestamp];
    return [super formatLogMessage:newLogMessage];
}

@end
