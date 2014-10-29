//
//  WatchingApiTests.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 24/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestUtils.h"
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>


#import "XMPPClient.h"
#import "WatchingApi.h"

#import "EpgModel.h"

@interface WatchingApiTests : SenTestCase
@end

@implementation WatchingApiTests{
    
    id mockXMPPStream;
    id mockXMPPRoster;

    WatchingApi *api;
}

-(void)setUp
{
    mockXMPPStream = [OCMockObject mockForClass:[XMPPStream class]];
    mockXMPPRoster = [OCMockObject mockForClass:[XMPPRosterMemoryStorage class]];
    
    api = [[WatchingApi alloc] initWithRoster:mockXMPPRoster];

    [[mockXMPPStream expect] addDelegate:api delegateQueue:api.moduleQueue];
    [[mockXMPPStream expect] registerModule:api];
    dispatch_sync(api.moduleQueue, ^{
        [api activate:mockXMPPStream];
    });
    
    
}

-(void)tearDown
{
    [mockXMPPStream verify];
    [mockXMPPRoster verify];
}

-(void)validatePresence:(XMPPPresence*)p
{
    STAssertEqualObjects([[p elementForName:@"channelId"] stringValue], @"channel-callsign", @"Channel id correct");
    
    STAssertEqualObjects([[p elementForName:@"channelName"] stringValue], @"channel-title", @"Channel name correct");
    STAssertEqualObjects([[p elementForName:@"programmeId"] stringValue], @"program-id", @"Program id correct");
    STAssertEqualObjects([[p elementForName:@"programmeTitle"] stringValue], @"program-name", @"Program name correct");
    
}

-(void)testSetWatchingSetsPresenceWithCorrectStructure
{
    Programme *prog   = [[Programme alloc] init];
    prog.programmeID   = @"program-id";
    prog.name       = @"program-name";
    
    Channel *chan   = [[Channel alloc] init];
    chan.callSign   = @"channel-callsign";
    chan.title      = @"channel-title";
    
    [[[mockXMPPStream expect] andCall:@selector(validatePresence:) onObject:self] sendElement:instanceOf([XMPPPresence class])];
    
    [api setWatching:prog onChannel:chan];
}

-(void)testSetStoppedWatching
{
    
    [[mockXMPPStream expect] sendElement:instanceOf([XMPPPresence class])];
    
    [api setStoppedWatching];
}


@end
