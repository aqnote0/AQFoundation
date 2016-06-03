//
//  AQBase64.h
//  AQFoundation
//
//  Created by madding.lip on 8/3/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AQBase64 : NSObject

+ (NSString *)encodeStandardBase64ForData:(NSData *)data;

+ (NSData *)decodeStandardBase64String:(NSString *)string;

+ (NSString *)encodeUrlSafeBase64ForData:(NSData *)data;

+ (NSData *)decodeUrlSafeBase64String:(NSString *)string;

@end
