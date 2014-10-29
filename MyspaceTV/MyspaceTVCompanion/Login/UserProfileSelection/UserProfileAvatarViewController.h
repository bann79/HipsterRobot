//
//  UserProfileAvatarViewController.h
//  MyspaceTVCompanion
//
//  Created by Michael Lewis on 19/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfile.h"
#import "LazyLoadImageView.h"
#import "ProfileSelectionProtocol.h"
#import "ImageUtils.h"

NSString static *const DEFAULT_PROFILE_IMAGE = @"defaultProfilePic";
@interface UserProfileAvatarViewController : UIViewController<UIGestureRecognizerDelegate>

@property(nonatomic,strong)id<ProfileSelectionProtocol> delegate;
@property BOOL isEmptyProfile;
@property(nonatomic,strong)UserProfile * userProfile;
@property(nonatomic,strong)IBOutlet LazyLoadImageView * avatarImg;
@property(nonatomic,strong)IBOutlet UIButton * closeBtn;
@property(nonatomic,strong)IBOutlet UIButton * avatarBtn;
@property (strong, nonatomic) IBOutlet UIView *avatarContainer;
- (IBAction)onAvatarPressed:(id)sender;
- (IBAction)onRemoveProfile:(id)sender;
-(void)setUserProfile:(UserProfile *)user;
-(void)loadAvatar:(NSString *)url withContentMode:(UIViewContentMode)contentMode;

-(void)removeProfile;
-(void)setEmptyProfile;
-(void)setAccessibilityLabelWithIndex:(int)index;
-(void)shake;
-(void)stopShake;
-(void)setup;
@end
