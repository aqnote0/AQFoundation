//
//  YDObject.m
//  YDFoundation
//
//  Created by madding.lip on 5/15/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import "YDObject.h"

@implementation YDObject

+ (BOOL)iskindOfClass:(id)obj clazz:(Class)clazz {
  if (nil == obj || nil == clazz) {
    return FALSE;
  }
  return [obj isKindOfClass:clazz];
}

+ (BOOL)isMemberOfClass:(id)obj clazz:(Class)clazz {
  if (nil == obj || nil == clazz) {
    return FALSE;
  }
  return [obj isMemberOfClass:clazz];
}

+ (BOOL)isSubclassOfClass:(id)obj parentClass:(Class)partentClass {
  if (nil == obj) {
    return FALSE;
  }
  return [obj isSubclassOfClass:partentClass];
}

+ (BOOL)isConformsToProtocol:(id)obj protocol:(Protocol *)protocol {
  if (nil == obj || nil == protocol) {
    return FALSE;
  }
  return [obj conformsToProtocol:protocol];
}

+ (BOOL)isRespondsToSelector:(id)obj selector:(SEL)selector {
  if (nil == obj) {
    return FALSE;
  }
  return [obj respondsToSelector:selector];
}

+ (id)performSelector:(id)obj seletor:(SEL)selector {
  if (nil == obj) {
    return nil;
  }
  if ([YDObject isRespondsToSelector:obj selector:selector]) {
    IMP imp = [obj methodForSelector:selector];
    id (*function)(id, SEL) = (void *)imp;
    return function(obj, selector);
  }
  return nil;
}

+ (id)performSelector:(id)obj seletor:(SEL)selector withObject:(id)param {
  if (nil == obj) {
    return nil;
  }
  if ([YDObject isRespondsToSelector:obj selector:selector]) {
    IMP imp = [obj methodForSelector:selector];
    id (*func)(id, SEL, id) = (void *)imp;
    return func(obj, selector, param);
  }
  return nil;
}

+ (id)performSelector:(id)obj
              seletor:(SEL)selector
           withObject:(id)param
           withObject:(id)param2 {
  if (nil == obj) {
    return nil;
  }
  if ([YDObject isRespondsToSelector:obj selector:selector]) {
    IMP imp = [obj methodForSelector:selector];
    id (*func)(id, SEL, id, id) = (void *)imp;
    return func(obj, selector, param, param2);
  }
  return nil;
}

+ (NSInteger)asInteger:(id)object {
  return [[YDObject asNSNumber:object] integerValue];
}

+ (float)asFloat:(id)object {
  return [[YDObject asNSNumber:object] floatValue];
}

+ (BOOL)asBool:(id)object {
  return [[YDObject asNSNumber:object] boolValue];
}

+ (NSNumber *)asNSNumber:(id)object {
    if ( [object isKindOfClass:[NSNumber class]] ) {
        return (NSNumber *)object;
    } else if ( [object isKindOfClass:[NSString class]] ) {
        return [NSNumber numberWithFloat:[(NSString *)object floatValue]];
    } else if ( [object isKindOfClass:[NSDate class]] ) {
        return [NSNumber numberWithDouble:[(NSDate *)object timeIntervalSince1970]];
    } else if ( [object isKindOfClass:[NSNull class]] ) {
        return [NSNumber numberWithInteger:0];
    }
    return nil;
}

+ (NSString *)asNSString:(id)object {
    if ( [object isKindOfClass:[NSNull class]] )
        return nil;
    
    if ( [object isKindOfClass:[NSString class]] ) {
        return (NSString *)object;
    } else if ( [object isKindOfClass:[NSData class]] ) {
        NSData * data = (NSData *)object;
        
        NSString * text = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
        if ( nil == text ) {
            text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if ( nil == text ) {
                text = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            }
        }
        return text;
    } else {
        return [NSString stringWithFormat:@"%@", object];
    }
}

+ (NSDate *)asNSDate:(id)object {
    if ( [object isKindOfClass:[NSDate class]] ) {
        return (NSDate *)object;
    }
  if ( [object isKindOfClass:[NSString class]] ) {
        NSDate * date = nil;
        
        if ( nil == date ) {
            static NSDateFormatter * formatter = nil;
            
            if ( nil == formatter ) {
                formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss z"];
                [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            }
            
            date = [formatter dateFromString:(NSString *)object];
        }
        
        if ( nil == date ) {
            static NSDateFormatter * formatter = nil;
            
            if ( nil == formatter ) {
                formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
                [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            }
            
            date = [formatter dateFromString:(NSString *)object];
        }
        
        if ( nil == date ) {
            static NSDateFormatter * formatter = nil;
            
            if ( nil == formatter ) {
                formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            }
            
            date = [formatter dateFromString:(NSString *)object];
        }
        
        if ( nil == date ) {
            static NSDateFormatter * formatter = nil;
            
            if ( nil == formatter ) {
                formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            }
            
            date = [formatter dateFromString:(NSString *)object];
        }
        
        return date;
    }
  return [NSDate dateWithTimeIntervalSince1970:[YDObject asNSNumber:object].doubleValue];
}

+ (NSData *)asNSData:(id)object {
    if ( [object isKindOfClass:[NSString class]] ) {
        return [(NSString *)object dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    }
  if ( [object isKindOfClass:[NSData class]] ) {
        return (NSData *)object;
    }
    return nil;
}
+ (NSDictionary *)asNSDictionary:(id)object {
  if ( [object isKindOfClass:[NSDictionary class]] ) {
    return (NSDictionary *)object;
  }
  return nil;
}

+ (NSMutableDictionary *)asNSMutableDictionary:(id)object {
  if ( [object isKindOfClass:[NSMutableDictionary class]] ) {
    return (NSMutableDictionary *)object;
  }
  
  NSDictionary * dict = [YDObject asNSDictionary:object];
  if ( nil == dict )
    return nil;
  return [NSMutableDictionary dictionaryWithDictionary:dict];
}

+ (NSArray *)asNSArray:(id)object {
    if ( [object isKindOfClass:[NSArray class]] ) {
        return (NSArray *)object;
    }
    return [NSArray arrayWithObject:object];
}

+ (NSMutableArray *)asNSMutableArray:(id)object {
  if ( [object isKindOfClass:[NSMutableArray class]] ) {
    return (NSMutableArray *)object;
  }
  return nil;
}


@end