//
//  YDThreadSafeDictionary.h
//  YDFoundation
//
//  Created by madding.lip on 11/9/15.
//  Copyright © 2015 yudao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDSafeMutableDictionary<__covariant KeyType, __covariant ObjectType> : NSObject

@property(readonly) NSUInteger count;
@property(readonly, copy) NSArray *allKeys;
@property(readonly, copy) NSArray *allValues;
@property(readonly, copy) NSDictionary *dictionary;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCapacity:(NSUInteger)numItems NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary;

- (id)objectForKey:(id)aKey;
- (NSArray *)allKeysForObject:(id)anObject;
- (NSEnumerator *)keyEnumerator;
- (NSEnumerator *)objectEnumerator;

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary;
- (void)removeObjectForKey:(id)aKey;
- (void)removeObjectsForKeys:(NSArray *)keyArray;
- (void)removeAllObjects;

@end
