//
//  LoginViewController.m
//  MyspaceTVCompanion
//
//  Created by scott on 16/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "AppViewController.h"
#import "AppDelegate.h"
#import "UserProfilesManager.h"
#import "UserProfileSelectionViewController.h"
#import <QuartzCore/QuartzCore.h>


#import "DeviceId.h"

@implementation LoginViewController
{
    void (^transitionOutCB)();
    id authDelegate;
    float closeFailPromptDelay;
}
@synthesize knownUsernameLabel = _knownUsernameLabel;
@synthesize loginButton = _loginButton;
@synthesize backButton = _backButton;
@synthesize avatar = _avatar;
@synthesize elementsHolderView = _elementsHolderView;
@synthesize centerLoginView = _centerLoginView;
@synthesize centreCircle = _centreCircle;
@synthesize loadIndicator = _loadIndicator;
@synthesize backgroundCentreCircle = _backgroundCentreCircle;
@synthesize knownAvatar = _knownAvatar;
@synthesize backgroundGrad = _backgroundGrad;
@synthesize cancelFailPromptBtn = _cancelFailPromptBtn;
@synthesize centerRing = _centerRing;
@synthesize middleRing = _middleRing;
@synthesize outerRing = _outerRing;
@synthesize rings = _rings;
@synthesize sourceView = _sourceView;

@synthesize userLoginCredentials = _userLoginCredentials;
@synthesize knownUser = _knownUser;
@synthesize userAvatar = _userAvatar;
@synthesize username= _username, password = _password;
@synthesize isKnownUser = _isKnownUser;
@synthesize userDidPressReturnOnKeyboard = _userDidPressReturnOnKeyboard;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //NSLog(@"initWithNibName :self.userDidPressReturnOnKeyboard : %i ",self.userDidPressReturnOnKeyboard);
    }
    return self;
}

