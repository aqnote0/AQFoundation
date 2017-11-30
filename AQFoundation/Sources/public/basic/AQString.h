//
//  AQNSString.h
//  AQFoundation
//
//  Created by madding.lip on 5/14/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AQString : NSObject

+ (NSString *)fromCString:(char *)cString;

+ (NSString *)fromNSData:(NSData *)data;

+ (NSString *)fromNSData:(NSData *)data encoding:(NSStringEncoding)encoding;

+ (NSString *)fromProtocol:(Protocol *)protocol;

+ (NSString *)fromObject:(id)obj;

+ (NSString *)fromClass:(Class)clazz;

+ (NSString *)fromSelector:(SEL)selector;

+ (const char *)toCString:(NSString *)string;

+ (NSData *)toNSData:(NSString *)string;

+ (Protocol *)toProtocol:(NSString *)string;

+ (Class)toClass:(NSString *)string;

+ (SEL)toSEL:(NSString *)string;

+ (NSString *)trim:(NSString *)string;

+ (BOOL)hasSubString:(NSString *)string substring:(NSString *)substring;

+ (BOOL)isBlank:(NSString *)string;

+ (BOOL)isNotBlank:(NSString *)string;

+ (NSArray *)split:(NSString *)string sep:(NSString *)sep;
@end
