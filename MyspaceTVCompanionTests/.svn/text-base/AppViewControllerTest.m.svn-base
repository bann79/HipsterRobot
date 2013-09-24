//
//  AppViewControllerTest.m
//  MyspaceTVCompanion
//
//  Created by scott on 01/06/2012.

// Create a mock/test/stub view controller implementation ?

#import <SenTestingKit/SenTestingKit.h>
#import "AppViewController.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "AppViewProtocol.h"
#import "ViewFactory.h"
#import "AssertEventually.h"
#import "OnNowViewController.h"
#import <OCMock/OCMock.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "TestUtils.h"

@interface AppViewControllerTest : SenTestCase {
    AppViewController *appViewController;
    
    id mockControllerOne;
    id mockControllerTwo;
    id mockScreenContainer;
    UIView *controllerOnesView;
    void (^transitionOutCallback)();
}
@end

@implementation AppViewControllerTest


- (void)stubTransitionOutOnMockController:(id)mockController
{
    [[[mockController stub]
            andDo:^(NSInvocation *invocation) {
                void (^tmpBlock)() = nil;

                [invocation getArgument:&tmpBlock atIndex:2];

                transitionOutCallback = [tmpBlock copy];

            }]
            transitionOut:[OCMArg any]];
     
}

-(void)setUp
{
    appViewController = [[AppViewController alloc] init];
    
    mockControllerOne = [OCMockObject niceMockForClass:[HomeViewController class]];

    [[[mockControllerOne stub] andReturn:@"MockControllerOne"] nibName];
    
    controllerOnesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [[[mockControllerOne stub] andReturn:controllerOnesView] view];

    mockControllerTwo = [OCMockObject niceMockForClass:[OnNowViewController class]];
    [[[mockControllerTwo stub] andReturn:@"MockControllerTwo"] nibName];
    
    [self stubTransitionOutOnMockController:mockControllerOne];
    [self stubTransitionOutOnMockController:mockControllerTwo];

    mockScreenContainer = [OCMockObject niceMockForClass:[UIView class]];
    appViewController.screenContainer = mockScreenContainer;

    id mocktery = [OCMockObject mockForClass:[ViewFactory class]];
    [[[mocktery stub] andReturn:mockControllerOne] getViewControllerFromString:@"MockControllerOne"];
    [[[mocktery stub] andReturn:mockControllerOne] getViewControllerFromString:@"MockControllerTwo"];

    appViewController.factory = mocktery;
}

-(void)tearDown
{
    appViewController = nil;
    mockControllerOne = nil;
    mockControllerTwo = nil;
    mockScreenContainer = nil;
}

-(void)testSetContentSetsCurrentViewSynchronouslyWhenItIsTheFirstOne
{
    [[mockScreenContainer expect] addSubview:sameInstance(controllerOnesView)];

    [appViewController setCurrentViewController:nil];

    [appViewController setContentScreen:@"MockControllerOne"];

    [mockScreenContainer verify];
}

#pragma mark setContentScreenWithViewName tests

-(void)testSetContentScreenTransitionsCurrentViewOutThenReplacesView
{
    appViewController.currentViewController = mockControllerTwo;
    [appViewController setContentScreen:@"MockControllerOne"];

    [mockScreenContainer verify]; // Verify no interactions before transition callback

    [[mockScreenContainer expect] addSubview:sameInstance(controllerOnesView)];

    transitionOutCallback();

    [mockScreenContainer verify];
}

- (void)testCurrentControllersViewIsRemovedFromScreen
{
    appViewController.currentViewController = mockControllerOne;

    NSArray *const mockSubViews = [[NSArray alloc] initWithObjects:
            [OCMockObject mockForClass:[UIView class]]
            ,[OCMockObject mockForClass:[UIView class]]
            ,nil];

    for (int j = 0; j < mockSubViews.count; j++) {
        [[[mockSubViews objectAtIndex:j] expect] removeFromSuperview];
    }

    [[[mockScreenContainer stub] andReturn:mockSubViews] subviews];

    [appViewController setContentScreen:@"MockControllerTwo"];
    transitionOutCallback();

    for (int j = 0; j < mockSubViews.count; j++) {
        [[mockSubViews objectAtIndex:j] verify];
    }
}

