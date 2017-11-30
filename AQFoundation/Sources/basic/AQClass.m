//
//  AQClass.m
//  AQFoundation
//
//  Created by madding.lip on 5/15/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import "AQClass.h"

@implementation AQClass

+ (BOOL)isSubclassOf:(Class)clazz parentClass:(Class)partentClass {
  if (nil == clazz) {
    return FALSE;
  }
  return [clazz isSubclassOfClass:partentClass];
}

+ (BOOL)isConformsTo:(Class)clazz protocol:(Protocol *)protocol {
  if (nil == clazz) {
    return FALSE;
  }
  return [clazz conformsToProtocol:protocol];
}

+ (BOOL)isAtomClass:(Class)clazz {
  if (clazz == [NSArray class]) return YES;
  if (clazz == [NSData class]) return YES;
  if (clazz == [NSDate class]) return YES;
  if (clazz == [NSDictionary class]) return YES;
  if (clazz == [NSNull class]) return YES;
  if (clazz == [NSNumber class]) return YES;
  if (clazz == [NSObject class]) return YES;
  if (clazz == [NSString class]) return YES;
  if (clazz == [NSURL class]) return YES;
  if (clazz == [NSValue class]) return YES;
  return NO;
}
@end