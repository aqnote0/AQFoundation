//
//  YDSandbox.h
//  YDFoundation
//
//  Created by madding.lip on 5/4/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDSandbox : NSObject

/** 
 * 程序目录，不能存任何东西
 */
+ (NSString *)appPath;

/**
 * 文档目录，需要ITUNES同步备份的数据存这里
 */
+ (NSString *)docPath;

/**
 * 配置目录，配置文件存这里
 */
+ (NSString *)libPrefPath;

/**
 *  缓存目录，系统永远不会删除这里的文件，ITUNES会删除
 */
+ (NSString *)libCachePath;

/**
 *  缓存目录，APP退出后，系统可能会删除这里的内容
 */
+ (NSString *)tmpPath;

+ (BOOL)remove:(NSString *)path;

+ (BOOL)touch:(NSString *)path;

+ (BOOL)touchFile:(NSString *)file;

@end
