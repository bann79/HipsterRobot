//
//  PlanAheadEpgModelTest.m
//  MyspaceTVCompanion
//
//  Created by Dyfan Hughes on 08/06/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//



#import <OCMock/OCMock.h>
#import <SenTestingKit/SenTestingKit.h>
#import "../AssertEventually/AssertEventually.h"

#import "EpgApi.h"
#import "PlanAheadEpgModel.h"
#import "EpgProgramRenderer.h"

@interface EpgApi (Test)
+(void)setSharedInstance:(id)api;
@end

@interface PlanAheadEpgModelTest : SenTestCase {
 
    __weak id mockDelegate;
    id mockApi;
    
    NSMutableArray* mockChannels;
    PlanAheadEpgModel* model;
}
@end

typedef void (^GetChannelListCallback)(NSArray*, NSError*);

@implementation PlanAheadEpgModelTest

-(void) setUp
{
    mockChannels = [[NSMutableArray alloc] initWithCapacity:5];
    Channel *channel0 = [[Channel alloc] init];
    channel0.callSign = @"ANPL:tribune:uk";
    channel0.channelNumber = [NSNumber numberWithInt:103];
    channel0.title = @"ANPL";
    channel0.description = @"ANPL description";
    [mockChannels addObject:channel0];
    
    Channel *channel1 = [[Channel alloc] init];
    channel1.callSign = @"BBC1:tribune:uk";
    channel1.channelNumber = [NSNumber numberWithInt:101];
    channel1.title = @"BBC1 Wales";
    channel1.description = @"BBC flagship channel";
    [mockChannels addObject:channel1];
    
    Channel *channel2 = [[Channel alloc] init];
    channel2.callSign = @"DSC:tribune:uk";
    channel2.channelNumber = [NSNumber numberWithInt:102];
    channel2.title = @"DSC";
    channel2.description = @"DSC description";
    [mockChannels addObject:channel2];
    
    Channel *channel3 = [[Channel alloc] init];
    channel3.callSign = @"E!TV:tribune:uk";
    channel3.channelNumber = [NSNumber numberWithInt:311];
    channel3.title = @"E! TV";
    channel3.description = @"Celebrity news and gossip";
    [mockChannels addObject:channel3];
    
    
    Channel *channel4 = [[Channel alloc] init];
    channel4.callSign = @"ESPNCL:tribune:uk";
    channel4.channelNumber = [NSNumber numberWithInt:150];
    channel4.title = @"ESPN";
    channel4.description = @"Live sports";
    [mockChannels addObject:channel4];

    
    mockDelegate = [OCMockObject mockForProtocol:@protocol(PlanAheadEpgDelegate)];
    mockApi      = [OCMockObject mockForClass:[EpgApi class]];
    
    [[mockDelegate expect] onEpgModelInitialised];
    
    [EpgApi setSharedInstance:mockApi];
    
    __block GetChannelListCallback callback;
    
    [[[mockApi expect] andDo:^(NSInvocation *i) 
    {
        GetChannelListCallback cb;
        [i getArgument:&cb atIndex:3];
        callback = [cb copy];
        
    }] getChannelList:[OCMArg any] andCall:[OCMArg any]];
    
    model = [[PlanAheadEpgModel alloc] initWithDelegate:mockDelegate];
    model.startDate = [NSDate date];
    model.endDate   = [NSDate dateWithTimeIntervalSinceNow:3600 * 24]; //1 Day from now
    
    
    //Simulate asyncness
    callback(mockChannels,nil);
}

-(void) tearDown
{
    [mockApi verify];
    [mockDelegate verify];
    
    [EpgApi setSharedInstance:nil];
}

-(void) testGotCorrectNumberOfRows
{
    NSInteger rows = model.totalRowsInEpg;
    NSInteger expected = [mockChannels count];
    
    STAssertEquals(expected,rows ,@"Number of rows correct");
}

-(void) testGotCorrectNumberOfColumns
{
    NSInteger cols = model.totalColumnsInEpg;
    
    STAssertEquals(cols,  (3600 * 24) / PlanAheadEpgColDuration , @"Got correct number of columns");
}

-(void) testHorizonalOffestForDate
{
    NSInteger off = [model horizontalOffsetForDate:model.startDate];
    
    STAssertEquals(off, 0,@"startDate returns 0");
    
    off = [model horizontalOffsetForDate:[model.startDate dateByAddingTimeInterval: PlanAheadEpgColDuration]];
    
    STAssertEquals(off, (NSInteger)EpgCellSize.width,@"PlanAheadColDuration returns EpgCellSize.width");
}

//Lisa C: Fix this test
/*
-(void) testSelectProgram
{
    Program* p1 = [[Program alloc] init];
    p1.objectId = @"123456789";
    p1.name = @"Lisas funky show";
    p1.synopsis = @"Lisa talks to celebraties";
    
    Program* p1copy = [[Program alloc] init];
    p1copy.objectId = @"123456789";
    p1copy.name = @"Lisas funky show";
    p1copy.synopsis = @"Lisa talks to celebraties";
    
    Program* p2 = [[Program alloc] init];
    p2.objectId = @"987654321";
    p2.name = @"BBC News";
    p2.synopsis = @"News at 12";
    
//-(void) onSelectedProgramChangedTo: (Program*)program;
    [[mockDelegate expect] onSelectedProgramChangedTo:p1];
    [model selectProgram:p1 withChannel:nil];
    
    STAssertEquals(model.selectedProgram, p1, @"Selected Program now p1");

    [[mockDelegate expect] onSelectedProgramChangedTo:p1copy];
    [model selectProgram:p1copy  withChannel:nil];
    
    STAssertEquals(model.selectedProgram, p1copy, @"Selected Program now p1copy");
   
    [[mockDelegate expect] onSelectedProgramChangedTo:p2];
    [model selectProgram:p2  withChannel:nil];
    
    STAssertEquals(model.selectedProgram, p2, @"Selected Program now p2");
   
    [[mockDelegate expect] onSelectedProgramChangedTo:nil];
    [model selectProgram:nil  withChannel:nil];
    
    //STAssertEquals(model.selectedProgram, p2, @"Selected Program should still be p2");
}
 */
@end