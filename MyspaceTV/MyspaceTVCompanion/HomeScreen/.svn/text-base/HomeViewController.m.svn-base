//
//  HomeViewController.m
//  MyspaceTVCompanion
//
//  Created by Michael Lewis on 01/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "AppViewController.h"
#import "HomeSummaryPopulator.h"
#import "SubMenuDataDelegate.h"
#import "OnNowDataIterator.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface HomeViewController ()
@property (strong, nonatomic) NSMutableArray *leftBtns;
@property (strong, nonatomic) NSMutableArray *rightBtns;
@property (strong, nonatomic) NSMutableArray *btns;
@property (strong, nonatomic) NSMutableArray *btnAngleOnArc;
@property (strong, nonatomic) NSMutableArray *btnPosition;
@property (strong, nonatomic) NSArray *rings;

@end

@implementation HomeViewController
{
void (^transitionOutCB)();
@private
    HomeSummaryPopulator *_planAheadPopulator;
    PlanAheadDataIterator *planAheadIterator;
    SubMenuDataDelegate *planAheadDelegate;

    HomeSummaryPopulator *_onNowPopulator;
    OnNowDataIterator *onNowIterator;
    SubMenuDataDelegate *onNowDelegate;
}

@synthesize authState, avatarRing, avatarRingBG, centerRing, middleRing, outerRing;
@synthesize recommendBtn;
@synthesize alertsBtn;
@synthesize onNowBtn;
@synthesize peopleBtn;
@synthesize planAheadBtn;
@synthesize watchBtn;
@synthesize onNowSubMenu;
@synthesize planAheadSubMenu;

@synthesize leftBtns, rightBtns, btns, btnAngleOnArc, btnPosition, rings;

@synthesize planAheadPopulator = _planAheadPopulator;
@synthesize planAheadIterator;
@synthesize planAheadDelegate;
@synthesize onNowPopulator = _onNowPopulator;
@synthesize onNowIterator;
@synthesize onNowDelegate;

@synthesize infoPanel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.planAheadPopulator = [[HomeSummaryPopulator alloc] init];
        planAheadIterator = [[PlanAheadDataIterator alloc] init];
        planAheadDelegate = [[SubMenuDataDelegate alloc] init];

        self.onNowPopulator = [[HomeSummaryPopulator alloc] init];

        onNowIterator = [[OnNowDataIterator alloc] init];
        onNowDelegate = [[SubMenuDataDelegate alloc] init];
        
        
        btnAngleOnArc = [NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:(M_PI*5/4)], [NSNumber numberWithFloat:(M_PI)], [NSNumber numberWithFloat:(M_PI*3/4)], [NSNumber numberWithFloat:(M_PI/4)], [NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:(M_PI*7/4)],  nil];
    }
    return self;
}

#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [planAheadDelegate prepare:self.planAheadSubMenu];
    [self.planAheadPopulator prepareWithIterator:planAheadIterator andDelegate:planAheadDelegate];

    [onNowDelegate prepare:self.onNowSubMenu];
    [self.onNowPopulator prepareWithIterator:onNowIterator andDelegate:onNowDelegate];
    
    self.onNowSubMenu.isInsideTextAlignLeft = YES;
    self.planAheadSubMenu.isInsideTextAlignLeft = NO;

    leftBtns = [NSMutableArray arrayWithObjects:self.recommendBtn, self.onNowBtn, self.watchBtn, nil];
    rightBtns = [NSMutableArray arrayWithObjects:self.peopleBtn, self.planAheadBtn, self.alertsBtn, nil];
    
    btns = [NSMutableArray arrayWithObjects:self.recommendBtn, self.onNowBtn, self.watchBtn, self.alertsBtn, self.planAheadBtn, self.peopleBtn, nil];
    rings = [NSArray arrayWithObjects:self.avatarRingBG, self.centerRing, self.middleRing, self.outerRing, nil];
}

-(void)viewWillAppear:(BOOL)animated 
{
    //[[self getAppViewController] disableHomeButton];
    
    [self setAuthState:[AuthState sharedInstance]];
    [super viewWillAppear:animated];
    
    for (UIButton *btn in btns) {
        btn.alpha = 0.0f;
        btn.userInteractionEnabled = NO;
        btn.enabled = NO;
        
        NSValue *pointValue = [NSValue valueWithCGPoint:btn.layer.frame.origin];
        [btnPosition addObject:pointValue];
    }
    
    
    for (UIView *ring in self.rings) {
        ring.transform = CGAffineTransformMakeScale(0.5, 0.5);
        ring.alpha = 0;
    }
    
    self.onNowBtn.userInteractionEnabled = self.onNowBtn.enabled = YES;
    self.planAheadBtn.userInteractionEnabled = self.planAheadBtn.enabled = YES;
    avatarRing.alpha = 0;

    onNowSubMenu.alpha = 0;
    planAheadSubMenu.alpha = 0;
}

