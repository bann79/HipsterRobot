//
//  Created by Elwyn Malethan on 06/06/12.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "HomeViewController.h"
#import "AppViewController.h"
#import "SubMenuDataDelegate.h"
#import "HomeSummaryPopulator.h"
#import "AuthState.h"
#import "UserProfile.h"
#import "CircularImageButton.h"

@interface HomeViewControllerTest : SenTestCase
@end

@implementation HomeViewControllerTest
{
@private
    HomeViewController *controller;
    id mockPADelegate;
    id mockPAIterator;
    id mockPAPopulator;
    id mockONIterator;
    id mockONDelegate;
    id mockONPopulator;
    id mockAuthState;
    __weak id mockCircularImageButton;
}

- (void)setUp
{
    [super setUp];

    mockPAIterator = [OCMockObject niceMockForClass:[PlanAheadDataIterator class]];
    mockPADelegate = [OCMockObject niceMockForClass:[SubMenuDataDelegate class]];
    mockPAPopulator = [OCMockObject niceMockForClass:[HomeSummaryPopulator class]];

    mockONIterator = [OCMockObject niceMockForClass:[PlanAheadDataIterator class]];
    mockONDelegate = [OCMockObject niceMockForClass:[SubMenuDataDelegate class]];
    mockONPopulator = [OCMockObject niceMockForClass:[HomeSummaryPopulator class]];
    mockAuthState = [OCMockObject niceMockForClass:[AuthState class]];
    
    mockCircularImageButton = [OCMockObject niceMockForClass:[CircularImageButton class]];

    controller = [[HomeViewController alloc] init];
    controller.planAheadIterator = mockPAIterator;
    controller.planAheadDelegate = mockPADelegate;
    controller.planAheadPopulator = mockPAPopulator;

    controller.onNowIterator = mockONIterator;
    controller.onNowDelegate = mockONDelegate;
    controller.onNowPopulator = mockONPopulator;
    controller.authState = mockAuthState;
    
    controller.avatarRing = mockCircularImageButton;

}

-(void)testThatNilProfileImageStringSwitchedToDefaultImageWhenIsLoggedInTrue
{
    UserProfile *currentUser = [[UserProfile alloc] init];
    currentUser.avatarURL = nil;
    
    BOOL val = YES;
    
    [[[mockAuthState stub] andReturnValue:OCMOCK_VALUE(val)] isLoggedIn];
    [[[mockAuthState stub] andReturn:currentUser] currentUser];
    
    [[mockCircularImageButton expect] loadImage:GHOST_AVATAR_IMAGE];
    
    [controller doCheckToSeeIfUserLoggedIn];
    
    [mockCircularImageButton verify];
}


-(void)testThatNilProfileImageStringSwitchedToDefaultImageWhenIsLoggedInFalse
{
    UserProfile *currentUser = [[UserProfile alloc] init];
    currentUser.avatarURL = nil;
    
    BOOL val = NO;
    
    [[[mockAuthState stub] andReturnValue:OCMOCK_VALUE(val)] isLoggedIn];
    [[[mockAuthState stub] andReturn:currentUser] currentUser];
    
    [[mockCircularImageButton expect] loadImage:GHOST_AVATAR_IMAGE];
    
    [controller doCheckToSeeIfUserLoggedIn];
    
    [mockCircularImageButton verify];
}


-(void)testOnOptionTouchedForOnNowView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 1;

    id mockAppController = [OCMockObject mockForClass:[AppViewController class]];
    [[mockAppController expect] setContentScreen:[OCMArg any]];
    
    id mockHomeController = [OCMockObject partialMockForObject:controller];
    
    [[[mockHomeController stub] andReturn:mockAppController] getAppViewController];  
    
    
    [controller onOptionTouched:btn];
    
    [mockAppController verify];
}

- (void)testLoadPreparesPlanAheadDelegateWithSubMenu
{
    HomeSubMenuView *paSubMenu = [[HomeSubMenuView alloc] init];
    controller.planAheadSubMenu  = paSubMenu;

    [[mockPADelegate expect] prepare:sameInstance(paSubMenu)];

    [controller viewDidLoad];

    [mockPADelegate verify];
}

- (void)testLoadPreparesAndInitialisesThePlanAheadPopulator
{
    [[mockPAPopulator expect]
            prepareWithIterator:sameInstance(mockPAIterator)
                    andDelegate:sameInstance(mockPADelegate)];

    [controller viewDidLoad];

    [mockPAPopulator verify];
}

- (void)testLoadPreparesOnNowDelegateWithSubMenu
{
    HomeSubMenuView *onNowSubMenu = [[HomeSubMenuView alloc] init];
    controller.onNowSubMenu  = onNowSubMenu;

    [[mockONDelegate expect] prepare:sameInstance(onNowSubMenu)];

    [controller viewDidLoad];

    [mockONDelegate verify];
}

- (void)testLoadPreparesAndInitialisesTheOnNowPopulator
{
    [[mockONPopulator expect]
            prepareWithIterator:sameInstance(mockONIterator)
                    andDelegate:sameInstance(mockONDelegate)];

    [controller viewDidLoad];

    [mockONPopulator verify];
}


@end
