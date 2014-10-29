//
//  TopBarViewControllerTest.m
//  MyspaceTVCompanion
//
//  Created by Dyfan Hughes on 16/07/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "TopBarViewController.h"
#import <OCMock/OCMock.h>
#import "AuthState.h"
#import "UserProfile.h"
#import "CircularImageButton.h"

@interface TopBarViewControllerTest : SenTestCase
{
    
}

@end

@implementation TopBarViewControllerTest
{
@private
    TopBarViewController * controller;
    id mockAppViewController;
    id mockXMPPSession;
    id mockAuthState;
    __weak id mockCircularImageButton;
}

-(void)setUp
{
    [super setUp];
    controller = [[TopBarViewController alloc]initWithNibName:@"TopBarViewController" bundle:nil];
    
    mockAppViewController = [OCMockObject niceMockForClass:[AppViewController class]];
    controller.appViewController = mockAppViewController;
    [controller view];
    
    mockXMPPSession = [OCMockObject mockForClass:[XMPPClient class]];
    mockAuthState = [OCMockObject niceMockForClass:[AuthState class]];
    
    mockCircularImageButton = [OCMockObject niceMockForClass:[CircularImageButton class]];
    
    controller.xmppSession = mockXMPPSession;
    controller.authState = mockAuthState;
    controller.userMenuBtn = mockCircularImageButton;
}

-(void)tearDown
{
    [super tearDown];
    controller = nil;
}

-(void)testThatNilProfileImageStringSwitchedToDefaultImageWhenIsLoggedInTrue
{
    UserProfile *currentUser = [[UserProfile alloc] init];
    currentUser.avatarURL = nil;
    
    BOOL val = YES;
    
    [[[mockAuthState stub] andReturnValue:OCMOCK_VALUE(val)] isLoggedIn];
    [[[mockAuthState stub] andReturn:currentUser] currentUser];
    
    [[mockCircularImageButton expect] loadImage:@"ghost_avatar"];
    
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
    
    [[mockCircularImageButton expect] loadImage:@"login_image"];
    
    [controller doCheckToSeeIfUserLoggedIn];
    
    [mockCircularImageButton verify];
}

-(void)testOutletsSet
{
    STAssertNotNil(controller.view, @"View not nil");
    
    STAssertNotNil(controller.homeBtn,@"Home button created");
    STAssertNotNil(controller.onlineBuddiesCount,@"Buddy count label created");
}

-(void)testUserMenuIsCreatedCorrectly
{
    [controller viewDidAppear:NO];
}

-(void)testUserMenuIsShownToUserOnUserMenuBtnPressed
{
    id sender = [OCMockObject niceMockForClass:[UIButton class]];
    
    [[[mockAuthState stub] andReturnValue:[NSNumber numberWithBool:YES]] isLoggedIn];
    
    [[mockAppViewController expect] showMenuPopupView];
    [controller onUserMenuBtnPressed:sender];
    
    [mockAppViewController verify];
}


-(void)testRosterUpdatedUpdatesOnlineIndicator
{
    NSNotification *notification = [NSNotification notificationWithName:FriendsListUpdatedNotification object:@"jim ronk"];
    
    NSUInteger val = 5;
    
    [[[mockXMPPSession expect] andReturnValue:OCMOCK_VALUE(val)] numberOnlineBuddies];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    STAssertEqualObjects(controller.onlineBuddiesCount.text, @"5",@"Buddies online label has correct value");
}

@end
