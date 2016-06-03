//
//  AQSafeMutableSet.h
//  AQFoundation
//
//  Created by madding.lip on 11/9/15.
//  Copyright © 2015 yudao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSEnumerator;

@interface AQSafeMutableSet<__covariant ObjectType>
  : NSObject<NSCopying, NSMutableCopying, NSFastEnumeration>

@property(readonly, copy) NSSet *set;
@property(readonly, copy) NSArray *array;

@property(readonly, copy) NSArray *allObjects;
@property(readonly) NSUInteger count;

+ (instancetype)setWithSet:(NSSet *)set;
+ (instancetype)setWithArray:(NSArray *)array;

- (NSEnumerator *)objectEnumerator;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithObjects:(const id[])objects
                          count:(NSUInteger)cnt NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCapacity:(NSUInteger)numItems NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithSet:(NSSet *)set;

- (void)addObject:(id)object;
- (void)removeObject:(id)object;
- (void)removeAllObjects;

- (id)anyObject;
- (BOOL)containsObject:(id)anObject;

- (instancetype)copy;
- (instancetype)mutableCopy;

@end