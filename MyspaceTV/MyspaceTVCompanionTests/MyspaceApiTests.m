//
//  MyspaceApiTests.m
//
//  Created by Jason Zong on 18/07/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//
#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "AssertEventually/AssertEventually.h"

#import "TestUtils.h"
#import "MyspaceApi.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface MyspaceApiTests : SenTestCase
@end

@implementation MyspaceApiTests{
    MyspaceApi *api;
    Credential *credential;

    id mockTransformer;
    id urlConnection;
    void (^urlCallback)(NSURLResponse *, NSData *, NSError *);
}


- (void)setUp
{
    [super setUp];
    mockTransformer = [OCMockObject mockForClass:[AuthUserInfoTransformer class]];
    urlConnection = [OCMockObject mockForClass:[URLLoader class]];
    
    api = [MyspaceApi sharedInstance];
    
    api.urlLoader = urlConnection;
    api.transformer = mockTransformer;
    
    credential = [[Credential alloc] init];
    credential.username = @"testuser_1@ronk.com";
    credential.password = @"password";
    credential.snName   = @"myspace";
    credential.deviceId = @"d302703b-8e4e-4964-87cb-0f416556110e";
    credential.rememberMe = YES;

    urlCallback = nil;
}

-(void)tearDown
{
    [super tearDown];
    credential = nil;

    api.urlLoader = nil;
    api.transformer = nil;
    api = nil;

    mockTransformer = nil;
    urlConnection = nil;
    urlCallback = nil;
}

-(void)stubLoadUrlAndGrabCallback:(NSString *)requestPath
                       withHeader:(NSDictionary *)header
                     withPostData:(NSData *)data
{
    [[[urlConnection stub] andCaptureCallbackArgument:&urlCallback at:6]
            loadUrl:(NSString *)endsWith(requestPath)
     withHttpHeader:header
       withPostData:data
      useHttpMethod:@"POST"
           andCalls:[OCMArg any]
    ];
}

-(void)stubCheckLoadUrlAndGrabCallback:(NSString *)requestPath
                            withHeader:(NSDictionary *)header
                          withPostData:(NSData *)data
{
    assertThat(header, hasKey(@"Accept"));
    assertThat(header, hasKey(@"Content-Type"));

    [[[urlConnection stub] andCaptureCallbackArgument:&urlCallback at:6]
            loadUrl:(NSString *)endsWith(requestPath)
            withHttpHeader:header
            withPostData:data
            useHttpMethod:@"POST"
                 andCalls:[OCMArg any]
    ];
}

-(AuthUserInfo*)getLogoutAuthUserInfo
{
    AuthUserInfo *authUser = [[AuthUserInfo alloc] init];
    authUser.cookie = @"middleware-sessionId=a30b6b1a-04f3-4bde-b999-3d3d6c6a3e4b; Version=1; Comment=Middleware Session Cookie; Domain=ec2-107-20-153-10.compute-1.amazonaws.com; Max-Age=315360000; Path=/";
    authUser.dapPayload = [[NSMutableDictionary alloc] init];
    DapPayload *logout= [[DapPayload alloc] init];
    logout.uri = @"http://host/MiddlewareServerService/middlewareservice/account/logout";
    [authUser.dapPayload setValue:logout forKey:@"logout"];

    return authUser;
}

-(AuthUserInfo*)getKeepaliveAuthUser
{
    AuthUserInfo *authUser = [[AuthUserInfo alloc] init];
    authUser.cookie = @"middleware-sessionId=a30b6b1a-04f3-4bde-b999-3d3d6c6a3e4b; Version=1; Comment=Middleware Session Cookie; Domain=ec2-107-20-153-10.compute-1.amazonaws.com; Max-Age=315360000; Path=/";
    authUser.dapPayload = [[NSMutableDictionary alloc] init];
    DapPayload *keepalive= [[DapPayload alloc] init];
    keepalive.uri = @"http://host/MiddlewareServerService/middlewareservice/account/session/keepalive";
    [authUser.dapPayload setValue:keepalive forKey:@"POST"];
    
    return authUser;
}

