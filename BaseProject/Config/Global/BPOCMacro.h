//
//  BPOCMacro.h
//  BaseProject
//
//  Created by 沙庭宇 on 2020/4/20.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

#ifndef BPOCMacro_h
#define BPOCMacro_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#endif /* BPOCMacro_h */

/**  Logger */
#import <CocoaLumberjack/CocoaLumberjack.h>

#define LOG_FLAG_REQUEST (1 << 5) // 0...0100000
#define LOG_FLAG_EVENT   (1 << 6) // 0...1000000
#define LOG_FLAG_SOCKET  (1 << 7) // 0...0010000

#define LOG_CONTEXT_REQUEST 1
#define LOG_CONTEXT_EVENT   2
#define LOG_CONTEXT_SOCKET  3

#define BPRequestLog(frmt, ...)  LOG_MAYBE(YES, ddLogLevel, LOG_FLAG_REQUEST,  LOG_CONTEXT_REQUEST, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define BPSocketLog(frmt, ...)   LOG_MAYBE(YES, ddLogLevel, LOG_FLAG_SOCKET,   LOG_CONTEXT_SOCKET,  nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define BPLog(frmt, ...)         LOG_MAYBE(YES, ddLogLevel, LOG_FLAG_EVENT,    LOG_CONTEXT_EVENT,   nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

// Now we decide which flags we want to enable in our application

#define LOG_FLAG_TIMERS (LOG_FLAG_REQUEST | LOG_FLAG_EVENT | LOG_FLAG_SOCKET)
// 可能会报类型错误，所以用(DDLogLevel)强转一下
#ifdef DEBUG
static const DDLogLevel ddLogLevel = (DDLogLevel)(DDLogLevelInfo | LOG_FLAG_TIMERS);
#else
static const DDLogLevel ddLogLevel = (DDLogLevel)(DDLogLevelInfo | LOG_FLAG_TIMERS);
#endif
