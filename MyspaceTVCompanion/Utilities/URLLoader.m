//
//  URLLoader.m
//  LisasTestApp
//
//  Created by Lisa Croxford on 01/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "URLLoader.h"

#import "DDLog.h"

static const int ddLogLevel = LOG_LEVEL_ERROR;

const NSInteger MAX_REQUESTS = 4;

@implementation URLLoader
{
    NSInteger pendingRequests;
    
}

@synthesize cacheResults, useStaleCache, queue;

-(URLLoader*)init
{
    cacheResults = YES;
    useStaleCache = YES;
    
    NSInteger cap = [[NSURLCache sharedURLCache] diskCapacity];
    DDLogInfo(@"Current disk cache capacity %d",cap);

    return (URLLoader *) [super init];
}

-(void)scheduleRequest:(NSURLRequest*)req withHandler:(void (^)(NSURLResponse *, NSData *, NSError *))handler
{
    [queue addOperationWithBlock:^{
        
        pendingRequests++;
        
        DDLogVerbose(@"Requests queued: %d",pendingRequests);
        
        
        DDLogVerbose(@"Request headers %@",[req allHTTPHeaderFields]);
        
        [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse* r, NSData* d, NSError* e) {
        
             
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)r;
            
            if(e){
                DDLogError(@"Recived error response for url:\n%@\n%@",[req URL],e);
            }
            
            DDLogVerbose(@"Response for: %@ \n Status code:%d \n Headers:%@ \n Data: %@",
                 [req URL],
                 [httpResponse statusCode],
                 [httpResponse allHeaderFields],
                 [[NSString alloc] initWithData:d encoding:NSASCIIStringEncoding]);
            
            handler(r,d,e);
            
            pendingRequests--;
            DDLogVerbose(@"Request complete, requests left: %d",pendingRequests);
            
        }];
    }];
}

-(void)loadUrl:(NSString *)url 
withAcceptType:(NSString*) type 
      andCalls:(void (^)(NSURLResponse *, NSData *, NSError *))handler 
{
    DDLogInfo(@"Loading url: %@",url);
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    if(cacheResults)
    {
        [req setCachePolicy:NSURLCacheStorageAllowed];
    }
    
    [req setTimeoutInterval:10];
    
    if(type)
    {
        [req addValue:type forHTTPHeaderField:@"Accept"];
    }
    
    if(useStaleCache){
        NSCachedURLResponse* cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:req];
        if(cachedResponse){
            
            NSURLResponse *response = cachedResponse.response;
            NSData *data = cachedResponse.data;
            
            
            if(ddLogLevel == LOG_LEVEL_VERBOSE){
                DDLogVerbose(@"Cached Response for: %@ \n Data: %@",
                             [req URL],
                             [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
            }
            
            if(queue == [NSOperationQueue currentQueue]){
                handler(response,data,nil);
            }else{
                [queue addOperationWithBlock:^{handler(response,data,nil);}];
            }
            return;
        }
    }
    
    [self scheduleRequest:req withHandler:handler];
}


-(void)loadUrl:(NSString *)url 
withHttpHeader:(NSDictionary*)headers
withPostData:(NSData *)postData 
 useHttpMethod:(NSString*)method
    andCalls:(void (^)(NSURLResponse *, NSData *, NSError *))handler
{
    
    DDLogInfo(@"Posting data to url: %@",url);
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //POST should NOT cache storage.
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

    [request setTimeoutInterval:10];
    
    if (headers != nil) {
        for (NSString *key in [headers allKeys]) {
            [request setValue:[headers valueForKey:key] forHTTPHeaderField:key];
        }
    }
    
    if(method != nil && ![method isEqualToString:@""]) {
        [request setHTTPMethod:method];
    }
    if(postData != nil) {
        [request setHTTPBody:postData];
    }
    
    [self scheduleRequest:request withHandler:handler];

}
@end