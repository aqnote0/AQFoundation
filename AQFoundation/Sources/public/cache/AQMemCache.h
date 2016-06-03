//
//  AQMemCache.h
//  AQFoundation
//
//  Created by madding.lip on 5/4/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import "AQSingleton.h"
#import "AQCacheProtocol.h"

#pragma mark -

@interface AQMemCache : NSObject<AQCacheProtocol>

@property(nonatomic, assign) BOOL clearWhenMemoryLow;
@property(nonatomic, assign) NSUInteger maxCacheCount;
@property(nonatomic, assign) NSUInteger cachedCount;
@property(atomic, retain) NSMutableArray* cacheKeys;
@property(atomic, retain) NSMutableDictionary* cacheObjs;

AQ_DEC_SINGLETON

@end

