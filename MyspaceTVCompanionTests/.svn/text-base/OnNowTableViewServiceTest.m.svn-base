//
//  OnNowTableViewServiceTest.m
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 13/06/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "OnNowTableViewService.h"
#import "EpgApi.h"
#import "ScheduleItem.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface EpgApi (Test)
+(void)setSharedInstance:(id)api;
@end

@interface OnNowTableViewServiceTest : SenTestCase
@end

@implementation OnNowTableViewServiceTest

OnNowTableViewService *onNowService;
NSMutableArray *channels;
id mockEpgApi;
__weak id mockDelegate;
void (^getChannelsCB)(NSArray *, NSError *);
void (^getSchedulesCB)(NSDictionary *, NSError *);

-(void) setUp
{
    [super setUp];
    
    channels = [[NSMutableArray alloc] initWithCapacity:5];
    Channel *channel = [[Channel alloc] init];
    channel.callSign = @"ANPL:tribune:uk";
    channel.channelNumber = [NSNumber numberWithInt:103];
    channel.title = @"ANPL";
    channel.description = @"ANPL description";
    [channels addObject:channel];
    
    channel = [[Channel alloc] init];
    channel.callSign = @"BBC 1:ebsftp";
    channel.channelNumber = [NSNumber numberWithInt:101];
    channel.title = @"BBC1 Wales";
    channel.description = @"BBC flagship channel";
    [channels addObject:channel];
    
    channel = [[Channel alloc] init];
    channel.callSign = @"DSC:tribune:uk";
    channel.channelNumber = [NSNumber numberWithInt:102];
    channel.title = @"DSC";
    channel.description = @"DSC description";
    [channels addObject:channel];
    
    channel = [[Channel alloc] init];
    channel.callSign = @"E!TV:tribune:uk";
    channel.channelNumber = [NSNumber numberWithInt:311];
    channel.title = @"E! TV";
    channel.description = @"Celebrity news and gossip";
    [channels addObject:channel];
    
    
    channel = [[Channel alloc] init];
    channel.callSign = @"ESPNCL:tribune:uk";
    channel.channelNumber = [NSNumber numberWithInt:150];
    channel.title = @"ESPN";
    channel.description = @"Live sports";
    [channels addObject:channel];
    
    mockEpgApi = [OCMockObject mockForClass:[EpgApi class]];
    [EpgApi setSharedInstance:mockEpgApi];
    
    mockDelegate = [OCMockObject mockForProtocol:@protocol
                    (OnNowTableViewDelegate)];
    
    onNowService = [[OnNowTableViewService alloc] init];
    
    [[[mockEpgApi stub] andDo:^(NSInvocation *invocation) 
      {
          void (^tmpBlock)() = nil;
          [invocation getArgument:&tmpBlock atIndex:3];
          getChannelsCB = [tmpBlock copy];
      }]getChannelList:[OCMArg any] andCall:[OCMArg any]];
    
    [[[mockEpgApi stub] andDo:^(NSInvocation *invocation) 
      {
          void (^tmpBlock)() = nil;
          [invocation getArgument:&tmpBlock atIndex:3];
          getSchedulesCB = [tmpBlock copy];
      }]getSchedule:[OCMArg any] andCall:[OCMArg any]];
    
    [[[mockEpgApi stub] andDo:^(NSInvocation *invocation) 
      {
          void (^getProgramExtraInfoCB)(ProgramExtraInfo*, NSError*) = nil;
          [invocation getArgument:&getProgramExtraInfoCB atIndex:3];
          getProgramExtraInfoCB([ProgramExtraInfo alloc],nil);
      }]getExtraInfo:[OCMArg any] andCall:[OCMArg any]];
}

-(void) tearDown
{
    [EpgApi setSharedInstance:nil];
    
    
    mockEpgApi = nil;
    mockDelegate = nil;
    
    [super tearDown];
}

-(void) testServiceInitialise
{
    STAssertNotNil(onNowService,@"onNowService is not nil");
}

-(void) testInitialise
{
    [[mockDelegate expect] onInitialised:channels];
    
    [onNowService initialise:mockDelegate];
    
    getChannelsCB(channels, nil);
    
    [mockDelegate verify];
}

-(ScheduleCriteria*) mockCriteria
{
    ScheduleCriteria *criteria = [[ScheduleCriteria alloc] init];
    NSMutableArray *callSigns = [[NSMutableArray alloc] init];
    for (Channel *chan in channels)
    {
        [callSigns addObject:chan.callSign];
    }
    
    criteria.channelCallSigns = callSigns;
    criteria.startTime = [NSDate date];
    criteria.endTime = [NSDate dateWithTimeInterval:1 sinceDate:criteria.startTime];
    
    return criteria;
}

-(void) testGetScheduleForChannelFail
{ 
    NSError* error = [NSError errorWithDomain:@"Test error" code:-1 userInfo:nil];
    
    [[mockDelegate expect] onErrorOccurred:startsWith(@"Epg api met an error")];
    [onNowService getSchedule:channels
             onNowTBVDelegate:mockDelegate];
    getSchedulesCB(nil, error);
    [mockDelegate verify];
        
}

-(void) testGetSchedule
{
    //mock the data from epg api, which is callsign pair with a single program array.
    NSMutableDictionary *epgData = [NSMutableDictionary dictionary];
    
    //on now table view expect dictionary with callsign pair with program.
    NSMutableDictionary *onNowData = [NSMutableDictionary dictionary];
    
    NSMutableArray *programes = [[NSMutableArray alloc] init];
    Programme *prog = [[Programme alloc] init];
    prog.startTime = [NSDate date];
    //mock prog for 30 minutes long from now on.
    prog.endTime = [NSDate dateWithTimeInterval:60*30 sinceDate:prog.startTime];
    prog.programmeID = @"guid for that programe";
    prog.name = @"program name is ...";
    prog.synopsis = @"synopsis is ...";
    //prog.extraInfoUrl = @"extra info url is ....";
    [programes addObject:prog];
    
    NSMutableArray *callSigns = [[NSMutableArray alloc] init];
    
    for (Channel *chan in channels) {
        [callSigns addObject:chan.callSign];
        [onNowData setValue:prog forKey:chan.callSign];
        [epgData setValue:programes forKey:chan.callSign];
    }
    
    [[mockDelegate expect] onRecievedOnNowData:onNowData withExtraInfo:[OCMArg any]];
    [onNowService getSchedule:callSigns
             onNowTBVDelegate:mockDelegate];
    
    getSchedulesCB(epgData, nil);
    
    [mockDelegate verify];
}

@end
