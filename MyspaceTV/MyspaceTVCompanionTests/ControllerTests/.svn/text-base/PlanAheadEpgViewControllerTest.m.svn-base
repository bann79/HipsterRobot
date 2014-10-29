//
//  PlanAheadViewControllerTest.m
//  MyspaceTVCompanion
//
//  Created by Dyfan Hughes on 07/06/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "PlanAheadEpgViewController.h"
#import "ActionRingView.h"
#import "../AssertEventually/AssertEventually.h"
#import "EpgTimelineCell.h"
#import "InfoPageViewController.h"

@interface EpgApi (Test)
+(void)setSharedInstance:(id)api;
@end

@interface PlanAheadEpgViewControllerTest : SenTestCase

@end

@implementation PlanAheadEpgViewControllerTest 
{
    @private PlanAheadEpgViewController * controller;
    id mockEpgApi;
}

-(void)setUp
{
    
    mockEpgApi = [OCMockObject mockForClass:[EpgApi class]];
    
    
    [[mockEpgApi stub] getChannelList:[OCMArg any] andCall:[OCMArg any]];
    
    [EpgApi setSharedInstance:mockEpgApi];
    [super setUp];
    controller = [[PlanAheadEpgViewController alloc]initWithNibName:@"PlanAheadEpgViewController" bundle:nil];
}

-(void) tearDown
{
    controller = nil;
    [mockEpgApi verify];
    [EpgApi setSharedInstance:nil];
    [super tearDown];
}

-(void) testLoadedUIFromBundle
{
    [controller loadView];
    
    STAssertNotNil(controller.gridView,     @"Grid View initialised");
    STAssertNotNil(controller.topTimeline,  @"Top Timeline initialised");
    STAssertNotNil(controller.topTimeline,  @"Bottom Timeline initialised");
    STAssertNotNil(controller.actionRing,   @"Action Ring initialised");
}

//TODO[emalethan]: Talk to Dyf about this to see if we need more coverage
-(void) testInitActionRingView
{
    NSLog(@"WARNING: Tests needs implementation");

//    id mockActionRing = [OCMockObject niceMockForClass:[UIViewController class]];
//
//    [[mockActionRing expect] initBackButtonActionTarget:[OCMArg any] targetViewID:@"OnNowViewController"];
//
//    [controller setActionRing:(ActionRingView *) mockActionRing];
//    [controller viewDidAppear:NO];
//
//    [mockActionRing verify];
}

-(void) testModelSetup
{
    
    
    [controller viewWillAppear:NO];
    
    STAssertNotNil(controller.model,@"Model not nil");
    STAssertEquals(controller.model.delegate, controller,@"Models delegate is the controller");
    
    STAssertNotNil(controller.model.startDate, @"Got a time range for view");
    STAssertNotNil(controller.model.endDate, @"Got a time range for view");
    
}

//TODO[emalethan]: Find out whether this test is valid, or needs modification to fix
-(void) testGesturesAreAddedToTheActionView
{
    id actionRingViewMock = [OCMockObject niceMockForClass:[ActionRingView class]];
    [controller setActionRing:actionRingViewMock];
    [[actionRingViewMock expect] addGestureRecognizer:[OCMArg any]];
    [controller viewWillAppear:NO];
    [actionRingViewMock verify];
}

-(void)testAssertThatScrollViewIsCorrectlyCreatedInActionRingView
{
    CGRect scrollFrameSize = CGRectMake(0,
            0,
            controller.actionRing.frame.size.width,
            controller.actionRing.frame.size.height);

    [controller viewDidAppear:NO];
    STAssertEquals(controller.actionRing.arcScrollList.frame,scrollFrameSize,@"FrameSize for scroll should be 0,0,365,748");
}

-(void) testDirectionForBothSwipesAreCorrectToTheirNames
{
    [controller viewWillAppear:NO];

    STAssertEquals([controller.swipeLeftGesture direction], UISwipeGestureRecognizerDirectionLeft,@"swipe is not assigned to the left direction" );
    STAssertEquals([controller.swipeRightGesture direction], UISwipeGestureRecognizerDirectionRight,@"swipe is not assigned to the right direction" );
}

//TODO[emalethan]: Talk to Dyf about this to see if we need more coverage
-(void) testSwipeLeftGestureAnimationIsCalledIfTheViewPointIsLEssThan400
{
    NSLog(@"WARNING: Tests needs implementation");

//    id recognizer = [OCMockObject mockForClass:[UISwipeGestureRecognizer class]];
//
//    const CGPoint viewPoint = CGPointMake(399, 400);
//    [[[recognizer stub] andReturnValue:OCMOCK_VALUE(viewPoint)] locationInView:[OCMArg any]];
//
//    id actionRingViewMock = [OCMockObject mockForClass:[ActionRingView class]];
//    controller.actionRing = actionRingViewMock;
//    [[actionRingViewMock expect] updateActionRingPosition];
//
//    [controller swipeActionRingOut:recognizer];
//
//    [actionRingViewMock verify];
}

