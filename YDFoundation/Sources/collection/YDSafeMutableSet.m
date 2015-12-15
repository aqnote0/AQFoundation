//
//  YDSafeMutableSet.m
//  YDFoundation
//
//  Created by madding.lip on 11/9/15.
//  Copyright © 2015 yudao. All rights reserved.
//

#import "YDSafeMutableSet.h"

@interface YDSafeMutableSet ()

@property(atomic, readonly) dispatch_queue_t queue;
@property(atomic, readonly) NSMutableSet* backingStore;
@end

@implementation YDSafeMutableSet
@synthesize queue = _queue, backingStore = _backingStore;

- (void)createQueue {
  if (self.queue != nil) {
    return;
  }

  @synchronized(self) {
    if (self.queue == nil) {
      NSString* name =
          [NSString stringWithFormat:@"com.madding.tsafe.set.%ld",
                                     (unsigned long)self.hash];
      _queue = dispatch_queue_create(
          [name cStringUsingEncoding:NSASCIIStringEncoding],
          DISPATCH_QUEUE_CONCURRENT);
    }
  }
}

- (NSMutableSet*)backingStore {
  if (_backingStore != nil) {
    return _backingStore;
  }

  @synchronized(self) {
    if (_backingStore == nil) {
      _backingStore = [[NSMutableSet alloc] init];
    }
  }

  return _backingStore;
}

- (NSString*)description {
  return [NSString stringWithFormat:@"MTEThreadsafeSet: %@",
                                    [self.backingStore description]];
}

#pragma mark - Initializer

- (instancetype)init {
  self = [super init];
  if (self) {
    _backingStore = [[NSMutableSet alloc] init];
    [self createQueue];
  }
  return self;
}

- (instancetype)initWithObjects:(const id[])objects count:(NSUInteger)cnt {
  self = [super init];
  if (self) {
    _backingStore = [[NSMutableSet alloc] initWithObjects:objects count:cnt];
    [self createQueue];
  }
  return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems {
  self = [super init];
  if (self) {
    _backingStore = [[NSMutableSet alloc] initWithCapacity:numItems];
    [self createQueue];
  }
  return self;
}

- (instancetype)initWithSet:(NSSet*)set {
  self = [self init];
  if (self) {
    _backingStore = [set mutableCopy];
    [self createQueue];
  }
  return self;
}

#pragma mark Class Macros

+ (instancetype)setWithSet:(NSSet*)set {
  return [[self alloc] initWithSet:set];
}

+ (instancetype)setWithArray:(NSArray*)array {
  return [self setWithSet:[NSSet setWithArray:array]];
}

- (id)copyWithZone:(NSZone*)__unused zone {
  return [[[self class] alloc] initWithSet:self.set];
}

- (instancetype)copy {
  return [self copyWithZone:nil];
}

- (id)mutableCopyWithZone:(NSZone*)__unused zone {
  return [[[self class] alloc] initWithSet:self.set];
}

- (instancetype)mutableCopy {
  return [self mutableCopyWithZone:nil];
}

#pragma mark - Read methods

- (id)anyObject {
  __block id object = nil;

  [self runSynchronousReadBlock:^(NSMutableSet* backingStore) {
    object = [backingStore anyObject];
  }];

  return object;
}

- (NSArray*)allObjects {
  __block NSArray* array = nil;
  [self runSynchronousReadBlock:^(NSMutableSet* backingStore) {
    array = [backingStore allObjects];
  }];
  return array;
}

- (NSSet*)set {
  __block NSSet* set = nil;
  [self runSynchronousReadBlock:^(NSMutableSet* backingStore) {
    set = [backingStore copy];
  }];
  return set;
}

- (NSArray*)array {
  return [self allObjects];
}

- (BOOL)containsObject:(id)object {
  __block BOOL contains = NO;
  [self runSynchronousReadBlock:^(NSMutableSet* backingStore) {
    contains = [backingStore containsObject:object];
  }];
  return contains;
}

- (NSUInteger)count {
  __block NSUInteger count = 0;
  [self runSynchronousReadBlock:^(NSMutableSet* backingStore) {
    count = [backingStore count];
  }];
  return count;
}

- (NSEnumerator*)objectEnumerator {
  __block NSEnumerator* enumerator = nil;
  [self runSynchronousReadBlock:^(NSMutableSet* backingStore) {
    enumerator = [backingStore objectEnumerator];
  }];
  return enumerator;
}

- (BOOL)isEqual:(id)object {
  if ([object isKindOfClass:[self class]]) {
    return [self.backingStore isEqual:[object backingStore]];
  } else {
    return [object isEqual:self.backingStore];
  }
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState*)state
                                  objects:(id __unsafe_unretained[])buffer
                                    count:(NSUInteger)len {
  __block NSSet* copiedStore = nil;
  [self runSynchronousReadBlock:^(NSMutableSet* backingStore) {
    copiedStore = [backingStore copy];
  }];

  return
      [copiedStore countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark - Write Methods

- (void)addObject:(id)object {
  [self runAsynchronousWriteBlock:^(NSMutableSet* backingStore) {
    [backingStore addObject:object];
  }];
}

- (void)removeObject:(id)object {
  [self runAsynchronousWriteBlock:^(NSMutableSet* backingStore) {
    [backingStore removeObject:object];
  }];
}

- (void)removeAllObjects {
  [self runAsynchronousWriteBlock:^(NSMutableSet* backingStore) {
    [backingStore removeAllObjects];
  }];
}

#pragma mark - private

- (void)runAsynchronousWriteBlock:(void (^)(NSMutableSet* innerSet))block {
  [self createQueue];
  __weak __typeof(self) weakSelf = self;
  dispatch_barrier_async(self.queue, ^{
    block&& weakSelf.backingStore ? block(weakSelf.backingStore) : nil;
  });
}

- (void)runSynchronousReadBlock:(void (^)(NSMutableSet* innerSet))block {
  [self createQueue];
  __weak __typeof(self) weakSelf = self;
  dispatch_sync(self.queue, ^{
    block&& weakSelf.backingStore ? block(weakSelf.backingStore) : nil;
  });
}

@end