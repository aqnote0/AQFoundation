//
//  AQHttpClient.h
//  AQFoundation
//
//  Created by madding.lip on 7/31/15.
//  Copyright (c) 2015 aqnote.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AQHttpHandler)(NSURLResponse *response, NSData *data,
                               NSError *error);

@interface AQHttpClient : NSObject

/**
*  同步发起http请求;建议不要做同步调用
*
*  @param request <#request description#>
*  @param error   <#error description#>
*
*  @return <#return value description#>
*/
+ (void)doSyncHttpRequest:(NSMutableURLRequest *)request
                  handler:(AQHttpHandler)handler;

/**
 *  异步请求
 *
 *  @param request <#request description#>
 *  @param handler <#handler description#>
 */
+ (void)doAsyncHttpRequest:(NSMutableURLRequest *)request
                   handler:(AQHttpHandler)handler;

@end
