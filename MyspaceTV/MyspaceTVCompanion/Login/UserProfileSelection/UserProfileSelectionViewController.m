//
//  UserProfileSelectionViewController.m
//  MyspaceTVCompanion
//
//  Created by Michael Lewis on 16/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserProfileSelectionViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "AppViewController.h"
#define MAX_NUM_PROFILES 8
#define OPTION_RING_RADIUS 200


@interface UserProfileSelectionViewController ()
{
    void (^transitionOutCB)();
    
    NSArray * profilePostions;
    NSArray * btnAngleOnArc;
    BOOL isForReposition;
    BOOL isLoginCancelled;
}
@end

@implementation UserProfileSelectionViewController
@synthesize sourceView = _sourceView;
@synthesize centerLoginImg = _centerLoginImg;
@synthesize backgroundImg = _backgroundImg;
@synthesize centerRing = _centerRing;
@synthesize middleRing = _middleRing;
@synthesize outerRing = _outerRing;
@synthesize touchableBackground = _touchableBackground;
@synthesize currentlyLoggedInAvatar = _currentlyLoggedInAvatar;
@synthesize addNewUserBtn = _addNewUserBtn;
@synthesize backBtn = _backBtn;
@synthesize rings = _rings;
@synthesize knownUserProfiles = _knownUserProfiles;
@synthesize avatars = _avatars;
@synthesize fromLogout = _fromLogout;
@synthesize successfulLoggedout = _successfulLoggedout;

#pragma mark View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    if(self.fromLogout)
    {
        [self.centerLoginImg setAlpha:0.0];
        self.successfulLoggedout = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_successful_logged_out.png"]];
        [self.currentlyLoggedInAvatar addSubview:self.successfulLoggedout];
        
        [self performSelector:@selector(dismissTimerHandler:) withObject:nil afterDelay:3.0];
        
    }
    
    isForReposition = NO;
    isLoginCancelled = NO;
    self.sourceView = [[self getAppViewController]getSourceView];
    [self setup];   
    [self transitionIn];
}

-(void)dismissTimerHandler:(NSTimer*)timer
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.centerLoginImg setAlpha:1.0];
        [self.successfulLoggedout setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.successfulLoggedout removeFromSuperview];
        [self setSuccessfulLoggedout:nil];
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    _isTouchedProfileAnimating = NO;
    
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self cleanup];
    [super viewDidDisappear:animated];
    
}

-(void)cleanup
{
    for (int i = 0; i<[self.avatars count]; i++) {
        UserProfileAvatarViewController * avatar = (UserProfileAvatarViewController*)[self.avatars objectAtIndex:i];
        [avatar removeProfile];
        [avatar.view removeFromSuperview];
        avatar = nil;
    }
    
    [self setSuccessfulLoggedout:nil];
    [self setCurrentlyLoggedInAvatar:nil];
    [self setTouchableBackground:nil];
    [self setAddNewUserBtn:nil];
    [self setCenterRing:nil];
    [self setMiddleRing:nil];
    [self setOuterRing:nil];
    [self setBackBtn:nil];
    [self setBackgroundImg:nil];
    [self setSourceView:nil];
    [self setRings:nil];
    [self setKnownUserProfiles:nil];
    
    [self setAvatars:nil];
    
}
- (void)viewDidUnload
{
    //[self cleanup];
    
    [self setCenterLoginImg:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark IB Actions

- (IBAction)onBgTouched:(id)sender {    
    for (int i = 0; i<[self.avatars count]; i++) {
        UserProfileAvatarViewController * avatar = (UserProfileAvatarViewController*)[self.avatars objectAtIndex:i];
        [avatar stopShake];
    }   
}

- (IBAction)onBackTouched:(id)sender {
    isLoginCancelled = YES;
    [[self getAppViewController] setContentScreen:self.sourceView];
}


#pragma mark app protocols
-(AppViewController *)getAppViewController
{    
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController;
}


-(BOOL)isGreedy
{
    return YES;
}

#pragma mark Transitions
-(void)transitionIn
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.backgroundImg setAlpha:1.0];
    } completion:^(BOOL finished){
        
        [self animateInRings];
    }];
}
-(void)transitionOut:(void (^)())callback
{
    transitionOutCB = callback;
    for(int j=0; j<self.avatars.count; j++)
    {
        [self animateOutOptionButtons:j];
    }
}

