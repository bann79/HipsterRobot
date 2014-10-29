//
//  PlanAheadPopulatorTest.m
//  MyspaceTVCompanion
//
//  Created by Elwyn Malethan on 06/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "PlanAheadDataIterator.h"
#import "SubMenuDataDelegate.h"
#import "HomeSummaryPopulator.h"
#import "TimerFactory.h"

@interface HomeSummaryPopulatorTest : SenTestCase

@end

@implementation HomeSummaryPopulatorTest
{
@private
    HomeSummaryPopulator *populator;

    id mockIterator;
    id mockDelegate;
    BOOL dataReady;
    id mockTimerFactory;
}

- (void)setUp
{
    [super setUp];

    mockIterator = [OCMockObject niceMockForClass:[DataIterator class]];
    mockDelegate = [OCMockObject niceMockForProtocol:@protocol(DataIteratorDelegate)];
    mockTimerFactory = [OCMockObject mockForClass:[TimerFactory class] ];

    populator = [[HomeSummaryPopulator alloc] init];

    populator.timerFactory = mockTimerFactory;

    dataReady = NO;
}

- (void)testInitialiseCallsInitialiseOnIteratorWithDelegate
{
    [[mockIterator expect] initialise:(id <DataIteratorDelegate>) sameInstance(mockDelegate)];

    [populator prepareWithIterator:mockIterator andDelegate:mockDelegate];

    [mockIterator verify];
}

- (void)expectRequestForThreeSlotsOfData
{
    [[mockIterator expect] next:sameInstance(mockDelegate)
                             forSlot:(NSString *) equalTo(@"slot1")];

    [[mockIterator expect] next:sameInstance(mockDelegate)
                             forSlot:(NSString *) equalTo(@"slot2")];

    [[mockIterator expect] next:sameInstance(mockDelegate)
                             forSlot:(NSString *) equalTo(@"slot3")];
}

- (void)testStartRequestsThreeSlotsWorthOfDataSynchronouslyIfDataIsAvailable
{
    [populator prepareWithIterator:mockIterator andDelegate:mockDelegate];
    [self expectRequestForThreeSlotsOfData];

    dataReady = YES;

    [[[mockDelegate stub] andReturnValue:OCMOCK_VALUE(dataReady) ] isDataReady];
    [[mockTimerFactory stub] scheduleWithInterval:10 withBlock:[OCMArg any] repeats:YES];

    [populator start];

    [mockIterator verify];
}

- (void)testStartDoesNotRequestDataIfNoDataIsAvailable
{
    dataReady = NO;

    [[[mockDelegate stub] andReturnValue:OCMOCK_VALUE(dataReady) ] isDataReady];
    [[mockTimerFactory stub] scheduleWithInterval:0.1 withBlock:[OCMArg any] repeats:YES];
    [[mockTimerFactory stub] scheduleWithInterval:10 withBlock:[OCMArg any] repeats:YES];

    [populator start];

    [mockIterator verify];
}

- (void)testStartStartsATimerWithABlockThatRequestsThreeSlotsOfData
{
    [populator prepareWithIterator:mockIterator andDelegate:mockDelegate];

    __block void(^startEvent)() = nil;
    [[[mockTimerFactory expect]
            andDo:^(NSInvocation *invocation) {
                void(^tmpBlock)() = nil;
                [invocation getArgument:&tmpBlock atIndex:3];

                startEvent = [tmpBlock copy];
            }]
            scheduleWithInterval:0.1 withBlock:[OCMArg any] repeats:YES];

    __block void(^timedEvent)() = nil;
    [[[mockTimerFactory expect]
            andDo:^(NSInvocation *invocation) {
                void(^tmpBlock)() = nil;
                [invocation getArgument:&tmpBlock atIndex:3];

                timedEvent = [tmpBlock copy];
            }]
            scheduleWithInterval:10 withBlock:[OCMArg any] repeats:YES];

    __block int invocationCount = 0;
    __block BOOL dataNotReady = NO;
    dataReady = YES;

    [[[mockDelegate stub]
            andDo:^(NSInvocation *invocation) {
                if (invocationCount++ == 0) {
                    //Return false the first time
                    [invocation setReturnValue:&dataNotReady];
                } else {
                    //Return true for the timedEvent
                    [invocation setReturnValue:&dataReady];
                }
            }] isDataReady];

    [populator start];
    startEvent();

    assertThat(timedEvent, notNilValue());

    [self expectRequestForThreeSlotsOfData];

    timedEvent();

    [mockIterator verify];
}

- (void)testThatStopInvalidatesTheTimer
{
    [populator prepareWithIterator:mockIterator andDelegate:mockDelegate];

    id mockTimer = [OCMockObject mockForClass:[NSTimer class]];

    [[mockTimer expect] invalidate];
    [[[mockTimerFactory stub] andReturn:mockTimer]scheduleWithInterval:10 withBlock:[OCMArg any] repeats:YES];

    dataReady = YES;
    [[[mockDelegate stub] andReturnValue:OCMOCK_VALUE(dataReady) ] isDataReady];

    [populator start];

    [populator stop];

    [mockTimer verify];
}
@end
