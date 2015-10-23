//
//  YDThread.h
//  YDFoundation
//
//  Created by madding.lip on 5/4/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YD_FORE_BEGIN	 [YDThread foreground:^{
#define YD_FORE_COMMIT  }];

#define YD_INIT_BEGIN  [YDThread backgroundInitMain:^{
#define YD_INIT_COMMIT  }];

#define YD_INIT_SUB_BEGIN  [YDThread backgroundInitSub:^{
#define YD_INIT_SUB_COMMIT  }];

#define YD_TASK_BEGIN  [YDThread backgroundTask:^{
#define YD_TASK_COMMIT  }];

@interface YDThread : NSObject

+ (void)foreground:(dispatch_block_t)block;

+ (void)backgroundInitMain:(dispatch_block_t)block;

+ (void)backgroundInitSub:(dispatch_block_t)block;

+ (void)backgroundTask:(dispatch_block_t)block;

@end
