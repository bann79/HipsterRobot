//
//  HomeSubMenuItem.m
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 01/06/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import "HomeSubMenuItemView.h"
#import "ScheduleItem.h"

@implementation HomeSubMenuItemView
{
@private
    __weak UIActivityIndicatorView *_activityIndicator;
}

static UIButton* pressedBtn = nil;

@synthesize thumbnailBtn;
@synthesize headingLbl;
@synthesize subHeadingLbl;
@synthesize activityIndicator = _activityIndicator;
@synthesize isAlignLeft;

@synthesize currentImageIndex;
@synthesize currentData;

-(void)awakeFromNib
{
    // Initialization code
    currentData = nil;
    [self setUserInteractionEnabled:NO];
    self.thumbnailBtn.defaultImage = [UIImage imageNamed:@"on-now-image-preloader"];
}

- (void)populate:(ScheduleItem *)data
{
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alpha = 1;
        } completion:^(BOOL _finished) {
            [self __populate:data];
        }];
    }];
}

-(void) __populate:(ScheduleItem *)data
{
    currentData = data;
    
    if(currentData == Nil)
    {
        [self setUserInteractionEnabled:NO];
    }
    else
    {
        [self setUserInteractionEnabled:YES];
    }
    
    [self.activityIndicator stopAnimating];
    [self.activityIndicator setUserInteractionEnabled:NO];
    [self.activityIndicator setHidden:YES];
    
    if (self.isAlignLeft) {
        [self.headingLbl setTextAlignment:UITextAlignmentLeft];
        [self.subHeadingLbl setTextAlignment:UITextAlignmentLeft];
    }else {
        [self.headingLbl setTextAlignment:UITextAlignmentRight];
        [self.subHeadingLbl setTextAlignment:UITextAlignmentRight];
    }
    
    [self.headingLbl setText:data.heading];
    [self.headingLbl setFont:[UIFont boldSystemFontOfSize:15]];
    
    [self.subHeadingLbl setText:data.subHeading];
    [self.subHeadingLbl setFont:[UIFont systemFontOfSize:12]];
    

    [self.thumbnailBtn setBorderSize:6];
    [self.thumbnailBtn loadImage:data.thumbnailUrl];
}

- (void)setWaiting
{
    [self.activityIndicator startAnimating];
}


#pragma mark handle button touch events.
- (IBAction)onSubMenuTouchDown:(UIButton *)sender
{
    if ([HomeSubMenuItemView getPressedButton] == nil)
    {
        [HomeSubMenuItemView setPressedButton:sender];
        
        [self.subHeadingLbl setTextColor:[UIColor grayColor]];
        [self.headingLbl setTextColor:[UIColor grayColor]];
    
        [self.thumbnailBtn setHighlighted:YES];
    }
}

- (IBAction)onSubMenuTouchUpInside:(UIButton *)sender
{
    if ([HomeSubMenuItemView getPressedButton] == sender)
    {
        [self.subHeadingLbl setTextColor:[UIColor whiteColor]];
        [self.headingLbl setTextColor:[UIColor whiteColor]];
        
        [self.thumbnailBtn setTintColor:[UIColor clearColor]];
        [self.thumbnailBtn setHighlighted:NO];
        
        [HomeSubMenuItemView setPressedButton:nil];
    }
}

- (IBAction)onSubMenuTouchDragOutside:(UIButton *)sender
{
    if ([HomeSubMenuItemView getPressedButton] == sender)
    {
        [self.subHeadingLbl setTextColor:[UIColor whiteColor]];
        [self.headingLbl setTextColor:[UIColor whiteColor]];
        
        [self.thumbnailBtn setHighlighted:NO];
        
        [HomeSubMenuItemView setPressedButton:nil];
    }
}
    
+(UIButton*)getPressedButton
{
    return pressedBtn;
}
    
+(void)setPressedButton:(UIButton *)button
{
    @synchronized(self)
    {
        pressedBtn = button;
    }
    
}
@end
