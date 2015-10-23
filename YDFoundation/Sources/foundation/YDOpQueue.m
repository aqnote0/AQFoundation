//
//  YDOpQueueFactory.m
//  YDFoundation
//
//  Created by madding.lip on 7/31/15.
//  //  Copyright (c) 2015 yudao. All rights reserved.
//

#import "YDOpQueue.h"

@interface YDOpQueue ()

@property(nonatomic, retain) NSMutableDictionary *queues;

@end

@implementation YDOpQueue

+ (YDOpQueue *)instance {
  static YDOpQueue *_factory;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _factory = [[YDOpQueue alloc] init];
  });
  return _factory;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setQueues:[[NSMutableDictionary alloc] init]];
  }
  return self;
}

+ (NSOperationQueue *)get:(NSString *)queueName maxcount:(int)maxcount {
  @synchronized(self) {
    NSOperationQueue *queue =
        [[[YDOpQueue instance] queues] objectForKey:queueName];
    if (queue != nil) {
      return queue;
    }

    queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:maxcount];
    [[[YDOpQueue instance] queues] setObject:queue forKey:queueName];
    return queue;
  }
}

@end