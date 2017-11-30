//
//  AQClass.h
//  AQFoundation
//
//  Created by madding.lip on 5/15/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AQClass : NSObject

/**
 * 判断clazz类是不是partentClass类的子类
 */
+ (BOOL)isSubclassOf:(Class)clazz parentClass:(Class)partentClass;

/**
 * 判断clazz类是不是实现了protocol协议
 */
+ (BOOL)isConformsTo:(Class)clazz protocol:(Protocol *)protocol;

/**
 *  是否是原子类型类
 *
 *  @param clazz <#clazz description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isAtomClass:(Class)clazz;

@end
