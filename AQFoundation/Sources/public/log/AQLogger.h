//
//  AQLogger.h
//  AQLog
//
//  Created by madding.lip on 15/7/7.
//  //  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AQSingleton.h"

#undef AQ_DEBUG
#define AQ_DEBUG(...) \
  [[AQLogger sharedInstance] log:AQLogLevelDebug format:__VA_ARGS__];

#undef AQ_INFO
#define AQ_INFO(...) \
  [[AQLogger sharedInstance] log:AQLogLevelInfo format:__VA_ARGS__];

#undef AQ_PERF
#define AQ_PERF(...) \
  [[AQLogger sharedInstance] log:AQLogLevelPerf format:__VA_ARGS__];

#undef AQ_WARN
#define AQ_WARN(...) \
  [[AQLogger sharedInstance] log:AQLogLevelWarn format:__VA_ARGS__];

#undef AQ_ERROR
#define AQ_ERROR(...) \
  [[AQLogger sharedInstance] log:AQLogLevelError format:__VA_ARGS__];

#undef AQ_FUNC
#define AQ_FUNC \
  [[AQLogger sharedInstance] log:AQLogLevelDebug format:__FUNCTION__];

typedef enum {
  AQLogLevelDebug = 0,
  AQLogLevelInfo = 1,
  AQLogLevelPerf = 2,
  AQLogLevelWarn = 3,
  AQLogLevelError = 4,
  AQLogLevelNone = 5
} AQLogLevel;

@interface AQLogger : NSObject

AQ_DEC_SINGLETON

@property(nonatomic, assign) BOOL showLevel;
@property(nonatomic, assign) BOOL showModule;
@property(nonatomic, assign) NSUInteger indentTabs;

- (void)indent;
- (void)indent:(NSUInteger)tabs;
- (void)unindent;
- (void)unindent:(NSUInteger)tabs;

- (void)log:(AQLogLevel)level format:(NSString *)format, ...;

- (void)log:(AQLogLevel)level format:(NSString *)format args:(va_list)args;

@end