-(void)animateInRings
{    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.currentlyLoggedInAvatar.alpha = 1;
        self.currentlyLoggedInAvatar.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.centerRing.alpha = 1;
        self.centerRing.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        for(int j=0; j<self.avatars.count; j++)
        {
            [self animateInOptionButtons:j withFadeIn:YES];
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.addNewUserBtn setAlpha:1.0];
            [self.backBtn setAlpha:1.0];
        } completion:nil];
    }];
    
    [UIView animateWithDuration:0.5 delay:0.4 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.middleRing.alpha = 1;
        self.middleRing.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    [UIView animateWithDuration:0.5 delay:0.6 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.outerRing.alpha = 1;
        self.outerRing.transform = CGAffineTransformIdentity;
    } completion:nil];
}   

-(void)animateOutRings
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.addNewUserBtn setAlpha:0.0];
        [self.backBtn setAlpha:0.0];
    } completion:nil];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.outerRing.alpha = 0.0;
        self.outerRing.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:nil];
    
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.middleRing.alpha = 0.0;
        self.middleRing.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:nil];
    
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.centerRing.alpha = 0.0;
        self.centerRing.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:nil];
    
    
    [UIView animateWithDuration:0.2 delay:0.3 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.currentlyLoggedInAvatar.alpha = 0.0;
        self.currentlyLoggedInAvatar.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished) {
        
        if(isLoginCancelled)
        {
        
            [UIView animateWithDuration:0.5 animations:^{
                [self.backgroundImg setAlpha:1.0];
            } completion:^(BOOL bgfinished){
                [UIView animateWithDuration:0.5 animations:^{
                    [self.backgroundImg setAlpha:0.0];
                } completion:^(BOOL bgFadeComplete){
                    NSLog(@"transitionOutCB is called!!! ");
                    transitionOutCB();
                }];
            }];
        }else {
            NSLog(@"transitionOutCB is called!!! ");
            transitionOutCB();
        }
        
    }];
}   

-(void)animateInOptionButtons:(int)index withFadeIn:(BOOL)shouldFadeIn
{
    UIView *btn = ((UIViewController*) [self.avatars objectAtIndex:index]).view;
    
    // Set up fade in
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    if(shouldFadeIn)
    {
        [fadeInAnimation setToValue:[NSNumber numberWithFloat:1.0]];
        fadeInAnimation.fillMode = kCAFillModeForwards;
        fadeInAnimation.removedOnCompletion = NO;
    }
    // Set up path movement
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable(); 
    float start_radians;
    if(index == (self.avatars.count - 1))
    {
        //point to last button.
        start_radians = M_PI*3/2;
        
    }
    /*
     else if(index == 2){
     start_radians = M_PI/2;
     
     }*/
    else {
        start_radians = [[btnAngleOnArc objectAtIndex:(index+1)] floatValue];
        
    }
    /*
     float end_radians = [[btnAngleOnArc objectAtIndex:index] floatValue];
     CGPathAddArc(curvedPath, nil, self.avatarRing.center.x, self.avatarRing.center.y, OPTION_RING_RADIUS, start_radians, end_radians, NO);
     */
    CGPathAddRelativeArc(curvedPath, nil, self.centerRing.center.x, self.centerRing.center.y, OPTION_RING_RADIUS, start_radians, M_PI/4);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setAnimations:[NSArray arrayWithObjects:fadeInAnimation, pathAnimation, nil]];
    
    group.duration = 0.2f;
    group.delegate = self;
    //group.beginTime = CACurrentMediaTime() + 0.1f*index;
    
    [group setValue:[NSNumber numberWithInt:btn.tag] forKey:@"animationInOptionButtons"];
    [btn.layer addAnimation:group forKey:@"animationInOptionButtons"];
    
    
}

