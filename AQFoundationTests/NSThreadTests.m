//
//  NSThreadTests.m
//  AQFoundation
//
//  Created by madding.lip on 7/14/16.
//  Copyright © 2016 madding. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface NSThreadTests : XCTestCase

@end

@implementation NSThreadTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testIsMainThread {
  NSCondition *condition = [[NSCondition alloc] init];

  NSLog(@"[1] %d", [NSThread isMainThread]);

  dispatch_queue_t queue =
      dispatch_queue_create("com.aqnote.test", DISPATCH_QUEUE_SERIAL);
  dispatch_queue_t s1 = dispatch_queue_create("com.aqnote.test.s1", NULL);
  dispatch_queue_t s2 = dispatch_queue_create("com.aqnote.test.s2", NULL);

  dispatch_async(queue, ^{
    BOOL isMainThread = [NSThread isMainThread];
    NSLog(@"[2] %d", isMainThread);

    dispatch_async(dispatch_get_main_queue(), ^{
      BOOL isMainThread = [NSThread isMainThread];
      NSLog(@"[3] %d", isMainThread);
    });

    dispatch_sync(s1, ^{
      BOOL isMainThread = [NSThread isMainThread];
      NSLog(@"[4] %d", isMainThread);

      dispatch_sync(s2, ^{
        BOOL isMainThread = [NSThread isMainThread];
        NSLog(@"[5] %d", isMainThread);
      });
    });

    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
      BOOL isMainThread = [NSThread isMainThread];
      NSLog(@"[6] %d", isMainThread);
      dispatch_sync(dispatch_get_main_queue(), ^{
        BOOL isMainThread = [NSThread isMainThread];
        NSLog(@"[7] %d", isMainThread);
      });
    });
  });
  
  
  [condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
}

- (void) testNSAssert {
  NSCondition *condition = [[NSCondition alloc] init];
  BOOL isMainThread = [NSThread isMainThread];
  NSLog(@"[1] %d", isMainThread);
  NSAssert(isMainThread, @"in main thread.");
  NSLog(@"[2] %d", isMainThread);
  
  dispatch_queue_t queue = dispatch_queue_create("com.aqnote.test", DISPATCH_QUEUE_SERIAL);
  dispatch_async(queue, ^{
    BOOL isMainThread = [NSThread isMainThread];
    NSLog(@"[3] %d", isMainThread);
    NSAssert([NSThread isMainThread], @"in main thread.");
    NSLog(@"[4] %d", isMainThread);
  });
  
  [condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}


- (void)testPerformanceExample {
  [self measureBlock:^{
  }];
}

@end
