//
//  AQDate.h
//  AQFoundation
//
//  Created by madding.lip on 8/11/15.
//  //  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AQDate : NSObject

+ (NSNumber *)currentTimeStampInMillSeconds;

+ (NSNumber *)currentTimeStampInSeconds;

+ (NSString *)getDefaultForamtDate;
  
@end
