//
//  YDBundle.m
//  YDFoundation
//
//  Created by madding.lip on 5/19/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import "YDBundle.h"

#import "YDLogger.h"
#import "YDString.h"

@implementation YDBundle

+ (NSString *)appVersion {
  return [[[NSBundle mainBundle] infoDictionary]
            objectForKey:@"CFBundleVersion"];
}

+ (NSString *)appShortVersion {
  return [[[NSBundle mainBundle] infoDictionary]
            objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)appBundleId {
  return [[[NSBundle mainBundle] infoDictionary]
            objectForKey:(__bridge NSString *)kCFBundleIdentifierKey];
}

+ (NSString *)appSchema {
  return [self appSchema:nil];
}

+ (NSString *)appSchema:(NSString *)name {
  NSArray *array =
  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
  for (NSDictionary *dict in array) {
    if (name) {
      NSString *URLName = [dict objectForKey:@"CFBundleURLName"];
      if (nil == URLName) {
        continue;
      }
      
      if (NO == [URLName isEqualToString:name]) {
        continue;
      }
    }
    
    NSArray *URLSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
    if (nil == URLSchemes || 0 == URLSchemes.count) {
      continue;
    }
    
    NSString *schema = [URLSchemes objectAtIndex:0];
    if (schema && schema.length) {
      return schema;
    }
  }
  
  return nil;
}


+ (NSString *)mainBundleFileContent:(NSString *)fileName
                           fileType:(NSString *)fileType {
  NSBundle *ibundle = [NSBundle mainBundle];
  NSString *filePath = [ibundle pathForResource:fileName ofType:fileType];
  NSString *ret = [NSString stringWithContentsOfFile:filePath
                                            encoding:NSUTF8StringEncoding
                                               error:nil];
  if (!ret) {
    YD_DEBUG(@"%s %@ missing content: %@", __FUNCTION__, @"", fileName);
  }
  return ret;
}

+ (NSString *)bundleFileContent:(NSString *)fileName
                       fileType:(NSString *)fileType
                     bundleName:(NSString *)bundleName {
  NSURL *url = [YDBundle bundleFileURL:fileName
                                    fileType:fileType
                                  bundleName:bundleName];
  NSString *content = [NSString stringWithContentsOfURL:url
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];
  if (!content) {
    YD_DEBUG(@"%s missing content: %@.%@", __FUNCTION__, fileName, fileType);
  }
  return content;
}

+ (NSURL *)bundleFileURL:(NSString *)fileName
                fileType:(NSString *)fileType
              bundleName:(NSString *)bundleName {
  NSString *bundlePath =
      [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
  NSBundle *ibundle = [NSBundle bundleWithPath:bundlePath];
  NSString *filePath = [ibundle pathForResource:fileName ofType:fileType];

  if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    YD_ERROR(@"%s %@.bundle/%@.%@ is no exst.", __FUNCTION__, bundleName,
               fileName, fileType)
    return nil;
  }

  return [NSURL fileURLWithPath:filePath];
}

@end