//
//  AQNumber.m
//  AQFoundation
//
//  Created by madding.lip on 8/13/15.
//  //  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import "AQNumber.h"

@implementation AQNumber

+ (NSNumber *)stringToNumber:(NSString *)value {
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
  return [formatter numberFromString:value];
}

@end