#pragma mark View lifecycle


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self viewSetup];
    [self transitionIn];
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"viewDidDisappear");
    [self cleanup];
    [super viewDidDisappear:animated];
}
-(void)cleanup
{
    
    [self.loginButton.layer removeAllAnimations];
    [self.backButton.layer removeAllAnimations];
    [self.userAvatar.view.layer removeAllAnimations];
    [self.userAvatar removeProfile];
    [self.userAvatar.view removeFromSuperview];
    
    [self setUsername:nil];
    [self setPassword:nil];
    [self setRings:nil];
    [self setKnownUser:nil];
    
    [self setUserAvatar:nil];
    [self setCenterRing:nil];
    [self setMiddleRing:nil];
    [self setOuterRing:nil];
    [self setKnownAvatar:nil];
    [self setCenterLoginView:nil];
    [self setBackgroundGrad:nil];
    [self setLoginButton:nil];
    [self setAvatar:nil];
    [self setKnownUsernameLabel:nil];
    [self setBackButton:nil];
    [self setElementsHolderView:nil];
    [self setCentreCircle:nil];
    [self setLoadIndicator:nil];
    [self setUserLoginCredentials:nil];
    [self setSourceView:nil];
    [self setBackgroundCentreCircle:nil];
    [self setCancelFailPromptBtn:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewSetup
{
    self.userLoginCredentials = [[Credential alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.sourceView = [[self getAppViewController] getSourceView];
    [self.password setDelegate:self];
    [self.username setDelegate:self];
    
    self.rings = [NSArray arrayWithObjects:self.centerLoginView,self.centerRing, self.middleRing, self.outerRing, nil];
    for (UIView *ring in self.rings) {
        ring.transform = CGAffineTransformMakeScale(0.5, 0.5);
        ring.alpha = 0;
    }
    [self.avatar setAlpha:0.0];
    [self.loginButton setAlpha:0.0];
    [self.backButton setAlpha:0.0];
    [self.userAvatar.view setAlpha:0];
    [self.knownUsernameLabel setHidden:YES];
    self.knownUsernameLabel.accessibilityLabel = @"knownUser";
    [self.centreCircle setAlpha:1];
    [self.loadIndicator setHidden:YES];
    [self.loadIndicator setAlpha:0];
    //NSLog(@"sourceVIEW %@", self.sourceView);
    
    if(self.isKnownUser)
    {
        [self.knownUsernameLabel setHidden:NO];
        [self.username setHidden:YES];
        [self.knownUsernameLabel setText:self.knownUser.name];
        [self.userAvatar.view setFrame:CGRectMake(self.avatar.frame.origin.x, self.avatar.frame.origin.y, self.userAvatar.view.frame.size.width, self.userAvatar.view.frame.size.height)];
        [self.userAvatar setUserProfile:self.knownUser];
        [self.userAvatar loadAvatar:self.knownUser.avatarURL withContentMode:UIViewContentModeScaleAspectFill];
        [self.centreCircle setImage:[UIImage imageNamed:@"login-known-password-details"]];
    }
    else{
        [self.knownUsernameLabel setHidden:YES];
        [self.username setHidden:NO];
        [self.userAvatar.view setFrame:CGRectMake(self.avatar.frame.origin.x, self.avatar.frame.origin.y, self.userAvatar.view.frame.size.width, self.userAvatar.view.frame.size.height)];
        
        [self.userAvatar.avatarImg setImage:[UIImage imageNamed:@"login-blank-user-holder"]];
        [self.centreCircle setImage:[UIImage imageNamed:@"login-user-password-details"]];
    }
    [self.elementsHolderView addSubview:self.userAvatar.view];
}

-(void)transitionIn
{
    
    [self animateInRings];
}

-(void)animateInRings
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.centerLoginView.alpha = 1;
        self.centerLoginView.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.centerRing.alpha = 1;
        self.centerRing.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finsiehd){
        [self animateInOptions:@"avatarOption"];
    }];
    
    [UIView animateWithDuration:0.5 delay:0.4 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.middleRing.alpha = 1;
        self.middleRing.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finsiehd){
        [self animateInOptions:@"loginOption"];
        [self animateInOptions:@"backOption"];
    }];
    
    [UIView animateWithDuration:0.5 delay:0.6 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.outerRing.alpha = 1;
        self.outerRing.transform = CGAffineTransformIdentity;
    } completion:nil];
}

-(void)animateInOptions:(NSString*) optionType
{
    UIView * avatarImg = ((UIViewController*)self.userAvatar).view;
    
    // Set up fade in
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeInAnimation setToValue:[NSNumber numberWithFloat:1.0]];
    fadeInAnimation.fillMode = kCAFillModeForwards;
    fadeInAnimation.removedOnCompletion = NO;
    
    // Set up path movement
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;

    CGMutablePathRef curvedPath = CGPathCreateMutable();
    float start_radians;
    float end_radians;
    
    if([optionType isEqualToString:@"avatarOption"])
    {
        start_radians = M_PI*3/2;
        end_radians = M_PI;
        
        CGPathAddArc(curvedPath, nil, self.centerRing.center.x, self.centerRing.center.y, 200, start_radians, end_radians,YES);
    }
    
    else if([optionType isEqualToString:@"loginOption"])
    {
        start_radians = M_PI*3/2;
        end_radians = 0;
        
        CGPathAddArc(curvedPath, nil, self.middleRing.center.x, self.middleRing.center.y, 400, start_radians, end_radians, NO);
    }
    
    else if([optionType isEqualToString:@"backOption"])
    {
        start_radians = M_PI*3/2;
        end_radians = M_PI;
        
        CGPathAddArc(curvedPath, nil, self.middleRing.center.x, self.middleRing.center.y, 405, start_radians, end_radians, YES);
    }
    
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setAnimations:[NSArray arrayWithObjects:fadeInAnimation, pathAnimation, nil]];
    group.duration = 0.3f;
    group.delegate = self;
    if([optionType isEqualToString:@"avatarOption"])
    {
        [group setValue:@"animationInAvatarBtn" forKey:@"id"];
        [avatarImg.layer addAnimation:group forKey:@"animationInAvatarBtn"];
    }
    else if([optionType isEqualToString:@"loginOption"])
    {
        [group setValue:@"animationInLoginBtn" forKey:@"id"];
        [self.loginButton.layer addAnimation:group forKey:@"animationInLoginBtn"];
    }
    else if([optionType isEqualToString:@"backOption"])
    {
        [group setValue:@"animationInBackBtn" forKey:@"id"];
        [self.backButton.layer addAnimation:group forKey:@"animationInBackBtn"];
    }
}

