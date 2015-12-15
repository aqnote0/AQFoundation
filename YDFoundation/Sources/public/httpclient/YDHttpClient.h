//
//  YDHttpClient.h
//  YDFoundation
//
//  Created by madding.lip on 7/31/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^YDHttpHandler)(NSURLResponse *response, NSData *data,
                               NSError *error);

@interface YDHttpClient : NSObject

/**
*  同步发起http请求;建议不要做同步调用
*
*  @param request <#request description#>
*  @param error   <#error description#>
*
*  @return <#return value description#>
*/
+ (void)doSyncHttpRequest:(NSMutableURLRequest *)request
                  handler:(YDHttpHandler)handler;

/**
 *  异步请求
 *
 *  @param request <#request description#>
 *  @param handler <#handler description#>
 */
+ (void)doAsyncHttpRequest:(NSMutableURLRequest *)request
                   handler:(YDHttpHandler)handler;

@end
