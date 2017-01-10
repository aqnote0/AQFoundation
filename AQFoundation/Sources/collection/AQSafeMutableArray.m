//
//  AQSafeMutableArray.m
//  AQFoundation
//
//  Created by madding.lip on 11/9/15.
//  Copyright © 2015 yudao. All rights reserved.
//

#import "AQSafeMutableArray.h"

@interface AQSafeMutableArray ()
@property(atomic, readonly) dispatch_queue_t queue;
@property(atomic, readonly) NSMutableArray* backingStore;
@end

@implementation AQSafeMutableArray
@synthesize queue = _queue, backingStore = _backingStore;

- (void)createQueue {
  if (self.queue != nil) {
    return;
  }

  @synchronized(self) {
    if (self.queue == nil) {
      NSString* name =
          [NSString stringWithFormat:@"com.aqnote.tsafe.array.%ld",
                                     (unsigned long)self.hash];
      _queue = dispatch_queue_create(
          [name cStringUsingEncoding:NSASCIIStringEncoding],
          DISPATCH_QUEUE_CONCURRENT);
    }
  }
}

- (NSMutableArray*)backingStore {
  if (_backingStore != nil) {
    return _backingStore;
  }

  @synchronized(self) {
    if (_backingStore == nil) {
      _backingStore = [[NSMutableArray alloc] init];
    }
  }

  return _backingStore;
}

- (NSString*)description {
  return [NSString stringWithFormat:@"AQSafeMutableArray: %@",
                                    [self.backingStore description]];
}

#pragma mark - Initializer

- (instancetype)init {
  self = [super init];
  if (self) {
    _backingStore = [[NSMutableArray alloc] init];
    [self createQueue];
  }
  return self;
}

- (instancetype)initWithObjects:(const id[])objects count:(NSUInteger)cnt {
  self = [super init];
  if (self) {
    _backingStore = [[NSMutableArray alloc] initWithObjects:objects count:cnt];
    [self createQueue];
  }
  return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems {
  self = [super init];
  if (self) {
    _backingStore = [[NSMutableArray alloc] initWithCapacity:numItems];
    [self createQueue];
  }
  return self;
}

- (instancetype)initWithArray:(NSArray*)array {
  self = [self init];
  if (self) {
    _backingStore = [array mutableCopy];
    [self createQueue];
  }
  return self;
}

#pragma mark Class Macros

+ (instancetype)arrayWithSet:(NSSet*)set {
  return [self arrayWithArray:[set allObjects]];
}

+ (instancetype)arrayWithArray:(NSArray*)array {
  return [[self alloc] initWithArray:array];
}

- (id)copyWithZone:(NSZone*)__unused zone {
  return [[[self class] alloc] initWithArray:self.array];
}

- (instancetype)copy {
  return [self copyWithZone:nil];
}

- (id)mutableCopyWithZone:(NSZone*)__unused zone {
  return [[[self class] alloc] initWithArray:self.array];
}

- (instancetype)mutableCopy {
  return [self mutableCopyWithZone:nil];
}

#pragma mark - Read methods

- (id)objectAtIndex:(NSUInteger)index {
  __block id object = nil;
  [self runSynchronousReadBlock:^(NSMutableArray* backingStore) {
    if (index < [self count]) {
      object = [backingStore objectAtIndex:index];
    } else {
      NSAssert(NO, @"out of range exception: index %d to large for %@",
               (int)index, backingStore);
    }
  }];
  return object;
}

- (id)lastObject {
  __block id object = nil;
  [self runSynchronousReadBlock:^(NSMutableArray* backingStore) {
    object = [backingStore lastObject];
  }];
  return object;
}

- (id)popLastObject {
  __block id object = nil;
  [self runSynchronousReadBlock:^(NSMutableArray* backingStore) {
    object = [backingStore lastObject];
    [backingStore removeObject:object];
  }];
  return object;
}

- (id)firstObject {
  __block id object = nil;
  [self runSynchronousReadBlock:^(NSMutableArray* backingStore) {
    object = [backingStore firstObject];
  }];
  return object;
}

- (id)popFirstObject {
  __block id object = nil;
  [self runSynchronousReadBlock:^(NSMutableArray* backingStore) {
    object = [backingStore firstObject];
    [backingStore removeObject:object];
  }];
  return object;
}

- (NSArray*)array {
  __block NSArray* array = nil;
  [self runSynchronousReadBlock:^(NSMutableArray* backingStore) {
    array = [backingStore copy];
  }];
  return array;
}

- (NSSet*)set {
  return [NSSet setWithArray:[self array]];
}

- (NSUInteger)count {
  __block NSUInteger count = 0;
  [self runSynchronousReadBlock:^(NSMutableArray* backingStore) {
    count = [backingStore count];
  }];
  return count;
}

- (NSEnumerator*)objectEnumerator {
  return [[self array] objectEnumerator];
}

#pragma mark - Write Methods

- (void)addObject:(id)object {
  [self runAsynchronousWriteBlock:^(NSMutableArray* backingStore) {
    [backingStore addObject:object];
  }];
}

- (void)addObjects:(NSArray*)objects {
  [self runAsynchronousWriteBlock:^(NSMutableArray* backingStore) {
    [backingStore addObjectsFromArray:objects];
  }];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
  [self runAsynchronousWriteBlock:^(NSMutableArray* backingStore) {
    [backingStore insertObject:anObject atIndex:index];
  }];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
  [self runAsynchronousWriteBlock:^(NSMutableArray* backingStore) {
    [backingStore replaceObjectAtIndex:index withObject:anObject];
  }];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
  [self runAsynchronousWriteBlock:^(NSMutableArray* backingStore) {
    [backingStore removeObjectAtIndex:index];
  }];
}

- (void)removeLastObject {
  [self runAsynchronousWriteBlock:^(NSMutableArray* backingStore) {
    [backingStore removeLastObject];
  }];
}

- (void)removeObject:(id)object {
  [self runAsynchronousWriteBlock:^(NSMutableArray* backingStore) {
    [backingStore removeObject:object];
  }];
}

- (BOOL)isEqual:(id)object {
  if ([object isKindOfClass:[self class]]) {
    return [self.backingStore isEqual:[object backingStore]];
  } else {
    return [object isEqual:self.backingStore];
  }
}

#pragma mark - private

- (void)runAsynchronousWriteBlock:(void (^)(NSMutableArray*))block {
  [self createQueue];
  //  __weak __typeof(self) weakSelf = self;
  __unsafe_unretained __typeof(self) weakSelf = self;
  dispatch_barrier_async(self.queue, ^{
    block&& weakSelf.backingStore ? block(weakSelf.backingStore) : nil;
  });
}

- (void)runSynchronousReadBlock:(void (^)(NSMutableArray*))block {
  [self createQueue];
//  __weak __typeof(self) weakSelf = self;
  __unsafe_unretained __typeof(self) weakSelf = self;
  dispatch_sync(self.queue, ^{
    block&& weakSelf.backingStore ? block(weakSelf.backingStore) : nil;
  });
}

@end
