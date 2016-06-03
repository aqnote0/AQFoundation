//
//  AQTree.m
//  AQFoundation
//
//  Created by madding.lip on 5/19/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import "AQMutableTree.h"

#import "AQMutableStack.h"
#import "AQMutableQueue.h"

@interface DepthOrder : NSObject

@property(nonatomic, retain) AQMutableStack *stack;

+ (instancetype)sharedInstance;

- (NSArray *)depthOrder:(AQTreeNode *)node;

@end

@interface LevelOrder : NSObject

@property(nonatomic, retain) AQMutableQueue *queue;

+ (instancetype)sharedInstance;

- (NSArray *)levelOrder:(AQTreeNode *)node;

@end

@implementation AQTreeNode

- (instancetype)initWithData:(id)data {
  if (self) {
    _parent = nil;
    _children = [NSMutableArray array];
    _data = data;
  }
  return self;
}

- (void)addChild:(AQTreeNode *)node {
  if (nil == node) {
    return;
  }
  node.parent = self;
  [self.children addObject:node];
}

- (void)removeChild:(AQTreeNode *)node {
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

@implementation AQMutableTree

+ (void)preOrder:(AQTreeNode *)node {
  if (node != NULL) {
    NSLog(@"%@", node.data);  // 先遍历父节点
    NSInteger len = node.children.count;
    for (int i = 0; i < len; i++) {
      [self preOrder:node.children[i]];  // 再遍历子节点
    }
  }
}

+ (void)postOrder:(AQTreeNode *)node {
  if (node != NULL) {
    NSInteger len = node.children.count;
    for (int i = 0; i < len; i++) {
      [self preOrder:node.children[i]];  // 先遍历子节点
    }
    NSLog(@"%@", node.data);  // 后遍历父节点
  }
}

+ (NSArray *)depthOrder:(AQTreeNode *)node {
  NSArray *pluginOrderList = [[DepthOrder sharedInstance] depthOrder:node];
  return pluginOrderList;
}

+ (NSArray *)levelOrder:(AQTreeNode *)node {
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
    _stack = [[AQMutableStack alloc] initWithSize:128];
  }
  return self;
}

- (NSArray *)depthOrder:(AQTreeNode *)node {
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

- (AQTreeNode *)next {
  if ([self hasNext]) {
    AQTreeNode *node = (AQTreeNode *)[_stack pop];
    for (AQTreeNode *children in [node children]) {
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
    _queue = [[AQMutableQueue alloc] init];
  }
  return self;
}

- (NSArray *)levelOrder:(AQTreeNode *)node {
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

- (AQTreeNode *)next {
  if ([self hasNext]) {
    AQTreeNode *node = (AQTreeNode *)[_queue poll];
    for (AQTreeNode *children in [node children]) {
      [_queue push:children];
    }
    return node;
  } else {
    return nil;
  }
}

@end
