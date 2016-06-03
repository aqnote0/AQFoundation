//
//  AQQueue.h
//  AQFoundation
//
//  Created by madding.lip on 5/20/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AQMutableQueue<__covariant ObjectType>: NSObject

- (void)push:(id)object;

- (id)poll;

- (id)peek;

- (BOOL)empty;

- (void)clear;

- (NSArray *)dump;

@end
