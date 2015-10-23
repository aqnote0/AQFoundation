//
//  YDMemCache.h
//  YDFoundation
//
//  Created by madding.lip on 5/4/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import "YDSingleton.h"
#import "YDCacheProtocol.h"

#pragma mark -

@interface YDMemCache : NSObject<YDCacheProtocol>

@property(nonatomic, assign) BOOL clearWhenMemoryLow;
@property(nonatomic, assign) NSUInteger maxCacheCount;
@property(nonatomic, assign) NSUInteger cachedCount;
@property(atomic, retain) NSMutableArray* cacheKeys;
@property(atomic, retain) NSMutableDictionary* cacheObjs;

YD_DEC_SINGLETON

@end

