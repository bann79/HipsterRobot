//
//  PlanAheadViewController.h
//  MyspaceTVCompanion
//
//  Created by Michael Lewis on 01/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionRingView.h"
#import "AppViewProtocol.h"

#import "GridView.h"
#import "PlanAheadEpgCell.h"
#import "PlanAheadEpgModel.h"
#import "LazyLoadImageView.h"
#import "InfoObject.h"
#import "InfoPageViewController.h"

@interface PlanAheadEpgViewController : UIViewController<AppViewProtocol,PlanAheadEpgDelegate,
                        GridViewMotionDelegate, GridViewDataDelegate, ArcListDelegate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, InfoPageDelegate>


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) IBOutlet GridView *gridView;
@property (weak, nonatomic) IBOutlet GridView *topTimeline;
@property (weak, nonatomic) IBOutlet GridView *bottomTimeline;
@property (weak,nonatomic) IBOutlet UIView *progressIndicator;

@property (nonatomic) IBOutlet ActionRingView *actionRing;

@property (nonatomic) IBOutlet UIView *daySelector;
@property (nonatomic) IBOutlet UILabel *dayIndicator;
@property (nonatomic) IBOutlet UILabel *dateIndicator;

@property (weak, nonatomic) IBOutlet UIPickerView *dayPickerView;
@property (strong, nonatomic) UITapGestureRecognizer *tapDayPickerGesture;
@property int selectedRow;

@property (strong, nonatomic) NSTimer *timelineTimer;

-(IBAction)swipeActionRingOut:(UISwipeGestureRecognizer*) recognizer;
-(IBAction)swipeActionRingIn:(UISwipeGestureRecognizer*) recognizer;

@property UISwipeGestureRecognizer * swipeRightGesture;
@property UISwipeGestureRecognizer * swipeLeftGesture;

@property (strong, nonatomic) InfoPageViewController * modalInfoPage;

@property PlanAheadEpgModel *model;

-(void)updateProgressIndicator;

//Date selector logic
-(void)updateDaySelectorTime;
-(IBAction)pressedDaySelector:(UIButton *)sender;
-(void)pickerTapped:(UIGestureRecognizer *)gestureRecognizer;

-(void)updateTimelineTimerFired:(NSTimer*)t;

//PlanAheadEpgDelegate
-(void) onEpgModelInitialised;
-(void) onSelectedProgramChangedTo: (Programme*)program;

//GridViewMotionDelegate
-(void)gridView:(GridView*)gridView movedTo:(CGPoint)offset;
-(void)gridView:(GridView*)gridView stoppedMovingAt:(CGPoint)offset;

//ArcListDelegate
-(void)updateContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;
-(void)updateContentOffset:(CGPoint)contentOffset;
-(void)updateArcListContentOffset:(CGPoint)contentOffset;
-(void)movingUpdateActionPanelPostion;

-(void)preTransitionIn;
-(void (^)(void))transitionInActionRingView;
-(void (^)(BOOL))transitionInActionRing;

@end
