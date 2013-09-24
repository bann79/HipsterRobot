//
//  KnownUsersLoginTest.m
//  MyspaceTVCompanion
//
//  Created by Michael Lewis on 17/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "UserProfileAvatarViewController.h"
#import "UserProfileSelectionViewController.h"
#import "UserProfile.h"
@interface UserProfileLoginTest : SenTestCase
{
    id mockTouchableBackground;
    id mockLoginProfileAvatars;
    id mockCurrentlyLoggedInAvatar;
    id mockCenterRing;
    id mockMiddleRing;
    id mockOuterRing;
    id mockBackgroundImg;
    id mockAddNewUserBtn;
    id mockBackBtn;

    UserProfileSelectionViewController *userProfileSelectionVC;
}
@end


@implementation UserProfileLoginTest

-(void)setUp
{
    mockTouchableBackground = [OCMockObject mockForClass:[UIButton class]];
    mockCurrentlyLoggedInAvatar = [OCMockObject mockForClass:[UIView class]];
    mockBackgroundImg = [OCMockObject mockForClass:[UIImageView class]];
    mockCenterRing = [OCMockObject mockForClass:[UIImageView class]];
    mockMiddleRing = [OCMockObject mockForClass:[UIImageView class]];
    mockOuterRing = [OCMockObject mockForClass:[UIImageView class]];
    mockAddNewUserBtn = [OCMockObject mockForClass:[UIButton class]];
    mockBackBtn = [OCMockObject mockForClass:[UIButton class]];
    userProfileSelectionVC = [[UserProfileSelectionViewController alloc] initWithNibName:@"UserProfileSelectionViewController" bundle:[NSBundle mainBundle]];

    [userProfileSelectionVC setTouchableBackground:mockTouchableBackground];
    [userProfileSelectionVC setCurrentlyLoggedInAvatar:mockCurrentlyLoggedInAvatar];
    [userProfileSelectionVC setBackgroundImg:mockBackgroundImg];
    [userProfileSelectionVC setCenterRing:mockCenterRing];
    [userProfileSelectionVC setMiddleRing:mockMiddleRing];
    [userProfileSelectionVC setOuterRing:mockOuterRing];
    [userProfileSelectionVC setAddNewUserBtn:mockAddNewUserBtn];
    [userProfileSelectionVC setBackBtn:mockBackBtn];
}

-(void)testKnownUsersLoginOutletsAreNotNil
{
    STAssertNotNil(userProfileSelectionVC, @"KnownUsersLoginViewController should not be nil");
    STAssertNotNil(userProfileSelectionVC.touchableBackground, @"KnownUsersLoginViewController touchableBackground should not be nil");
    STAssertNotNil(userProfileSelectionVC.currentlyLoggedInAvatar, @"KnownUsersLoginViewController currentlyLoggedInAvatar should not be nil");
    STAssertNotNil(userProfileSelectionVC.backgroundImg, @"KnownUsersLoginViewController backgroundImg should not be nil");
    STAssertNotNil(userProfileSelectionVC.centerRing, @"KnownUsersLoginViewController centerRing should not be nil");
    STAssertNotNil(userProfileSelectionVC.middleRing, @"KnownUsersLoginViewController middleRing should not be nil");
    STAssertNotNil(userProfileSelectionVC.outerRing, @"KnownUsersLoginViewController outerRing should not be nil");
    STAssertNotNil(userProfileSelectionVC.addNewUserBtn, @"KnownUsersLoginViewController addNewUserBtn should not be nil");
    STAssertNotNil(userProfileSelectionVC.backBtn, @"KnownUsersLoginViewController backBtn should not be nil");
}

-(void)testCreateAvatarsForThreeProfiles
{
    int expectedNumProfilesInTotal = 8;
    NSArray * mockProfiles = [NSArray arrayWithObjects:[OCMockObject niceMockForClass:[UserProfile class]],[OCMockObject niceMockForClass:[UserProfile class]],[OCMockObject niceMockForClass:[UserProfile class]],nil];

    [userProfileSelectionVC createAvatars:mockProfiles];

    STAssertTrue(([userProfileSelectionVC.avatars count] == expectedNumProfilesInTotal), @"Expected the avatar creation count to be %i but was %i ", expectedNumProfilesInTotal, [userProfileSelectionVC.avatars count]);

}

-(void)testCreateAvatarsWithNilProfiles
{
    int expectedNumEmptyProfilesInTotal = 8;
    NSArray * mockProfiles = nil;
    [userProfileSelectionVC createAvatars:mockProfiles];

    STAssertTrue(([userProfileSelectionVC.avatars count] == expectedNumEmptyProfilesInTotal), @"Expected the avatar creation count to be %i but was %i ", expectedNumEmptyProfilesInTotal, [userProfileSelectionVC.avatars count]);
}

-(void)testPerformShake
{
    id mockAvatar = [OCMockObject niceMockForClass:[UserProfileAvatarViewController class]];
    
    [[mockAvatar expect] shake];
    NSArray * arrOfMockAvatars = [NSArray arrayWithObjects:mockAvatar,mockAvatar,mockAvatar,mockAvatar,mockAvatar,nil];
    
    NSMutableArray *mockAvatars = [NSMutableArray arrayWithArray:arrOfMockAvatars];
    
    [userProfileSelectionVC setAvatars:mockAvatars];
    
    [userProfileSelectionVC performShake];
    
    [mockAvatar verify];
}

-(void)testStopShake
{
    id mockAvatar = [OCMockObject niceMockForClass:[UserProfileAvatarViewController class]];
    
    [[mockAvatar expect] stopShake];
    NSArray * arrOfMockAvatars = [NSArray arrayWithObjects:mockAvatar,mockAvatar,mockAvatar,mockAvatar,mockAvatar,nil];
    
    NSMutableArray *mockAvatars = [NSMutableArray arrayWithArray:arrOfMockAvatars];
    
    [userProfileSelectionVC setAvatars:mockAvatars];
    
    [userProfileSelectionVC stopAllFromShaking];
    
    [mockAvatar verify];
}

-(void)testRemovedProfile
{
    id mockAvatar = [OCMockObject niceMockForClass:[UserProfileAvatarViewController class]];
    
    id mockAvatars = [OCMockObject niceMockForClass:[NSMutableArray class]];
    
    [[mockAvatars expect] removeObject:mockAvatar];
    
    [userProfileSelectionVC setAvatars:mockAvatars];
    
    [userProfileSelectionVC removedProfile:mockAvatar];
    
    [mockAvatars verify];
    
}

-(void)tearDown
{
    [userProfileSelectionVC setCurrentlyLoggedInAvatar:nil];
    [userProfileSelectionVC setTouchableBackground:nil];
    userProfileSelectionVC = nil;

    mockTouchableBackground = nil;
    mockLoginProfileAvatars = nil;
    mockCurrentlyLoggedInAvatar = nil;
    mockCenterRing = nil;
    mockMiddleRing = nil;
    mockOuterRing = nil;
    mockBackgroundImg = nil;
    mockAddNewUserBtn = nil;
    mockBackBtn = nil;
}

@end