-(void) testSwipeRightGestureAnimationIsCalled
{
    NSLog(@"WARNING: Tests needs implementation");
//    id actionRingViewMock = [OCMockObject niceMockForClass:[ActionRingView class]];
//    UISwipeGestureRecognizer * recognizer;
//
//    [controller setActionRing:actionRingViewMock];
//    [[actionRingViewMock expect] updateActionRingPosition];
//    [controller swipeActionRingIn:recognizer]; //TODO[emalethan]: recognizer is always nil, production code requires mocked instance
//    [actionRingViewMock verify];
}

-(void) liveIndicatorTimerUpdatesTimelineCells
{
    id mockTimelineCell = [OCMockObject mockForClass:[EpgTimelineCell class]];
    
    NSSet* visibleTimelineCells = [NSSet setWithObject:mockTimelineCell];
    
    id mockTopTimeline = [OCMockObject mockForClass:[GridView class]];
    [[[mockTopTimeline expect] andReturn:visibleTimelineCells] visibleCells];
    
    
    id mockBottomTimeline = [OCMockObject mockForClass:[GridView class]];
    [[[mockBottomTimeline expect] andReturn:visibleTimelineCells] visibleCells];
    
    
    [[mockTimelineCell expect] update];
    [[mockTimelineCell expect] update];
    
    [controller updateTimelineTimerFired:nil];
    
    
    [mockTimelineCell verify];
    [mockTopTimeline verify];
    [mockBottomTimeline verify];
    
}


-(void)testUpdateDaySelectorTime
{
    id mockDayIndicator = [OCMockObject mockForClass:[UILabel class]];
    [[mockDayIndicator expect] setText:[OCMArg any]];
    
    
    id mockDateIndicator = [OCMockObject mockForClass:[UILabel class]];
    [[mockDateIndicator expect] setText:[OCMArg any]];
    
    id mockModel = [OCMockObject mockForClass:[PlanAheadEpgModel class]];
    [[[mockModel expect] andReturn:[NSDate date]]startDateForCellAt:0];

    [controller setModel:mockModel];
    [controller setDayIndicator: mockDayIndicator];
    [controller setDateIndicator: mockDateIndicator];
    
    [controller updateDaySelectorTime];
    
    [mockDayIndicator verify];
    [mockDateIndicator verify];
}

-(void)testPressedDateSelectorShowDaySelector
{
    id mockDaySelector = [OCMockObject mockForClass:[UIView class]];
    
    [[[mockDaySelector expect] andReturnValue:[NSNumber numberWithBool:YES]] isHidden];
    [[mockDaySelector expect] setAlpha:1.0];
    [[mockDaySelector expect] setHidden:NO];
    controller.daySelector = mockDaySelector;
    
    [controller pressedDaySelector:nil];
    
    [mockDaySelector verify];
}

-(void)testPressedDateSelectorHidesDaySelector
{
    id mockDaySelector = [OCMockObject mockForClass:[UIView class]];
    
    [[[mockDaySelector expect] andReturnValue:[NSNumber numberWithBool:NO]] isHidden];
    [[mockDaySelector expect] setAlpha:0.0];
    controller.daySelector = mockDaySelector;
    
    [controller pressedDaySelector:nil];
    
    [mockDaySelector verify];
}


-(void)testpreTransitionInCallsActionRingPreTransitionIn
{
    id actionRingViewMock = [OCMockObject niceMockForClass:[ActionRingView class]];
    [controller setActionRing:actionRingViewMock];
    [[actionRingViewMock expect] preTransitionIn];
    [controller preTransitionIn];
    [actionRingViewMock verify];
}


-(void)testTransitionInActionRing
{
    id actionRingViewMock = [OCMockObject niceMockForClass:[ActionRingView class]];
    [controller setActionRing:actionRingViewMock];
    [[actionRingViewMock expect] transitionInWithBlockCallback:[OCMArg any]];
    [controller transitionInActionRing](YES);
    [actionRingViewMock verify];
    
}

/* Timing issue with test ?
-(void)testOnSelectedProgramCellInfoPageAddedToViewHierarchy
{
    id mockExtraInfoViewController = [OCMockObject niceMockForClass:[InfoPageViewController class]];
    [controller setModalInfoPage:mockExtraInfoViewController];
    
    id mockView = [OCMockObject niceMockForClass:[UIView class]];
    [controller setView:mockView];
    [[mockView expect] addSubview:[OCMArg any]];
    
    Program * programInfoObject = [[Program alloc]init];
    
    programInfoObject.name = @"something";
    programInfoObject.synopsis = @"something a bit more descriptive";
            
    [controller onSelectedProgramChangedTo:programInfoObject fromOldProgram:programInfoObject];
    
    [mockView verify];    

}
*/

@end


