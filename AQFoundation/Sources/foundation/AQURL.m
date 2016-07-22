//
//  AQURL.m
//  AQFoundation
//
//  Created by madding.lip on 5/14/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>

#import "AQString.h"
#import "AQURL.h"

@implementation AQURL

+ (NSString *)urlEncoded:(NSString *)string {
  CFStringRef cstring = CFURLCreateStringByAddingPercentEscapes(
      kCFAllocatorDefault, (CFStringRef)string, NULL,
      CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
  NSString *result = (__bridge NSString *)cstring;
  CFRelease(cstring);

  return result;
}

+ (NSString *)urlDecoded:(NSString *)string {
  CFStringRef cstring = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
      kCFAllocatorDefault, (CFStringRef)string, CFSTR(""),
      kCFStringEncodingUTF8);
  NSString *result = (__bridge NSString *)cstring;
  CFRelease(cstring);
  return result;
}

@end
