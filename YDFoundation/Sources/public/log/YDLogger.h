//
//  YDLogger.h
//  YDLog
//
//  Created by madding.lip on 15/7/7.
//  //  Copyright (c) 2015 yudao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YDSingleton.h"

#undef YD_DEBUG
#define YD_DEBUG(...) \
  [[YDLogger sharedInstance] log:YDLogLevelDebug format:__VA_ARGS__];

#undef YD_INFO
#define YD_INFO(...) \
  [[YDLogger sharedInstance] log:YDLogLevelInfo format:__VA_ARGS__];

#undef YD_PERF
#define YD_PERF(...) \
  [[YDLogger sharedInstance] log:YDLogLevelPerf format:__VA_ARGS__];

#undef YD_WARN
#define YD_WARN(...) \
  [[YDLogger sharedInstance] log:YDLogLevelWarn format:__VA_ARGS__];

#undef YD_ERROR
#define YD_ERROR(...) \
  [[YDLogger sharedInstance] log:YDLogLevelError format:__VA_ARGS__];

#undef YD_FUNC
#define YD_FUNC \
  [[YDLogger sharedInstance] log:YDLogLevelDebug format:__FUNCTION__];

#ifndef logFunc
  #ifdef DEBUG
    #define logFunc [YDLogFuncitonInvoke invokeWithName:__FUNCTION__];
  #else
    #define logFunc
  #endif
#endif

typedef enum {
  YDLogLevelDebug = 0,
  YDLogLevelInfo = 1,
  YDLogLevelPerf = 2,
  YDLogLevelWarn = 3,
  YDLogLevelError = 4,
  YDLogLevelNone = 5
} YDLogLevel;

@interface YDLogger : NSObject

YD_DEC_SINGLETON

@property(nonatomic, assign) BOOL showLevel;
@property(nonatomic, assign) BOOL showModule;
@property(nonatomic, assign) NSUInteger indentTabs;

- (void)indent;
- (void)indent:(NSUInteger)tabs;
- (void)unindent;
- (void)unindent:(NSUInteger)tabs;

- (void)log:(YDLogLevel)level format:(NSString *)format, ...;

- (void)log:(YDLogLevel)level format:(NSString *)format args:(va_list)args;

@end

