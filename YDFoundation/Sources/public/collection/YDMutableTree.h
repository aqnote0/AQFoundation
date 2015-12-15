//
//  YDTree.h
//  YDFoundation
//
//  Created by madding on 5/19/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDTreeNode<__covariant ObjectType> : NSObject

@property(nonatomic, strong) id data;
@property(nonatomic, strong) NSMutableArray *children;
@property(nonatomic, strong) YDTreeNode *parent;

- (instancetype)initWithData:(id)data;

- (void)addChild:(NSObject *)node;

- (void)removeChild:(NSObject *)node;

- (void)printDescription;

@end

@interface YDMutableTree : NSObject

// 先序遍历
+ (void)preOrder:(YDTreeNode *)node;

// 后序遍历
+ (void)postOrder:(YDTreeNode *)node;

// 深度遍历
+ (NSArray *)depthOrder:(YDTreeNode *)node;

// 层次遍历
+ (NSArray *)levelOrder:(YDTreeNode *)node;

@end

