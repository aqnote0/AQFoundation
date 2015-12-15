//
//  YDHttpUtil.m
//  YDFoundation
//
//  Created by madding.lip on 7/31/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import "YDHttpUtil.h"
#import "YDLogger.h"

@implementation YDHttpUtil

//表单数据转义处理
+ (NSData *)encodeDictionaryToKV:(NSDictionary *)dict {
  if (dict.count <= 0) {
    return nil;
  }

  NSMutableArray *keyValuePairs = [NSMutableArray array];
  for (NSString *key in [dict allKeys]) {
    NSString *value = [dict objectForKey:key];
    if (![value isKindOfClass:[NSString class]]) {
      YD_DEBUG(@"%s, %@ is not NSString Class", __FUNCTION__, value);
    }

    CFStringRef escapedStr = CFURLCreateStringByAddingPercentEscapes(
        NULL, (CFStringRef)value, NULL, (CFStringRef) @" !*'();:@&=+$,/?%#[]",
        kCFStringEncodingUTF8); //注意空格
    [keyValuePairs
        addObject:[NSString stringWithFormat:@"%@=%@", key, escapedStr]];
    CFRelease(escapedStr);
  }
  return [[keyValuePairs componentsJoinedByString:@"&"]
      dataUsingEncoding:NSUTF8StringEncoding];
}

@end
