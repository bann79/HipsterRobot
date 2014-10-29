//
//  PlanAheadEpgModelTest.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 08/06/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//



#import <OCMock/OCMock.h>
#import <SenTestingKit/SenTestingKit.h>
#import "../AssertEventually/AssertEventually.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "EpgTimelineCell.h"
#import "EpgTimelineRenderer.h"

@interface EpgTimelineRenderer(Test)
+(void)setTopbarRenderer:(id)inst;
+(void)setBottombarRenderer:(id)inst;
@end

@interface EpgTimelineCellTests : SenTestCase

@end

@implementation EpgTimelineCellTests


-(void)testRendersTopBarOnAdd
{
    id mockRenderer = [OCMockObject mockForClass:[EpgTimelineRenderer class]];
    [EpgTimelineRenderer setTopbarRenderer:mockRenderer];
    
    NSDate* t = [NSDate dateWithTimeIntervalSince1970:0];
    
    [[[mockRenderer expect] andReturn:nil] renderCellForTime:t];
    
    EpgTimelineCell* cell = [[EpgTimelineCell alloc] initWithDate:t isTopBar:YES];
    
    [cell addedToGridView:nil];
    
    
    [EpgTimelineRenderer setTopbarRenderer:nil];
    [mockRenderer verify];
    
}

-(void)testRendersBottomBarOnAdd
{
    id mockRenderer = [OCMockObject mockForClass:[EpgTimelineRenderer class]];
    [EpgTimelineRenderer setBottombarRenderer:mockRenderer];
    
    NSDate* t = [NSDate dateWithTimeIntervalSince1970:0];
    
    [[[mockRenderer expect] andReturn:nil] renderCellForTime:t ];
    
    EpgTimelineCell* cell = [[EpgTimelineCell alloc] initWithDate:t isTopBar:NO];
    
    [cell addedToGridView:nil];
    
    
    [EpgTimelineRenderer setBottombarRenderer:nil];
    [mockRenderer verify];
    
}

@end