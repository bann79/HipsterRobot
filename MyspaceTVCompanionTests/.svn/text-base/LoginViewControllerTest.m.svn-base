//
//  LoginViewControllerTest.m
//  MyspaceTVCompanion
//
//  Created by scott on 17/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import "LoginViewController.h"
#import <OCMock/OCMock.h>
#import "AppViewController.h"
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "UserProfilesManager.h"

@interface LoginViewControllerTest : SenTestCase
{
    LoginViewController *loginViewController;
    id mockAppViewController;
    id mockLoginViewController;
}
@end

@implementation LoginViewControllerTest


-(void)setUp
{
    mockAppViewController = [OCMockObject niceMockForClass:[AppViewController class]];
    
    loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    mockLoginViewController = [OCMockObject partialMockForObject:loginViewController];
    [[[mockLoginViewController stub] andReturn:mockAppViewController] getAppViewController];
    
    Credential * testCredential = [[Credential alloc]init];
    [loginViewController setUserLoginCredentials:testCredential];
}

-(void)tearDown
{
    loginViewController.sourceView = nil;
    mockAppViewController = nil;
    mockLoginViewController = nil;
    loginViewController = nil;
}
-(void)testCorrectsetupOfLoginAndCredentialObjects
{
    [loginViewController viewWillAppear:YES];
    STAssertNotNil(loginViewController.userLoginCredentials,@"credential object not created");
    //STAssertNotNil(loginViewController.authLoginDetails,@"auth object not created");
}

-(void)testSourceViewIsCreatedCorrectlyOnViewWillAppear
{
    [[mockAppViewController expect] getSourceView];
    [loginViewController viewWillAppear:YES];
    
    [mockAppViewController verify];
}

-(void)testCheckLoginWithBothFieldsContainingText
{
    NSString * testUsername = @"test";
    NSString * testPassword = @"test";
    
    [loginViewController checkLoginFieldsUsing:testUsername AndPassword:testPassword];
    
    STAssertTrue(loginViewController.backButton.enabled == NO,@"button shouldn't be enabled");
    STAssertTrue(loginViewController.loginButton.enabled == NO,@"button shouldn't be enabled");
    STAssertTrue(loginViewController.centreCircle.hidden == NO,@"view should be hidden");
    STAssertTrue(loginViewController.loadIndicator.hidden == NO,@"object should be hidden");
    STAssertTrue(loginViewController.knownUsernameLabel.hidden == NO,@"object should be hidden");
}

-(void)testKnownUserWorksWithOnlyBeingGivenAPassword
{
    UserProfile * testUser = [[UserProfile alloc]init];
    testUser.email = @"test";
    
    NSString * testPassword = @"test";
    
    [loginViewController checkLoginFieldsUsing:testUser.email AndPassword:testPassword];
    
    STAssertTrue(loginViewController.backButton.enabled == NO,@"button shouldn't be enabled");
    STAssertTrue(loginViewController.loginButton.enabled == NO,@"button shouldn't be enabled");
    STAssertTrue(loginViewController.centreCircle.hidden == NO,@"view should be hidden");
    STAssertTrue(loginViewController.loadIndicator.hidden == NO,@"object should be hidden");
    STAssertTrue(loginViewController.knownUsernameLabel.hidden == NO,@"object should be hidden");
}

-(void)testCancelButtonClearsTextFields
{
    id sender;
    [loginViewController cancelButtonTapped:sender];
    STAssertTrue([loginViewController.loginButton isEnabled] == NO,@"button shouldn't be enabled");
    STAssertTrue([loginViewController.backButton isEnabled]  == NO,@"button shouldn't be enabled");
}

-(void)testClearLoginDetailsWipesUsernameAndPassword
{
    [loginViewController setIsKnownUser:NO];
    
    id mockUsernameLabel = [OCMockObject niceMockForClass:[UITextField class]];
    id mockPasswordLabel = [OCMockObject niceMockForClass:[UITextField class]];
    
    // username is not cleared
    [[mockPasswordLabel expect] setText:@""];
    
    [loginViewController setUsername:mockUsernameLabel];
    [loginViewController setPassword:mockPasswordLabel];
    
    [loginViewController clearLoginDetails];
    
    [mockUsernameLabel verify];
    [mockPasswordLabel verify];
}

