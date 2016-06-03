//
//  AQSingleton.h
//  AQFoundation
//
//  Created by madding.lip on 5/4/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#undef AQ_DEC_SINGLETON
#define AQ_DEC_SINGLETON       \
  -(instancetype)sharedInstance; \
  +(instancetype)sharedInstance;

#undef AQ_DEF_SINGLETON
#define AQ_DEF_SINGLETON                 \
  -(instancetype)sharedInstance {          \
    return [[self class] sharedInstance];  \
  }                                        \
  +(instancetype)sharedInstance {          \
    static dispatch_once_t once;           \
    static id __singleton__;               \
    dispatch_once(&once, ^{                \
      __singleton__ = [[self alloc] init]; \
    });                                    \
    return __singleton__;                  \
  }

#undef AQ_DEF_SINGLETON
#define AQ_DEF_SINGLETON                 \
  -(instancetype)sharedInstance {          \
    return [[self class] sharedInstance];  \
  }                                        \
  +(instancetype)sharedInstance {          \
    static dispatch_once_t once;           \
    static id __singleton__;               \
    dispatch_once(&once, ^{                \
      __singleton__ = [[self alloc] init]; \
    });                                    \
    return __singleton__;                  \
  }
