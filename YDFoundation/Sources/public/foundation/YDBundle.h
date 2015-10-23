//
//  YDBundle.h
//  YDFoundation
//
//  Created by madding.lip on 5/19/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDBundle : NSObject

/**
 * 内部版本号
 */
+ (NSString *)appVersion;

/**
 * 发布版本号
 */
+ (NSString *)appShortVersion;

/**
 * bundle Id
 */
+ (NSString *)appBundleId;

/**
 *
 */
+ (NSString *)appSchema;

/**
 *
 */
+ (NSString *)appSchema:(NSString *)name;

/**
 *  从main bundle读取文件
 *
 *  @param fileName   文件名
 *  @param fileType   文件类型
 *
 *  @return 文件内容
 */
+ (NSString *)mainBundleFileContent:(NSString *)fileName
                           fileType:(NSString *)fileType;

/**
 *  从指定的bundle读取文件
 *
 *  @param fileName   文件名
 *  @param fileType   文件类型
 *  @param bundleName bundle名，不包含bundle
 *
 *  @return 文件内容
 */
+ (NSString *)bundleFileContent:(NSString *)fileName
                       fileType:(NSString *)fileType
                     bundleName:(NSString *)bundleName;

/**
 *  获取指定bundle下文件的路径
 *
 *  @param fileName   文件名
 *  @param fileType   文件类型
 *  @param bundleName bundle名，不包含bundle
 *
 *  @return 文件路径的url
 */
+ (NSURL *)bundleFileURL:(NSString *)fileName
                fileType:(NSString *)fileType
              bundleName:(NSString *)bundleName;

@end
