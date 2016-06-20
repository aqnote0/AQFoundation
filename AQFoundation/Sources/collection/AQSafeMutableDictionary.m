//
//  AQThreadSafeDictionary.m
//  AQFoundation
//
//  Created by madding.lip on 11/9/15.
//  Copyright © 2015 yudao. All rights reserved.
//

#import "AQSafeMutableDictionary.h"

@interface AQSafeMutableDictionary ()

@property(atomic, readonly) dispatch_queue_t queue;
@property(atomic, readonly) NSMutableDictionary *backingStore;

@end

@implementation AQSafeMutableDictionary
@synthesize queue = _queue, backingStore = _backingStore;

- (void)createQueue {
  if (self.queue != nil) {
    return;
  }

  @synchronized(self) {
    if (self.queue == nil) {
      NSString *name = [NSString
          stringWithFormat:@"com.aqnote.tsafe.dictionary.%ld",
                           (unsigned long)self.hash];
      _queue = dispatch_queue_create(
          [name cStringUsingEncoding:NSASCIIStringEncoding],
          DISPATCH_QUEUE_CONCURRENT);
    }
  }
}

- (NSMutableDictionary *)backingStore {
  if (_backingStore != nil) {
    return _backingStore;
  }

  @synchronized(self) {
    if (_backingStore == nil) {
      _backingStore = [[NSMutableDictionary alloc] init];
    }
  }

  return _backingStore;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"AQThreadSafeDictionary: %@",
                                    [self.backingStore description]];
}

#pragma mark - Initializer

- (instancetype)init {
  self = [super init];
  if (self) {
    _backingStore = [[NSMutableDictionary alloc] init];
    [self createQueue];
  }
  return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems {
  self = [super init];
  if (self) {
    _backingStore = [[NSMutableDictionary alloc] initWithCapacity:numItems];
    [self createQueue];
  }
  return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary {
  self = [self init];
  if (self) {
    _backingStore = [otherDictionary mutableCopy];
    [self createQueue];
  }
  return self;
}

+ (instancetype)dictionaryWithDictionary:(NSDictionary *)dict {
  return [[self alloc] initWithDictionary:dict];
}

#pragma mark NSCoding

#define AQSafeMutableDictionaryCodingKeyBackingStore \
  @"AQSafeMutableDictionaryCodingKeyBackingStore"
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
    _backingStore = [[aDecoder decodeObjectOfClass:[NSDictionary class
    ] forKey:AQSafeMutableDictionaryCodingKeyBackingStore] mutableCopy];
    [self createQueue];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:[_backingStore copy]
                forKey:AQSafeMutableDictionaryCodingKeyBackingStore];
}

#pragma mark Copying

- (id)copyWithZone:(NSZone *)zone {
  return [[[self class] alloc] initWithDictionary:[self.dictionary copy]];
}

- (instancetype)copy {
  return [self copyWithZone:nil];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
  return [[[self class] alloc] initWithDictionary:[self.dictionary copy]];
}

- (instancetype)mutableCopy {
  return [self mutableCopyWithZone:nil];
}

#pragma mark - Read methods

- (id)objectForKey:(id)aKey {
  __block id object = nil;
  [self runSynchronousReadBlock:^(NSMutableDictionary *backingStore) {
    object = [backingStore objectForKey:aKey];
  }];
  return object;
}

- (id)valueForKey:(NSString *)key {
  __block id object = nil;
  [self runSynchronousReadBlock:^(NSMutableDictionary *backingStore) {
    object = [backingStore valueForKey:key];
  }];
  return object;
}

- (NSArray *)allKeysForObject:(id)anObject {
  __block NSArray *array = nil;
  [self runSynchronousReadBlock:^(NSMutableDictionary *backingStore) {
    array = [backingStore allKeysForObject:anObject];
  }];
  return array;
}

- (NSArray *)allKeys {
  __block NSArray *array = nil;
  [self runSynchronousReadBlock:^(NSMutableDictionary *backingStore) {
    array = [backingStore allKeys];
  }];
  return array;
}

- (NSArray *)allValues {
  __block NSArray *array = nil;
  [self runSynchronousReadBlock:^(NSMutableDictionary *backingStore) {
    array = [backingStore allValues];
  }];
  return array;
}

- (NSDictionary *)dictionary {
  __block NSDictionary *dictionary = nil;
  [self runSynchronousReadBlock:^(NSMutableDictionary *backingStore) {
    dictionary = [backingStore copy];
  }];
  return dictionary;
}

- (NSUInteger)count {
  __block NSUInteger count = 0;
  [self runSynchronousReadBlock:^(NSMutableDictionary *backingStore) {
    count = [backingStore count];
  }];
  return count;
}

- (NSEnumerator *)keyEnumerator {
  return [[self dictionary] keyEnumerator];
}

- (NSEnumerator *)objectEnumerator {
  return [[self dictionary] objectEnumerator];
}

#pragma mark - Write Methods

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey {
  [self runAsynchronousWriteBlock:^(NSMutableDictionary *backingStore) {
    [backingStore setObject:anObject forKey:aKey];
  }];
}

- (void)setValue:(id)value forKey:(NSString *)key {
  [self runAsynchronousWriteBlock:^(NSMutableDictionary *backingStore) {
    [backingStore setValue:value forKey:key];
  }];
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary {
  [self runAsynchronousWriteBlock:^(NSMutableDictionary *backingStore) {
    [backingStore addEntriesFromDictionary:otherDictionary];
  }];
}

- (void)removeObjectForKey:(id)aKey {
  [self runAsynchronousWriteBlock:^(NSMutableDictionary *backingStore) {
    [backingStore removeObjectForKey:aKey];
  }];
}

- (void)removeObjectsForKeys:(NSArray *)keyArray {
  [self runAsynchronousWriteBlock:^(NSMutableDictionary *backingStore) {
    [backingStore removeObjectsForKeys:keyArray];
  }];
}

- (void)removeAllObjects {
  [self runAsynchronousWriteBlock:^(NSMutableDictionary *backingStore) {
    [backingStore removeAllObjects];
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

- (void)runAsynchronousWriteBlock:(void (^)(NSMutableDictionary *))block {
  [self createQueue];
  __weak __typeof(self) weakSelf = self;
  dispatch_barrier_async(self.queue, ^{
    block &&weakSelf.backingStore ? block(weakSelf.backingStore) : nil;
  });
}

- (void)runSynchronousReadBlock:(void (^)(NSMutableDictionary *))block {
  [self createQueue];
  __weak __typeof(self) weakSelf = self;
  dispatch_sync(self.queue, ^{
    block &&weakSelf.backingStore ? block(weakSelf.backingStore) : nil;
  });
}

@end