-(void)testLoginCallsURLoader
{
    [[urlConnection expect] loadUrl:(NSString *) endsWith(@"MiddlewareServerService/middlewareservice/login") withHttpHeader:[OCMArg any] withPostData:[OCMArg any] useHttpMethod:[OCMArg any] andCalls:[OCMArg any]];

    [api login:credential andCalls:nil];

    [urlConnection verify];
}

-(void)testLoginCallsback
{
    NSData *mockServerResponseData = [TestUtils loadTestData:@"myspaceapi/authUser.json"];

    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    [header setValue:@"application/vnd.specificmedia.mws+json;type=loginResponse" forKey:@"Accept"];
    [header setValue:@"application/vnd.specificmedia.mws+json;type=loginRequest" forKey:@"Content-Type"];

    [self stubCheckLoadUrlAndGrabCallback:@"MiddlewareServerService/middlewareservice/login"
                               withHeader:header
                             withPostData:[api getPostData:credential]];

    NSMutableDictionary *responseHeader = [[NSMutableDictionary alloc] init];
    [responseHeader setValue:@"application/vnd.specificmedia.mws+json;type=loginResponse" forKey:@"Content-Type"];
    [responseHeader setValue:@"middleware-sessionId=a30b6b1a-04f3-4bde-b999-3d3d6c6a3e4b; Version=1; Comment=Middleware Session Cookie; Domain=ec2-107-20-153-10.compute-1.amazonaws.com; Max-Age=315360000; Path=/" forKey:@"Set-Cookie"];
    NSURLResponse *response = (NSURLResponse *)[[NSHTTPURLResponse alloc] initWithURL:[[NSURL alloc]initWithString:@"tesurl"] statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:responseHeader];

    [[[mockTransformer stub] andReturn: [AuthUserInfo alloc]] transformAuthUserInfo:[OCMArg any]];

    //check url not invoke.
    [mockTransformer verify];
    [urlConnection verify];

    __block BOOL callbackInvoked = NO;
    [api login:credential andCalls:^(AuthUserInfo *authUser, NSError *error) {
        callbackInvoked = YES;
        
        STAssertNil(error,@"Error was nil");
        STAssertNotNil(authUser, @"auth user not nil");
        STAssertNotNil(authUser.cookie,@"user cookie not nil");
    }];

    urlCallback(response, mockServerResponseData, nil);

    STAssertTrue(callbackInvoked, @"login calls callback");
    [mockTransformer verify];
    [urlConnection verify];
}

-(void)testLoginFail2
{
    NSData *mockServerResponseData = [TestUtils loadTestData:@"myspaceapi/failLogin.json"];
    
    credential.username = @"randomemailaddress@random.com";
    NSMutableDictionary *header = [[NSMutableDictionary alloc] init]; 
    [header setValue:@"application/vnd.specificmedia.mws+json;type=loginResponse" forKey:@"Accept"];
    [header setValue:@"application/vnd.specificmedia.mws+json;type=loginRequest" forKey:@"Content-Type"];
    
    [self stubLoadUrlAndGrabCallback:@"MiddlewareServerService/middlewareservice/login"
                               withHeader:header
                             withPostData:[api getPostData:credential]];
    NSMutableDictionary *responseHeader = [[NSMutableDictionary alloc] init];
    [responseHeader setValue:@"application/vnd.specificmedia.mws+json;type=loginResponse" forKey:@"Content-Type"];
    NSURLResponse *response = (NSURLResponse *)[[NSHTTPURLResponse alloc] initWithURL:[[NSURL alloc]initWithString:@"tesurl"] statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:responseHeader];
    
    [urlConnection verify];
    [mockTransformer verify];
    
    __block BOOL callbackInvoked = NO;
    [api login:credential andCalls:^(AuthUserInfo *authUser, NSError *nserror) {
        callbackInvoked = YES;
        
        STAssertNotNil(nserror,@"Error was not nil");
        STAssertNil(authUser, @"auth user nil");
        //-1012 is wrong credential
        STAssertTrue(nserror.code == NSURLErrorUserCancelledAuthentication, @"http status code equal -1012");
    }];
    
    urlCallback(response, mockServerResponseData, nil);
    
    STAssertTrue(callbackInvoked, @"login calls callback");
    [urlConnection verify];
    [mockTransformer verify];

}

