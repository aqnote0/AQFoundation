//
//  LockTests.m
//  AQFoundation
//
//  Created by madding.lip on 7/4/16.
//  Copyright © 2016 madding. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AQFoundation/AQString.h"

@interface TestObj : NSObject
- (void)method1;
- (void)method2;
@end

@interface LockTests : XCTestCase

@end

@implementation LockTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

// 主子线程
- (void)testLock_1 {
  //主线程中
  TestObj *obj = [[TestObj alloc] init];
  NSLock *lock = [[NSLock alloc] init];
  
  [lock lock];
  //线程1
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [obj method1];
    sleep(10);
    [lock unlock];
  });
  
  NSLog(@"[%@ %@]", @"main",  [AQString fromSelector:_cmd]);
}

// 并行线程
- (void)testLock_2 {
  //主线程中
  TestObj *obj = [[TestObj alloc] init];
  
  NSCondition *condition = [[NSCondition alloc] init];
  
  NSLock *mainLock = [[NSLock alloc] init];
  NSLock *lock = [[NSLock alloc] init];
  
  //线程1
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [lock lock];
    [obj method1];
    sleep(10);
    [lock unlock];
  });
  
  //线程2
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    sleep(1);//以保证让线程2的代码后执行
    [lock lock];
    [obj method2];
    [lock unlock];
    
    [condition lock];
    [condition signal];
    [condition unlock];
  });
  
  [condition lock];
  [condition wait];
  [condition unlock];
  NSLog(@"[%@ %@]", @"main",  [AQString fromSelector:_cmd]);
}
@end

@implementation TestObj

- (void)method1 {
  NSLog(@"[%@ %@]", [AQString fromObject:self],  [AQString fromSelector:_cmd]);
}

- (void)method2 {
  NSLog(@"[%@ %@]", [AQString fromObject:self],  [AQString fromSelector:_cmd]);
}
@end