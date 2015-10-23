//
//  YDFileCache.m
//  YDFoundation
//
//  Created by madding.lip on 4/30/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import "YDFileCache.h"

#import "YDSandbox.h"
#import "YDDevice.h"
#import "YDBundle.h"
#import "YDObject.h"

#pragma mark -

@interface YDFileCache () {
  NSFileManager *_fileManager;
}
@end

@implementation YDFileCache

YD_DEF_SINGLETON

- (id)init {
  self = [super init];
  if (self) {
    self.cacheUser = @"";
    self.cachePath =
        [NSString stringWithFormat:@"%@/%@/Cache/", [YDSandbox libCachePath],
                                   [YDBundle appVersion]];
    _fileManager = [[NSFileManager alloc] init];
  }
  return self;
}

- (NSString *)fileNameForKey:(NSString *)key {
  NSString *pathName = nil;

  if (self.cacheUser && [self.cacheUser length]) {
    pathName = [self.cachePath stringByAppendingFormat:@"%@/", self.cacheUser];
  } else {
    pathName = self.cachePath;
  }

  if (NO == [_fileManager fileExistsAtPath:pathName]) {
    [_fileManager createDirectoryAtPath:pathName
            withIntermediateDirectories:YES
                             attributes:nil
                                  error:NULL];
  }

  return [pathName stringByAppendingString:key];
}

- (BOOL)hasObjectForKey:(id)key {
  return [_fileManager fileExistsAtPath:[self fileNameForKey:key]];
}

- (id)objectForKey:(id)key {
  return [NSData dataWithContentsOfFile:[self fileNameForKey:key]];
}

- (void)setObject:(id)object forKey:(id)key {
  if (nil == object) {
    [self removeObjectForKey:key];
  } else {
    NSData *data = [YDObject asNSData:object];
    if (data) {
      [data writeToFile:[self fileNameForKey:key]
                options:NSDataWritingAtomic
                  error:NULL];
    }
  }
}

- (void)removeObjectForKey:(NSString *)key {
  [_fileManager removeItemAtPath:[self fileNameForKey:key] error:nil];
}

- (void)removeAllObjects {
  [_fileManager removeItemAtPath:_cachePath error:NULL];
  [_fileManager createDirectoryAtPath:_cachePath
          withIntermediateDirectories:YES
                           attributes:nil
                                error:NULL];
}

- (id)objectForKeyedSubscript:(id)key {
  return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key {
  [self setObject:obj forKey:key];
}

@end
