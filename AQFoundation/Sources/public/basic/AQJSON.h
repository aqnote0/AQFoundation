//
//  AQJSON.h
//  AQFoundation
//
//  Created by madding.lip on 8/11/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AQJSON : NSObject

+ (NSDictionary *)jsonDataToDictionary:(NSData *)jsonData;
+ (NSDictionary *)jsonStringToDictionary:(NSString *)jsonString;

+ (NSArray *)jsonDataToArray:(NSData *)jsonData;
+ (NSArray *)jsonStringToArray:(NSString *)jsonString;

+ (id)jsonStringToObject:(NSString *)jsonString class:(Class)clazz;
+ (NSString *)objectToJsonString:(id)object;

+ (id)jsonDataToObject:(NSData *)jsonData class:(Class)clazz;
+ (NSData *)objectToJsonData:(id)object;

+ (id)jsonDataToObject:(NSData *)jsonData class:(Class)clazz option:(NSJSONReadingOptions)option;
+ (NSData *)objectToJsonData:(id)object option:(NSJSONWritingOptions)option;

@end
