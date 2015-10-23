//
//  YDNotification.h
//  YDFoundation
//
//  Created by madding.lip on 5/4/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDNotification : NSObject

+ (BOOL)postNotification:(NSString *)name;

+ (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object;

+ (void)observeNotification:(id)observer name:(NSString *)name;

+ (void)unobserveNotification:(id)observer name:(NSString *)name;

- (void)handleNotification:(NSNotification *)notification;

@end