-(void)transitionOut:(void (^)())callback
{
    transitionOutCB = callback;
    
    if([self.username isFirstResponder])
    {
        [self.username resignFirstResponder];
    }else if([self.password isFirstResponder])
    {
        [self.password resignFirstResponder];
    }
    
    [self animateOptionsOut:@"avatarOption"];
    [self animateOptionsOut:@"loginOption"];
    [self animateOptionsOut:@"backOption"];
}

-(void)animateOptionsOut:(NSString*) optionType
{
    UIView * avatarImg = ((UIViewController*)self.userAvatar).view;
    
    // Set up fade in
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeInAnimation setToValue:[NSNumber numberWithFloat:0]];
    fadeInAnimation.fillMode = kCAFillModeForwards;
    fadeInAnimation.removedOnCompletion = NO;
    
    // Set up path movement
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    float avatar_start_radians = M_PI;
    float avatar_end_radians = M_PI*3/2;
    float login_start_radians = 0;
    float login_end_radians = M_PI*3/2;
    
    if([optionType isEqualToString:@"avatarOption"])
    {
        CGPathAddArc(curvedPath, nil, self.centerRing.center.x, self.centerRing.center.y, 180, avatar_start_radians, avatar_end_radians,NO);
    }
    
    else if([optionType isEqualToString:@"loginOption"])
    {
        CGPathAddArc(curvedPath, nil, self.middleRing.center.x, self.middleRing.center.y, 400, login_start_radians, login_end_radians, YES);
    }
    
    else if([optionType isEqualToString:@"backOption"])
    {
        CGPathAddArc(curvedPath, nil, self.middleRing.center.x, self.middleRing.center.y, 400, avatar_start_radians, avatar_end_radians, NO);
    }
    
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setAnimations:[NSArray arrayWithObjects:fadeInAnimation, pathAnimation, nil]];
    
    group.duration = 0.5f;
    group.delegate = self;
    
    if([optionType isEqualToString:@"avatarOption"])
    {
        [group setValue:@"animationOutAvatarBtn" forKey:@"id"];
        [avatarImg.layer addAnimation:group forKey:@"animationInOptionButtons"];
        //[group setValue:[NSNumber numberWithInt:self.avatarButton.tag] forKey:@"animationOutOptionButtons"];
    }
    else if([optionType isEqualToString:@"loginOption"])
    {
        [group setValue:@"animationOutLoginBtn" forKey:@"id"];
        [self.loginButton.layer addAnimation:group forKey:@"animationInOptionButtons"];
        //[group setValue:[NSNumber numberWithInt:self.loginButton.tag] forKey:@"animationOutOptionButtons"];
    }
    else if([optionType isEqualToString:@"backOption"])
    {
        [group setValue:@"animationOutbackBtn" forKey:@"id"];
        [self.backButton.layer addAnimation:group forKey:@"animationInOptionButtons"];
        //[group setValue:[NSNumber numberWithInt:self.loginButton.tag] forKey:@"animationOutOptionButtons"];
    }
}

