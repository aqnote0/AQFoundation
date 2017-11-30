//
//  AQOpQueueFactory.m
//  AQFoundation
//
//  Created by madding.lip on 7/31/15.
//  //  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import "AQOperationQueue.h"

@interface AQOperationQueue ()

@property(nonatomic, retain) NSMutableDictionary *queues;

@end

@implementation AQOperationQueue

+ (AQOperationQueue *)instance {
  static AQOperationQueue *_factory;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _factory = [[AQOperationQueue alloc] init];
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
        [[[AQOperationQueue instance] queues] objectForKey:queueName];
    if (queue != nil) {
      return queue;
    }

    queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:maxcount];
    [[[AQOperationQueue instance] queues] setObject:queue forKey:queueName];
    return queue;
  }
}

@end