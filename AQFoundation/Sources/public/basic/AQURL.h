//
//  AQURL.h
//  AQFoundation
//
//  Created by madding.lip on 5/14/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AQURL : NSObject

+ (NSString *)urlEncoded:(NSString *)string;

+ (NSString *)urlDecoded:(NSString *)string;
  
@end
