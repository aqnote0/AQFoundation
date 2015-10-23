//
//  YDSingleton.h
//  YDFoundation
//
//  Created by madding.lip on 5/4/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#undef YD_DEC_SINGLETON
#define YD_DEC_SINGLETON       \
  -(instancetype)sharedInstance; \
  +(instancetype)sharedInstance;

#undef YD_DEF_SINGLETON
#define YD_DEF_SINGLETON                 \
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

#undef YD_DEF_SINGLETON
#define YD_DEF_SINGLETON                 \
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