-(void)viewDidAppear:(BOOL)animated 
{
    //disable all option buttons
    //[self setUserInteractionEnabledForOptionButtons:NO];
    [super viewDidAppear:animated];
       
    [self.avatarRing setDefaultImage:[UIImage imageNamed:GHOST_AVATAR_IMAGE]];  //set default ready so not blank when lazy loading
    self.avatarRing.userInteractionEnabled = FALSE;
    [self doCheckToSeeIfUserLoggedIn];
    
    [self transitionIn];

    [self.planAheadPopulator start];
    [self.onNowPopulator start];
}

-(void)doCheckToSeeIfUserLoggedIn
{
    if (self.authState.isLoggedIn)
    {
        NSLog(@">>> home logged in");
        
        NSString *urlStr;
        
        if(self.authState.currentUser.avatarURL != nil)
        {
            urlStr = self.authState.currentUser.avatarURL;
        }
        else
        {
            urlStr = GHOST_AVATAR_IMAGE;
        }
        [self.avatarRing loadImage:urlStr];
        [self.avatarRing setBorderSize:4];
    }
    else
    {
        NSLog(@"<<< home not logged in");
        [self.avatarRing loadImage:GHOST_AVATAR_IMAGE];
        [self.avatarRing setBorderSize:4];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    // Remove animation references from the button layers, stops delegate (self) being retained
    for (UIButton *btn in self.btns) {
        [btn.layer removeAllAnimations];
    }
    
    [self.planAheadPopulator stop];
    [self.onNowPopulator stop];

    [self setAvatarRing:nil];
    [self setAvatarRingBG:nil];
    [self setCenterRing:nil];
    [self setMiddleRing:nil];
    [self setOuterRing:nil];
    [self setRecommendBtn:nil];
    [self setAlertsBtn:nil];
    [self setOnNowBtn:nil];
    [self setPeopleBtn:nil];
    [self setPlanAheadBtn:nil];
    [self setWatchBtn:nil];
    [self setOnNowSubMenu:nil];
    [self setPlanAheadSubMenu:nil];
    
    [self setLeftBtns:nil];
    [self setRightBtns:nil];
    [self setBtns:nil];
    [self setRings:nil];
    
    [super viewDidDisappear:animated];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark handle touch events

- (IBAction)onOptionTouched:(UIButton *)sender {
    [sender setEnabled:NO];
    switch ([sender tag]) {
        case 1:
            [[self getAppViewController] setContentScreen:@"OnNowViewController"];
            break;
        case 4:
            [[self getAppViewController] setContentScreen:@"PlanAheadEpgViewController"];
            break;
        default:
            break;
    }
    
}

- (IBAction)onSubMenuItemTouchedInside:(UIButton *)sender
{
    if ([HomeSubMenuItemView getPressedButton] == sender)
    {
        HomeSubMenuItemView *item = (HomeSubMenuItemView *)sender.superview;
        infoPanel = [[InfoPageViewController alloc] initWithNibName:@"InfoPageView" bundle:[NSBundle mainBundle]];
        
        [infoPanel setTypeOfInfoPanel:INFO_IN_NORMAL_MODE];
        [infoPanel setCurrentChannel:item.currentData.channel];
        [infoPanel setCurrentProgram:item.currentData.program];
        [infoPanel setInfoPageDelegate:self];
        
        [self.view addSubview:infoPanel.view];
        [self.infoPanel transitionIn];
    }
}

# pragma mark InfoPageDelegate

-(void)infoPageClosed {
    [self.infoPanel.view removeFromSuperview];
    [self setInfoPanel:nil];
}

#pragma mark AppViewProtocol

-(void)transitionIn
{
    [self animateInRings];
}

-(void)animateInRings
{
    avatarRing.alpha = 0.0;
    avatarRingBG.alpha = 0.0;
    centerRing.alpha = 0.0;
    middleRing.alpha = 0.0;
    outerRing.alpha = 0.0;
    
    avatarRing.transform = CGAffineTransformMakeScale(0.5, 0.5);
    avatarRingBG.transform = CGAffineTransformMakeScale(0.5, 0.5);
    centerRing.transform = CGAffineTransformMakeScale(0.5, 0.5);
    middleRing.transform = CGAffineTransformMakeScale(0.5, 0.5);
    outerRing.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        avatarRingBG.alpha = 1.0;
        //avatarRingBG.transform = CGAffineTransformIdentity;
        avatarRingBG.transform = CGAffineTransformMakeScale(1.0, 1.0);
        avatarRing.alpha = 1.0;
        avatarRing.transform = CGAffineTransformMakeScale(1.0, 1.0);
        //avatarRing.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        centerRing.alpha = 1.0;
        centerRing.transform = CGAffineTransformMakeScale(1.0, 1.0);
        //centerRing.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        for(int j=0; j<btns.count; j++)
        {
            [self animateInOptionButtons:j];
        }
    }];
    
    [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        middleRing.alpha = 1.0;
        middleRing.transform = CGAffineTransformMakeScale(1.0, 1.0);
       // middleRing.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        outerRing.alpha = 1.0;
        outerRing.transform = CGAffineTransformMakeScale(1.0, 1.0);
        //outerRing.transform = CGAffineTransformIdentity;
    } completion:nil];
}   

