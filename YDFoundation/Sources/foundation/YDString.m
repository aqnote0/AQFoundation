//
//  YDNSString.m
//  YDFoundation
//
//  Created by madding.lip on 5/14/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import "YDString.h"

@implementation YDString

+ (NSString *)fromCString:(char *)cString {
  if (nil == cString) {
    return nil;
  }
  return [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
}

+ (NSString *)fromNSData:(NSData *)data {
  return
      [YDString fromNSData:data encoding:NSUTF8StringEncoding];
}

+ (NSString *)fromNSData:(NSData *)data
                           encoding:(NSStringEncoding)encoding {
  if (nil == data) {
    return nil;
  }
  return [[NSString alloc] initWithData:data encoding:encoding];
}

+ (NSString *)fromNSURL:(NSURL *)url {
  if (nil == url) {
    return nil;
  }
  return [url absoluteString];
}

+ (NSString *)fromProtocol:(Protocol *)protocol {
  if (nil == protocol) {
    return nil;
  }
  return NSStringFromProtocol(protocol);
}

+ (NSString *)fromObject:(id)obj {
  if (nil == obj) {
    return nil;
  }
  return [YDString fromClass:[obj class]];
}

+ (NSString *)fromClass:(Class)clazz {
  if (nil == clazz) {
    return nil;
  }
  return NSStringFromClass(clazz);
}

+ (NSString *)fromSelector:(SEL)selector {
  if (nil == selector) {
    return nil;
  }
  return NSStringFromSelector(selector);
}

+ (const char *)toCString:(NSString *)string {
  if (nil == string) {
    return nil;
  }
  return [string UTF8String];
}

+ (NSData *)toNSData:(NSString *)string {
  if (nil == string) {
    return nil;
  }
  return [string dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSURL *)toNSURL:(NSString *)string {
  if (nil == string) {
    return nil;
  }
  return [NSURL URLWithString:string];
}

+ (Protocol *)toProtocol:(NSString *)string {
  if (nil == string) {
    return nil;
  }
  return NSProtocolFromString(string);
}

+ (Class)toClass:(NSString *)string {
  if (nil == string) {
    return nil;
  }
  return NSClassFromString(string);
}

+ (SEL)toSEL:(NSString *)string {
  if (nil == string) {
    return nil;
  }
  return NSSelectorFromString(string);
}

+ (NSString *)trim:(NSString *)string {
  return [string
      stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (BOOL)hasSubString:(NSString *)string substring:(NSString *)substring {
  NSRange r = [string rangeOfString:substring];
  return r.length == 0 ? NO : YES;
}

+ (BOOL)isNotBlank:(NSString *)string {
  return ![YDString isBlank:string];
}

+ (BOOL)isBlank:(NSString *)string {
  return nil == string ||
         0 ==
             [string stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceCharacterSet]]
                 .length;
}

+ (NSArray *)split:(NSString *)string sep:(NSString *)sep {
  if(string == nil) {
    return nil;
  }
  
  return [string componentsSeparatedByString:sep];
}

@end