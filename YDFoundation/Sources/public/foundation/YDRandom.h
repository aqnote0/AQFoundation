//
//  YDRandom.h
//  YDFoundation
//
//  Created by madding.lip on 8/11/15.
//  //  Copyright (c) 2015 yudao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDRandom : NSObject

+ (NSData *)randomSeedKeyData;

+ (NSString *)randomSeedKeyString;

+ (NSString *)randomStringWithLength:(NSInteger)length;
  
@end
