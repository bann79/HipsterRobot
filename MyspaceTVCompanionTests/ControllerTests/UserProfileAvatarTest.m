//
//  KnownUserLoginAvatarTest.m
//  MyspaceTVCompanion
//
//  Created by Michael Lewis on 17/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "UserProfileAvatarViewController.h"
#import "UserProfile.h"
@interface UserProfileAvatarTest : SenTestCase
{
    id mockAvatarImg;
    id mockAvatarBtn;
    id mockCloseBtn;
    UserProfileAvatarViewController * userProfileAvatarVC;
}
@end

@implementation UserProfileAvatarTest

-(void)setUp
{
    mockAvatarImg = [OCMockObject niceMockForClass:[LazyLoadImageView class]];
    mockAvatarBtn = [OCMockObject niceMockForClass:[UIButton class]];
    mockCloseBtn = [OCMockObject mockForClass:[UIButton class]];
    
    userProfileAvatarVC = [[UserProfileAvatarViewController alloc] init];
    [userProfileAvatarVC setCloseBtn:mockCloseBtn];
    [userProfileAvatarVC setAvatarImg:mockAvatarImg];
    [userProfileAvatarVC setAvatarBtn:mockAvatarBtn];
}

-(void)testOutletsAreNotNil
{
    STAssertNotNil(userProfileAvatarVC.avatarImg,@"Known users avatar backgrounds image should not be nil");
    STAssertNotNil(userProfileAvatarVC.closeBtn,@"Known users avatar remove button should not be nil");
}

-(void)testSetUserProfile
{
    id mockUserProfile = [OCMockObject niceMockForClass:[UserProfile class]];
    
    [userProfileAvatarVC setUserProfile:mockUserProfile];
    
    STAssertEqualObjects(userProfileAvatarVC.userProfile, mockUserProfile, @"UserProfile should be set to %@ but was %@", mockUserProfile, userProfileAvatarVC.userProfile);
}

-(void)testLoadAvatar
{
    NSString *imgURL = @"http://www.odcpl.com/web_images/logo_-_national_geographic_kids.jpg";
    UIViewContentMode contMode = UIViewContentModeCenter;
    [[mockAvatarImg expect] lazyLoadImageFromURLString:imgURL contentMode:contMode];
    [userProfileAvatarVC loadAvatar:imgURL withContentMode:contMode];
    [mockAvatarImg verify];
}

-(void)tearDown
{
    [userProfileAvatarVC setAvatarImg:nil];
    [userProfileAvatarVC setCloseBtn:nil];
    [userProfileAvatarVC setAvatarBtn:nil];
    userProfileAvatarVC = nil;
}
@end
