//
//  AQTree.h
//  AQFoundation
//
//  Created by madding.lip on 5/19/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AQTreeNode<__covariant ObjectType> : NSObject

@property(nonatomic, strong) id data;
@property(nonatomic, strong) NSMutableArray *children;
@property(nonatomic, strong) AQTreeNode *parent;

- (instancetype)initWithData:(id)data;

- (void)addChild:(NSObject *)node;

- (void)removeChild:(NSObject *)node;

- (void)printDescription;

@end

@interface AQMutableTree : NSObject

// 先序遍历
+ (void)preOrder:(AQTreeNode *)node;

// 后序遍历
+ (void)postOrder:(AQTreeNode *)node;

// 深度遍历
+ (NSArray *)depthOrder:(AQTreeNode *)node;

// 层次遍历
+ (NSArray *)levelOrder:(AQTreeNode *)node;

@end