-(void)animateOutOptionButtons:(int)index
{
    // Set up fade out
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeOutAnimation setToValue:[NSNumber numberWithFloat:0.0]];
    fadeOutAnimation.fillMode = kCAFillModeForwards;
    fadeOutAnimation.removedOnCompletion = NO;
    
    // Set up path movement
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    
    UIView *btn = ((UIViewController*) [self.avatars objectAtIndex:index]).view;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    float start_radians = [[btnAngleOnArc objectAtIndex:index] floatValue];
    /*float end_radians = 0.0f;
    if(index == (self.avatars.count - 1))
    {
        //point to last button.
        end_radians = M_PI*3/2;
        
    }else {
        end_radians = [[btnAngleOnArc objectAtIndex:(index+1)] floatValue];
        
    }*/
    
    CGPathAddRelativeArc(curvedPath, nil, self.centerRing.center.x, self.centerRing.center.y, OPTION_RING_RADIUS, start_radians, -M_PI/4);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setAnimations:[NSArray arrayWithObjects:fadeOutAnimation, pathAnimation, nil]];
    
    group.duration = 0.2f;
    group.delegate = self;
    //group.beginTime = CACurrentMediaTime() + 0.1f*index;
    
    [group setValue:[NSNumber numberWithInt:btn.tag] forKey:@"animationOutOptionButtons"];
    [btn.layer addAnimation:group forKey:@"animationOutOptionButtons"];
}


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    // Create the second animation and add it
    NSNumber *tag = [theAnimation valueForKey:@"animationInOptionButtons"];
    if(tag != nil)
    {
        int nextIndex = tag.intValue + 1;
        /*
         if (nextIndex < btns.count) {
         [self animateInOptionButtons:nextIndex];
         }
         */
        
        if(nextIndex == self.avatars.count)
        {
            for (UIViewController *vc in self.avatars) {
                UIView *v = vc.view;
                v.alpha = 1;
            }
            
            if(isForReposition)
            {
                isForReposition =NO;
                [self setPositionOfProfilesFromIndex:0 withAlpha:1.0];
                [self repositionAvatarsFromId:([self.avatars count]-1)];
            }
        }
    }else{
        tag = [theAnimation valueForKey:@"animationOutOptionButtons"];
        
        if (tag) {
            int next = tag.intValue + 1;
            if (next == self.avatars.count) 
            {
                [self animateOutRings];
            }
        }
    }
}


#pragma mark Setup