-(void)testLoginFail
{
    NSData *mockServerResponseData = [TestUtils loadTestData:@"myspaceapi/failLogin.json"];
    
    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    [header setValue:@"application/vnd.specificmedia.mws+json;type=loginResponse" forKey:@"Accept"];
    [header setValue:@"application/vnd.specificmedia.mws+json;type=loginRequest" forKey:@"Content-Type"];

    credential.username = @"testuser_99@ronk.com";
    [self stubCheckLoadUrlAndGrabCallback:@"MiddlewareServerService/middlewareservice/login"
                               withHeader:header
                             withPostData:[api getPostData:credential]];

    NSError *error = [[NSError alloc] initWithDomain:@"NSURLErrorDomain" code:-1012 userInfo:nil];

    [[[mockTransformer stub] andReturn: [AuthUserInfo alloc]] transformAuthUserInfo:[OCMArg any]];

    //check url not invoke.
    [mockTransformer verify];
    [urlConnection verify];

    __block BOOL callbackInvoked = NO;
    [api login:credential andCalls:^(AuthUserInfo *authUser, NSError *nserror) {
        callbackInvoked = YES;

        STAssertNotNil(nserror,@"Error was not nil");
        STAssertNil(authUser, @"auth user nil");
        //-1012 is wrong credential
        STAssertTrue(nserror.code == -1012, @"http status code equal -1012");
    }];

    urlCallback(nil, mockServerResponseData, error);

    STAssertTrue(callbackInvoked, @"login calls callback");
    [urlConnection verify];
    [mockTransformer verify];
}

-(void)testLogoutCallsURLoader
{
    AuthUserInfo *authUser = [self getLogoutAuthUserInfo];
    [[urlConnection expect] loadUrl:(NSString *) endsWith(@"MiddlewareServerService/middlewareservice/account/logout")
                     withHttpHeader:[OCMArg any]
                        withPostData:[OCMArg any]
                        useHttpMethod:[OCMArg any]
                        andCalls:[OCMArg any]];

    [api logout:authUser andCalls:nil];

    [urlConnection verify];
}

-(void)testLogout
{
    AuthUserInfo *authUser = [self getLogoutAuthUserInfo];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    [header setValue:@"middleware-sessionId=a30b6b1a-04f3-4bde-b999-3d3d6c6a3e4b; Version=1; Comment=Middleware Session Cookie; Domain=ec2-107-20-153-10.compute-1.amazonaws.com; Max-Age=315360000; Path=/" forKey:@"Cookie"];
    
    [self stubLoadUrlAndGrabCallback:@"MiddlewareServerService/middlewareservice/account/logout"
                          withHeader:header 
                        withPostData:nil];

    NSMutableDictionary *responseHeader = [[NSMutableDictionary alloc] init];
    [responseHeader setValue:@"application/json" forKey:@"Accept"];
    NSURLResponse *response = (NSURLResponse *) [[NSHTTPURLResponse alloc] initWithURL:[[NSURL alloc] initWithString:@"tesurser1"] statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:responseHeader];

    [urlConnection verify];

    __block BOOL callbackInvoked = NO;
    [api logout:authUser andCalls:^(BOOL isLogout, int status, NSError *error) {
        callbackInvoked = YES;

        STAssertTrue(isLogout, @"successful logout");
        STAssertNil(error,@"Error was nil");
        STAssertTrue((status==200 || status == 403),@"successful logout status should be 200 or 403");
   }];

    urlCallback(response, nil, nil);
    
    STAssertTrue(callbackInvoked, @"login calls callback");
    [urlConnection verify];
}

