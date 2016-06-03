//
//  AQNotification.m
//  AQFoundation
//
//  Created by madding.lip on 5/4/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import "AQNotification.h"

@implementation AQNotification

+ (BOOL)postNotification:(NSString *)name {
  [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
  return YES;
}

+ (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object {
  [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                      object:object];
  return YES;
}

+ (void)observeNotification:(id)observer name:(NSString *)name {
  [[NSNotificationCenter defaultCenter] removeObserver:observer
                                                  name:name
                                                object:nil];
  [[NSNotificationCenter defaultCenter]
      addObserver:observer
         selector:@selector(handleNotification:)
             name:name
           object:nil];
}

+ (void)unobserveNotification:(id)observer name:(NSString *)name {
  [[NSNotificationCenter defaultCenter] removeObserver:observer
                                                  name:name
                                                object:nil];
}

- (void)handleNotification:(NSNotification *)notification {
}

@end