-(void)animateOutRings
{
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
        self.centerLoginView.alpha = 0.0;
        self.centerLoginView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.backgroundGrad setAlpha:1.0];
        } completion:^(BOOL bgfinished){
            [UIView animateWithDuration:0.5 animations:^{
                [self.backgroundGrad setAlpha:0.0];
            } completion:^(BOOL bgFadeComplete){
                transitionOutCB();
            }];
        }];
    }];
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    
    if([[theAnimation valueForKey:@"id"] isEqual:@"animationInLoginBtn"])
    {
        [self.userAvatar.view setAlpha:1.0];
        [self.loginButton setAlpha:1.0];
        [self.backButton setAlpha:1.0];
    }
    
    
    if([[theAnimation valueForKey:@"id"] isEqual:@"animationOutAvatarBtn"])
    {
        [self.userAvatar.view setAlpha:0.0];
        [self.loginButton setAlpha:0.0];
        [self.backButton setAlpha:0.0];
        
        [self.loginButton.layer removeAllAnimations];
        [self.backButton.layer removeAllAnimations];
        [self.userAvatar.view.layer removeAllAnimations];
        [self animateOutRings];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark Actions

-(IBAction)loginButtonTapped:(id)sender
{
    //NSLog(@"MJL:::: loginButtonTapped: ");
    [self checkLoginFieldsUsing:self.username.text AndPassword:self.password.text];
}

-(void)checkLoginFieldsUsing:(NSString*) p_username AndPassword:(NSString *) p_password
{
    if(self.isKnownUser)
    {
        if(![p_password isEqualToString:@""])
        {
            //NSLog(@"both textFields contain text");
            [self prepareScreenForLogin];
        }
        
        else
        {
            //NSLog(@" username and/or password boxes are empty");
            [self doShakeOnLoginFields];
        }
    }
    
    else
    {
        if(![p_username isEqualToString:@""] && ![p_password isEqualToString:@""])
        {
            //NSLog(@"both textFields contain text");
            [self prepareScreenForLogin];
        }
        else {
            //NSLog(@" username and/or password boxes are empty");
            [self doShakeOnLoginFields];
        }
    }
    
}

-(void)prepareScreenForLogin
{
    [self.backButton setEnabled:NO];
    [self.loginButton setEnabled:NO];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         [self.knownUsernameLabel setAlpha:0];
                         [self.password setAlpha:0];
                         [self.username setAlpha:0];
                     }
                     completion:^(BOOL finished){
                         [self.loadIndicator setHidden:NO];
                         [self.centreCircle setImage:[UIImage imageNamed:@"login-user-login-in"]];
                     }];
    
    [UIView animateWithDuration:0.2
                          delay:0.4
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         [self.centreCircle setAlpha:1];
                         [self.loadIndicator setAlpha:1];
                     }
                     completion:^(BOOL finished){
                         [self.loadIndicator startAnimating];
                         if(self.isKnownUser)
                         {
                             [self wrapUpLoginDetailsInCredentialObjectUsing:self.knownUser.email And:self.password.text];
                         }
                         else
                         {
                             [self wrapUpLoginDetailsInCredentialObjectUsing:self.username.text And:self.password.text];
                         }
                     }];
}

-(IBAction)cancelButtonTapped:(id)sender
{
    [self.loginButton setEnabled:NO];
    [self.backButton setEnabled:NO];
    [self doCancel];
}

- (IBAction)onCancelFailPrompt:(id)sender {
    closeFailPromptDelay = 0.0;
    [self.cancelFailPromptBtn setHidden:YES];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onDismissLoginFail:) object:NULL];
    
    [self reloadLoginCentreCircleAfterFailedLogin];
    
}

#pragma mark Login

-(void)wrapUpLoginDetailsInCredentialObjectUsing:(NSString*) p_username And:(NSString*) p_password;
{
    self.userLoginCredentials.username = p_username;
    self.userLoginCredentials.password = p_password;
    self.userLoginCredentials.deviceId = [DeviceId deviceId];
    self.userLoginCredentials.snName = @"myspace";
    self.userLoginCredentials.rememberMe = YES;
    
    //NSLog(@"userlogincredentials %@ %@", self.userLoginCredentials.username, self.userLoginCredentials.password);
    
    [self authenticateUserLoginDetails];
}

