//
//  YDSandbox.m
//  YDFoundation
//
//  Created by madding.lip on 5/4/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//
#import "YDSandbox.h"

#import "YDSingleton.h"

@interface YDSandbox () {
  NSString *_appPath;
  NSString *_docPath;
  NSString *_libPrefPath;
  NSString *_libCachePath;
  NSString *_tmpPath;
}

@property(nonatomic, readonly) NSString *appPath;
@property(nonatomic, readonly) NSString *docPath;
@property(nonatomic, readonly) NSString *libPrefPath;
@property(nonatomic, readonly) NSString *libCachePath;
@property(nonatomic, readonly) NSString *tmpPath;

- (BOOL)remove:(NSString *)path;
- (BOOL)touch:(NSString *)path;
- (BOOL)touchFile:(NSString *)path;

@end

@implementation YDSandbox

YD_DEF_SINGLETON

@dynamic appPath;
@dynamic docPath;
@dynamic libPrefPath;
@dynamic libCachePath;
@dynamic tmpPath;

+ (NSString *)appPath {
  return [[YDSandbox sharedInstance] appPath];
}

+ (NSString *)docPath {
  return [[YDSandbox sharedInstance] docPath];
}

+ (NSString *)libPrefPath {
  return [[YDSandbox sharedInstance] libPrefPath];
}

+ (NSString *)libCachePath {
  return [[YDSandbox sharedInstance] libCachePath];
}

+ (NSString *)tmpPath {
  return [[YDSandbox sharedInstance] tmpPath];
}

+ (BOOL)remove:(NSString *)path {
  return [[YDSandbox sharedInstance] remove:path];
}

- (BOOL)remove:(NSString *)path {
  return [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

+ (BOOL)touch:(NSString *)path {
  return [[YDSandbox sharedInstance] touch:path];
}

+ (BOOL)touchFile:(NSString *)file {
  return [[YDSandbox sharedInstance] touchFile:file];
}

#pragma Private Method

- (NSString *)appPath {
  if (nil == _appPath) {
    NSString *exeName =
        [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
    NSString *appPath =
        [[NSHomeDirectory() stringByAppendingPathComponent:exeName]
            stringByAppendingPathExtension:@"app"];
    _appPath = appPath;
  }
  return _appPath;
}

- (NSString *)docPath {
  if (nil == _docPath) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    _docPath = [paths objectAtIndex:0];
  }
  return _docPath;
}

- (NSString *)libPrefPath {
  if (nil == _libPrefPath) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                         NSUserDomainMask, YES);
    NSString *path =
        [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
    [self touch:path];
    _libPrefPath = path;
  }
  return _libPrefPath;
}

- (NSString *)libCachePath {
  if (nil == _libCachePath) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                         NSUserDomainMask, YES);
    NSString *path =
        [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
    [self touch:path];
    _libCachePath = path;
  }
  return _libCachePath;
}

- (NSString *)tmpPath {
  if (nil == _tmpPath) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                         NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/tmp"];
    [self touch:path];
    _tmpPath = path;
  }
  return _tmpPath;
}

- (BOOL)touch:(NSString *)path {
  if (NO == [[NSFileManager defaultManager] fileExistsAtPath:path]) {
    return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:NULL];
  }
  return YES;
}

- (BOOL)touchFile:(NSString *)file {
  if (NO == [[NSFileManager defaultManager] fileExistsAtPath:file]) {
    return [[NSFileManager defaultManager] createFileAtPath:file
                                                   contents:[NSData data]
                                                 attributes:nil];
  }
  return YES;
}
@end
