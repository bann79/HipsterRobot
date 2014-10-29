//
//  MyspaceApi.m
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 18/07/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import "MyspaceApi.h"
#import "DDLog.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation MyspaceApi
@synthesize responseData;
@synthesize urlLoader;
@synthesize transformer;
@synthesize serverHost;

static NSString *loginUrl = @"http://%@/MiddlewareServerService/middlewareservice/login";

static MyspaceApi *instance = nil;

-(MyspaceApi*)init
{
    urlLoader = [[URLLoader alloc] init];
    urlLoader.cacheResults = NO;
    urlLoader.useStaleCache = NO;
    urlLoader.queue = [NSOperationQueue mainQueue];
    
    transformer =[[AuthUserInfoTransformer alloc] init];
    serverHost = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MiddlewareServerHost"];
    return (MyspaceApi *) [super init];
}

+(MyspaceApi*)sharedInstance
{
    @synchronized (self) {
        if(instance == nil){
            instance = [[self alloc] init];
        }
    }
    return instance;
}

+(void)setSharedInstance:(MyspaceApi*)api
{
    @synchronized (self) {
        instance = api;  
    }
}

/**
 * Client side of this method need check whether or not error occurred.
 * AuthUserInfo is the login user info
 * int is http status code
 * NSError is extra error information.
 *   NSError.code -1000: bad url
 *   NSError.code -1001: time out
 *   NSError.code -1009: not connected with internet
 *   NSError.code -1012: wrong username/password
 */
-(void) login:(Credential *)credential andCalls:(void (^)(AuthUserInfo *, NSError*)) handler
{
    DDLogInfo(@"Logging in user: %@",credential.username);
    
    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    [header setValue:@"application/vnd.specificmedia.mws+json;type=loginResponse" forKey:@"Accept"];
    [header setValue:@"application/vnd.specificmedia.mws+json;type=loginRequest" forKey:@"Content-Type"];
    
    NSData *postData = [self getPostData:credential];
    [urlLoader loadUrl:[NSString stringWithFormat:loginUrl,serverHost]
            withHttpHeader:header
              withPostData:postData
             useHttpMethod:@"POST"
                  andCalls:^(NSURLResponse *response, NSData *data, NSError *error)
                  {
                      AuthUserInfo *result = nil;

                      int httpStatus = [(NSHTTPURLResponse*)response statusCode];

                      DDLogVerbose(@"Login response: %d", httpStatus);
                      
                      if ([data length] > 0 && error == nil) {
                          NSDictionary *fields = [(NSHTTPURLResponse *) response allHeaderFields];
                          NSString *cookie = [fields valueForKey:@"Set-Cookie"];
                          
                          //currently server response null value for any random credential, indeed server should response 401 error.
                          if (cookie == nil) {
                              error = [[NSError alloc] initWithDomain:@"MWSLOGIN" code:NSURLErrorUserCancelledAuthentication userInfo:nil];
                              
                              result = nil;
                              
                          }else {
                              NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                              result = [transformer transformAuthUserInfo:json];
                              
                              //keep cookie for this user;
                              result.cookie = cookie;
                              [ChannelListRequestId setNewChannelListId:result.channelListId];
                          }

                      } else if ([data length] == 0 && error == nil) {
                          //empty reply;
                          result = nil;

                      } else if (error != nil) {
                          //there is error occurred, need check error code,
                          result = nil;
                      }

                      handler(result,error);
                  }];
}

-(void) logout:(AuthUserInfo*)currentUser andCalls:(void (^)(BOOL, int, NSError*)) handler
{
    DDLogInfo(@"Logging out user %@",currentUser.name);
    
    DapPayload *logoutDap = [currentUser.dapPayload valueForKey:@"logout"];
    
    DDLogVerbose(@"Logout url is: %@", logoutDap.uri);

    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    [headers setValue:currentUser.cookie  forKey:@"Cookie"];
    
    [urlLoader loadUrl:logoutDap.uri withHttpHeader:headers withPostData:nil useHttpMethod:@"POST" andCalls:^(NSURLResponse *response, NSData *data, NSError *error) 
     {    
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        int httpStatus = [httpResponse statusCode];
            
        NSDictionary *fields = [httpResponse allHeaderFields];
        NSString *cookie = [fields valueForKey:@"Set-Cookie"];
        DDLogVerbose(@"Logout response, status code:%i, cookie:%@", httpStatus, cookie);
        
        BOOL isSuccessfulLogout = NO;
        if (httpStatus == 200 || httpStatus == 403 ) {
            //403 invalid session id, which means that user cookie has been expired on server.
            isSuccessfulLogout = YES;
            
        }else {
            //unsuccessful logout.
            DDLogError(@"Handle login met error %@", error);
            isSuccessfulLogout = NO;
        }
        [ChannelListRequestId setNewChannelListId:@"9999"];
        
        handler(isSuccessfulLogout,httpStatus,error);
    }];
}

//post server to keep alive, if 403 forbidden, return httpError, the client of this method should check error nil or not.
-(void) keepalive:(AuthUserInfo *)currentUser andCalls:(void (^)(BOOL, AuthUserInfo*, int, NSError*)) handler
{
    DapPayload *keepalive = [currentUser.dapPayload valueForKey:@"POST"];
    
    __block AuthUserInfo *authUser = [currentUser copy];
    
    DDLogInfo(@"Doing keep alive for user: %@",currentUser);
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    [headers setValue:currentUser.cookie  forKey:@"Cookie"];
    
    [urlLoader loadUrl:keepalive.uri withHttpHeader:headers withPostData:nil useHttpMethod:@"POST" andCalls:^(NSURLResponse *response, NSData *data, NSError *error)
     {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        int httpStatus = [httpResponse statusCode];

        //new cookie come back from server?
        NSDictionary *fields = [httpResponse allHeaderFields];
        NSString *cookie = [fields valueForKey:@"Set-Cookie"];
        DDLogVerbose(@"Status error:%@ code:%i, cookie:%@", error, httpStatus, cookie);
        
        BOOL isSuccessfulRenew = NO;
        if (error != nil) {
            //met nsurlerror, return authUser as nil;
            authUser = nil;
            isSuccessfulRenew = NO;
            
        }else {
            //no nserror, check http status
            if (httpStatus == 200) {
                //successful renew server session;
                [authUser setCookie:cookie];
                isSuccessfulRenew = YES;
                
            }else{
                //request session has already been expired on server, return authUser as nil;
                authUser = nil;
                isSuccessfulRenew = NO;
            }
        }
        
        handler(isSuccessfulRenew,authUser,httpStatus,error);

    }];
}

-(NSData *)getPostData:(Credential*)credential
{
    /*
    //NSString *uuid = [[UIDevice currentDevice] uniqueIdentifier];
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    NSString *uuid = (__bridge NSString *)  CFUUIDCreateString(NULL, theUUID);
    */
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    [postData setValue:credential.username forKey:@"email"];
    [postData setValue:credential.password forKey:@"password"];
    [postData setValue:credential.snName forKey:@"snName"];
    [postData setValue:credential.deviceId forKey:@"deviceId"];
    [postData setValue:[NSNumber numberWithBool:credential.rememberMe ] forKey:@"rememberMe"];

    //serialize dictionary to json string.
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postData options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = nil;
    
    if (! jsonData) {
        DDLogError(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    //generate post data from string.
    return [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
}

/*
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    
    DDLogVerbose(@"delegate connection http status code %i", code);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    responseData = nil;
    connection = nil;
    DDLogVerbose(@"Unable to fetch data");
}
*/
@end