-(void)testLogout2
{
    AuthUserInfo *authUser = [self getLogoutAuthUserInfo];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    [header setValue:@"middleware-sessionId=a30b6b1a-04f3-4bde-b999-3d3d6c6a3e4b; Version=1; Comment=Middleware Session Cookie; Domain=ec2-107-20-153-10.compute-1.amazonaws.com; Max-Age=315360000; Path=/" forKey:@"Cookie"];

    [self stubLoadUrlAndGrabCallback:@"MiddlewareServerService/middlewareservice/account/logout"
                          withHeader:header
                        withPostData:nil];

    NSMutableDictionary *responseHeader = [[NSMutableDictionary alloc] init];
    [responseHeader setValue:@"application/json" forKey:@"Accept"];
    NSURLResponse *response = (NSURLResponse *) [[NSHTTPURLResponse alloc] initWithURL:[[NSURL alloc] initWithString:@"tesurser1"] statusCode:403 HTTPVersion:@"HTTP/1.1" headerFields:responseHeader];

    __block bool callbackInvoked = NO;
    [api logout:authUser andCalls:^(BOOL isLogout, int status, NSError *error) {
        callbackInvoked = YES;

        STAssertTrue(isLogout, @"successful logout");
        STAssertNil(error, @"Error was nil");
        STAssertTrue((status == 200 || status == 403), @"successful logout status should be 200 or 403");
    }];
    urlCallback(response, nil, nil);

    STAssertTrue(callbackInvoked, @"login calls callback");
    [urlConnection verify];
}


-(void)testLogoutFail
{
    AuthUserInfo *authUser = [self getLogoutAuthUserInfo];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    [header setValue:@"middleware-sessionId=a30b6b1a-04f3-4bde-b999-3d3d6c6a3e4b; Version=1; Comment=Middleware Session Cookie; Domain=ec2-107-20-153-10.compute-1.amazonaws.com; Max-Age=315360000; Path=/" forKey:@"Cookie"];

    [self stubLoadUrlAndGrabCallback:@"MiddlewareServerService/middlewareservice/account/logout"
                          withHeader:header
                        withPostData:nil];


    NSMutableDictionary *responseHeader = [[NSMutableDictionary alloc] init];
    [responseHeader setValue:@"application/json" forKey:@"Accept"];

    NSURLResponse *response = (NSURLResponse *) [[NSHTTPURLResponse alloc] initWithURL:[[NSURL alloc] initWithString:@"MiddlewareServerService/middlewareservice/account/logout"] statusCode:500 HTTPVersion:@"HTTP/1.1" headerFields:responseHeader];

    __block bool callbackInvoked = NO;
    [api logout:authUser andCalls:^(BOOL isLogout, int status, NSError *error) {
        callbackInvoked = YES;
        
        STAssertNil(error, @"Error is nil");
        STAssertFalse(isLogout, @"not successful logout");
        STAssertFalse((status == 200 && status == 403), @"successful logout status should be 200 or 403");
    }];
    urlCallback(response, nil, nil);

    STAssertTrue(callbackInvoked, @"login calls callback");
    [urlConnection verify];
}

