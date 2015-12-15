//
//  YDHttpClient.m
//  YDFoundation
//
//  Created by madding.lip on 7/31/15.
//  Copyright (c) 2015 yudao. All rights reserved.
//

#import "YDHttpClient.h"
#import "YDThread.h"
#import "YDLogger.h"
#import "YDOpQueue.h"

#define YD_HTTP_QUEUE [YDOpQueue get:@"com.madding.http" maxcount:3]

@interface YDHttpThread : NSObject {
  dispatch_queue_t _backHttpQueue;
}

YD_DEC_SINGLETON

+ (void)backgroundHttp:(dispatch_block_t)block;
  
@end


@implementation YDHttpThread

YD_DEF_SINGLETON

- (instancetype)init {
  self = [super init];
  if(self) {
    _backHttpQueue = dispatch_queue_create("com.madding.queue.ihttp", DISPATCH_QUEUE_SERIAL);
  }
  return self;
}

+ (void)backgroundHttp:(dispatch_block_t)block {
  return [[YDHttpThread sharedInstance] backgroundHttp:block];
}
- (void)backgroundHttp:(dispatch_block_t)block {
  dispatch_async(_backHttpQueue, block);
}

@end

@implementation YDHttpClient

+ (void)doSyncHttpRequest:(NSMutableURLRequest *)request
                  handler:(YDHttpHandler)handler {
  // 包装请求
  NSMutableURLRequest *middleRequest = [self wrapRequest:request];

  // 发送请求
  NSError *middleError = nil;
  NSURLResponse *middleResponse = nil;
  NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request
                                                               delegate:self];
  
  NSData *middleData = [[connection class] sendSynchronousRequest:middleRequest
                                             returningResponse:&middleResponse
                                                         error:&middleError];

  // 处理响应
  NSURLResponse *finalResponse;
  NSError *finalError;
  NSData *finalData = [self wrapResponse:middleData
                                 request:middleRequest
                                response:middleResponse
                                   error:middleError
                               oresponse:&finalResponse
                                  oerror:&finalError];
  if (handler) {
    dispatch_block_t block = ^(void) {
     handler(finalResponse, finalData, finalError);
    };
    [YDHttpThread backgroundHttp:block];
  }
}

+ (void)doAsyncHttpRequest:(NSMutableURLRequest *)request
                   handler:(YDHttpHandler)handler {
  NSMutableURLRequest *middleRequest = [self wrapRequest:request];

  YDHttpHandler middleHandler =
      ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSURLResponse *finalResponse = nil;
        NSError *finalError = nil;
        NSData *finalData = [self wrapResponse:data
                                       request:request
                                      response:response
                                         error:connectionError
                                     oresponse:&finalResponse
                                        oerror:&finalError];
        if (handler) {
          dispatch_block_t block = ^(void) {
            handler(finalResponse, finalData, finalError);
          };
          [YDHttpThread backgroundHttp:block];
        }
        return;
      };

  [NSURLConnection sendAsynchronousRequest:middleRequest
                                     queue:YD_HTTP_QUEUE
                         completionHandler:middleHandler];
}

#pragma marks - Private Method
+ (NSMutableURLRequest *)wrapRequest:(NSMutableURLRequest *)request {
  NSTimeInterval userDefTimeout = [request timeoutInterval];
  if (userDefTimeout < 1.0f || userDefTimeout > 60.0f) {
    userDefTimeout = 15.0f;
    [request setTimeoutInterval:userDefTimeout];
  }
  NSURL *url = [request URL];
  NSMutableURLRequest *tmpRequest = [NSMutableURLRequest
                                     requestWithURL:url
                                     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                     timeoutInterval:userDefTimeout];
  
  [tmpRequest setAllHTTPHeaderFields:[request allHTTPHeaderFields]];
  [tmpRequest setHTTPMethod:[request HTTPMethod]];
  [tmpRequest setHTTPBody:[request HTTPBody]];
  return [tmpRequest mutableCopy];
}

+ (NSData *)wrapResponse:(NSData *)data
                 request:(NSMutableURLRequest *)request
                response:(NSURLResponse *)response
                   error:(NSError *)error
               oresponse:(NSURLResponse *__autoreleasing *)oresponse
                  oerror:(NSError *__autoreleasing *)oerror {
  *oresponse = response;
  *oerror = error;
  return data;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    YD_FUNC
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    YD_FUNC
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//    YD_FUNC
}

@end
