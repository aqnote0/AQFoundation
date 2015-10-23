//
//  YDJSON.h
//  YDFoundation
//
//  Created by madding.lip on 8/11/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDJSON : NSObject

+ (id)jsonDataToObject:(NSData *)jsonData class:(Class)clazz;

+ (NSDictionary *)jsonDataToDictionary:(NSData *)jsonData;

+ (NSArray *)jsonDataToArray:(NSData *)jsonData;


+ (id)jsonStringToObject:(NSString *)jsonString class:(Class)clazz;

+ (NSDictionary *)jsonStringToDictionary:(NSString *)jsonString;

+ (NSArray *)jsonStringToArray:(NSString *)jsonString;


+ (NSString *)objectToJsonString:(id)object;

+ (NSData *)objectToJsonData:(id)object;
  
@end
