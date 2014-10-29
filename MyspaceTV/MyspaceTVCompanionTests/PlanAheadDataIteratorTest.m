//
//  PlanAheadDataIteratorTest.m
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 06/06/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//
#import <SenTestingKit/SenTestingKit.h>
#import "PlanAheadDataIterator.h"
#import "EpgApi.h"
#import <OCMock/OCMock.h>
#import "AssertEventually/AssertEventually.h"


#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface EpgApi (Test)
+(void)setSharedInstance:(id)api;
@end

@interface PlanAheadDataIteratorTest : SenTestCase
@end

@implementation PlanAheadDataIteratorTest

PlanAheadDataIterator* planAheadDataIterator;
NSMutableArray *channels;
id mockEpgApi;
id mockDelegate;

void (^getScheduleCB)(NSArray *, NSError *);
void (^firstGetScheduleCB)(NSArray *, NSError *);
void (^secondGetScheduleCB)(NSArray *, NSError *);

static NSDateFormatter *rfc2822DateParser;

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
    
    rfc2822DateParser = [[NSDateFormatter alloc] init];
    [rfc2822DateParser setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
    
    mockEpgApi = [OCMockObject mockForClass:[EpgApi class]];
    [EpgApi setSharedInstance:mockEpgApi];
    
    mockDelegate = [OCMockObject mockForProtocol:@protocol(DataIteratorDelegate)];

    planAheadDataIterator = [[PlanAheadDataIterator alloc] init];

}


-(void) tearDown
{
    [EpgApi setSharedInstance:nil];
    
    planAheadDataIterator._channels = nil;
    planAheadDataIterator._index = 0;
    mockEpgApi = nil;
    mockDelegate = nil;
    
    [super tearDown];
}

-(void) testNextOutOfRange
{
    planAheadDataIterator._channels = channels;
    planAheadDataIterator._index = channels.count;
    
    [[mockDelegate expect] onErrorOccurred:@"There are no more channels" forSlot:@"slot1"];
    
    [planAheadDataIterator next:mockDelegate forSlot:@"slot1"];
    
    [mockDelegate verify];
}

-(void) testOverrideGetScheduleForChannel
{
    planAheadDataIterator._channels = channels;
    planAheadDataIterator._index = 1;
    
    @try {
        [planAheadDataIterator next:mockDelegate forSlot:@"slot1"];
        
    }
    @catch (NSException *exception) {
        if([exception.name isEqualToString:@"MethodNeedBeOverridden"]) NSAssert(NO, @"The concrete next method should override super getScheduleForChannel.");
    }
}


-(void) testCallOnRequestingScheduleItemForSlot
{
    planAheadDataIterator._channels = channels;
    planAheadDataIterator._index = 2;
    
    [[mockDelegate expect] onRequestingScheduleItemForSlot:@"slot2"];
    [[mockEpgApi expect] getScheduleForChannel:[OCMArg any] startingAt:[OCMArg any] endingAt:[OCMArg any] andCall:[OCMArg any]];
    [planAheadDataIterator next:mockDelegate forSlot:@"slot2"];
    [mockDelegate verify];
    [mockEpgApi verify];
}



- (void)stubEpgApiGetSchedule {
    [[[mockEpgApi stub] andDo:^(NSInvocation *invocation) {
        void (^tmpBlock)() = nil;
        [invocation getArgument:&tmpBlock atIndex:5];
        getScheduleCB = [tmpBlock copy];
        
    }] getScheduleForChannel:[OCMArg any] startingAt:[OCMArg any] endingAt:[OCMArg any] andCall:[OCMArg any]];
}

-(void) testGetScheduleForChannel
{
    [self stubEpgApiGetSchedule];
    planAheadDataIterator._channels = channels;
    planAheadDataIterator._index = 1;
    Channel *chan = [channels objectAtIndex:1];
    
    NSDate *startTime = [rfc2822DateParser dateFromString:@"Tue, 15 May 2012 23:00:00 +0000"];
    planAheadDataIterator._queryAt = startTime;
    
    NSMutableArray *programmes = [[NSMutableArray alloc] init];
    Programme *prog = [[Programme alloc] init];
    prog.startTime = [rfc2822DateParser dateFromString:@"Tue, 15 May 2012 23:15:00 +0000"];
    prog.endTime = [rfc2822DateParser dateFromString:@"Wed, 16 May 2012 00:15:00 +0000"];
    
    prog.programmeID = @"e9e30a9f-f941-4d60-9da7-6721d0726a37";
    prog.name = @"The Apprentice";
    prog.synopsis = @"The eighth ....";
    [programmes addObject:prog];
    
    [[mockDelegate expect] onReceivedScheduleItem:[OCMArg any] forSlot:@"slot1"];
    [planAheadDataIterator getScheduleForChannel:chan startingAt:startTime dIDelegate:mockDelegate forSlot:@"slot1"];
    
    getScheduleCB(programmes, nil);
    [mockDelegate verify];
}

