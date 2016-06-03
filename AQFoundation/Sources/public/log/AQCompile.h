//
//  AQPreCompile.h
//  AQFoundation
//
//  Created by madding.lip on 5/4/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#ifndef AQ_FOUNDATION_VERSION
#define AQ_FOUNDATION_VERSION @"2.0.0"
#endif

#ifndef AQ_CONDITION_DEF
#define AQ_CONDITION_DEF                                    \
  NSCondition *_lockCondition = [[NSCondition alloc] init]; \
  BOOL _lockResult = TRUE;
#endif

#ifndef AQ_CONDITION_SIGNAL
#define AQ_CONDITION_SIGNAL \
  [_lockCondition lock];    \
  [_lockCondition signal];  \
  [_lockCondition unlock];
#endif

#ifndef AQ_CONDITION_WAIT
#define AQ_CONDITION_WAIT(_time)                                  \
  [_lockCondition lock];                                          \
  _lockResult = [_lockCondition                                   \
      waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:_time]]; \
  [_lockCondition unlock];
#endif

#ifndef AQ_CONDITION_RESULT
#define AQ_CONDITION_RESULT _lockResult
#endif
