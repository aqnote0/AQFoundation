//
//  YDRandom.m
//  YDFoundation
//
//  Created by madding.lip on 8/11/15.
//  //  Copyright (c) 2015 yudao. All rights reserved.
//

#import "YDRandom.h"

@implementation YDRandom

static NSString *kLetters =
    @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

+ (NSData *)randomSeedKeyData {
  NSString *seedKeyString = [YDRandom randomSeedKeyString];
  return [seedKeyString dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)randomSeedKeyString {
  //必须是128bytes
  NSString *result = [YDRandom randomStringWithLength:16];
  return result;
}

+ (NSString *)randomStringWithLength:(NSInteger)length {
  NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
  for (int i = 0; i < length; i++) {
    [randomString
        appendFormat:@"%C", [kLetters characterAtIndex:arc4random() %
                                                  [kLetters length]]];
  }
  return randomString;
}

@end
