//
//  UserProfileAvatarViewController.m
//  MyspaceTVCompanion
//
//  Created by Michael Lewis on 19/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserProfileAvatarViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface UserProfileAvatarViewController ()
@property(nonatomic,strong)UILongPressGestureRecognizer *longpressGesture;
@end

@implementation UserProfileAvatarViewController
@synthesize avatarContainer = _avatarContainer;

@synthesize avatarImg = _avatarImg, closeBtn = _closeBtn, userProfile = _userProfile, avatarBtn = _avatarBtn, delegate = _delegate, isEmptyProfile = _isEmptyProfile,longpressGesture=_longpressGesture;


#pragma mark View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setup];
    [super viewWillAppear:animated];
}

-(void)setup
{
    _isEmptyProfile = YES;
    _longpressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onAvatarHeldDown:)];
    _longpressGesture.minimumPressDuration = 1;
    [_longpressGesture setDelegate:self];
    [_avatarBtn addGestureRecognizer:_longpressGesture];
    //self.view.layer.borderColor = [[UIColor redColor] CGColor];
    //self.view.layer.borderWidth = 1.0;
}

- (void)viewDidUnload
{
    [self cleanup];
    [super viewDidUnload];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self cleanup];
    [super viewDidDisappear:animated];
}

-(void)cleanup
{
    [self setAvatarContainer:nil];
    [self setAvatarBtn:nil];
    [self setAvatarImg:nil];
    [self setCloseBtn:nil];
    [self setUserProfile:nil];
    [self setDelegate:nil];
    [self setLongpressGesture:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark View lifecycle
- (IBAction)onAvatarPressed:(id)sender {
   /* _isEmptyProfile = [self checkIsEmptyProfile];
    if(!_isEmptyProfile)
    {*/
        [_delegate onProfileTouched:[self.view tag]];
    //}
}

- (IBAction)onRemoveProfile:(id)sender {
    [self.view setUserInteractionEnabled:NO];
    
    // [self stopShake];
    [self hideDelete];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setTransform:(CGAffineTransformScale(self.view.transform, 1.01, 1.01))];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.view setAlpha:0.0];
            [self.view setTransform:(CGAffineTransformScale(self.view.transform, 0.01, 0.01))];
        } completion:^(BOOL removeFinished) {
            [self.view removeFromSuperview];
            [_delegate removedProfile:self];
        }]; 
    }];
}


#pragma mark profile management
-(void)setUserProfile:(UserProfile *)user
{
    _userProfile = user;
    //NSLog(@"_userProfile.avatarURL::: %@",_userProfile.avatarURL);
    if(_userProfile.isKnownUser)
    {
        [self loadAvatar:_userProfile.avatarURL withContentMode:UIViewContentModeScaleAspectFill];
    }
}

-(void)loadAvatar:(NSString *)url withContentMode:(UIViewContentMode)contentMode
{
    _isEmptyProfile = NO;
    //[_avatarBtn setEnabled:YES];
    [_avatarImg lazyLoadImageFromURLString:url contentMode:contentMode];

    [ImageUtils setRoundedView:_avatarContainer toDiameter:75.0];
}

-(void)removeProfile
{
    _userProfile = nil;
    [self setEmptyProfile];
}
-(void)setEmptyProfile
{
    //NSLog(@"MJL::::: emptyProfileAvatar  %i",self.view.tag);
    _isEmptyProfile = YES;
    //[_avatarBtn setEnabled:NO];
}

-(void)setAccessibilityLabelWithIndex:(int)index
{
    _avatarBtn.accessibilityLabel = [@"Avatar_pos_" stringByAppendingString:[NSString stringWithFormat:@"%i", index]];
    _closeBtn.accessibilityLabel = [@"Delete_avatar_pos_" stringByAppendingString:[NSString stringWithFormat:@"%i", index]];
}

-(BOOL)checkIsEmptyProfile
{
    return !_userProfile.isKnownUser;
}

-(void)onAvatarHeldDown:(UILongPressGestureRecognizer *)gesture
{
    // NOTE: Must be !_isEmptyProfile because only profiles can be removed
   
    _isEmptyProfile = [self checkIsEmptyProfile];
    
    if(!_isEmptyProfile)
    {
        [_avatarBtn removeGestureRecognizer:_longpressGesture];
        [_delegate performShake];
    }
}


#pragma mark Hide/Show Delete
-(void)showDelete
{
    [_closeBtn setHidden:NO];
    [_closeBtn setAlpha:0.0];
    [UIView animateWithDuration:0.3 animations:^(void){
        [_closeBtn setAlpha:1.0];
    }];
}
-(void)hideDelete
{
    [UIView animateWithDuration:0.3 animations:^(void){
        [_closeBtn setAlpha:0.0];
    }completion:^(BOOL finised){
        
        [_closeBtn setHidden:YES];
    }];
}

#pragma mark shake animation

-(void)shake
{
    
    _isEmptyProfile = [self checkIsEmptyProfile];
    
    if(!_isEmptyProfile)
    {
        [self showDelete];
        [_avatarBtn setEnabled:NO];
        CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        [anim setToValue:[NSNumber numberWithFloat:0.0f]];
        [anim setFromValue:[NSNumber numberWithDouble:M_PI/32]]; // rotation angle
        [anim setDuration:0.1];
        [anim setRepeatCount:NSUIntegerMax];
        [anim setAutoreverses:YES];
        [self.view.layer addAnimation:anim forKey:@"jiggy"];
    }
}

-(void)stopShake
{
    [self.view.layer removeAnimationForKey:@"jiggy"];
    [self hideDelete];
    [_avatarBtn setEnabled:YES];
    
    [_avatarBtn addGestureRecognizer:_longpressGesture];
}
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    //NSLog(@"animationDidStop!!!! %@",theAnimation.description);
}


@end
