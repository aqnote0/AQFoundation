//
//  AQStack.m
//  AQFoundation
//
//  Created by madding.lip on 5/19/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import "AQMutableStack.h"

@interface AQMutableStack ()

@property(nonatomic, strong) NSMutableArray *stackArray;
@property(nonatomic, assign) NSUInteger maxStackSize;

@end

@implementation AQMutableStack
;

#pragma mark - Default init

#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)init {
  self = [super init];
  if (self) {
    _stackArray = [@[] mutableCopy];
  }
  return self;
}

#pragma mark - Init with limited size of stack

- (instancetype)initWithSize:(NSUInteger)size {
  self = [super init];
  if (self) {
    if (size <= 0) {
      NSAssert(size != 0, @"AQStack size must be > 0");
    }
    _stackArray = [@[] mutableCopy];
    _maxStackSize = size;
  }
  return self;
}

#pragma mark - Public API

- (id)pop {
  id object = [self peek];
  [self.stackArray removeLastObject];
  return object;
}

- (void)push:(id)object {
  if (nil == object) return;
  if ([self full] && self.maxStackSize) {
    NSLog(@"Stack is full");
    return;
  }
  [self.stackArray addObject:object];
}

- (id)peek {
  if ([self.stackArray count] > 0) {
    return [self.stackArray lastObject];
  }
  return nil;
}

- (NSInteger)size {
  return (NSInteger)[self.stackArray count];
}

- (BOOL)empty {
  return [self.stackArray count] == 0;
}

- (BOOL)full {
  return ([self size] == (NSInteger)self.maxStackSize) ? YES : NO;
}

- (void)clear {
  [self.stackArray removeAllObjects];
}

- (NSArray *)dump {
  NSMutableArray *buffer = [@[] mutableCopy];
  for (id object in self.stackArray) {
    [buffer addObject:object];
  }
  return [buffer copy];
}

@end
