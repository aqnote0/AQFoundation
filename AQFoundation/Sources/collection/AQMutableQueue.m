//
//  AQQueue.m
//  AQFoundation
//
//  Created by madding.lip on 5/20/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import "AQMutableQueue.h"

@interface AQMutableQueue ()

@property(nonatomic, strong) NSMutableArray *queue;

@end

@implementation AQMutableQueue

#pragma mark - init

- (instancetype)init {
  self = [super init];
  if (self) {
    _queue = [@[] mutableCopy];
  }
  return self;
}

#pragma mark - Public API

- (void)push:(id)object {
  if (nil == object) {
    return;
  }

  [_queue addObject:object];
}

- (id)poll {
  if ([_queue count] > 0) {
    id object = [self peek];
    [_queue removeObjectAtIndex:0];
    return object;
  }
  return nil;
}

- (id)peek {
  if ([_queue count] > 0) {
    return (_queue)[0];
  }
  return nil;
}

- (BOOL)empty {
  return [_queue count] == 0;
}

- (void)clear {
  [_queue removeAllObjects];
}

- (NSArray *)dump {
  NSMutableArray *buffer = [@[] mutableCopy];
  for (id object in _queue) {
    [buffer addObject:object];
  }
  return [buffer copy];
}

@end
