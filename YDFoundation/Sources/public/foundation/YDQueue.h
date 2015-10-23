//
//  YDQueue.h
//  YDFoundation
//
//  Created by madding.lip on 5/20/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDQueue : NSObject

- (void)push:(id)object;

- (id)poll;

- (id)peek;

- (BOOL)empty;

- (void)clear;

- (NSArray *)dump;

@end
