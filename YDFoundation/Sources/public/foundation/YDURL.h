//
//  YDURL.h
//  YDFoundation
//
//  Created by madding.lip on 5/14/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDURL : NSObject

+ (NSString *)urlEncoded:(NSString *)string;

+ (NSString *)urlDecoded:(NSString *)string;
  
@end
