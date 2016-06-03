//
//  AQOpQueueFactory.m
//  AQFoundation
//
//  Created by madding.lip on 7/31/15.
//  //  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import "AQOpQueue.h"

@interface AQOpQueue ()

@property(nonatomic, retain) NSMutableDictionary *queues;

@end

@implementation AQOpQueue

+ (AQOpQueue *)instance {
  static AQOpQueue *_factory;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _factory = [[AQOpQueue alloc] init];
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
        [[[AQOpQueue instance] queues] objectForKey:queueName];
    if (queue != nil) {
      return queue;
    }

    queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:maxcount];
    [[[AQOpQueue instance] queues] setObject:queue forKey:queueName];
    return queue;
  }
}

@end