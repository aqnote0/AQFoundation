//
//  YDTree.m
//  YDFoundation
//
//  Created by madding on 5/19/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import "YDMutableTree.h"

#import "YDMutableStack.h"
#import "YDMutableQueue.h"

@interface DepthOrder : NSObject

@property(nonatomic, retain) YDMutableStack *stack;

+ (instancetype)sharedInstance;

- (NSArray *)depthOrder:(YDTreeNode *)node;

@end

@interface LevelOrder : NSObject

@property(nonatomic, retain) YDMutableQueue *queue;

+ (instancetype)sharedInstance;

- (NSArray *)levelOrder:(YDTreeNode *)node;

@end

@implementation YDTreeNode

- (instancetype)initWithData:(id)data {
  if (self) {
    _parent = nil;
    _children = [NSMutableArray array];
    _data = data;
  }
  return self;
}

- (void)addChild:(YDTreeNode *)node {
  if (nil == node) {
    return;
  }
  node.parent = self;
  [self.children addObject:node];
}

- (void)removeChild:(YDTreeNode *)node {
  [self.children removeObject:node];
}

- (void)printDescription {
  NSLog(@"%@", self.data);

  if (self.children) {
    NSLog(@"First child of %@ will be the -->", self.data);
    NSInteger len = self.children.count;
    for (int i = 0; i < len; i++) {
      [self.children[i] printDescription];
    }
  }
}

@end

@implementation YDMutableTree

+ (void)preOrder:(YDTreeNode *)node {
  if (node != NULL) {
    NSLog(@"%@", node.data);  // 先遍历父节点
    NSInteger len = node.children.count;
    for (int i = 0; i < len; i++) {
      [self preOrder:node.children[i]];  // 再遍历子节点
    }
  }
}

+ (void)postOrder:(YDTreeNode *)node {
  if (node != NULL) {
    NSInteger len = node.children.count;
    for (int i = 0; i < len; i++) {
      [self preOrder:node.children[i]];  // 先遍历子节点
    }
    NSLog(@"%@", node.data);  // 后遍历父节点
  }
}

+ (NSArray *)depthOrder:(YDTreeNode *)node {
  NSArray *pluginOrderList = [[DepthOrder sharedInstance] depthOrder:node];
  return pluginOrderList;
}

+ (NSArray *)levelOrder:(YDTreeNode *)node {
  NSArray *pluginOrderList = [[LevelOrder sharedInstance] levelOrder:node];
  return pluginOrderList;
}

@end

@implementation DepthOrder

+ (instancetype)sharedInstance {
  static DepthOrder *instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[DepthOrder alloc] init];
  });
  return instance;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _stack = [[YDMutableStack alloc] initWithSize:128];
  }
  return self;
}

- (NSArray *)depthOrder:(YDTreeNode *)node {
  NSMutableArray *pluginList = [NSMutableArray array];
  // 添加root节点
  [_stack push:node];
  while ([self hasNext]) {
    [pluginList addObject:[self next]];
  }
  return [pluginList copy];
}

- (BOOL)hasNext {
  return ![_stack empty];
}

- (YDTreeNode *)next {
  if ([self hasNext]) {
    YDTreeNode *node = (YDTreeNode *)[_stack pop];
    for (YDTreeNode *children in [node children]) {
      [_stack push:children];
    }
    return node;
  } else {
    return nil;
  }
}

@end

@implementation LevelOrder

+ (instancetype)sharedInstance {
  static LevelOrder *instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[LevelOrder alloc] init];
  });
  return instance;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _queue = [[YDMutableQueue alloc] init];
  }
  return self;
}

- (NSArray *)levelOrder:(YDTreeNode *)node {
  NSMutableArray *pluginList = [NSMutableArray array];
  // 添加root节点
  [_queue push:node];
  while ([self hasNext]) {
    [pluginList addObject:[self next]];
  }
  return [pluginList copy];
}

- (BOOL)hasNext {
  return ![_queue empty];
}

- (YDTreeNode *)next {
  if ([self hasNext]) {
    YDTreeNode *node = (YDTreeNode *)[_queue poll];
    for (YDTreeNode *children in [node children]) {
      [_queue push:children];
    }
    return node;
  } else {
    return nil;
  }
}

@end
