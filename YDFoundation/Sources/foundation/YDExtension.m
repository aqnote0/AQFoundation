//
//  YDExtension.m
//  YDFoundation
//
//  Created by madding.lip on 5/8/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import "YDExtension.h"

#import <objc/runtime.h>

@implementation YDExtension

+ (id)allocByClass:(Class)clazz {
  if (nil == clazz) return nil;

  return [clazz alloc];
}

+ (id)allocByClassName:(NSString *)clazzName {
  if (nil == clazzName || 0 == [clazzName length]) return nil;

  Class clazz = NSClassFromString(clazzName);
  if (nil == clazz) return nil;

  return [clazz alloc];
}

+ (NSString *)stringFromClass:(Class)clazz {
  return NSStringFromClass(clazz);
}

- (void)performMsgSendWithTarget:(id)target sel:(SEL)sel signal:(id)signal {
  NSMethodSignature *sig =
      [[target class] instanceMethodSignatureForSelector:sel];

  if (sig) {
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:target];
    [inv setSelector:sel];
    [inv setArgument:(__bridge void *)(signal)atIndex:2];
    [inv invoke];
  }
}
- (BOOL)performMsgSendWithTarget:(id)target sel:(SEL)sel {
  NSMethodSignature *methodSignature =
      [[target class] instanceMethodSignatureForSelector:sel];

  if (methodSignature) {
    //从签名获得调用对象
    NSInvocation *invocation =
        [NSInvocation invocationWithMethodSignature:methodSignature];
    //设置target
    [invocation setTarget:target];
    //设置selector
    [invocation setSelector:sel];
    id returnValue = nil;
    //调用
    [invocation invoke];
    //得到返回值，此时不会再调用，只是返回值
    //        [invocation getReturnValue:&returnValue];
    const char *returnType = methodSignature.methodReturnType;
    //返回值长度
    NSUInteger length = [methodSignature methodReturnLength];
    //根据长度申请内存
    void *buffer = (void *)malloc(length);
    //为变量赋值
    [invocation getReturnValue:buffer];
    if (!strcmp(returnType, @encode(BOOL))) {
      returnValue = [NSNumber numberWithBool:*((BOOL *)buffer)];
    } else if (!strcmp(returnType, @encode(NSInteger))) {
      returnValue = [NSNumber numberWithInteger:*((NSInteger *)buffer)];
    }

    return [returnValue intValue];
  }

  return NO;
}

- (void)copyPropertiesFrom:(id)obj {
  for (Class clazzType = [obj class]; clazzType != [NSObject class];) {
    unsigned int propertyCount = 0;
    objc_property_t *properties =
        class_copyPropertyList(clazzType, &propertyCount);

    for (NSUInteger i = 0; i < propertyCount; i++) {
      const char *name = property_getName(properties[i]);
      NSString *propertyName =
          [NSString stringWithCString:name encoding:NSUTF8StringEncoding];

      [self setValue:[obj valueForKey:propertyName] forKey:propertyName];
    }

    free(properties);

    clazzType = class_getSuperclass(clazzType);
    if (nil == clazzType) break;
  }
}

@end