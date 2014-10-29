//
//  ChannelBarViewControllerTest.m
//  MyspaceTVCompanion
//
//  Created by Michael Lewis on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "ChannelBarViewController.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "TestUtils.h"
#import "EpgApi.h"

@interface EpgApi(Test)
+(void)setSharedInstance:(id)inst;
@end


@interface ChannelBarViewControllerTest : SenTestCase
{
    __weak id mockTimeLbl;
    NSTimer *mockTimer;
    
    id mockEpgApi;
    
    ChannelBarViewController *channelBar;
}

@end

@implementation ChannelBarViewControllerTest

-(void)setUp
{
    mockTimeLbl = [OCMockObject mockForClass:[UILabel class]];
    mockTimer = [OCMockObject niceMockForClass:[NSTimer class]];
    
    mockEpgApi = [OCMockObject niceMockForClass:[EpgApi class]];
    [EpgApi setSharedInstance:mockEpgApi];

    channelBar = [[ChannelBarViewController alloc] init];
}


-(void)testTimeUpdate
{
    
    [channelBar setTimeLbl:(UILabel *)mockTimeLbl];
    [channelBar setClockTimer:mockTimer];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];

    NSDate *now = [[NSDate alloc] init];
    NSString *theTime = [timeFormat stringFromDate:now];

    [[mockTimeLbl expect] setText:theTime];
    [channelBar updateCurrentTime:theTime];
    [mockTimeLbl verify];
}

-(void)tearDown
{
    [mockEpgApi verify];
    [EpgApi setSharedInstance:nil];
    
    mockTimeLbl = nil;
    mockTimer=nil;
    channelBar = nil;
}


-(void)testSetActiveChannelSetsChannels
{
    
    void (^callback)(NSArray*,NSError*) = nil;
    [[[mockEpgApi expect] andCaptureCallbackArgument:&callback at:3] getChannelList:@"9999" andCall:[OCMArg any]];
    
    
    
    Channel* c = [Channel alloc];

    
    [channelBar setActiveChannel:c startingAtProgram:nil];
        
    callback([NSArray arrayWithObject:c],nil);
    
    STAssertNotNil(channelBar.channels,@"Channel model initialsied");
    
    STAssertEquals(channelBar.channels.count, (NSUInteger)1,@"1 Channel model");
    
}



@end
