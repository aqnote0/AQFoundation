//
//  AQRuntime.m
//  AQFoundation
//
//  Created by madding.lip on 7/22/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import "AQRuntime.h"
#import <objc/runtime.h>
#import "AQRTClass.h"
#import "AQRTIvar.h"
#import "AQRTMethod.h"
#import "AQRTProperty.h"
#import "AQRTProtocol.h"

@implementation AQRuntime

+ (id)allocByClass:(Class)clazz {
  if ( nil == clazz )
    return nil;
  
  return [clazz alloc];
}

+ (id)allocByClassName:(NSString *)clazzName {
  if ( nil == clazzName || 0 == [clazzName length] )
    return nil;
  
  Class clazz = NSClassFromString( clazzName );
  if ( nil == clazz )
    return nil;
  
  return [clazz alloc];
}

+ (NSArray *)rt_allclasses {
  static NSMutableArray *__allClasses = nil;
  if (nil == __allClasses) {
    __allClasses = [[NSMutableArray alloc] init];
  }

  if (0 == [__allClasses count]) {
    unsigned int classesCount = 0;
    Class *classes = objc_copyClassList(&classesCount);

    for (unsigned int i = 0; i < classesCount; ++i) {
      Class classType = classes[i];
      Class superClass = class_getSuperclass(classType);
      if (nil == superClass) continue;
      if (NO == [classType isSubclassOfClass:[NSObject class]]) continue;
      [__allClasses addObject:classType];
    }
    free(classes);
  }
  return __allClasses;
}

+ (NSArray *)rt_subclasses:(Class)parentClass {
  NSMutableArray *array = [NSMutableArray array];
  NSArray *classes = [AQRuntime rt_allclasses];
  for (Class clazz in classes) {
    // 保存clazz
    Class candidate = clazz;
    // 临时父类变量
    Class superclass = candidate;
    // 查找继承关系中是不是包含当前类
    while (superclass) {
      if ((superclass == parentClass) && (superclass != clazz)) {
        [array addObject:candidate];
        break;
      }
      superclass = class_getSuperclass(superclass);
    }
  }
  return array;
}

+ (NSArray *)rt_allClassesImplOf:(Protocol *)protocol {
  NSMutableArray * results = [[NSMutableArray alloc] init];
  
  for ( Class classType in [AQRuntime rt_allclasses] ) {
    if ( classType == protocol )
      continue;
    
    if ( NO == [classType conformsToProtocol:protocol] )
      continue;
    
    [results addObject:classType];
  }
  
  return results;
}

+ (AQRTClass *)rt_createUnregisteredSubclass:(NSString *)name
                                   parentClass:(Class)parentClass {
  return
      [AQRTClass unregisteredClassWithName:name withSuperclass:parentClass];
}

+ (Class)rt_createSubclass:(NSString *)name parentClass:(Class)parentClass {
  return
      [[AQRuntime rt_createUnregisteredSubclass:name
                                      parentClass:parentClass] registerClass];
}

+ (void)rt_destroyClass:(Class)clazz {
  objc_disposeClassPair(clazz);
}

+ (BOOL)rt_isMetaClass:(Class)clazz {
  return class_isMetaClass(clazz);
}

#ifdef __clang__
#pragma clang diagnostic push
#endif
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+ (Class)rt_setSuperclass:(Class)clazz superClass:(Class)newSuperclass {
  return class_setSuperclass(clazz, newSuperclass);
}
#ifdef __clang__
#pragma clang diagnostic pop
#endif

+ (size_t)rt_instanceSize:(Class)clazz {
  return class_getInstanceSize(clazz);
}

+ (NSArray *)rt_protocols:(Class)clazz {
  unsigned int count;
  Protocol *__unsafe_unretained *protocols =
      class_copyProtocolList(clazz, &count);
  NSMutableArray *array = [NSMutableArray array];
  for (unsigned i = 0; i < count; i++)
    [array addObject:[AQRTProtocol protocolWithObjCProtocol:protocols[i]]];

  free(protocols);
  return array;
}

+ (NSArray *)rt_methods:(Class)clazz {
  unsigned int count;
  Method *methods = class_copyMethodList(clazz, &count);
  NSMutableArray *array = [NSMutableArray array];
  for (unsigned i = 0; i < count; i++)
    [array addObject:[AQRTMethod methodWithObjCMethod:methods[i]]];

  free(methods);
  return array;
}

+ (AQRTMethod *)rt_methodForSelector:(Class)clazz sel:(SEL)sel {
  Method method = class_getInstanceMethod(clazz, sel);
  if (!method) return nil;
  return [AQRTMethod methodWithObjCMethod:method];
}

+ (void)rt_addMethod:(Class)clazz method:(AQRTMethod *)method {
  class_addMethod(clazz, [method selector], [method implementation],
                  [[method signature] UTF8String]);
}

+ (NSArray *)rt_ivars:(Class)clazz {
  unsigned int count;
  Ivar *list = class_copyIvarList(clazz, &count);
  NSMutableArray *array = [NSMutableArray array];
  for (unsigned i = 0; i < count; i++)
    [array addObject:[AQRTIvar ivarWithObjCIvar:list[i]]];

  free(list);
  return array;
}

+ (AQRTIvar *)rt_ivarForName:(Class)clazz varName:(NSString *)name {
  Ivar ivar = class_getInstanceVariable(clazz, [name UTF8String]);
  if (!ivar) return nil;
  return [AQRTIvar ivarWithObjCIvar:ivar];
}

