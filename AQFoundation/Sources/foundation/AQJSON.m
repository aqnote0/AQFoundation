//
//  AQJSON.m
//  AQFoundation
//
//  Created by madding.lip on 8/11/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import "AQJSON.h"
#import "AQLogger.h"
#import "AQRuntime.h"
#import "AQObject.h"

@implementation AQJSON

+ (id)jsonDataToObject:(NSData *)jsonData class:(Class)clazz {
  return [AQJSON jsonDataToObject:jsonData class:clazz option:NSJSONReadingAllowFragments];
}

+ (id)jsonDataToObject:(NSData *)jsonData class:(Class)clazz option:(NSJSONReadingOptions)option {
  if (!jsonData || [[NSNull null] isEqual:jsonData] ||
      [jsonData isKindOfClass:[NSError class]]) {
    return nil;
  }
  //先调用json kit转化为dictionary或array对象
  id obj = [NSJSONSerialization JSONObjectWithData:jsonData
                                           options:option
                                             error:nil];

  if (![obj isKindOfClass:[NSDictionary class]]) {
    return obj;
  }
  return [AQJSON dictionaryToClass:obj class:clazz];
}

+ (NSDictionary *)jsonDataToDictionary:(NSData *)jsonData {
  return [AQJSON jsonDataToObject:jsonData class:[NSDictionary class]];
}

+ (NSArray *)jsonDataToArray:(NSData *)jsonData {
  return [AQJSON jsonDataToObject:jsonData class:[NSArray class]];
}

+ (id)jsonStringToObject:(NSString *)jsonString class:(Class)clazz {
  if (jsonString == nil) {
    return nil;
  }
  NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
  return [AQJSON jsonDataToObject:jsonData class:clazz];
}

+ (NSDictionary *)jsonStringToDictionary:(NSString *)jsonString {
  return [AQJSON jsonStringToObject:jsonString class:[NSDictionary class]];
}

+ (NSArray *)jsonStringToArray:(NSString *)jsonString {
  return [AQJSON jsonStringToObject:jsonString class:[NSArray class]];
}

+ (NSData *)objectToJsonData:(id)object option:(NSJSONWritingOptions)option {
  if (object == nil) {
    return nil;
  }

  NSError *writeError = nil;
  id jsonableObject = [AQJSON asJsonableObject:object];
  NSData *jsonData =
      [NSJSONSerialization dataWithJSONObject:jsonableObject
                                      options:option
                                        error:&writeError];
  return jsonData;
}
+ (NSData *)objectToJsonData:(id)object {
  return [AQJSON objectToJsonData:object option:NSJSONWritingPrettyPrinted];
}

+ (NSString *)objectToJsonString:(id)object {
  NSData *jsonData = [AQJSON objectToJsonData:object];
  if(jsonData == nil) return @"";
  return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma - Private Method

+ (id)dictionaryToClass:(NSDictionary *)dictionary class:(Class)clazz {
  // clazz 为字典类型，不需要转换
  if ([clazz isSubclassOfClass:[NSDictionary class]]) {
    return [dictionary copy];
  }

  //获取clazz属性列表
  NSArray *propertyArray = [AQRuntime rt_properties:clazz];

  id clazzInstance = [[clazz alloc] init];

  //枚举clazz中的每个属性，然后赋值
  for (AQRTProperty *property in propertyArray) {
    NSString *propertyName = [property name];
    id value = [dictionary objectForKey:propertyName];

    // 值不存在，不需要赋值
    if (value == nil) {
      continue;
    }

    // 值为null对象，直接赋值
    if (value == [NSNull null]) {
      [clazzInstance setValue:nil forKey:propertyName];
      continue;
    }

    Class valueClazz = [value class];
    Class propertyClazz =
        [AQRuntime rt_propertyClassForName:clazz propName:propertyName];

    if (propertyClazz) {
      if ([value isKindOfClass:propertyClazz]) {
        // array 需要特殊处理
        if ([propertyClazz isSubclassOfClass:[NSArray class]]) {
          NSString *elementClassSel =
              [NSString stringWithFormat:@"%@ElementClass", propertyName];
          SEL selector = NSSelectorFromString(elementClassSel);
          if ([clazz respondsToSelector:selector]) {
            Class eClazz =
                [AQObject performSelector:clazzInstance seletor:selector];
            NSArray *arr = (NSArray *)value;
            NSMutableArray *mutArr =
                [NSMutableArray arrayWithCapacity:arr.count];
            for (id item in arr) {
              id newItem = [AQJSON dictionaryToClass:item class:eClazz];
              if (newItem) [mutArr addObject:newItem];
            }
            [clazzInstance setValue:mutArr forKey:propertyName];
          } else {
            [clazzInstance setValue:value forKey:propertyName];
          }
        } else {
          [clazzInstance setValue:value forKey:propertyName];
        }
      } else if ([value isKindOfClass:[NSDictionary class]]) {
        [clazzInstance
            setValue:[AQJSON dictionaryToClass:value class:propertyClazz]
              forKey:propertyName];
      } else {
        [clazzInstance setValue:value forKey:propertyName];
        AQ_DEBUG(@"type of '%@' is %@, %@ is expected", propertyName,
                   propertyClazz, valueClazz);
      }
    } else {
      [clazzInstance setValue:value forKey:propertyName];
    }
  }

  return clazzInstance;
}

+ (id)asJsonableObject:(id)object {
  // NSString对象直接返回，可转json
  if ([object isKindOfClass:[NSString class]]) {
    return object;
  }

  // NSNumber对象直接返回，可转json
  if ([object isKindOfClass:[NSNumber class]]) {
    return object;
  }
  
  // NSDate对象直接返回，可转json
  if ([object isKindOfClass:[NSDate class]]) {
    return [NSString stringWithFormat:@"%@", object];
  }

  // NSArray对象处理，内嵌充血模型递归处理
  if ([object isKindOfClass:[NSArray class]]) {
    NSArray *oldArray = (NSArray *)object;
    NSMutableArray *newArray =
        [NSMutableArray arrayWithCapacity:[oldArray count]];
    for (id item in oldArray) {
      [newArray addObject:[AQJSON asJsonableObject:item]];
    }
    return newArray;
  }
  
  // NSDictionary对象，内嵌充血模型递归处理
  if ([object isKindOfClass:[NSDictionary class]]) {
    NSDictionary *oldDict = (NSDictionary *)object;
    NSMutableDictionary *newDict =
        [NSMutableDictionary dictionaryWithCapacity:[oldDict count]];
    for (id key in [oldDict allKeys]) {
      id item = [oldDict objectForKey:key];
      [newDict setObject:[AQJSON asJsonableObject:item] forKey:key];
    }
    return newDict;
  }
  
  // 充血模型对象，转成NSDictionary对象
  NSArray *propertyArray = [AQRuntime rt_properties:[object class]];
  NSMutableDictionary *returnDic =
      [NSMutableDictionary dictionaryWithCapacity:propertyArray.count];
  for (AQRTProperty *property in propertyArray) {
    if (property == nil) continue;
    id value = [object valueForKey:[property name]];
    if (!value) {
      value = [NSNull null];
    } else {
      value = [AQJSON asJsonableObject:value];
    }

    if (value != [NSNull null]) {
      [returnDic setObject:value forKey:[property name]];
    }
  }

  return returnDic;
}
@end
