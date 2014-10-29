//
//  HomeViewController.h
//  MyspaceTVCompanion
//
//  Created by Michael J. Lewis on 01/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeSubMenuView.h"
#import "PlanAheadDataIterator.h"
#import "AppViewProtocol.h"
#import "CircularImageButton.h"
#import "AuthState.h"
#import "InfoPageViewController.h"

@class PlanAheadDataIterator;
@class TimerFactory;
@class SubMenuDataDelegate;
@class HomeSummaryPopulator;
@class OnNowDataIterator;

@interface HomeViewController : UIViewController <AppViewProtocol, InfoPageDelegate>

@property(strong, nonatomic) AuthState *authState;
@property (weak, nonatomic) IBOutlet UIImageView *avatarRingBG;
@property (weak, nonatomic) IBOutlet CircularImageButton *avatarRing;
@property (weak, nonatomic) IBOutlet UIImageView *centerRing;
@property (weak, nonatomic) IBOutlet UIImageView *middleRing;
@property (weak, nonatomic) IBOutlet UIImageView *outerRing;

@property (weak, nonatomic) IBOutlet UIButton *recommendBtn;
@property (weak, nonatomic) IBOutlet UIButton *alertsBtn;
@property (weak, nonatomic) IBOutlet UIButton *onNowBtn;
@property (weak, nonatomic) IBOutlet UIButton *peopleBtn;
@property (weak, nonatomic) IBOutlet UIButton *planAheadBtn;
@property (weak, nonatomic) IBOutlet UIButton *watchBtn;

@property (weak, nonatomic) IBOutlet HomeSubMenuView *onNowSubMenu;
@property (weak, nonatomic) IBOutlet HomeSubMenuView *planAheadSubMenu;

@property(nonatomic, strong) HomeSummaryPopulator *planAheadPopulator;
@property(nonatomic, strong) PlanAheadDataIterator *planAheadIterator;
@property(nonatomic, strong) SubMenuDataDelegate *planAheadDelegate;

@property(nonatomic, strong) HomeSummaryPopulator *onNowPopulator;
@property(nonatomic, strong) OnNowDataIterator *onNowIterator;
@property(nonatomic, strong) SubMenuDataDelegate *onNowDelegate;

@property(nonatomic, strong) InfoPageViewController *infoPanel;

-(void)doCheckToSeeIfUserLoggedIn;

#pragma mark handle touch events.
- (IBAction)onOptionTouched:(UIButton *)sender;
- (IBAction)onSubMenuItemTouchedInside:(UIButton *)sender;

@end

NSString static *const HOME_VIEW_CONTROLLER = @"HomeViewController";
NSString static *const GHOST_AVATAR_IMAGE = @"ghost_avatar";
int static const OPTION_RING_RADIUS = 180;
