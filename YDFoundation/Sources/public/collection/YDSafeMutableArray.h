//
//  YDSafeMutableArray.h
//  YDFoundation
//
//  Created by madding.lip on 11/9/15.
//  Copyright © 2015 yudao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDSafeMutableArray<__covariant ObjectType> : NSObject<NSCopying, NSMutableCopying>

@property(readonly) NSUInteger count;
@property(readonly, copy) NSArray *array;
@property(readonly, copy) NSSet *set;

+ (instancetype)arrayWithArray:(NSArray *)array;
+ (instancetype)arrayWithSet:(NSSet *)set;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithObjects:(const id[])objects
                          count:(NSUInteger)cnt NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCapacity:(NSUInteger)numItems NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithArray:(NSArray *)array;

- (id)objectAtIndex:(NSUInteger)index;
- (id)lastObject;
- (id)popLastObject;
- (id)firstObject;
- (id)popFirstObject;

- (void)addObject:(id)anObject;
- (void)addObjects:(NSArray *)objects;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

- (void)removeLastObject;
- (void)removeObject:(id)object;
- (void)removeObjectAtIndex:(NSUInteger)index;

- (instancetype)copy;
- (instancetype)mutableCopy;

@end
