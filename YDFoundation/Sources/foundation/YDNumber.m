//
//  YDNumber.m
//  YDFoundation
//
//  Created by madding.lip on 8/13/15.
//  //  Copyright (c) 2015 yudao. All rights reserved.
//

#import "YDNumber.h"

@implementation YDNumber

+ (NSNumber *)stringToNumber:(NSString *)value {
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
  return [formatter numberFromString:value];
}

@end
