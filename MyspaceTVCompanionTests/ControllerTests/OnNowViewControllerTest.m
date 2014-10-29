//
//  OnNowViewControllerTest.m
//  MyspaceTVCompanion
//
//  Created by Dyfan Hughes on 08/06/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//



#import <OCMock/OCMock.h>
#import <SenTestingKit/SenTestingKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "../AssertEventually/AssertEventually.h"
#import "OnNowViewController.h"
#import "ActionRingView.h"

@interface OnNowViewControllerTest : SenTestCase
{
    OnNowViewController * controller;
    id actionRingViewMock;
}

@end

@implementation OnNowViewControllerTest 

-(void) setUp
{
    [super setUp];
    controller = [[OnNowViewController alloc]init];
    actionRingViewMock = [OCMockObject niceMockForClass:[ActionRingView class]];    
    [controller setActionRing:actionRingViewMock];
}

-(void) tearDown
{
    actionRingViewMock = nil;
    controller = nil;
}


-(void)testOutletsSet
{
    STAssertNotNil(controller, @"Controller doesn't exist");
    STAssertNotNil(controller.view, @"View doesn't exist");
    
    STAssertNotNil(controller.tableView, @"Controller doesn't exist");
    STAssertNotNil(controller, @"Controller doesn't exist");
    STAssertNotNil(controller, @"Controller doesn't exist");
    STAssertNotNil(controller, @"Controller doesn't exist");
}

-(void)testAssertThatScrollViewIsCorrectlyCreatedInActionRingView
{
    [controller setActionRing:nil];
    CGRect scrollFrameSize = CGRectMake(0,
                                        0,
                                        controller.actionRing.frame.size.width,
                                        controller.actionRing.frame.size.height);
    
    [controller viewDidLoad];
    STAssertEquals(controller.actionRing.arcScrollList.frame,scrollFrameSize,@"FrameSize for scroll should be 0,0,365,748");
}



-(void) testSwipeLeftGestureAnimationIsCalled
{
    //id actionRingViewMock = [OCMockObject niceMockForClass:[ActionRingView class]];
    UISwipeGestureRecognizer * recognizer;

    //[controller setActionRing:actionRingViewMock];
    [[actionRingViewMock expect] updateActionRingPosition];
    [controller swipeActionRingOut:recognizer];
    [actionRingViewMock verify];
}

-(void) testSwipeRightGestureAnimationIsCalled
{
    //id actionRingViewMock = [OCMockObject niceMockForClass:[ActionRingView class]];
    UISwipeGestureRecognizer * recognizer;

    //[controller setActionRing:actionRingViewMock];
    [[actionRingViewMock expect] updateActionRingPosition];
    [controller swipeActionRingIn:recognizer];
    [actionRingViewMock verify];
}

- (void) testThatTableExists
{

}

- (void) testThatNumberOfTableRowsMatchesNumberOfObjectsInChannelArray
{
    
}

- (void) testThatOnNowReusableTableCellExists
{

}

- (void) testThatCustomCellOnlyLoadsDataOnceOnInitOrRefresh
{

}

-(void) testAllInstancesAreNilledOnViewDidDisappear
{
    [controller viewDidDisappear:YES];
    STAssertNil(controller.modalInfoPage,@"modalInfoPage Exists");
    STAssertNil(controller.dataService,@"dataService Exists");
    STAssertNil(controller.tableView,@"tableView Exists");
    STAssertNil(controller.actionRing,@"actionRing Exists");
    STAssertNil(controller.activityIndicator,@"infoPage Exists");
}

-(void)testpreTransitionInCallsActionRingPreTransitionIn
{
    [[actionRingViewMock expect] preTransitionIn];
    [controller preTransitionIn];
    [actionRingViewMock verify];
}

-(void)testTransitionInActionRing
{
    [[actionRingViewMock expect] transitionInWithBlockCallback:nil];
    [controller transitionInActionRing](YES);
    [actionRingViewMock verify];
    
}

@end
