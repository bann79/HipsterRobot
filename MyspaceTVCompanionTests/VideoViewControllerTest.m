//
//  VideoViewControllerTest.
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 15/08/2012.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "VideoViewController.h"
#import <OCMock/OCMock.h>

@interface VideoViewControllerTest : SenTestCase
{
    VideoViewController *controller;
    id mockPlayer;
}
@end

@implementation VideoViewControllerTest

-(void)setUp
{
    mockPlayer = [OCMockObject niceMockForClass:[XumoVideoPlayer class]];
    
    controller = [VideoViewController alloc];
    //controller.xumoPlayer = mockPlayer;
}

-(void)testAddedViewToRootView
{
   // id mockView = [OCMockObject mockForClass:[UIView class]];
   // [controller transitionInFromView:mockView withPlayer:mockPlayer];
   // STAssertNotNil(controller.view.superview, @"controller view is visible.");
   // STAssertEqualObjects(mockPlayer, controller.videoView.xumoPlayer, @"the player should be same as passed in player.");
}

-(void)tearDown
{    
    [mockPlayer verify];
}

@end
