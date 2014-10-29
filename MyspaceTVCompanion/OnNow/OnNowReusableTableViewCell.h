//
//  OnNowReusableTableViewCell.h
//  MyspaceTVCompanion
//
//  Created by Bann Al-Jelawi on 06/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LazyLoadImageView.h"
#import "ProgramTimeConverter.h"

@class Programme;

@interface OnNowReusableTableViewCell : UITableViewCell 

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak ,nonatomic) IBOutlet LazyLoadImageView *image;

@property (weak, nonatomic) IBOutlet UIButton *watchButton;
@property (weak, nonatomic) IBOutlet UIView *watchingView;
@property (weak, nonatomic) IBOutlet UIScrollView *watchingViewFriends;
@property (weak, nonatomic) IBOutlet UILabel *watchCount;
@property (weak, nonatomic) IBOutlet UIView *selectionView;
@property (weak, nonatomic) IBOutlet UIImageView *progressIndicator;
@property (weak, nonatomic) IBOutlet UILabel * programStartAndEndTimes;
@property (weak, nonatomic) IBOutlet UILabel * timeRemaining;
@property (weak, nonatomic) IBOutlet UITextView *programDescription;
@property (weak, nonatomic) IBOutlet UIImageView* progressPointer;


@property (strong,nonatomic) Programme* program;
@property (nonatomic, strong)ProgramTimeConverter * timeConverter;

+(OnNowReusableTableViewCell*)cellView;

//When resuing reset any state first
-(void)reset;

//Watching 
-(void)showWatchingAvatars;
-(void)hideWatchingAvatars;

-(void)setWatchingFriends:(NSArray*)friends;


@end
