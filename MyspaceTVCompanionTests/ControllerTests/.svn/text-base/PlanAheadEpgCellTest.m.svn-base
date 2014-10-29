//
//  PlanAheadEpgModelTest.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 08/06/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//



#import "TestUtils.h"
#import <SenTestingKit/SenTestingKit.h>
#import "../AssertEventually/AssertEventually.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "EpgApi.h"
#import "PlanAheadEpgCell.h"
#import "PlanAheadEpgModel.h"

@interface EpgProgramRenderer(Test)
+(void)setSharedRenderer:(id)inst;
@end

@interface PlanAheadEpgCellTest : SenTestCase{
 
    NSArray *mockProgramData;
    id mockEpgProgramRenderer;
    PlanAheadEpgCell* cell;
    
    UIView* container;
}

@property id mockEpgModel;
@end


@implementation PlanAheadEpgCellTest

@synthesize mockEpgModel;

-(void)setUp
{
    mockEpgModel = [OCMockObject niceMockForClass:[PlanAheadEpgModel class]];
    mockEpgProgramRenderer = [OCMockObject mockForClass:[EpgProgramRenderer class]];
    [EpgProgramRenderer setSharedRenderer:mockEpgProgramRenderer];
    
    Programme* p1  = [[Programme alloc] init];
    p1.startTime = [NSDate dateWithTimeIntervalSinceNow: 60 * -5]; // 5 Minutes ago
    p1.endTime   = [NSDate dateWithTimeIntervalSinceNow: 60 * 20]; // 20 Minutes time
    p1.name      = @"Cash in the attic";
    p1.synopsis  = @"Old people desperatly try yo flog there worthless crap";
    
    Programme* p2  = [[Programme alloc] init];
    p2.startTime = p1.endTime;
    p2.endTime   = [NSDate dateWithTimeIntervalSinceNow:60 * 60]; // 1 Hours times
    p2.name      = @"Telly tubbies";
    p2.synopsis  = @"Weird alien kiddy show";
    
    Programme* p3 = [[Programme alloc] init];
    p3.startTime = p2.endTime;
    p3.endTime   = [NSDate dateWithTimeIntervalSinceNow:60 * 90]; // 90 Minutes time;
    p3.name      = @"BBC Brunchtime news";
    p3.synopsis  = @"Depresing news at mid morning";
    
    mockProgramData = [NSArray arrayWithObjects:p1,p2,p3, nil];
    
    
    [[[mockEpgProgramRenderer expect] andReturn:[UIImage alloc]] getLoadingImage];
    
    container = [[UIView alloc] initWithFrame:CGRectMake(0,0, 100, 100)];
    
    cell = [[PlanAheadEpgCell alloc] init];
    
    [container addSubview:cell];
    
    cell.model = mockEpgModel;
    cell.startTime = [NSDate date];
    cell.endTime = [NSDate dateWithTimeIntervalSinceNow:120 * 60];
}

-(void)tearDown
{
    [mockEpgModel verify];
    [mockEpgProgramRenderer verify];
    [EpgProgramRenderer setSharedRenderer:nil];
}

-(void)testCreatedWithLoadingImage
{
    STAssertNotNil(cell.image,@"Has image");
}

-(void)testSetProgamsRendersView
{
    cell.image = nil;

    void (^callback)(UIImage*) = nil;
    
    [[[mockEpgProgramRenderer expect] andCaptureCallbackArgument:&callback at:5] renderPrograms:mockProgramData beginingAt:cell.startTime endingAt:cell.endTime andCall:[OCMArg any]];
    
    [cell setPrograms: mockProgramData];
    
    STAssertNotNil(callback,@"Callabck not nil");
    callback([UIImage alloc]);
    STAssertNotNil(cell.image,@"Image not nil");
}

-(void)testDoesNotRenderWhenRemovedFromScreen
{
    [[mockEpgProgramRenderer reject] renderPrograms:[OCMArg any] beginingAt:[OCMArg any] endingAt:[OCMArg any]  andCall:[OCMArg any]];
    
    [cell removeFromSuperview];
    
    [cell setPrograms:mockProgramData];
    
}


@end