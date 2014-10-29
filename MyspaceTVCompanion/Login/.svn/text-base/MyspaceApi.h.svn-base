//
//  MyspaceApi.h
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 18/07/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLLoader.h"
#import "AuthUserInfoTransformer.h"
#import "Credential.h"
#import "ChannelListRequestId.h"

@interface MyspaceApi : NSObject //<NSURLConnectionDelegate>
@property (strong, nonatomic) NSMutableData *responseData;@property (strong, nonatomic) URLLoader *urlLoader;
@property (strong, nonatomic) AuthUserInfoTransformer *transformer;
@property NSString* serverHost;

+(MyspaceApi*)sharedInstance;

-(void) login:(Credential *)credential andCalls:(void (^)(AuthUserInfo*, NSError*)) handler;
-(void) logout:(AuthUserInfo*)currentUser andCalls:(void (^)(BOOL, int, NSError*)) handler;
-(void) keepalive:(AuthUserInfo *)currentUser andCalls:(void (^)(BOOL, AuthUserInfo*, int, NSError*)) handler;

-(NSData *)getPostData:(Credential*)credential;
@end
