//
//  BasicUserProfileAvatarViewController.m
//  MyspaceTVCompanion
//
//  Created by Dyfan Hughes on 27/07/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//

#import "BasicUserProfileAvatarViewController.h"

@interface BasicUserProfileAvatarViewController ()


@end

@implementation BasicUserProfileAvatarViewController

@synthesize avatarImg = _avatarImg;
@synthesize avatarContainer = _avatarContainer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setup
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setAvatarContainer:nil];
    [self setAvatarImg:nil];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)loadAvatar:(NSString *)url withContentMode:(UIViewContentMode)contentMode
{
    [_avatarImg lazyLoadImageFromURLString:url contentMode:contentMode];
    
    [ImageUtils setRoundedView:_avatarContainer toDiameter:75.0];
}


@end