-(void)setup
{
    // calculate original avitar positions based on angles

    float cX = 512 - 55; // screen center adjusted for half status-bar height
    float cY = 374 - 45;
    int r = 200; // avatar (inner) ring radius
     
    // TODO: this should use a table
    CGPoint profilePos1 = CGPointMake(cX + (r * cosf(M_PI*3/2)), cY + r * sinf(M_PI*3/2)); // 270
    CGPoint profilePos2 = CGPointMake(cX + (r * cosf(M_PI*5/4)), cY + r * sinf(M_PI*5/4)); // 225
    CGPoint profilePos3 = CGPointMake(cX + (r * cosf(M_PI)),     cY + r * sinf(M_PI));     // 180
    CGPoint profilePos4 = CGPointMake(cX + (r * cosf(M_PI*3/4)), cY + r * sinf(M_PI*3/4)); // 135
    CGPoint profilePos5 = CGPointMake(cX + (r * cosf(M_PI/2)),   cY + r * sinf(M_PI/2));   // 90
    CGPoint profilePos6 = CGPointMake(cX + (r * cosf(M_PI/4)),   cY + r * sinf(M_PI/4));   // 45
    CGPoint profilePos7 = CGPointMake(cX + (r * cosf(0)),        cY + r * sinf(0));        // 0
    CGPoint profilePos8 = CGPointMake(cX + (r * cosf(M_PI*7/4)), cY + r * sinf(M_PI*7/4)); // 315 / -45
    
    profilePostions = [NSArray arrayWithObjects:
                       [NSValue valueWithCGPoint:profilePos1],
                       [NSValue valueWithCGPoint:profilePos2],
                       [NSValue valueWithCGPoint:profilePos3],
                       [NSValue valueWithCGPoint:profilePos4],
                       [NSValue valueWithCGPoint:profilePos5],
                       [NSValue valueWithCGPoint:profilePos6],
                       [NSValue valueWithCGPoint:profilePos7],
                       [NSValue valueWithCGPoint:profilePos8],
                       nil];
    
    btnAngleOnArc = [NSMutableArray arrayWithObjects:
                     [NSNumber numberWithFloat:(M_PI*3/2)],
                     [NSNumber numberWithFloat:(M_PI*5/4)], 
                     [NSNumber numberWithFloat:M_PI], 
                     [NSNumber numberWithFloat:(M_PI*3/4)],
                     [NSNumber numberWithFloat:M_PI/2],
                     [NSNumber numberWithFloat:(M_PI/4)],
                     [NSNumber numberWithFloat:0],
                     [NSNumber numberWithFloat:(M_PI*7/4)],  nil];
    
    self.knownUserProfiles = [[UserProfilesManager sharedSingleton] loadUserProfiles];
    [self createAvatars:self.knownUserProfiles];
    
    self.rings = [NSArray arrayWithObjects:self.currentlyLoggedInAvatar, self.centerRing, self.middleRing, self.outerRing, nil];
    for (UIView *ring in self.rings) {
        ring.transform = CGAffineTransformMakeScale(0.5, 0.5);
        ring.alpha = 0;
    }
    
    [self.backgroundImg setAlpha:0.0];
    [self.addNewUserBtn setAlpha:0.0];
    [self.backBtn setAlpha:0.0];
}


-(void)createAvatars:(NSArray *)profileCollection
{   
    self.avatars = [[NSMutableArray alloc] init];
    for (int i = 0; i<MAX_NUM_PROFILES; i++) {
       [self addEmptyAvatarAtIndex:i];
    }
    
    for (int i=0; i<[profileCollection count]; i++) {
        UserProfileAvatarViewController *userProfileAvatar = [[UserProfileAvatarViewController alloc] initWithNibName:@"UserProfileAvatarView" bundle:[NSBundle mainBundle]];
        [self.view addSubview:userProfileAvatar.view];
        [userProfileAvatar.view setHidden:YES];
        UserProfile * tempProfile = [profileCollection objectAtIndex:i];
        tempProfile.isKnownUser = YES;
        [userProfileAvatar setUserProfile:tempProfile];
        [userProfileAvatar setDelegate:self];
        //[self.avatars addObject:userProfileAvatar];
        [self.avatars replaceObjectAtIndex:tempProfile.profileSelectionPositionIndex withObject:userProfileAvatar];
       
    }
    _isTouchedProfileAnimating = NO;
    [self setPositionOfProfilesFromIndex:0 withAlpha:0.0];
}

-(UIView*)addEmptyAvatarAtIndex:(int)index
{
    UserProfileAvatarViewController *emptyProfileAvatar = [[UserProfileAvatarViewController alloc] initWithNibName:@"UserProfileAvatarView" bundle:[NSBundle mainBundle]];
    [self.view addSubview:emptyProfileAvatar.view];
    [emptyProfileAvatar.view setHidden:YES];
    
    UserProfile * tempProfile = [[UserProfile alloc] init];
    [tempProfile setProfileSelectionPositionIndex:index];
    [tempProfile setIsKnownUser:NO];
    
    [emptyProfileAvatar setUserProfile:tempProfile];
    [emptyProfileAvatar setEmptyProfile];
    [emptyProfileAvatar setDelegate:self];
    
    if(index == [self.avatars count]+1)
    {
        [self.avatars addObject:emptyProfileAvatar];
    }else{
        [self.avatars insertObject:emptyProfileAvatar atIndex:index];
    }
    
    return emptyProfileAvatar.view;
}

