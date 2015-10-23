//
//  YDDate.h
//  YDFoundation
//
//  Created by madding.lip on 8/11/15.
//  //  Copyright (c) 2015 yudao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDDate : NSObject

+ (NSNumber *)currentTimeStampInMillSeconds;

+ (NSNumber *)currentTimeStampInSeconds;

+ (NSString *)getDefaultForamtDate;
  
@end
