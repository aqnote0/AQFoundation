//
//  AQRandom.h
//  AQFoundation
//
//  Created by madding.lip on 8/11/15.
//  //  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AQRandom : NSObject

+ (NSData *)randomSeedKeAQata;

+ (NSString *)randomSeedKeyString;

+ (NSString *)randomStringWithLength:(NSInteger)length;
  
@end