-(void)testLogoutFailNSError
{
    AuthUserInfo *authUser = [self getLogoutAuthUserInfo];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    [header setValue:@"middleware-sessionId=a30b6b1a-04f3-4bde-b999-3d3d6c6a3e4b; Version=1; Comment=Middleware Session Cookie; Domain=ec2-107-20-153-10.compute-1.amazonaws.com; Max-Age=315360000; Path=/" forKey:@"Cookie"];

    [self stubLoadUrlAndGrabCallback:@"MiddlewareServerService/middlewareservice/account/logout"
                          withHeader:header
                        withPostData:nil];

    NSMutableDictionary *responseHeader = [[NSMutableDictionary alloc] init];
    [responseHeader setValue:@"application/json" forKey:@"Accept"];
    NSURLResponse *response = (NSURLResponse *) [[NSHTTPURLResponse alloc] initWithURL:[[NSURL alloc] initWithString:@"MiddlewareServerService/middlewareservice/account/logout"] statusCode:500 HTTPVersion:@"HTTP/1.1" headerFields:responseHeader];

    NSError *error = [[NSError alloc] initWithDomain:@"NSURLErrorDomain" code:-1009 userInfo:nil];

    __block bool callbackInvoked = false;
    [api logout:authUser andCalls:^(BOOL isLogout, int status, NSError *nserror) {

        callbackInvoked = true;

        STAssertNotNil(nserror, @"Error not nil");
        STAssertFalse(isLogout, @"not successful logout");
        STAssertFalse((status == 200 && status == 403), @"successful logout status should be 200 or 403");

    }];

    urlCallback(response, nil, error);
    STAssertTrue(callbackInvoked, @"login calls callback");
    [urlConnection verify];

}

-(void)testkeepaliveCallsURLoader
{
    AuthUserInfo *authUser = [self getKeepaliveAuthUser];
    [[urlConnection expect] loadUrl:(NSString *) endsWith(@"MiddlewareServerService/middlewareservice/account/session/keepalive") withHttpHeader:[OCMArg any] withPostData:[OCMArg any] useHttpMethod:[OCMArg any] andCalls:[OCMArg any]];
    
    [api keepalive:authUser andCalls:nil];
    
    [urlConnection verify];
}

-(void)testKeepalive
{
    AuthUserInfo *authUser = [self getKeepaliveAuthUser];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    [header setValue:@"middleware-sessionId=a30b6b1a-04f3-4bde-b999-3d3d6c6a3e4b; Version=1; Comment=Middleware Session Cookie; Domain=ec2-107-20-153-10.compute-1.amazonaws.com; Max-Age=315360000; Path=/" forKey:@"Cookie"];

    [self stubLoadUrlAndGrabCallback:@"MiddlewareServerService/middlewareservice/account/session/keepalive"
                          withHeader:header
                        withPostData:nil];

    NSMutableDictionary *responseHeader = [[NSMutableDictionary alloc] init];
    [responseHeader setValue:@"application/json" forKey:@"Accept"];
    [responseHeader setValue:@"middleware-sessionId=a30b6b1a-04f3-4bde-b999-3d3d6c6a3e4b; Version=1; Comment=Middleware Session Cookie; Domain=ec2-107-20-153-10.compute-1.amazonaws.com; Max-Age=1342785600; Path=/" forKey:@"Set-Cookie"];

    NSURLResponse *response = (NSURLResponse *) [[NSHTTPURLResponse alloc] initWithURL:[[NSURL alloc] initWithString:@"tesurser1"] statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:responseHeader];

    __block BOOL callbackInvoked = NO;
    [api keepalive:authUser andCalls:^(BOOL isSuccessfulRenew, AuthUserInfo *user, int status, NSError *error) {

        callbackInvoked = YES;

        STAssertNil(error, @"Error was nil");
        STAssertNotNil(user, @"User not nil");
        STAssertTrue(isSuccessfulRenew, @"successful keepalive");
        STAssertTrue(status == 200, @"successful keepalive status should be 200");
        STAssertFalse([authUser.cookie isEqualToString:user.cookie], @"cookie should be different.");
    }];

    urlCallback(response, nil, nil);

    STAssertTrue(callbackInvoked, @"login calls callback");
    [urlConnection verify];
}


