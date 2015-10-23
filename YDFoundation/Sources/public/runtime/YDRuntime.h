//
//  YDRuntime.h
//  YDFoundation
//
//  Created by madding.lip on 7/22/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YDRTIvar.h"
#import "YDRTMethod.h"
#import "YDRTProperty.h"
#import "YDRTClass.h"
#import "YDRTProtocol.h"

@interface YDRuntime : NSObject

/**
 *  返回class的对象
 *
 *  @param clazz <#clazz description#>
 *
 *  @return <#return value description#>
 */
+ (id)allocByClass:(Class)clazz;

/**
 *  返回className对应类的对象
 *
 *  @param clazzName <#clazzName description#>
 *
 *  @return <#return value description#>
 */
+ (id)allocByClassName:(NSString *)clazzName;

/**
 * 获取runtime所有类
 *
 *  @return <#return value description#>
 */
+ (NSArray/*Class*/ *)rt_allclasses;

/**
 *  获取runtime中partentClass的所有子类
 *
 *  @param parentClass 需要查询的类
 *
 *  @return parentClass子类集合
 */
+ (NSArray/*Class*/ *)rt_subclasses:(Class)parentClass;

/**
 *  获取runtime中所有视线protocol协议的类
 *
 *  @param protocol <#protocol description#>
 *
 *  @return <#return value description#>
 */
+ (NSArray/*Class*/ *)rt_allClassesImplOf:(Protocol *)protocol;

/**
 *  动态创建一个未注册的class
 *
 *  @param name        name description
 *  @param parentClass <#parentClass description#>
 *
 *  @return <#return value description#>
 */
+ (YDRTClass *)rt_createUnregisteredSubclass:(NSString *)name
                                   parentClass:(Class)parentClass;

/**
 *  动态创建一个注册过的类
 *
 *  @param name        <#name description#>
 *  @param parentClass <#parentClass description#>
 *
 *  @return <#return value description#>
 */
+ (Class)rt_createSubclass:(NSString *)name parentClass:(Class)parentClass;

/**
 *  动态销毁运行态中一个类
 *
 *  @param clazz <#clazz description#>
 */
+ (void)rt_destroyClass:(Class)clazz;

/**
 *  判断一个类的isa指针是否是指向类
 *
 *  @param clazz <#clazz description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)rt_isMetaClass:(Class)clazz;

/**
 *  设置clazz的父类为newSuperClass
 *
 *  @param clazz         需要操作的类
 *  @param newSuperclass 新的父类
 *
 *  @return <#return value description#>
 */
+ (Class)rt_setSuperclass:(Class)clazz superClass:(Class)newSuperclass;

/**
 *  获取clazz实例内存占用空间
 *
 *  @param clazz <#clazz description#>
 *
 *  @return <#return value description#>
 */
+ (size_t)rt_instanceSize:(Class)clazz;

/**
 *  获取clazz中实现的协议列表
 *
 *  @param clazz <#clazz description#>
 *
 *  @return <#return value description#>
 */
+ (NSArray /*YDRTProtocol*/ *)rt_protocols:(Class)clazz;

/**
 *  获取clazz中所有的方法列表
 *
 *  @param clazz <#clazz description#>
 *
 *  @return <#return value description#>
 */
+ (NSArray /*YDRTMethod*/ *)rt_methods:(Class)clazz;

/**
 *  获取clazz中sel方法选择器(SEL)对应的函数指针(IMP)
 *
 *  @param clazz <#clazz description#>
 *  @param sel   <#sel description#>
 *
 *  @return <#return value description#>
 */
+ (YDRTMethod *)rt_methodForSelector:(Class)clazz sel:(SEL)sel;

/**
 *  向clazz类中添加method方法
 *
 *  @param clazz  <#clazz description#>
 *  @param method <#method description#>
 */
+ (void)rt_addMethod:(Class)clazz method:(YDRTMethod *)method;

/**
 *  获取clazz的所有变量
 *
 *  @param clazz <#clazz description#>
 *
 *  @return <#return value description#>
 */
+ (NSArray /*YDRTIvar*/ *)rt_ivars:(Class)clazz;

/**
 *  获取clazz类中名称为name的变量
 *
 *  @param clazz <#clazz description#>
 *  @param name  <#name description#>
 *
 *  @return <#return value description#>
 */
+ (YDRTIvar *)rt_ivarForName:(Class)clazz varName:(NSString *)name;

/**
 *  获取clazz类中的所有属性
 *
 *  @param clazz <#clazz description#>
 *
 *  @return <#return value description#>
 */
+ (NSArray /*YDRTProperty*/ *)rt_properties:(Class)clazz;

/**
 *  获取clazz类中名字为name的属性
 *
 *  @param clazz <#clazz description#>
 *  @param name  <#name description#>
 *
 *  @return <#return value description#>
 */
+ (YDRTProperty *)rt_propertyForName:(Class)clazz propName:(NSString *)name;

+ (Class)rt_propertyClassForName:(Class)clazz propName:(NSString *)name;

/**
 *  向clazz中添加property属性
 *
 *  @param BOOL <#BOOL description#>
 *
 *  @return <#return value description#>
 */
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_7
+ (BOOL)rt_addProperty:(Class)clazz property:(YDRTProperty *)property;
#endif

/**
 *  交互clazz中两个方法选择器的实现
 *
 *  @param clazz <#clazz description#>
 *  @param orig  <#orig description#>
 *  @param dest  <#dest description#>
 */
+ (void)exchangeImplementations:(Class)clazz orig:(SEL)orig dest:(SEL)dest;

/// 对象操作方法

/**
 *  获取obj对应的meta class的实例（即obj的类，但不等同于[obj class]）
 *
 *  @param obj <#obj description#>
 *
 *  @return <#return value description#>
 */
+ (Class)rt_class:(id)obj;

/**
 *  将obj的类设置为为newClass
 *
 *  @param obj      <#obj description#>
 *  @param newClass <#newClass description#>
 *
 *  @return <#return value description#>
 */
+ (Class)rt_setClass:(id)obj class:(Class)newClass;

/**
 *  传入指定的参数，调用obj对象的method方法指针
 *
 *  @param obj    <#obj description#>
 *  @param method <#method description#>
 *
 *  @return <#return value description#>
 */
+ (id)rt_returnValue:(id)obj method:(YDRTMethod *)method, ...;

/**
 *  传入指定参数，调用obj对象的method方法指针，并通过return返回对应的结果
 *
 *  @param obj    <#obj description#>
 *  @param retPtr <#retPtr description#>
 *  @param method <#method description#>
 */
+ (void)rt_returnValue:(id)obj
                return:(void *)pRet
                method:(YDRTMethod *)method, ...;

/**
 *  传入指定参数，调用obj对象的sel方法选择器指向的方法
 *
 *  @param obj <#obj description#>
 *  @param sel <#sel description#>
 *
 *  @return <#return value description#>
 */
+ (id)rt_returnValue:(id)obj sel:(SEL)sel, ...;

/**
 *  传入指定参数，调用obj对象的sel方法选择器指向的方法，并通过return返回结果
 *
 *  @param obj    <#obj description#>
 *  @param retPtr <#retPtr description#>
 *  @param sel    <#sel description#>
 */
+ (void)rt_returnValue:(id)obj return:(void *)pRet sel:(SEL)sel, ...;

+ (id)rt_returnValue:(id)instance sel:(SEL)sel params:(NSArray *)params;

@end
