//
//  YDLogger.m
//  YDLog
//
//  Created by madding.lip on 15/7/7.
//  //  Copyright (c) 2015 yudao. All rights reserved.
//

#import "YDLogger.h"

#import <UIKit/UIKit.h>

#import "YDDevice.h"
#import "YDCompile.h"

@interface YDLogger ()

- (void)printLogHeader;

@end

@implementation YDLogger

YD_DEF_SINGLETON

- (id)init {
  self = [super init];
  if (self) {
    [self setShowLevel:YES];
    [self setShowModule:YES];
    [self setIndentTabs:0];
    [self printLogHeader];
  }
  return self;
}

- (void)printLogHeader {
  NSString *homePath = [NSBundle mainBundle].bundlePath;
  homePath =
      [homePath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
  fprintf(stderr, "====================YDFoundation========================\n");
  fprintf(stderr, "KVersion:  %s \n", [YD_FOUNDATION_VERSION UTF8String]);
  fprintf(stderr, "OSVersion: %s	\n",
          [[YDDevice osVersion] UTF8String]);
  fprintf(stderr, "Device:    %s	\n",
          [[YDDevice deviceModel] UTF8String]);
  fprintf(stderr, "Home:      %s	\n", [homePath UTF8String]);
  fprintf(stderr, "======================================================\n");
}

- (void)indent {
  _indentTabs += 1;
}

- (void)indent:(NSUInteger)tabs {
  _indentTabs += tabs;
}

- (void)unindent {
  if (_indentTabs > 0) {
    _indentTabs -= 1;
  }
}

- (void)unindent:(NSUInteger)tabs {
  if (_indentTabs < tabs) {
    _indentTabs = 0;
  } else {
    _indentTabs -= tabs;
  }
}

- (void)log:(YDLogLevel)level format:(NSString *)format, ... {
  if (nil == format || NO == [format isKindOfClass:[NSString class]]) return;
  va_list args;
  va_start(args, format);
  [self log:level format:format args:args];
  va_end(args);
}

- (void)log:(YDLogLevel)level format:(NSString *)format args:(va_list)args {
  NSMutableString *text = [NSMutableString string];
  NSMutableString *tabs = nil;
  if (_indentTabs > 0) {
    tabs = [NSMutableString string];
    for (int i = 0; i < _indentTabs; ++i) {
      [tabs appendString:@"\t"];
    }
  }

  NSString *module = nil;
  if (self.showLevel || self.showModule) {
    NSMutableString *tmp = [NSMutableString string];
    if (self.showLevel) {
      if (YDLogLevelDebug == level) {
        [tmp appendString:@"[DEBUG]"];
      } else if (YDLogLevelInfo == level) {
        [tmp appendString:@"[INFO]"];
      } else if (YDLogLevelPerf == level) {
        [tmp appendString:@"[PERF]"];
      } else if (YDLogLevelWarn == level) {
        [tmp appendString:@"[WARN]"];
      } else if (YDLogLevelError == level) {
        [tmp appendString:@"[ERROR]"];
      } else {
        [tmp appendString:@"[PRINT]"];
      }
    }

    if (self.showModule) {
      if (module && module.length) {
        [tmp appendFormat:@" [%@]", module];
      }
    }

    if (tmp.length) {
      NSString *tmp2 =
          [tmp stringByPaddingToLength:((tmp.length / 8) + 1) * 8
                             withString:@" "
                        startingAtIndex:0];
      [text appendString:tmp2];
    }
  }

  if (tabs && tabs.length) {
    [text appendString:tabs];
  }

  NSString *content = [[NSString alloc] initWithFormat:format arguments:args];
  if (content && content.length) {
    [text appendString:content];
  }

  if ([text rangeOfString:@"\n"].length) {
    [text replaceOccurrencesOfString:@"\n"
                          withString:@""
                             options:NSCaseInsensitiveSearch
                               range:NSMakeRange(0, text.length)];
  }
  
  if ([text rangeOfString:@"    "].length) {
    [text replaceOccurrencesOfString:@"    "
                          withString:@" "
                             options:NSCaseInsensitiveSearch
                               range:NSMakeRange(0, text.length)];
  }

  if ([text rangeOfString:@"%"].length) {
    [text replaceOccurrencesOfString:@"%"
                          withString:@"%%"
                             options:NSCaseInsensitiveSearch
                               range:NSMakeRange(0, text.length)];
  }

  fprintf(stderr, [text UTF8String], NULL);
  fprintf(stderr, "\n", NULL);
}

@end
