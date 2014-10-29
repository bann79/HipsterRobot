//
//  UserProfileSelectionViewController.h
//  MyspaceTVCompanion
//
//  Created by Michael Lewis on 16/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppViewProtocol.h"
#import "AppDelegate.h"
#import "UserProfilesManager.h"
#import "UserProfileAvatarViewController.h"
#import "ProfileSelectionProtocol.h"

@interface UserProfileSelectionViewController : UIViewController <AppViewProtocol,ProfileSelectionProtocol>
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (strong, nonatomic) IBOutlet UIImageView *centerRing;
@property (strong, nonatomic) IBOutlet UIImageView *middleRing;
@property (strong, nonatomic) IBOutlet UIImageView *outerRing;
@property (strong, nonatomic) IBOutlet UIButton *touchableBackground;
@property (strong, nonatomic) IBOutlet UIView *currentlyLoggedInAvatar;
@property (strong, nonatomic) IBOutlet UIButton *addNewUserBtn;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) NSArray *knownUserProfiles;
@property (strong, nonatomic) NSArray *rings;

@property (strong, nonatomic) NSMutableArray *avatars;
@property (strong, nonatomic) NSString *sourceView;
@property (strong, nonatomic) IBOutlet UIImageView *centerLoginImg;
@property (strong, nonatomic) UIImageView *successfulLoggedout;

@property BOOL fromLogout;
@property BOOL isTouchedProfileAnimating;


- (IBAction)onBgTouched:(id)sender;
- (IBAction)onBackTouched:(id)sender;
-(void)createAvatars:(NSArray *)profileCollection;
-(void)performShake;
-(void)stopAllFromShaking;
@end
