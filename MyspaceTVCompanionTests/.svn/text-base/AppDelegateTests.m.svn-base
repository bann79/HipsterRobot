//
//  AppDelegateTests.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 01/08/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <SenTestingKit/SenTestingKit.h>


#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "AuthState.h"
#import "AppDelegate.h"
#import "AppViewController.h"

@interface AuthState (Test)
+(void)setSharedInstance:(id)inst;
@end

@interface AppDelegateTests : SenTestCase
@end


@implementation AppDelegateTests{

    AppDelegate* appDelegate;
    id mockAuthState;
    id mockViewController;
}


-(void)setUp{

    appDelegate = [[AppDelegate alloc] init];
    mockAuthState = [OCMockObject niceMockForClass:[AuthState class]];
    [AuthState setSharedInstance:mockAuthState];

    mockViewController = [OCMockObject mockForClass:[AppViewController class]];
    [appDelegate setViewController:mockViewController];
}

-(void)tearDown
{
    [AuthState setSharedInstance:nil];
    [mockAuthState verify];
    [mockViewController verify];
}

-(void)testApplicationDidFinishLaunchingAttemptsLogin
{
    [[mockAuthState expect] revivePreviousSession:instanceOf([AppDelegate class])];
    
    [appDelegate application:nil didFinishLaunchingWithOptions:nil];
}

-(void)testOnSucessLoadsViewController
{
    [[mockViewController expect] startupComplete];    
    
    [appDelegate onSuccess:nil];
}


-(void)testOnFailureLoadsViewController
{
    [[mockViewController expect] startupComplete];    
    [appDelegate onFailure:nil]; 
}

-(void)testWillTerminateLogsOutUser
{
    [[mockAuthState expect] logoutWithResponder:instanceOf([AppDelegate class])];
 
    [appDelegate applicationWillTerminate:nil];
}

@end
