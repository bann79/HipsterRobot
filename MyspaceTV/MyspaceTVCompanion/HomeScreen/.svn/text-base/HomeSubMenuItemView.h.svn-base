//
//  HomeSubMenuItem.h
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 01/06/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoScrollLabel.h"
#import "CircularImageButton.h"

@class ScheduleItem;

@interface HomeSubMenuItemView : UIView

@property(weak,nonatomic) IBOutlet AutoScrollLabel *headingLbl;
@property(weak,nonatomic) IBOutlet AutoScrollLabel *subHeadingLbl;
@property(weak,nonatomic) IBOutlet CircularImageButton *thumbnailBtn;
@property(weak,nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


- (IBAction)onSubMenuTouchDown:(UIButton *)sender;
- (IBAction)onSubMenuTouchUpInside:(UIButton *)sender;
- (IBAction)onSubMenuTouchDragOutside:(UIButton *)sender;

@property BOOL isAlignLeft;
@property int currentImageIndex;
@property ScheduleItem *currentData;

- (void)populate:(ScheduleItem *)data;

- (void)setWaiting;

+(UIButton*)getPressedButton;

+(void)setPressedButton:(UIButton *)button;

@end
