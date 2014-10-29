//
//  URLLoader.h
//  LisasTestApp
//
//  Created by Lisa Croxford on 01/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLLoader : NSObject

@property(strong) NSOperationQueue *queue;
@property bool cacheResults;    //Store items in system webcache
@property bool useStaleCache;   //Retrieve items from cache without checking freshness

-(URLLoader*)init;

-(void)loadUrl:(NSString *)url withAcceptType:(NSString*) type andCalls:(void (^)(NSURLResponse *, NSData *, NSError *))handle;

-(void)loadUrl:(NSString *)url withHttpHeader:(NSDictionary*)headers withPostData:(NSData *)data useHttpMethod:(NSString*)method andCalls:(void (^)(NSURLResponse *, NSData *, NSError *))handler;

//-(void)keepalive:(NSString *)url withCookie:(NSString *)cookie withDelegate:(id<NSURLConnectionDelegate>)delegate andCalls:(void (^)(NSURLResponse *, NSData *, NSError *))handle;
@end
