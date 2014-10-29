//
//  AuthUserInfoTransformerTests.m
//
//  Created by Jason Zong on 18/07/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//
#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "AssertEventually/AssertEventually.h"

#import "TestUtils.h"

#import "AuthUserInfo.h"
#import "AuthUserInfoTransformer.h"

@interface AuthUserInfoTransformerTests : SenTestCase{
    AuthUserInfoTransformer* transformer;
}
@end


@implementation AuthUserInfoTransformerTests

-(void)setUp{
    transformer = [[AuthUserInfoTransformer alloc] init];
}

-(void)testTransformAuthUserInfo
{
    NSData* data =[TestUtils loadTestData:@"myspaceapi/authUser.json"];
    NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    AuthUserInfo *authUser = [transformer transformAuthUserInfo:jsonData];
    
    [self validateAuthUserInfo:authUser];
}


-(void)validateAuthUserInfo:(AuthUserInfo*)authUser
{
    STAssertNotNil(authUser.xmppJid,@"xmppJid not nil");
    STAssertNotNil(authUser.xmppPassword,@"password not nil");
    STAssertNotNil(authUser.name,@"name not nil");
    STAssertNotNil(authUser.sessionId,@"session id not nil");
    STAssertNotNil(authUser.accountId,@"account id not nil");
    STAssertNotNil(authUser.authenticationToken,@"authentication token not nil");
    STAssertNotNil(authUser.channelListId,@"channel list id not nil");
    //STAssertNotNil(authUser.objectIDString,@"objectIDString not nil");
    
    STAssertTrue(authUser.profileImageUrls.count > 0, @"profile image url not nil");
    STAssertTrue(authUser.dapPayload.count >0, @"dap payload not nil");
}

-(void)testTransformProfileImages
{
    NSData* data =[TestUtils loadTestData:@"myspaceapi/authUser.json"];
    NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSMutableArray* images = [jsonData valueForKeyPath:@"serverObject.profileImageUrls"];
    for(NSDictionary* json in images)
    {
        ProfileImage *img = [transformer transformProfileImages:json];
        [self validateProfileImages:img];
    }
}


-(void)validateProfileImages:(ProfileImage*)image
{
    STAssertNotNil(image.name,@"profile image name not nil");
    STAssertNotNil(image.url,@"url not nil");
    STAssertTrue(image.width>0,@"width not nil");
    STAssertTrue(image.height>0,@"height not nil");
}


-(void)testTransformPayload
{
    NSData* data =[TestUtils loadTestData:@"myspaceapi/authUser.json"];
    NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSMutableArray* payloads = [jsonData valueForKey:@"dapPayload"];
    for(NSDictionary* json in payloads)
    {
        DapPayload *payload = [transformer transformPayload:json];
        [self validatePayload:payload];
    }
}


-(void)validatePayload:(DapPayload*)payload
{
    STAssertNotNil(payload.rel,@"rel not nil");
    STAssertNotNil(payload.uri,@"uri not nil");
    //STAssertNotNil(payload.accepts,@"accepts not nil");
    //STAssertNotNil(payload.produces,@"produces not nil");
}

-(void)testNilOrJSONValue
{
    STAssertNil([transformer nilOrJSONValue:[NSNull null]], @"return nil when json value is NSNull null object.");
    
    STAssertEquals([transformer nilOrJSONValue:@"mock json value"], @"mock json value", @"transformer class return same non-null value.");
}
@end