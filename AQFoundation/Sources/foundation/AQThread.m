//
//  AQThread.m
//  AQFoundation
//
//  Created by madding.lip on 5/4/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import "AQThread.h"

#import "AQSingleton.h"

@interface AQThread () {
  dispatch_queue_t _foreQueue;
  dispatch_queue_t _backQueueInitMain;
  dispatch_queue_t _backQueueInitSub;
  dispatch_queue_t _backQueueTask;
}
@end

@implementation AQThread

AQ_DEF_SINGLETON

- (id)init {
  self = [super init];
  if (self) {
    _foreQueue = dispatch_get_main_queue();
    _backQueueInitMain = dispatch_queue_create("com.aqnote.queue.init.main", nil);
    _backQueueInitSub = dispatch_queue_create("com.aqnote.queue.init.sub", nil);
    _backQueueTask = dispatch_queue_create("com.aqnote.queue.task", nil);
  }

  return self;
}

+ (void)foreground:(dispatch_block_t)block {
  return [[AQThread sharedInstance] foreground:block];
}

- (void)foreground:(dispatch_block_t)block {
  dispatch_async(_foreQueue, block);
}

+ (void)backgroundInitMain:(dispatch_block_t)block {
  return [[AQThread sharedInstance] backgroundInitMain:block];
}

- (void)backgroundInitMain:(dispatch_block_t)block {
  dispatch_async(_backQueueInitMain, block);
}

+ (void)backgroundInitSub:(dispatch_block_t)block {
  return [[AQThread sharedInstance] backgroundInitSub:block];
}

- (void)backgroundInitSub:(dispatch_block_t)block {
  dispatch_async(_backQueueInitSub, block);
}

+ (void)backgroundTask:(dispatch_block_t)block {
  return [[AQThread sharedInstance] backgroundTask:block];
}

- (void)backgroundTask:(dispatch_block_t)block {
  dispatch_async(_backQueueTask, block);
}

+ (void)backgroundTaskWithDelay:(dispatch_time_t)ms
                             block:(dispatch_block_t)block {
  [[AQThread sharedInstance] backgroundTaskWithDelay:ms block:block];
}

- (void)backgroundTaskWithDelay:(dispatch_time_t)ms
                             block:(dispatch_block_t)block {
  dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, ms * USEC_PER_SEC);
  dispatch_after(time, _backQueueTask, block);
}










@end