-(void)testKeepaliveFail
{
    AuthUserInfo *authUser = [self getKeepaliveAuthUser];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    [header setValue:@"middleware-sessionId=a30b6b1a-04f3-4bde-b999-3d3d6c6a3e4b; Version=1; Comment=Middleware Session Cookie; Domain=ec2-107-20-153-10.compute-1.amazonaws.com; Max-Age=315360000; Path=/" forKey:@"Cookie"];

    [self stubLoadUrlAndGrabCallback:@"MiddlewareServerService/middlewareservice/account/session/keepalive"
                          withHeader:header
                        withPostData:nil];

    NSMutableDictionary *responseHeader = [[NSMutableDictionary alloc] init];
    [responseHeader setValue:@"application/json" forKey:@"Accept"];
    [responseHeader setValue:@"middleware-sessionId=a30b6b1a-04f3-4bde-b999-3d3d6c6a3e4b; Version=1; Comment=Middleware Session Cookie; Domain=ec2-107-20-153-10.compute-1.amazonaws.com; Max-Age=1342785600; Path=/" forKey:@"Set-Cookie"];

    NSURLResponse *response = (NSURLResponse *) [[NSHTTPURLResponse alloc] initWithURL:[[NSURL alloc] initWithString:@"tesurser1"] statusCode:403 HTTPVersion:@"HTTP/1.1" headerFields:responseHeader];

    __block BOOL callbackInvoked = NO;
    [api keepalive:authUser andCalls:^(BOOL isSuccess, AuthUserInfo *user, int status, NSError *error) {

        callbackInvoked = YES;

        STAssertNil(error, @"Error was nil");
        STAssertNil(user, @"User was nil");
        STAssertFalse(isSuccess, @"not success keeplive");
        STAssertFalse(status == 200, @"successful keeplive status should be 200");
    }];

    urlCallback(response, nil, nil);

    STAssertTrue(callbackInvoked, @"login calls callback");
    [urlConnection verify];
}

-(void)testKeepaliveFail2
{
    AuthUserInfo *authUser = [self getKeepaliveAuthUser];
    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    [header setValue:@"middleware-sessionId=a30b6b1a-04f3-4bde-b999-3d3d6c6a3e4b; Version=1; Comment=Middleware Session Cookie; Domain=ec2-107-20-153-10.compute-1.amazonaws.com; Max-Age=315360000; Path=/" forKey:@"Cookie"];

    [self stubLoadUrlAndGrabCallback:@"MiddlewareServerService/middlewareservice/account/session/keepalive"
                          withHeader:header
                        withPostData:nil];

    NSMutableDictionary *responseHeader = [[NSMutableDictionary alloc] init];
    [responseHeader setValue:@"application/json" forKey:@"Accept"];
    [responseHeader setValue:@"middleware-sessionId=a30b6b1a-04f3-4bde-b999-3d3d6c6a3e4b; Version=1; Comment=Middleware Session Cookie; Domain=ec2-107-20-153-10.compute-1.amazonaws.com; Max-Age=1342785600; Path=/" forKey:@"Set-Cookie"];

    NSURLResponse *response = (NSURLResponse *) [[NSHTTPURLResponse alloc] initWithURL:[[NSURL alloc] initWithString:@"tesurser1"] statusCode:500 HTTPVersion:@"HTTP/1.1" headerFields:responseHeader];

    NSError *error = [[NSError alloc] initWithDomain:@"NSURLErrorDomain" code:-1009 userInfo:nil];

    __block BOOL callbackInvoked = NO;
    [api keepalive:authUser andCalls:^(BOOL isSuccess, AuthUserInfo *user, int status, NSError *nserror) {

        callbackInvoked = YES;

        STAssertNotNil(nserror, @"Error not nil");
        STAssertNil(user, @"User was nil");
        STAssertFalse(isSuccess, @"not success keeplive");
        STAssertFalse(status == 200, @"successful keeplive status should be 200");

    }];

    urlCallback(response, nil, error);

    STAssertTrue(callbackInvoked, @"login calls callback");

    [urlConnection verify];
}
@end
