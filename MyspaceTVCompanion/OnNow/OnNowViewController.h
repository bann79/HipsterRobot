//
//  OnNowViewController.h
//  MyspaceTVCompanion
//
//  Created by Bann Al-Jelawi on 01/06/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppViewProtocol.h"
#import "ActionRingView.h"
#import "LazyLoadImageView.h"
#import "OnNowTableViewService.h"
#import "ArcTableView.h"

#import "LostConnectionIndicatorViewController.h"


@class OnNowReusableTableViewCell;
#import "InfoPageViewController.h"

@interface OnNowViewController : UIViewController <AppViewProtocol, OnNowTableViewDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, ArcListDelegate>
{
    BOOL isScrollingFromArcList;
    BOOL hasAnimatedIn;
    BOOL actionRingActiveBool;
}

@property (strong, nonatomic) IBOutlet ActionRingView * actionRing;
@property (weak, nonatomic) IBOutlet ArcTableView *tableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSArray *channelData;
@property (strong, nonatomic) NSArray *programData;
@property (strong, nonatomic) NSArray *extroInfoData;

@property (strong, nonatomic) OnNowTableViewService *dataService;
@property (strong, nonatomic) InfoPageViewController * modalInfoPage;

@property (weak, nonatomic) IBOutlet UIImageView *dayViewIndicator;
@property (weak, nonatomic) IBOutlet UILabel *dayLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;


#pragma mark Actions
-(IBAction)watchButtonClicked:(UIButton *)sender;
-(IBAction)swipeActionRingOut:(UISwipeGestureRecognizer *)recognizer;
-(IBAction)swipeActionRingIn:(UISwipeGestureRecognizer *)recognizer;

#pragma mark ArcListDelegate
-(void)updateContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;
-(void)updateContentOffset:(CGPoint)contentOffset;
-(void)updateArcListContentOffset:(CGPoint)contentOffset;
-(void)movingUpdateActionPanelPostion;

-(void)preTransitionIn;
-(void (^)(void))transitionInActionRingView;
-(void (^)(BOOL))transitionInActionRing;

@property CGPoint fingerPosInApp;

@end
