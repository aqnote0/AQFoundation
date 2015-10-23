//
//  YDExtension.h
//  YDFoundation
//
//  Created by madding.lip on 5/8/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDExtension : NSObject

+ (id)allocByClass:(Class)clazz;

+ (id)allocByClassName:(NSString *)clazzName;

+ (NSString *)stringFromClass:(Class)clazz;

- (void)performMsgSendWithTarget:(id)target sel:(SEL)sel signal:(id)signal;

- (BOOL)performMsgSendWithTarget:(id)target sel:(SEL)sel;

- (void)copyPropertiesFrom:(id)obj;

@end
