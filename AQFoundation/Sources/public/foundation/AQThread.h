//
//  AQThread.h
//  AQFoundation
//
//  Created by madding.lip on 5/4/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AQ_FORE_BEGIN	 [AQThread foreground:^{
#define AQ_FORE_COMMIT  }];

#define AQ_INIT_BEGIN  [AQThread backgroundInitMain:^{
#define AQ_INIT_COMMIT  }];

#define AQ_INIT_SUB_BEGIN  [AQThread backgroundInitSub:^{
#define AQ_INIT_SUB_COMMIT  }];

#define AQ_TASK_BEGIN  [AQThread backgroundTask:^{
#define AQ_TASK_COMMIT  }];

@interface AQThread : NSObject

+ (void)foreground:(dispatch_block_t)block;

+ (void)backgroundMain:(dispatch_block_t)block;

+ (void)backgroundSub:(dispatch_block_t)block;

+ (void)backgroundTask:(dispatch_block_t)block;

@end
