//
//  AQFileCache.h
//  AQFoundation
//
//  Created by madding.lip on 4/30/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import "AQCacheProtocol.h"
#import "AQSingleton.h"

@interface AQFileCache : NSObject<AQCacheProtocol>

@property(nonatomic, retain) NSString *cachePath;
@property(nonatomic, retain) NSString *cacheUser;

AQ_DEC_SINGLETON

- (NSString *)fileNameForKey:(NSString *)key;

@end
