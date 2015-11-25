//
//  YDJSON.m
//  YDFoundation
//
//  Created by madding.lip on 8/11/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import "YDJSON.h"
#import "YDLogger.h"
#import "YDRuntime.h"
#import "YDObject.h"

@implementation YDJSON

+ (id)jsonDataToObject:(NSData *)jsonData class:(Class)clazz {
  return [YDJSON jsonDataToObject:jsonData class:clazz option:NSJSONReadingAllowFragments];
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
  return [YDJSON dictionaryToClass:obj class:clazz];
}

+ (NSDictionary *)jsonDataToDictionary:(NSData *)jsonData {
  return [YDJSON jsonDataToObject:jsonData class:[NSDictionary class]];
}

+ (NSArray *)jsonDataToArray:(NSData *)jsonData {
  return [YDJSON jsonDataToObject:jsonData class:[NSArray class]];
}

+ (id)jsonStringToObject:(NSString *)jsonString class:(Class)clazz {
  if (jsonString == nil) {
    return nil;
  }
  NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
  return [YDJSON jsonDataToObject:jsonData class:clazz];
}

+ (NSDictionary *)jsonStringToDictionary:(NSString *)jsonString {
  return [YDJSON jsonStringToObject:jsonString class:[NSDictionary class]];
}

+ (NSArray *)jsonStringToArray:(NSString *)jsonString {
  return [YDJSON jsonStringToObject:jsonString class:[NSArray class]];
}

+ (NSData *)objectToJsonData:(id)object option:(NSJSONWritingOptions)option {
  if (object == nil) {
    return nil;
  }

  NSError *writeError = nil;
  id jsonableObject = [YDJSON asJsonableObject:object];
  NSData *jsonData =
      [NSJSONSerialization dataWithJSONObject:jsonableObject
                                      options:option
                                        error:&writeError];
  return jsonData;
}
+ (NSData *)objectToJsonData:(id)object {
  return [YDJSON objectToJsonData:object option:NSJSONWritingPrettyPrinted];
}

+ (NSString *)objectToJsonString:(id)object {
  NSData *jsonData = [YDJSON objectToJsonData:object];
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
  NSArray *propertyArray = [YDRuntime rt_properties:clazz];

  id clazzInstance = [[clazz alloc] init];

  //枚举clazz中的每个属性，然后赋值
  for (YDRTProperty *property in propertyArray) {
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
        [YDRuntime rt_propertyClassForName:clazz propName:propertyName];

    if (propertyClazz) {
      if ([value isKindOfClass:propertyClazz]) {
        // array 需要特殊处理
        if ([propertyClazz isSubclassOfClass:[NSArray class]]) {
          NSString *elementClassSel =
              [NSString stringWithFormat:@"%@ElementClass", propertyName];
          SEL selector = NSSelectorFromString(elementClassSel);
          if ([clazz respondsToSelector:selector]) {
            Class eClazz =
                [YDObject performSelector:clazzInstance seletor:selector];
            NSArray *arr = (NSArray *)value;
            NSMutableArray *mutArr =
                [NSMutableArray arrayWithCapacity:arr.count];
            for (id item in arr) {
              id newItem = [YDJSON dictionaryToClass:item class:eClazz];
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
            setValue:[YDJSON dictionaryToClass:value class:propertyClazz]
              forKey:propertyName];
      } else {
        [clazzInstance setValue:value forKey:propertyName];
        YD_DEBUG(@"type of '%@' is %@, %@ is expected", propertyName,
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
      [newArray addObject:[YDJSON asJsonableObject:item]];
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
      [newDict setObject:[YDJSON asJsonableObject:item] forKey:key];
    }
    return newDict;
  }
  
  // 充血模型对象，转成NSDictionary对象
  NSArray *propertyArray = [YDRuntime rt_properties:[object class]];
  NSMutableDictionary *returnDic =
      [NSMutableDictionary dictionaryWithCapacity:propertyArray.count];
  for (YDRTProperty *property in propertyArray) {
    if (property == nil) continue;
    id value = [object valueForKey:[property name]];
    if (!value) {
      value = [NSNull null];
    } else {
      value = [YDJSON asJsonableObject:value];
    }

    if (value != [NSNull null]) {
      [returnDic setObject:value forKey:[property name]];
    }
  }

  return returnDic;
}
@end
