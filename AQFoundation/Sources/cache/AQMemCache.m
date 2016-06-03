//
//  AQMemCache.m
//  AQFoundation
//
//  Created by madding.lip on 5/4/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import "AQMemCache.h"

#import <UIKit/UIKit.h>

#import "AQNotification.h"
#import "AQString.h"

#undef DEFAULT_MAX_COUNT
#define DEFAULT_MAX_COUNT (48)

@implementation AQMemCache

AQ_DEF_SINGLETON

- (id)init {
  self = [super init];
  if (self) {
    _clearWhenMemoryLow = YES;
    _maxCacheCount = DEFAULT_MAX_COUNT;
    _cachedCount = 0;

    _cacheKeys = [[NSMutableArray alloc] init];
    _cacheObjs = [[NSMutableDictionary alloc] init];

    [AQNotification
        observeNotification:self
                       name:UIApplicationDidReceiveMemoryWarningNotification];
  }
  return self;
}

- (void)dealloc {
  [AQNotification
      unobserveNotification:self
                       name:UIApplicationDidReceiveMemoryWarningNotification];
}

- (BOOL)hasObjectForKey:(id)key {
  return [[self cacheObjs] objectForKey:key] ? YES : NO;
}

- (id)objectForKey:(id)key {
  return [[self cacheObjs] objectForKey:key];
}

- (void)setObject:(id)object forKey:(id)key {
  if (nil == key) return;

  if (nil == object) return;

  id cachedObj = [_cacheObjs objectForKey:key];
  if (cachedObj == object) return;

  _cachedCount += 1;
  if (_maxCacheCount > 0) {
    while (_cachedCount >= _maxCacheCount) {
      NSString *tempKey = [_cacheKeys objectAtIndex:0];
      if (tempKey) {
        [_cacheObjs removeObjectForKey:tempKey];
        [_cacheKeys removeObjectAtIndex:0];
      }

      _cachedCount -= 1;
    }
  }

  [_cacheKeys addObject:key];
  [_cacheObjs setObject:object forKey:key];
}

- (void)removeObjectForKey:(NSString *)key {
  if ([_cacheObjs objectForKey:key]) {
    [_cacheKeys removeObjectIdenticalTo:key];
    [_cacheObjs removeObjectForKey:key];
    _cachedCount -= 1;
  }
}

- (void)removeAllObjects {
  [_cacheKeys removeAllObjects];
  [_cacheObjs removeAllObjects];

  _cachedCount = 0;
}

- (id)objectForKeyedSubscript:(id)key {
  return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key {
  [self setObject:obj forKey:key];
}

- (void)handleNotification:(NSNotification *)notification {
  if ([UIApplicationDidReceiveMemoryWarningNotification
          isEqualToString:[notification name]]) {
    if (_clearWhenMemoryLow) {
      [self removeAllObjects];
    }
  }
}

@end