-(void)testLoginSuccessfulSourceView
{
    NSString * sourceView = @"HomeViewController";
    loginViewController.sourceView = sourceView;
    [[mockAppViewController expect]setContentScreen:sourceView];

    [loginViewController loginSucceeded];
    [mockAppViewController verify];
}

-(void)testSetUserProfileAssignsUserProfileAsExpected
{
    UserProfile * testUser = [[UserProfile alloc]init];
    testUser.email = @"testuser_123@ronk.com";
    testUser.name = @"testuser_123";
    testUser.isKnownUser = YES;
    
    [loginViewController setUserProfile:testUser];
    
    STAssertNotNil(loginViewController.userAvatar,@"user avatar is nil");
    STAssertTrue(loginViewController.isKnownUser == YES, @"known user is NO");
    STAssertTrue([loginViewController.knownUser isEqual:testUser],@"not the same object");
}

-(void)testCorrectMessageIsDisplayedToTheUserOnServerError
{
    int errorCode = 500;

    id mockFeedbackImage = [OCMockObject niceMockForClass:[UIImageView class]];

    [loginViewController setBackgroundCentreCircle:mockFeedbackImage];

    [[mockFeedbackImage expect] setImage:[UIImage imageNamed:@"login_failed"]];

    [loginViewController displayCorrectLoginMessageAccordingToErrorCode:errorCode OrSuccessfulLogin:NO];

    [mockFeedbackImage verify];
}


-(void)testCorrectMessageIsDisplayedToTheUserOn401Error
{
    int errorCode = 401;

    id mockFeedbackImage = [OCMockObject niceMockForClass:[UIImageView class]];

    [loginViewController setBackgroundCentreCircle:mockFeedbackImage];

    [[mockFeedbackImage expect] setImage:[UIImage imageNamed:@"login_failed"]];

    [loginViewController displayCorrectLoginMessageAccordingToErrorCode:errorCode OrSuccessfulLogin:NO];

    [mockFeedbackImage verify];
}

-(void)testCorrectMessageIsDisplayedToTheUserOnSuccessfulLogin
{
    int errorCode = 0;

    id mockFeedbackImage = [OCMockObject niceMockForClass:[UIImageView class]];

    [loginViewController setBackgroundCentreCircle:mockFeedbackImage];

    [[mockFeedbackImage expect] setImage:[UIImage imageNamed:@"login_successful"]];

    [loginViewController displayCorrectLoginMessageAccordingToErrorCode:errorCode OrSuccessfulLogin:YES];

    [mockFeedbackImage verify];
}

-(void)testLoginSuccessWithNoSourceOrTargetView
{
    [[mockAppViewController reject] setContentScreen:[OCMArg any]];
    [loginViewController loginSucceeded];
    [mockAppViewController verify];
}


-(void)testCancelDoesNothingIfNoSourceOrTarget
{
    [[mockAppViewController reject] setContentScreen:[OCMArg any]];
    [loginViewController doCancel];
    [mockAppViewController verify];
}

-(void)testCorrectBehaviourOccursWhenBothUserDetailsBoxesAreFilled
{
    [loginViewController wrapUpLoginDetailsInCredentialObjectUsing:@"text" And:@"text"];
    
    STAssertTrue(loginViewController.userLoginCredentials.username != NULL,@"");
    STAssertTrue(loginViewController.userLoginCredentials.password != @"",@"");
    STAssertTrue(loginViewController.userLoginCredentials.deviceId != @"",@"");
    STAssertTrue(loginViewController.userLoginCredentials.snName != @"",@"");    
    STAssertTrue(loginViewController.userLoginCredentials.rememberMe == YES,@"");
}
/*
-(void)testAuthenticateLoginDetailsAreCalledCorrectly
{
    id mockAuthState = [OCMockObject niceMockForClass:[AuthState class]];
    [loginViewController setAuthLoginDetails:mockAuthState];
    [[mockAuthState expect] authenticate:[OCMArg any] withCallback:[OCMArg any]];
    
    [loginViewController authenticateUserLoginDetails];
    [mockAuthState verify];
}
*/
@end