+ (NSArray *)rt_properties:(Class)clazz {
  unsigned int count;
  objc_property_t *list = class_copyPropertyList(clazz, &count);
  NSMutableArray *array = [NSMutableArray array];
  for (unsigned i = 0; i < count; i++)
    [array addObject:[AQRTProperty propertyWithObjCProperty:list[i]]];

  free(list);
  return array;
}

+ (AQRTProperty *)rt_propertyForName:(Class)clazz propName:(NSString *)name {
  objc_property_t property = class_getProperty(clazz, [name UTF8String]);
  if (!property) return nil;
  return [AQRTProperty propertyWithObjCProperty:property];
}

+ (Class)rt_propertyClassForName:(Class)clazz propName:(NSString *)name {
  objc_property_t property = class_getProperty(clazz, [name UTF8String]);
  if (!property) return nil;

  AQRTProperty *rtProperty =
      [AQRTProperty propertyWithObjCProperty:property];
  if (rtProperty == nil) return nil;

  NSString *typeEncoding = [rtProperty typeEncoding];
  NSArray *splitTypeEncoding = [typeEncoding componentsSeparatedByString:@"\""];

  NSString *className = nil;
  if (splitTypeEncoding.count > 1) {
    className = splitTypeEncoding[1];
    if (className) {
      return NSClassFromString(className);
    }
  }
  return nil;
}

#if __MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_7
+ (BOOL)rt_addProperty:(Class)clazz property:(AQRTProperty *)property {
  return [property addToClass:clazz];
}
#endif

+ (void)exchangeImplementations:(Class)clazz orig:(SEL)orig dest:(SEL)dest {
  Method origM = class_getInstanceMethod(clazz, orig);
  Method destM = class_getInstanceMethod(clazz, dest);
  method_exchangeImplementations(origM, destM);
}

+ (Class)rt_class:(id)obj {
  return object_getClass(obj);
}

+ (Class)rt_setClass:(id)obj class:(Class)newClass {
  return object_setClass(obj, newClass);
}

+ (id)rt_returnValue:(id)obj method:(AQRTMethod *)method, ... {
  NSParameterAssert([[method signature]
      hasPrefix:[NSString stringWithUTF8String:@encode(id)]]);
  id retVal = nil;
  va_list args;
  va_start(args, method);
  [method returnValue:&retVal sendToTarget:obj args:args];
  va_end(args);
  return retVal;
}

+ (void)rt_returnValue:(id)obj
                return:(void *)pRet
                method:(AQRTMethod *)method, ... {
  va_list args;
  va_start(args, method);
  [method returnValue:pRet sendToTarget:obj args:args];
  va_end(args);
}

+ (id)rt_returnValue:(id)obj sel:(SEL)sel, ... {
  AQRTMethod *method =
      [AQRuntime rt_methodForSelector:object_getClass(obj) sel:sel];
  NSParameterAssert([[method signature]
      hasPrefix:[NSString stringWithUTF8String:@encode(id)]]);
  id retVal = nil;
  va_list args;
  va_start(args, sel);
  [method returnValue:&retVal sendToTarget:obj args:args];
  va_end(args);

  return retVal;
}

+ (void)rt_returnValue:(id)obj
                return:(void *)pRet
                   sel:(SEL)sel, ... {
  AQRTMethod *method =
      [AQRuntime rt_methodForSelector:object_getClass(obj) sel:sel];
  va_list args;
  va_start(args, sel);
  [method returnValue:pRet sendToTarget:obj args:args];
  va_end(args);
}

+ (id)rt_returnValue:(id)instance
                 sel:(SEL)sel
              params:(NSArray *)params {
  NSMethodSignature *signature = [instance methodSignatureForSelector:sel];
  NSAssert(signature != nil, @"methodSignature must not be nil!");
  
  NSInvocation *invocation =
  [NSInvocation invocationWithMethodSignature:signature];
  
  BOOL isNeedParam = params && [params count] > 0;
  if (isNeedParam) {
    int i = 0;
    for (id o in params) {
      __unsafe_unretained id param = o;
      [invocation setArgument:&param atIndex:2 + i];
      i++;
    }
  }
  
  [invocation setTarget:instance];
  [invocation setSelector:sel];
  [invocation invoke];
  
  id result;
  
  BOOL isNeedMethodResult = [signature methodReturnLength] > 0;
  if (isNeedMethodResult) {
    //获得返回值类型
    const char *returnType = signature.methodReturnType;
    
    //声明返回值变量
    __unsafe_unretained id returnValue;
    //如果没有返回值，也就是消息声明为void，那么returnValue=nil
    if (!strcmp(returnType, @encode(void))) {
      returnValue = nil;
      
    }  //如果返回值为对象，那么为变量赋值
    else if (!strcmp(returnType, @encode(id))) {
      [invocation getReturnValue:&returnValue];
    } else {
      //如果返回值为普通类型NSInteger  BOOL
      //返回值长度
      NSUInteger length = [signature methodReturnLength];
      
      //根据长度申请内存
      void *buffer = (void *)malloc(length);
      
      //为变量赋值
      [invocation getReturnValue:buffer];
      
      if (!strcmp(returnType, @encode(BOOL))) {
        returnValue = [NSNumber numberWithBool:*((BOOL *)buffer)];
      } else if (!strcmp(returnType, @encode(NSInteger))) {
        returnValue = [NSNumber numberWithInteger:*((NSInteger *)buffer)];
      } else {
        returnValue = [NSValue valueWithBytes:buffer objCType:returnType];
      }
    }
    
    result = returnValue;
    returnValue = nil;
  }
  if (isNeedParam) {
    params = nil;
  }
  return result;
}


@end
