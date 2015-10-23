//
//  YDPreCompile.h
//  YDFoundation
//
//  Created by madding.lip on 5/4/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#ifndef YD_FOUNDATION_VERSION
#define YD_FOUNDATION_VERSION @"2.0.0"
#endif

#ifndef YD_CONDITION_DEF
#define YD_CONDITION_DEF                                    \
  NSCondition *_lockCondition = [[NSCondition alloc] init]; \
  BOOL _lockResult = TRUE;
#endif

#ifndef YD_CONDITION_SIGNAL
#define YD_CONDITION_SIGNAL \
  [_lockCondition lock];    \
  [_lockCondition signal];  \
  [_lockCondition unlock];
#endif

#ifndef YD_CONDITION_WAIT
#define YD_CONDITION_WAIT(_time)                                  \
  [_lockCondition lock];                                          \
  _lockResult = [_lockCondition                                   \
      waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:_time]]; \
  [_lockCondition unlock];
#endif

#ifndef YD_CONDITION_RESULT
#define YD_CONDITION_RESULT _lockResult
#endif