-(void) testGetScheduleForChannelCallEpgApiAgain
{
    planAheadDataIterator._channels = channels;
    planAheadDataIterator._index = 1;
    Channel *chan = [channels objectAtIndex:1];
    
    NSDate *startTime = [rfc2822DateParser dateFromString:@"Wed, 16 May 2012 00:00:00 +0000"];
    planAheadDataIterator._queryAt = startTime;
    
    NSMutableArray *programmes = [[NSMutableArray alloc] init];
    Programme *prog = [[Programme alloc] init];    prog.startTime = [rfc2822DateParser dateFromString:@"Tue, 15 May 2012 23:15:00 +0000"];
    prog.endTime = [rfc2822DateParser dateFromString:@"Wed, 16 May 2012 00:15:00 +0000"];
    prog.programmeID = @"e9e30a9f-f941-4d60-9da7-6721d0726a37";
    prog.name = @"The Apprentice";
    prog.synopsis = @"The eighth....";
    [programmes addObject:prog];
    
    NSMutableArray *programmes2 = [[NSMutableArray alloc] init];
    Programme *prog2 = [[Programme alloc] init];
    prog2.startTime = prog.endTime;
    prog2.endTime = [NSDate dateWithTimeInterval:60*60 sinceDate:prog.endTime];
    prog2.programmeID = @"e9e30a9f-f941-4d60-9da7-6721d37";
    prog2.name = @"The Apprentice";
    prog2.synopsis = @"The eighth....";
    [programmes2 addObject:prog2];
    
    
    [[[mockEpgApi expect] andDo:^(NSInvocation *invocation) {
        void (^tmpBlock)() = nil;
        [invocation getArgument:&tmpBlock atIndex:5];
        firstGetScheduleCB = [tmpBlock copy];
        
    }] getScheduleForChannel:[OCMArg any] startingAt:startTime endingAt:[NSDate dateWithTimeInterval:1 sinceDate:startTime] andCall:[OCMArg any]];

    [[[mockEpgApi expect] andDo:^(NSInvocation *invocation) {
        void (^tmpBlock)() = nil;
        [invocation getArgument:&tmpBlock atIndex:5];
        secondGetScheduleCB = [tmpBlock copy];
        
    }] getScheduleForChannel:[OCMArg any] startingAt:prog.endTime endingAt:[NSDate dateWithTimeInterval:1 sinceDate:prog.endTime] andCall:[OCMArg any]];
    
    
    [[mockDelegate expect] onReceivedScheduleItem:[OCMArg any] forSlot:[OCMArg any]];
    [planAheadDataIterator getScheduleForChannel:chan startingAt:startTime dIDelegate:mockDelegate forSlot:@"slot1"];
    
    firstGetScheduleCB(programmes, nil);
    secondGetScheduleCB(programmes2, nil);
    
    [mockEpgApi verify];
    [mockDelegate verify];

}

-(void) testGetScheduleForChannelFail
{
    [self stubEpgApiGetSchedule];
    planAheadDataIterator._channels = channels;
    planAheadDataIterator._index = 1;
    Channel *chan = [channels objectAtIndex:1];
    
    NSDate *startTime = [rfc2822DateParser dateFromString:@"Wed, 16 May 2012 00:00:00 +0000"];
    planAheadDataIterator._queryAt = startTime;
    
    NSError* error = [NSError errorWithDomain:@"Test error" code:-1 userInfo:nil];
    
    [[mockDelegate expect] onErrorOccurred:startsWith(@"Epg api met an error:")];
    [planAheadDataIterator getScheduleForChannel:chan 
                                      startingAt:startTime 
                                      dIDelegate:mockDelegate 
                                         forSlot:@"slot1"];
    getScheduleCB(nil, error);
    [mockDelegate verify];
    
}

@end
