//
//  XMPPSessionTests.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 17/07/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//

#import "TestUtils.h"
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "XMPPClient.h"
#import "XMPPPresence.h"
#import "XMPPDeprecatedDigestAuthentication.h"
#import "DDXML.h"

#import "UserProfile.h"

@interface XMPPClientTests : SenTestCase {

    id mockXMPPStream;
    id mockNotificationQueue;

    XMPPClient *client;
}
@end

@implementation XMPPClientTests

-(void)setUp
{
    mockXMPPStream = [OCMockObject niceMockForClass:[XMPPStream class]];
    mockNotificationQueue = [OCMockObject mockForClass:[NSNotificationQueue class]];

    client = [[XMPPClient alloc] init];
    [client setXmppStream:mockXMPPStream];
    [client setNotifcationQueue:mockNotificationQueue];
}

-(void)tearDown
{
    [mockXMPPStream verify];
    [mockNotificationQueue verify];
}

-(void)testConnectOkAndAuthenticate
{
    [[mockXMPPStream expect] setMyJID:instanceOf([XMPPJID class])];

    [[[mockXMPPStream expect] andReturnValue:[NSNumber numberWithBool:YES]] connect:[OCMArg setTo:nil]];

    [[[mockXMPPStream expect] andReturnValue:[NSNumber numberWithBool:YES]]
        authenticate:instanceOf([XMPPDeprecatedDigestAuthentication class]) error:[OCMArg setTo:nil]];

    [[mockNotificationQueue expect] enqueueNotification:hasProperty(@"name",XMPPAuthSuccessNotification) postingStyle:NSPostASAP];

    BOOL result = [client connectWithJID:@"bob@myspace.com" andPassword:@"correct-password"];

    //Simulate connection
    [client xmppStreamDidConnect:mockXMPPStream];
    [client xmppStreamDidAuthenticate:mockXMPPStream];

    STAssertTrue(result,@"Session did connect");
}

-(void)testConnectionFailed
{
    [[mockXMPPStream expect] setMyJID:instanceOf([XMPPJID class])];

    [[[mockXMPPStream expect] andReturnValue:[NSNumber numberWithBool:NO]] connect:[OCMArg setTo:nil]];


    BOOL result = [client connectWithJID:@"bob@myspace.com" andPassword:@"correct-password"];


    STAssertFalse(result,@"Session did not connect");
}

-(void)testConnectionWithAuthBad
{
    [[mockXMPPStream expect] setMyJID:instanceOf([XMPPJID class])];

    [[[mockXMPPStream expect] andReturnValue:[NSNumber numberWithBool:YES]] connect:[OCMArg setTo:nil]];

    [[[mockXMPPStream expect] andReturnValue:[NSNumber numberWithBool:NO]]
     authenticate:instanceOf([XMPPDeprecatedDigestAuthentication class]) error:[OCMArg setTo:nil]];

    [[mockNotificationQueue expect] enqueueNotification:hasProperty(@"name",XMPPAuthFailedNotification) postingStyle:NSPostASAP];

    BOOL result = [client connectWithJID:@"bob@myspace.com" andPassword:@"bad-password"];

    //Simulate connection
    [client xmppStreamDidConnect:mockXMPPStream];
    [client xmppStream:mockXMPPStream didNotAuthenticate:nil];

    STAssertTrue(result,@"Session did connect"); //Connected but not authed


}

-(void)validateLogooutPresenece:(XMPPPresence*)presence
{
    STAssertEqualObjects(presence.type, @"unavailable",@"Correct type for logout");
}

-(void)testLogoutSendsPresenceAndDisconnects
{
    [[[mockXMPPStream expect] andCall:@selector(validateLogooutPresenece:) onObject:self] sendElement:instanceOf([XMPPPresence class])];

    [[mockXMPPStream expect] disconnect];

    [client logout];
}

-(void)testMyspaceNameFromJid
{
    XMPPJID *jid = [XMPPJID jidWithString:@"9d588e8f-e4d4-4aa2-a4f0-1657ae818bb2_jim@ec2-107-20-153-10.compute-1.amazonaws.com/3ef6a7df-f393-4f14-820e-3c8e5939b093"];

    NSString *name = @"jim";

    STAssertEqualObjects([XMPPClient myspaceNameFromJID:jid],name, @"Correct name from jid");

}

-(void)testMyspaceNameFromJidUnEscapesWhitespace
{
    XMPPJID *jid = [XMPPJID jidWithString:@"edc381ce-e53d-4756-99d9-4b3f5b4147e2_jason\\20stringer@10.10.10.10/aabbcc4433-e53d-4756-99d9-4b3f5b4147e2"];

    NSString *name = @"jason stringer";

    STAssertEqualObjects([XMPPClient myspaceNameFromJID:jid], name, @"Correct name from jid");

}


