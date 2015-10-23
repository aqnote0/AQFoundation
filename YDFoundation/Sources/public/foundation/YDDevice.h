//
//  YDDevice.h
//  YDFoundation
//
//  Created by madding.lip on 5/4/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IOS8_OR_LATER                                           \
  ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != \
   NSOrderedAscending)
#define IOS7_OR_LATER                                           \
  ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != \
   NSOrderedAscending)
#define IOS6_OR_LATER                                           \
  ([[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != \
   NSOrderedAscending)
#define IOS5_OR_LATER                                           \
  ([[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != \
   NSOrderedAscending)
#define IOS4_OR_LATER                                           \
  ([[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != \
   NSOrderedAscending)
#define IOS3_OR_LATER                                           \
  ([[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != \
   NSOrderedAscending)

#define IOS7_OR_EARLIER (!IOS8_OR_LATER)
#define IOS6_OR_EARLIER (!IOS7_OR_LATER)
#define IOS5_OR_EARLIER (!IOS6_OR_LATER)
#define IOS4_OR_EARLIER (!IOS5_OR_LATER)
#define IOS3_OR_EARLIER (!IOS4_OR_LATER)

#define IS_SCREEN_55_INCH IS_IPHONE_6P
#define IS_SCREEN_47_INCH IS_IPHONE_6
#define IS_SCREEN_4_INCH IS_IPHONE_5
#define IS_SCREEN_35_INCH                                            \
  ([UIScreen instancesRespondToSelector:@selector(currentMode)]      \
       ? CGSizeEqualToSize(CGSizeMake(640, 960),                     \
                           [[UIScreen mainScreen] currentMode].size) \
       : NO)

@interface YDDevice : NSObject

+ (NSString *)osVersion;

+ (NSString *)deviceModel;

+ (NSString *)deviceUUID;

+ (BOOL)isJailBroken NS_AVAILABLE_IOS(4_0);

+ (NSString *)jailBreaker NS_AVAILABLE_IOS(4_0);

+ (BOOL)isDevicePhone;

+ (BOOL)isDevicePad;

+ (BOOL)requiresPhoneOS;

+ (BOOL)isPhone;

+ (BOOL)isPhone35;

+ (BOOL)isPhoneRetina35;

+ (BOOL)isPhoneRetina4;

+ (BOOL)isPad;

+ (BOOL)isPadRetina;

+ (BOOL)isScreenSize:(CGSize)size;

@end