-(void)setPositionOfProfilesFromIndex:(int)index withAlpha:(float)alpha
{
    for (int i = index; i<[self.avatars count]; i++) {
        UserProfileAvatarViewController * avatar = (UserProfileAvatarViewController*)[self.avatars objectAtIndex:i];
        [avatar.view setTag:i];
        [avatar.view setAlpha:alpha];
        NSValue *targetVal = [profilePostions objectAtIndex:i];
        CGPoint position = [targetVal CGPointValue];
        
        [avatar.view setFrame:CGRectMake(position.x, position.y, avatar.view.frame.size.width, avatar.view.frame.size.height)];
        [self.view insertSubview:avatar.view atIndex:[self.avatars count]];
        [avatar.view setHidden:NO];
        [avatar setAccessibilityLabelWithIndex:i];
    }
}


#pragma mark profile selection protocols
-(void)onProfileTouched:(int)index
{
    if (!_isTouchedProfileAnimating)
    {
        _isTouchedProfileAnimating = YES;
        
        UserProfileAvatarViewController * chosenAvatar = (UserProfileAvatarViewController*)[self.avatars objectAtIndex:index];
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        UserProfile * tempProfile = chosenAvatar.userProfile;
        [tempProfile setProfileSelectionPositionIndex:index];
        [loginViewController setUserProfile:tempProfile];
        
        [[self getAppViewController] setContentScreenWithViewName:nil orViewController:loginViewController];
    }
}

-(void)performShake
{
    for (int i = 0; i<[self.avatars count]; i++) {
        UserProfileAvatarViewController * avatar = (UserProfileAvatarViewController*)[self.avatars objectAtIndex:i];
        [avatar shake];
    }    
}

-(void)stopAllFromShaking
{
    for (int i = 0; i<[self.avatars count]; i++) {
        UserProfileAvatarViewController * avatar = (UserProfileAvatarViewController*)[self.avatars objectAtIndex:i];
        [avatar stopShake];
    }    
    
}

-(void)removedProfile:(id)profileRemoved
{
    UserProfileAvatarViewController*removedAvatar = (UserProfileAvatarViewController*)profileRemoved;
    
    [self.avatars removeObject:removedAvatar];
    
    [[UserProfilesManager sharedSingleton] removeCurrentUserFromUserDefaultsThenSave:removedAvatar.userProfile];
    
    [UIView animateWithDuration:3.0 animations:^{
        [removedAvatar.view setAlpha:0.0];
        removedAvatar.view.transform = CGAffineTransformScale(removedAvatar.view.transform, 0.5f, 0.5f);
    } completion:^(BOOL finished) {
        UIView *newView = [self addEmptyAvatarAtIndex:[removedAvatar.view tag]];
        
        [self setPositionOfProfilesFromIndex:[removedAvatar.view tag] withAlpha:1.0];
        newView.transform = CGAffineTransformScale(newView.transform, 0.5f, 0.5f);
        [newView setAlpha:0.0];
        [self animateInOptionButtons:[removedAvatar.view tag] withFadeIn:NO];
        
        
        [UIView animateWithDuration:0.5 animations:^{
            [newView setAlpha:1.0];
            [newView setTransform:CGAffineTransformIdentity];
        }];
    }];
    removedAvatar = nil;
}

-(void)repositionAvatarsFromId:(int)index
{
    
    for(int j=index; j<self.avatars.count; j++)
    {
        [self animateInOptionButtons:j withFadeIn:NO];
    }    
}

@end
