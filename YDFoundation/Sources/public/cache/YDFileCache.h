//
//  YDFileCache.h
//  YDFoundation
//
//  Created by madding.lip on 4/30/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import "YDCacheProtocol.h"
#import "YDSingleton.h"

@interface YDFileCache : NSObject<YDCacheProtocol>

@property(nonatomic, retain) NSString *cachePath;
@property(nonatomic, retain) NSString *cacheUser;

YD_DEC_SINGLETON

- (NSString *)fileNameForKey:(NSString *)key;

@end