- (void)testThatSettingTheSameViewAsIsCurrentlyDisplayedDisplaysSameView
{
    appViewController.currentViewController = mockControllerOne;

    [[mockScreenContainer expect] addSubview:sameInstance(controllerOnesView)];
    
    [appViewController setContentScreen:@"MockControllerOne"];
    transitionOutCallback();

    [mockScreenContainer verify];
}

#pragma mark setContentScreenWithViewName orViewController tests using ViewName

-(void)testSetContentScreenTransitionsCurrentViewOutThenReplacesViewUsingViewName
{
    appViewController.currentViewController = mockControllerTwo;
    [appViewController setContentScreenWithViewName:@"MockControllerOne" orViewController:nil];
    [mockScreenContainer verify]; // Verify no interactions before transition callback
    
    [[mockScreenContainer expect] addSubview:sameInstance(controllerOnesView)];
    
    transitionOutCallback();
    
    [mockScreenContainer verify];
}

- (void)testCurrentControllersViewIsRemovedFromScreenUsingViewName
{
    appViewController.currentViewController = mockControllerOne;
    
    NSArray *const mockSubViews = [[NSArray alloc] initWithObjects:
                                   [OCMockObject mockForClass:[UIView class]]
                                   ,[OCMockObject mockForClass:[UIView class]]
                                   ,nil];
    
    for (int j = 0; j < mockSubViews.count; j++) {
        [[[mockSubViews objectAtIndex:j] expect] removeFromSuperview];
    }
    
    [[[mockScreenContainer stub] andReturn:mockSubViews] subviews];
    
    [appViewController setContentScreenWithViewName:@"MockControllerTwo" orViewController:nil];
    transitionOutCallback();
    
    for (int j = 0; j < mockSubViews.count; j++) {
        [[mockSubViews objectAtIndex:j] verify];
    }
}

- (void)testThatSettingTheSameViewAsIsCurrentlyDisplayedUsingViewNameDisplaysSameView
{
    appViewController.currentViewController = mockControllerOne;
    
    [appViewController setContentScreenWithViewName:@"MockControllerOne" orViewController:nil];
    
    [[mockScreenContainer expect] addSubview:sameInstance(controllerOnesView)];
    transitionOutCallback();
    
    [mockScreenContainer verify];
}

#pragma mark setContentScreenWithViewName orViewController tests using ViewController

-(void)testSetContentScreenTransitionsCurrentViewOutThenReplacesViewUsingViewController
{
    appViewController.currentViewController = mockControllerTwo;

    [appViewController setContentScreenWithViewName:nil orViewController:mockControllerOne];
    
    
    [mockScreenContainer verify]; // Verify no interactions before transition callback
    
    [[mockScreenContainer expect] addSubview:sameInstance(controllerOnesView)];
    
    transitionOutCallback();
    
    [mockScreenContainer verify];
}

- (void)testCurrentControllersViewIsRemovedFromScreenUsingViewController
{
    appViewController.currentViewController = mockControllerOne;
    
    NSArray *const mockSubViews = [[NSArray alloc] initWithObjects:
                                   [OCMockObject mockForClass:[UIView class]]
                                   ,[OCMockObject mockForClass:[UIView class]]
                                   ,nil];
    
    for (int j = 0; j < mockSubViews.count; j++) {
        [[[mockSubViews objectAtIndex:j] expect] removeFromSuperview];
    }
    
    [[[mockScreenContainer stub] andReturn:mockSubViews] subviews];
    
    [appViewController setContentScreenWithViewName:nil orViewController:mockControllerTwo];
    
    
    transitionOutCallback();
    
    for (int j = 0; j < mockSubViews.count; j++) {
        [[mockSubViews objectAtIndex:j] verify];
    }
}

