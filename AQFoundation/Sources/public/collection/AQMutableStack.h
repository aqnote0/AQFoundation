//
//  AQStack.h
//  AQFoundation
//
//  Created by madding.lip on 5/19/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AQMutableStack<__covariant ObjectType> : NSObject

- (instancetype)initWithSize:(NSUInteger)size NS_DESIGNATED_INITIALIZER;

- (id)pop;

- (id)peek;

- (void)push:(id)object;

- (NSInteger)size;

- (BOOL)empty;

- (BOOL)full;

- (void)clear;

- (NSArray *)dump;

@end