-(void)authenticateUserLoginDetails
{
    [[AuthState sharedInstance] authenticate:self.userLoginCredentials withResponder:self];
}

-(void)doShakeOnLoginFields
{
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    [anim setToValue:[NSNumber numberWithFloat:5.0f]];
    [anim setFromValue:[NSNumber numberWithFloat:0.0f]];
    [anim setDuration:0.1];
    [anim setRepeatCount:3];
    [anim setAutoreverses:YES];
    [self.centerLoginView.layer addAnimation:anim forKey:@"incorrectJiggy"];
    //NSLog(@"ANIMATION HIT");
    [self clearLoginDetails];
}

-(void)loginSucceeded
{
    //NSLog(@"*** login succedded ***");
    
    if(self.sourceView)
    {
        [[self getAppViewController] setContentScreen:self.sourceView];
    }
    
    else
    {
        //NSLog(@"sourceview is empty!");
    }
}

-(void)doCancel
{
    if (self.sourceView) {
        [[self getAppViewController] setContentScreen:@"UserProfileSelectionViewController"];
    } else {
        //NSLog(@"*** Error -couldn't load user profile selection screen");
    }
}

-(BOOL)isGreedy
{
    return YES;
}

-(AppViewController *)getAppViewController
{
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController;
}


-(void)setUserProfile:(UserProfile *)userProfile
{
    self.userAvatar = [[UserProfileAvatarViewController alloc]
                   initWithNibName:@"UserProfileAvatarView" bundle:[NSBundle mainBundle]];
    
    self.knownUser = userProfile;
    self.isKnownUser = self.knownUser.isKnownUser;
}

-(void)animateInSuccessfulLogin
{
    [self.backgroundCentreCircle setImage:[UIImage imageNamed:@"login_successful"]];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         [self.knownUsernameLabel setAlpha:0];
                         [self.centreCircle setAlpha:0];
                         [self.loadIndicator setAlpha:0];
                     }
                     completion:^(BOOL finished){
                         [self.loadIndicator setHidden:YES];
                         [self.knownUsernameLabel setText:self.knownUser.name];
                         [self.loadIndicator stopAnimating];
                         [self performSelector:@selector(onDismissLoginSuccessful:) withObject:nil afterDelay:0];
                     }];
    
    
    
}

-(void)onDismissLoginSuccessful:(NSTimer *)timer
{
    [self loginSucceeded];
}

-(void)animateInFailedLoginUsingCode:(int) errorCode
{
    [self.cancelFailPromptBtn setHidden:NO];
    if(errorCode ==500)
    {
        [self.backgroundCentreCircle setImage:[UIImage imageNamed:@"login_failed"]];
    }
    else if (errorCode == 401)
    {
        [self.backgroundCentreCircle setImage:[UIImage imageNamed:@"login_failed"]];
    }
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         [self.knownUsernameLabel setAlpha:0];
                         [self.centreCircle setAlpha:0];
                         [self.loadIndicator setAlpha:0];
                     }
                     completion:^(BOOL finished){
                         [self.loadIndicator setHidden:YES];
                         [self.knownUsernameLabel setText:self.knownUser.name];
                         [self.loadIndicator stopAnimating];
                         [self performSelector:@selector(onDismissLoginFail:) withObject:nil afterDelay:1];
                     }];
}

-(void)onDismissLoginFail:(NSTimer *)timer
{
    if(self.isKnownUser)
    {
        closeFailPromptDelay = 5.3;
    }else{
        closeFailPromptDelay = 5.0;
    }
    
    [self reloadLoginCentreCircleAfterFailedLogin];
}

-(void)displayCorrectLoginMessageAccordingToErrorCode:(int) errorCode
                                    OrSuccessfulLogin:(BOOL) loginWorked
{
    if(loginWorked)
    {
        [self animateInSuccessfulLogin];
    }
    
    if(errorCode == 500)
    {
        [self animateInFailedLoginUsingCode:errorCode];
    }
    else if (errorCode == 401)
    {
        [self animateInFailedLoginUsingCode:errorCode];
    }
}

