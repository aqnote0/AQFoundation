//
//  AQCacheProtocol.h
//  AQFoundation
//
//  Created by madding.lip on 4/30/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AQCacheProtocol <NSObject>

/**
 * 判断实例是否已经缓存
 */
- (BOOL)hasObjectForKey:(id)key;

/**
 * 获取指定key的缓存对象
 */
- (id)objectForKey:(id)key;

/**
 * 设置缓存对象
 */
- (void)setObject:(id)object forKey:(id)key;

/**
 * 删除指定key的缓存对象
 */
- (void)removeObjectForKey:(id)key;

/**
 * 清空缓存
 */
- (void)removeAllObjects;

@end

