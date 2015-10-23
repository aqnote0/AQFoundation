//
//  YDObject.h
//  YDFoundation
//
//  Created by madding.lip on 5/15/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDObject : NSObject

/**
 * 用来判断是否是某个类或其子类的实例
 */
+ (BOOL)iskindOfClass:(id)obj clazz:(Class)clazz;

/**
 * 用来判断是否是某个类的实例
 */
+ (BOOL)isMemberOfClass:(id)obj clazz:(Class)clazz;

/**
 * 判断obj对象是不是partentClass类的子类实现
 */
+ (BOOL)isSubclassOfClass:(id)obj parentClass:(Class)partentClass;

/**
 * 判断obj对象是不是实现了protocol协议
 */
+ (BOOL)isConformsToProtocol:(id)obj protocol:(Protocol *)protocol;

/**
 * 用来判断是否有以某个名字命名的方法(被封装在一个selector的对象里传递)
 */
+ (BOOL)isRespondsToSelector:(id)obj selector:(SEL)selector;

+ (id)performSelector:(id)obj seletor:(SEL)selector;

+ (id)performSelector:(id)obj seletor:(SEL)selector withObject:(id)param;

+ (id)performSelector:(id)obj
              seletor:(SEL)selector
           withObject:(id)param
           withObject:(id)param2;

+ (NSData *)asNSData:(id)object;

@end
