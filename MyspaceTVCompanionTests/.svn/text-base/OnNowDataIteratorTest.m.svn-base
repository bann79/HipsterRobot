//
//  OnNowDataIteratorTest.m
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 11/06/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "OnNowDataIterator.h"
#import "EpgApi.h"
#import <OCMock/OCMock.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface EpgApi (Test)
+(void)setSharedInstance:(id)api;
@end

@interface OnNowDataIteratorTest : SenTestCase
@end

@implementation OnNowDataIteratorTest

OnNowDataIterator* onNowDataIterator;
NSMutableArray *channels;
id mockEpgApi;
id mockDelegate;
void (^getScheduleCB)(NSArray *, NSError *);


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
    mockDelegate = [OCMockObject mockForProtocol:@protocol(DataIteratorDelegate)];
    
    onNowDataIterator = [[OnNowDataIterator alloc] init];
    [EpgApi setSharedInstance:mockEpgApi];
    
    [[[mockEpgApi stub] andDo:^(NSInvocation *invocation) {
        void (^tmpBlock)() = nil;
        [invocation getArgument:&tmpBlock atIndex:5];
        getScheduleCB = [tmpBlock copy];
        
    }] getScheduleForChannel:[OCMArg any] startingAt:[OCMArg any] endingAt:[OCMArg any] andCall:[OCMArg any]];
}

-(void) tearDown
{
    [EpgApi setSharedInstance:nil];
    onNowDataIterator._index =0;
    onNowDataIterator._channels = nil;
    
    mockEpgApi = nil;
    mockDelegate = nil;
    
    [super tearDown];
    
}

-(void) testNextOutOfRange
{
    onNowDataIterator._channels = channels;
    onNowDataIterator._index = channels.count;
    
    [[mockDelegate expect] onErrorOccurred:@"There are no more channels" forSlot:@"slot1"];
    [onNowDataIterator next:mockDelegate forSlot:@"slot1"];
    [mockDelegate verify];
}

-(void) testOverrideGetScheduleForChannel
{
    onNowDataIterator._channels = channels;
    onNowDataIterator._index = 1;
    
    @try {
        [onNowDataIterator next:mockDelegate forSlot:@"slot1"];
    }
    @catch (NSException *exception) {
        if([exception.name isEqualToString:@"MethodNeedBeOverridden"]) NSAssert(NO, @"The concrete next method should override super getScheduleForChannel.");
    }
}

-(void) testNextCallOnRequestingScheduleItemForSlot
{
    onNowDataIterator._channels = channels;
    onNowDataIterator._index = 2;
    
    [[mockDelegate expect] onRequestingScheduleItemForSlot:@"slot2"];
    [onNowDataIterator next:mockDelegate forSlot:@"slot2"];
    [mockDelegate verify];
}


-(void) testGetScheduleForChannel
{
    onNowDataIterator._channels = channels;
    onNowDataIterator._index = 1;
    Channel *chan = [channels objectAtIndex:1];
    NSDate *startTime = [NSDate date];
    
    NSMutableArray *programmes = [[NSMutableArray alloc] init];
    Programme *prog = [[Programme alloc] init];
    prog.startTime = startTime;
    //mock prog for 30 minutes long from now on.
    prog.endTime = [NSDate dateWithTimeInterval:60*30 sinceDate:prog.startTime];
    prog.programmeID = @"e9e30a9f-f941-4d60-9da7-6721d0726a37";
    prog.name = @"The Apprentice";
    prog.synopsis = @"synopsis";
    [programmes addObject:prog];
    
    [[mockDelegate expect] onReceivedScheduleItem:[OCMArg any] forSlot:@"slot1"];
    
    [onNowDataIterator getScheduleForChannel:chan startingAt:startTime dIDelegate:mockDelegate forSlot:@"slot1"];
    
    getScheduleCB(programmes, nil);
    [mockDelegate verify];
    
}

-(void) testGetScheduleForChannelFail
{
    onNowDataIterator._channels = channels;
    onNowDataIterator._index = 1;
    Channel *chan = [channels objectAtIndex:1];
    
    NSDate *startTime = [NSDate dateWithTimeIntervalSinceNow:60];
    
    NSError* error = [NSError errorWithDomain:@"Test error" code:-1 userInfo:nil];
    
    [[mockDelegate expect] onErrorOccurred:startsWith(@"Epg api met an error")];
    [onNowDataIterator getScheduleForChannel:chan 
                                  startingAt:startTime 
                                  dIDelegate:mockDelegate
                                     forSlot:@"slot1"];
    getScheduleCB(nil, error);
    [mockDelegate verify];
    
}


@end