-(void)testMyspaceNameFromJidWithUnderScore
{
    XMPPJID *jid = [XMPPJID jidWithString:@"edc381ce-e53d-4756-99d9-4b3f5b4147e2_testuser_1@10.10.10.10/aabbcc4433-e53d-4756-99d9-4b3f5b4147e2"];

    NSString *name = @"testuser_1";

    STAssertEqualObjects([XMPPClient myspaceNameFromJID:jid], name, @"Correct name from jid");

}
-(void)testDidReceivePresenceUserAvailibeGeneratesNotification
{


    NSString *jid = @"9d588e8f-e4d4-4aa2-a4f0-1657ae818bb2_jim@ec2-107-20-153-10.compute-1.amazonaws.com/3ef6a7df-f393-4f14-820e-3c8e5939b093";

    XMPPPresence *presence = [XMPPPresence presence];


    [presence setAttributes:[NSArray arrayWithObjects:
                        [DDXMLNode attributeWithName:@"xmlns" stringValue:@"jabber:client"],
                        [DDXMLNode attributeWithName:@"from" stringValue:jid],
                             nil]];

    [presence addChild:[DDXMLElement elementWithName:@"displayName" stringValue:@"jim"]];


    [[[mockNotificationQueue expect] andDo:^(NSInvocation *i) {

        NSNotification *n = nil;
        [i getArgument:&n atIndex:2];

        STAssertNotNil(n,@"Have a notifation");

        STAssertEqualObjects(n.name, FriendLoggedInNotification,@"Correct notification name");

        UserProfile *user =n.object;

        STAssertNotNil(user,@"Has user object");

        STAssertEqualObjects(user.name, @"jim",@"Correct name");
        STAssertEqualObjects(user.email, @"9d588e8f-e4d4-4aa2-a4f0-1657ae818bb2_jim@ec2-107-20-153-10.compute-1.amazonaws.com",@"Correct name");

    }] enqueueNotification:[OCMArg any] postingStyle:NSPostASAP];



    [client xmppStream:mockXMPPStream didReceivePresence:[presence copy]];



}

-(void)testDidReceivePresenceUserUnavailibeGeneratesNotification
{
    NSString *jid = @"9d588e8f-e4d4-4aa2-a4f0-1657ae818bb2_jim@ec2-107-20-153-10.compute-1.amazonaws.com/3ef6a7df-f393-4f14-820e-3c8e5939b093";

    XMPPPresence *presence = [XMPPPresence presence];
    [presence setAttributes:[NSArray arrayWithObjects:
                        [DDXMLNode attributeWithName:@"xmlns" stringValue:@"jabber:client"],
                        [DDXMLNode attributeWithName:@"type" stringValue:@"unavailable"],
                        [DDXMLNode attributeWithName:@"from" stringValue:jid],
                        nil]];

    [presence addChild:[DDXMLElement elementWithName:@"displayName" stringValue:@"jim"]];

    [[[mockNotificationQueue expect] andDo:^(NSInvocation *i) {

        NSNotification *n = nil;
        [i getArgument:&n atIndex:2];

        STAssertNotNil(n,@"Have a notifation");

        STAssertEqualObjects(n.name, FriendLoggedOutNotification,@"Correct notification name");

        UserProfile *user =n.object;
        STAssertNotNil(user,@"Has user object");
        STAssertEqualObjects(user.name, @"jim",@"Correct name");
        STAssertEqualObjects(user.email, @"9d588e8f-e4d4-4aa2-a4f0-1657ae818bb2_jim@ec2-107-20-153-10.compute-1.amazonaws.com",@"Correct name");

    }] enqueueNotification:[OCMArg any] postingStyle:NSPostASAP];

    [client xmppStream:mockXMPPStream didReceivePresence:presence];
}


-(void)testDidReceivePresenceMissingNameDoesNotThrow
{
    NSString *jid = @"9d588e8f-e4d4-4aa2-a4f0-1657ae818bb2_jim@ec2-107-20-153-10.compute-1.amazonaws.com/3ef6a7df-f393-4f14-820e-3c8e5939b093";

    XMPPPresence *presence = [XMPPPresence presence];
    [presence setAttributes:[NSArray arrayWithObjects:
            [DDXMLNode attributeWithName:@"xmlns" stringValue:@"jabber:client"],
            [DDXMLNode attributeWithName:@"type" stringValue:@"unavailable"],
            [DDXMLNode attributeWithName:@"from" stringValue:jid],
            nil]];
    [[mockNotificationQueue expect]  enqueueNotification:[OCMArg any] postingStyle:NSPostASAP];
    STAssertNoThrow([client xmppStream:mockXMPPStream didReceivePresence:presence], @"Never blew up with missing name");


}

-(void)testDidReceivePresenceMissingNameQueuesWithNilName
{
    NSString *jid = @"9d588e8f-e4d4-4aa2-a4f0-1657ae818bb2_jim@ec2-107-20-153-10.compute-1.amazonaws.com/3ef6a7df-f393-4f14-820e-3c8e5939b093";

    XMPPPresence *presence = [XMPPPresence presence];
    [presence setAttributes:[NSArray arrayWithObjects:
            [DDXMLNode attributeWithName:@"xmlns" stringValue:@"jabber:client"],
            [DDXMLNode attributeWithName:@"type" stringValue:@"unavailable"],
            [DDXMLNode attributeWithName:@"from" stringValue:jid],
            nil]];
    [[[mockNotificationQueue expect] andDo:^(NSInvocation *i) {

        NSNotification *n = nil;
        [i getArgument:&n atIndex:2];


        UserProfile *user =n.object;
        STAssertNil(user.name ,@"No name");

    }] enqueueNotification:[OCMArg any] postingStyle:NSPostASAP];
    [client xmppStream:mockXMPPStream didReceivePresence:presence];
    [mockNotificationQueue verify];

}

/*
@"<presence xmlns="jabber:client" type="unavailable" from="9d588e8f-e4d4-4aa2-a4f0-1657ae818bb2_jim@ip-10-116-79-104.ec2.internal/Lisas-Macbook" to="9d588e8f-e4d4-4aa2-a4f0-1657ae818bb2_jim@ip-10-116-79-104.ec2.internal/3ef6a7df-f393-4f14-820e-3c8e5939b093"/>;

*/

@end