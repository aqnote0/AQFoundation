//
//  AQOpQueueFactory.h
//  AQFoundation
//
//  Created by madding.lip on 7/31/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AQOpQueueFactory : NSObject

/**
 *  返回指定queuenanme的OperationQueue，如果已经存在，直接返回；否则构造一个新的给用户；
 *   建议queueName设置格式如下：com.alibaba.baichuan.{pluginname}.name
 *
 *  @param queueName operationQueue的名字
 *  @param maxcount  queue的最大并发(线程数）
 *
 *  @return 工厂创建的queue
 */
+ (NSOperationQueue *)get:(NSString *)queueName maxcount:(int)maxcount;

@end