-(void)reloadLoginCentreCircleAfterFailedLogin
{
    
    if(self.isKnownUser)
    {
        [self.centreCircle setImage:[UIImage imageNamed:@"login-known-password-details"]];
        
        [UIView animateWithDuration:0.2
                              delay:closeFailPromptDelay
                            options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             [self.centreCircle setAlpha:1];
                             [self.knownUsernameLabel setAlpha:1];
                             [self.password setAlpha:1];
                         }
                         completion:^(BOOL finished){
                             [self.loginButton setEnabled:YES];
                             [self.backButton setEnabled:YES];
                             [self.cancelFailPromptBtn setHidden:YES];
                         }];}
    else {
        [self.centreCircle setImage:[UIImage imageNamed:@"login-user-password-details"]];
        
        [UIView animateWithDuration:0.3
                              delay:closeFailPromptDelay
                            options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             [self.centreCircle setAlpha:1];
                             [self.username setAlpha:1];
                             [self.password setAlpha:1];
                         }
                         completion:^(BOOL finished){
                             [self.loginButton setEnabled:YES];
                             [self.backButton setEnabled:YES];
                             [self.cancelFailPromptBtn setHidden:YES];
                         }];
    }
}

-(void)clearLoginDetails
{
    [self.password setText:@""];
    /*
     if(!self.isKnownUser)
     {
     [self.username setText:@""];
     }*/
    
}

-(void)keyboardDidShow:(NSNotification*) notification
{
    self.userDidPressReturnOnKeyboard = NO;
    //NSLog(@"keyboard showing");
    CGRect rect = CGRectMake(0,-160, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.elementsHolderView.frame = rect;
    }];
}

-(void)keyboardDidHide:(NSNotification*) notification
{
    //NSLog(@"keyboard hidden ::: self.userDidPressReturnOnKeyboard: %i",self.userDidPressReturnOnKeyboard);
    if((!self.userDidPressReturnOnKeyboard) || ([self.password isFirstResponder]))
    {
        if(([self.username isFirstResponder] && self.userDidPressReturnOnKeyboard == NO) || [self.password isFirstResponder] )
        {
            [self animateScreenBackAfterkeyboardDidHide];
        }
    }
}

-(void)animateScreenBackAfterkeyboardDidHide
{
    CGRect rect = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.elementsHolderView.frame = rect;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.userDidPressReturnOnKeyboard = YES;
    //NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    
    if([textField isEqual:self.username])
    {
        [self.password becomeFirstResponder];
    }
    
    else if([textField isEqual:self.password])
    {
        [self prepareScreenForLogin];
    }
    return NO;
}

#pragma mark AuthStateDelegate Protocol

- (void)onSuccess:(UserProfile *)userProfile {
    UserProfile * tempUP = userProfile;
    [tempUP setProfileSelectionPositionIndex:self.knownUser.profileSelectionPositionIndex];
   // [tempUP setAvatarURL: @"http://placehold.it/150x150"];
    [tempUP setIsKnownUser:YES];
    [[UserProfilesManager sharedSingleton] saveCurrentUserProfile:tempUP];
    
    [self displayCorrectLoginMessageAccordingToErrorCode:0 OrSuccessfulLogin:YES];
}

- (void)onFailure:(NSError *)authError {
    
    int errorCode = authError.code;
    
    //NSLog(@"incorrect Login");
    [self.loginButton setEnabled:YES];
    [self.backButton setEnabled:YES];
    
    [self displayCorrectLoginMessageAccordingToErrorCode:errorCode OrSuccessfulLogin:NO];
    
    [self performSelectorOnMainThread:@selector(clearLoginDetails) withObject:nil waitUntilDone:YES];
}

-(void)onSuccessfulLogout {
}

@end