-(void)animateInOptionButtons:(int)index
{
    UIButton *btn = (UIButton*) [btns objectAtIndex:index];
    
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
    if(index == (btns.count - 1))
    {
        //point to last button.
        start_radians = M_PI*3/2;
        
    }else if(index == 2){
        start_radians = M_PI/2;
        
    }else {
        start_radians = [[btnAngleOnArc objectAtIndex:(index + 1)] floatValue];
        
    }
    /*
    float end_radians = [[btnAngleOnArc objectAtIndex:index] floatValue];
    CGPathAddArc(curvedPath, nil, self.avatarRing.center.x, self.avatarRing.center.y, OPTION_RING_RADIUS, start_radians, end_radians, NO);
    */
    CGPathAddRelativeArc(curvedPath, nil, self.avatarRing.center.x, self.avatarRing.center.y, OPTION_RING_RADIUS, start_radians, M_PI/4);
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
   
    UIButton *btn = (UIButton*) [btns objectAtIndex:index];
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    float start_radians = [[btnAngleOnArc objectAtIndex:index] floatValue];
    float end_radians;
    if(index == (btns.count - 1))
    {
        //point to last button.
        end_radians = M_PI*3/2;
        
    }else if(index == 2){
        end_radians = M_PI/2;
        
    }else {
        end_radians = [[btnAngleOnArc objectAtIndex:(index + 1)] floatValue];
        
    }
    
    CGPathAddRelativeArc(curvedPath, nil, self.avatarRing.center.x, self.avatarRing.center.y, OPTION_RING_RADIUS, start_radians, -M_PI/4);
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

-(void)animateOutRings
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        outerRing.alpha = 0.0;
        outerRing.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:nil];
    
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        middleRing.alpha = 0.0;
        middleRing.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:nil];
    
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        centerRing.alpha = 0.0;
        centerRing.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:nil];
    
    
    [UIView animateWithDuration:0.2 delay:0.3 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        avatarRingBG.alpha = 0.0;
        avatarRingBG.transform = CGAffineTransformMakeScale(0.5, 0.5);
        avatarRing.alpha = 0.0;
        avatarRing.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished) {transitionOutCB();}];
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
        
        if(nextIndex == btns.count)
        {
            for (UIButton *btn in btns) {
                btn.alpha = 1;
            }
            
            //animate all buttons.
            [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                planAheadSubMenu.alpha = 1;
                onNowSubMenu.alpha = 1;
            
            } completion:^(BOOL finished) {
                //[self setUserInteractionEnabledForOptionButtons:YES];
            }];
        }
    }else{
        tag = [theAnimation valueForKey:@"animationOutOptionButtons"];
        
        if (tag) {
            int next = tag.intValue + 1;
            if (next == btns.count) 
            {
                [self animateOutRings];
            }
        }
    }
}

-(AppViewController *)getAppViewController
{    
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController;
}

-(void) setUserInteractionEnabledForOptionButtons:(BOOL)_enable
{
    for (UIView *btn in btns) {
        [btn setUserInteractionEnabled:_enable];
    }
}

-(void)transitionOut:(void (^)())callback
{
    if (infoPanel.view.superview) {
        [infoPanel transitionOut];
    }
    
    [UIView animateWithDuration:0.5
                     animations:^
                                {
                                    onNowSubMenu.alpha = 0;
                                    planAheadSubMenu.alpha = 0; 
                                }
                     completion:^(BOOL finished)
                                {                                    
                                    transitionOutCB = callback;
                                    for(int i=0; i<btns.count; i++)
                                    {
                                        [self animateOutOptionButtons:i];
                                    }
                                }];
}

-(BOOL)isGreedy
{
    return NO;
}

@end