- (void)testThatSettingTheSameViewAsIsCurrentlyDisplayedUsingViewControllerDisplaysSameView
{
    appViewController.currentViewController = mockControllerOne;
    
    [[mockScreenContainer expect] addSubview:sameInstance(controllerOnesView)];
    [appViewController setContentScreenWithViewName:nil orViewController:mockControllerOne];
    transitionOutCallback();
    
    [mockScreenContainer verify];
}

-(void)testThatSettingViewNameAndViewControllerToNilDoesNothing
{
    
    id partialAppViewController = [OCMockObject partialMockForObject:appViewController];
    [[partialAppViewController reject] switchCurrentViewTo:[OCMArg any]];
    [appViewController setContentScreenWithViewName:nil orViewController:nil];
    
    [partialAppViewController verify];
    
}

-(void)testTransitionInTopAndBottomBarSetsFlagToYes
{
    [appViewController transitionInTopAndBottomBar];
    STAssertTrue([appViewController getTopAndBottomBarShowing], @"TopAndBottomBar flag should be YES");
}

-(void)testTransitionOutTopAndBottomBarSetsFlagToNo
{
    [appViewController transitionOutTopAndBottomBar];
    STAssertFalse([appViewController getTopAndBottomBarShowing], @"TopAndBottomBar flag should be NO");
}

-(void)testShowingAGreedyScreenWhenBarsAreShowingHidesThem
{
    id greedyViewController = [OCMockObject niceMockForClass:[LoginViewController class]];
    
    BOOL val = YES;
    [[[greedyViewController stub] andReturnValue:OCMOCK_VALUE(val)] isGreedy];
    
    [appViewController transitionInTopAndBottomBar];
    [appViewController setContentScreenWithViewName:nil orViewController:greedyViewController];
    STAssertFalse([appViewController getTopAndBottomBarShowing], @"Top and bottom bar should be hidden");
}

-(void)testShowingGreedyScreenWhenBarsArentShowingDoesntShowThem
{
    id greedyViewController = [OCMockObject niceMockForClass:[LoginViewController class]];
    
    BOOL val = YES;
    [[[greedyViewController stub] andReturnValue:OCMOCK_VALUE(val)] isGreedy];
    
    [appViewController transitionOutTopAndBottomBar];
    [appViewController setContentScreenWithViewName:nil orViewController:greedyViewController];
    STAssertFalse([appViewController getTopAndBottomBarShowing], @"Top and bottom bar should be hidden");
}

-(void)testShowingNonGreedyScreenWhenBarsAreShowingDoesntHideThem
{
    id nonGreedyViewController = [OCMockObject niceMockForClass:[LoginViewController class]];
    
    BOOL val = NO;
    [[[nonGreedyViewController stub] andReturnValue:OCMOCK_VALUE(val)] isGreedy];
    
    [appViewController transitionInTopAndBottomBar];
    [appViewController setContentScreenWithViewName:nil orViewController:nonGreedyViewController];
    STAssertTrue([appViewController getTopAndBottomBarShowing], @"Top and bottom bar should be showing");
}

-(void)testShowingNonGreedyScreenWhenBarsArentShowingShowsThem
{
    id nonGreedyViewController = [OCMockObject niceMockForClass:[LoginViewController class]];
    
    BOOL val = NO;
    [[[nonGreedyViewController stub] andReturnValue:OCMOCK_VALUE(val)] isGreedy];
    
    [appViewController transitionOutTopAndBottomBar];
    [appViewController setContentScreenWithViewName:nil orViewController:nonGreedyViewController];
    STAssertTrue([appViewController getTopAndBottomBarShowing], @"Top and bottom bar should be showing");
}








@end
