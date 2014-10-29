//
//  PlanAheadViewController.m
//  MyspaceTVCompanion
//
//  Created by Michael Lewis on 01/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlanAheadEpgViewController.h"
#import "PlanAheadEpgCell.h"

#import "EpgTimelineRenderer.h"
#import "EpgTimelineCell.h"

#import "EpgProgramRenderer.h"
#import "AppDelegate.h"

#define ArcCenterX -165
#define ArcCenterY 320


static const int DAYS_PAST = 5;
static const int DAYS_FUTURE = 5;

@implementation PlanAheadEpgViewController

@synthesize activityIndicator;
@synthesize gridView;
@synthesize topTimeline;
@synthesize bottomTimeline;
@synthesize progressIndicator;
@synthesize actionRing;
@synthesize daySelector;
@synthesize dayIndicator;
@synthesize dateIndicator;
@synthesize swipeLeftGesture;
@synthesize swipeRightGesture;
@synthesize modalInfoPage;
@synthesize dayPickerView;
@synthesize tapDayPickerGesture;
@synthesize selectedRow;

@synthesize model, timelineTimer;


#pragma mark View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handleFriendsWatchNotifications:) 
                                                 name:FriendsListUpdatedNotification
                                               object:nil];
    
    [self.actionRing.arcScrollList setArcCenterX:ArcCenterX];
    [self.actionRing.arcScrollList setArcCenterY:ArcCenterY];
    [self.actionRing.arcScrollList setFrame:CGRectMake(0,0,self.actionRing.frame.size.width, self.actionRing.frame.size.height)];
    [self.actionRing.arcScrollList setDelegate:self];
    [self.actionRing.arcScrollList setArcDelegate:self];
    [self.actionRing.arcScrollList setScrollEnabled:YES];
    
    activityIndicator.hidesWhenStopped = YES;
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [activityIndicator startAnimating];
    
    [self preTransitionIn];

    swipeLeftGesture = [[UISwipeGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(swipeActionRingOut:)];
   
    [swipeLeftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.actionRing addGestureRecognizer:swipeLeftGesture];
    
    swipeRightGesture = [[UISwipeGestureRecognizer alloc]
                                                   initWithTarget:self 
                                                   action:@selector(swipeActionRingIn:)];
    
    [swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.actionRing addGestureRecognizer:swipeRightGesture];
    
    //[actionRing setNeedsDisplay]; 
    // Do any additional setup after loading the view from its nib.  
    

    model = [[PlanAheadEpgModel alloc] initWithDelegate:self];

    NSDate* startTime = [NSDate dateWithTimeIntervalSinceNow: -24 * 3600 * DAYS_PAST];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];   
    NSDateComponents* components = [gregorianCalendar components:0xffffff fromDate:startTime];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    [components setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]; //Enforce UTC
    model.startDate = [gregorianCalendar dateFromComponents:components];
    
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow: (DAYS_FUTURE+1) * 24 * 3600];
    components = [gregorianCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:endDate];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    [components setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]; //Enforce UTC
    model.endDate   =  [gregorianCalendar dateFromComponents:components];//1 Weeks
    
    gridView.motionDelegate = self;
    
    topTimeline.userInteractionEnabled = NO;
    bottomTimeline.userInteractionEnabled = NO;
    
    self.timelineTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateTimelineTimerFired:) userInfo:nil repeats:YES];
    
    [self.view addSubview:actionRing];
    
    self.daySelector.hidden = YES;
    self.daySelector.alpha = 0;
    [self.view addSubview:daySelector];
    
    [dayPickerView selectRow:7 inComponent:0 animated:NO];
    selectedRow = 7;
    
    tapDayPickerGesture = [[UITapGestureRecognizer alloc] 
                                          initWithTarget:self
                                          action:@selector(pickerTapped:)];
    [dayPickerView addGestureRecognizer:tapDayPickerGesture];
    
    
    [self.actionRing initBackButtonActionTargetWithTargetViewID:@"OnNowViewController"];
    
    //[self.modalInfoPage setDestroyDelegate:self];
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                 name:FriendWatchingNotification
                                               object:nil];

    [super viewDidDisappear:animated];
    [self.timelineTimer invalidate];
    [self setTimelineTimer:nil];
    
    [self setActionRing:nil];
    [self setGridView:nil];
    [self setActivityIndicator:nil];
    [self setTopTimeline:nil];
    [self setBottomTimeline:nil];
    [self setDaySelector:nil];
    [self setDayIndicator:nil];
    [self setDateIndicator:nil];
    [self setModalInfoPage:nil];
    [self setDayPickerView:nil];
    
    [self.actionRing removeGestureRecognizer:swipeLeftGesture];
    [self.actionRing removeGestureRecognizer:swipeRightGesture];
    [self setSwipeLeftGesture:nil];
    [self setSwipeRightGesture:nil];
    
    [dayPickerView removeGestureRecognizer:tapDayPickerGesture];
    [self setTapDayPickerGesture:nil];

}


-(void) gotoTime:(NSDate*)date
{
    NSInteger start = [model horizontalOffsetForDate:date];
    start -= self.actionRing.frame.size.width + 50;
    
    [gridView setContentOffset:CGPointMake(start, gridView.contentOffset.y) animated:NO];
    
}

-(void) gotoTimeWithAnimation:(NSDate*)date
{
    /*
        Make it look like we are wizzing to the new time but dont because that will cane the server and we still 
        want the appearance of it loading whilst moving
    */

    NSInteger finalPos = [model horizontalOffsetForDate:date];
    finalPos -= self.actionRing.frame.size.width + 50;
    
    NSInteger scrollingFromPos = finalPos + (finalPos < gridView.contentOffset.x ? 1 : -1) * EpgCellSize.width;
    
    if(abs(gridView.contentOffset.x - finalPos) > EpgCellSize.width){
        [gridView setContentOffset:CGPointMake(scrollingFromPos, gridView.contentOffset.y) animated:NO];
    }
    
    [gridView setContentOffset:CGPointMake(finalPos, gridView.contentOffset.y) animated:YES];
}


-(void) onEpgModelInitialised {
    
    [gridView setGridDataDelegate:self];
    [topTimeline setGridDataDelegate:self];
    [bottomTimeline setGridDataDelegate:self];
    
    [self gotoTime:[NSDate date]];
    
    [activityIndicator stopAnimating];
    
    NSArray *channelList = model.channelList;

    //BA: get row height from const in EPGProgramRenderer
    CGFloat rowHeight = EpgCellSize.height;
    
    [self.actionRing initialiseArcListWithChannels:channelList withTopPadding:3 andRowHeight:rowHeight];
    
    [self transitionIn];
}


-(void) onErrorOccured: (NSError*) error 
{
    NSLog(@"Error occured on plan ahead screen: %@", error);
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)swipeActionRingOut:(UISwipeGestureRecognizer*) recognizer 
{  
    [self.actionRing updateActionRingPosition];
    CGPoint fingerPos = [recognizer locationInView:self.view];
    if(fingerPos.x < 400)
    {
        [UIView animateWithDuration:0.5 
                         animations:^{
                             self.actionRing.frame = CGRectMake(-180,0,self.actionRing.frame.size.width,self.actionRing.frame.size.height);
                             [self.actionRing transitionOut];
                             dayIndicator.alpha = 0;
                             dateIndicator.alpha = 0;
                             
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

-(void)swipeActionRingIn:(UISwipeGestureRecognizer*)recognizer 
{   
    [self.actionRing updateActionRingPosition];
    CGPoint fingerPos = [recognizer locationInView:self.view];
    
    if(fingerPos.x < 100)
    {
        [UIView animateWithDuration:0.5 
                         animations:^{
                             self.actionRing.frame = CGRectMake(0,0,self.actionRing.frame.size.width,self.actionRing.frame.size.height);
                             [self.actionRing fadeIn];
                             
                             dayIndicator.alpha = 1;
                             dateIndicator.alpha = 1;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

-(void)handleFriendsWatchNotifications:(NSNotification*)notification
{
    NSSet *currentVisibleCells = [gridView visibleCells];
    UIImageView<GridViewCell>* cell = nil;
    
    for (cell in currentVisibleCells) {
        [(PlanAheadEpgCell*)cell update];
    }
}


#pragma mark AppViewProtocol

-(void)preTransitionIn 
{
    actionRing.transform = CGAffineTransformMakeTranslation(-400, 0);

    
    progressIndicator.alpha = 0.0;
    gridView.alpha = 0;
    self.dateIndicator.alpha = 0.0;
    self.dayIndicator.alpha = 0.0;
    [actionRing preTransitionIn];
    topTimeline.transform = CGAffineTransformMakeTranslation(0, -60);
    bottomTimeline.transform = CGAffineTransformMakeTranslation(0, 60);
}

-(void)transitionIn 
{
    actionRing.arcScrollList.contentOffset = CGPointMake(0, -800);
    gridView.contentOffset = CGPointMake(gridView.contentOffset.x, -800);
    
    
    [self updateProgressIndicator];
    
    [UIView animateWithDuration:0.5 animations:[self transitionInActionRingView] completion:[self transitionInActionRing]];
        
}

-(void (^)(void))transitionInActionRingView
{
    return ^{
        actionRing.transform = CGAffineTransformIdentity;
        topTimeline.transform = CGAffineTransformIdentity;
        bottomTimeline.transform = CGAffineTransformIdentity;
        gridView.alpha = 1.0;
    };
}

-(void (^)(BOOL))transitionInActionRing
{
    return ^(BOOL finished){
        
        [gridView setContentOffset:CGPointMake(gridView.contentOffset.x, -121) animated:YES];
        [actionRing.arcScrollList setContentOffset:CGPointMake(0, -121) animated:YES];
        [actionRing transitionInWithBlockCallback:^{
            [UIView beginAnimations:@"fade" context:nil];
            [UIView setAnimationDuration:0.5];
            self.dateIndicator.alpha = 1.0;
            self.dayIndicator.alpha = 1.0;
            [UIView commitAnimations];
            
        }];
        
        [UIView animateWithDuration:0.5 animations:^{
            //progressIndicator.alpha = 0.5;
            
            
            progressIndicator.alpha = 1.0;
        }];
        [[self getAppViewController] enableHomeButton];
    };
}

-(void)transitionOut:(void (^)())callback {
   
    if (!self.daySelector.hidden) {
        self.daySelector.hidden = YES;
    }
    
    [actionRing.arcScrollList setContentOffset:CGPointMake(0, -800) animated:YES];
    [gridView setContentOffset:CGPointMake(gridView.contentOffset.x, -800) animated:YES];
    
    [self.modalInfoPage transitionOut];
        
    progressIndicator.alpha = 0;
        
    [UIView animateWithDuration:0.5 animations:^{
        [self preTransitionIn];
    }completion:^(BOOL finished){
        callback();
    }];
    [[self getAppViewController] disableHomeButton];
}

-(AppViewController *)getAppViewController
{    
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController;
}



#pragma mark Grid view

-(void)updateProgressIndicator
{
    
    CGPoint pt = progressIndicator.center;
    
    pt.x = [model horizontalOffsetForDate:[NSDate date]] - gridView.contentOffset.x;
    
    if(pt.x > 1034+10)
        pt.x = 1034;
    
    progressIndicator.center = pt;

}


-(void)updateTimelineTimerFired:(NSTimer *)t
{
    [self updateProgressIndicator];
}

-(void)gridView:(GridView*)gv movedTo:(CGPoint)offset
{
    bottomTimeline.contentOffset = topTimeline.contentOffset = CGPointMake(gridView.contentOffset.x, 0);
    
    actionRing.arcScrollList.contentOffset = CGPointMake(0, gridView.contentOffset.y);
    
    [self updateProgressIndicator];
    [self updateDaySelectorTime];
}

-(void)gridView:(GridView*)gv stoppedMovingAt:(CGPoint)offset
{
    
}

-(void) onSelectedProgramChangedTo: (Programme*)program;
{
    [self showInfoPanel:program];
}

-(void)showInfoPanel:(Programme*)newProgram
{
    if(newProgram == nil)
        return;
    
    InfoPageViewController *ipvc = [[InfoPageViewController alloc] initWithNibName:@"InfoPageView" bundle:nil];
    
    [ipvc setTypeOfInfoPanel:INFO_IN_NORMAL_MODE];
    [ipvc setCurrentChannel:model.selectedChannel];
    [ipvc setCurrentProgram:model.selectedProgram];    
    [ipvc setInfoPageDelegate:self];
    
    [self.view addSubview:ipvc.view];
    self.modalInfoPage = ipvc;
    
    [self.modalInfoPage transitionIn];
}

#pragma mark GridDataSourceDelegate

- (NSInteger)rowCountForGridView:(GridView*)gv;
{
    if(gv == topTimeline || gv == bottomTimeline){
        return 1;
    }
    
    return model.totalRowsInEpg;
}

-(NSInteger)columnCountForGridView:(GridView*)gv;
{
    return model.totalColumnsInEpg;
}

-(CGSize)cellSizeForGridView:(GridView*)gv;
{
    if(gv == topTimeline || gv == bottomTimeline){
        return EpgTimeLineCellSize;
    }
    
    return EpgCellSize;
}

-(UIView <GridViewCell> *)gridView:(GridView*)gv createCellViewAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex{
    
    if(gv == gridView){
        PlanAheadEpgCell *view = [[PlanAheadEpgCell alloc ] init];
        view.model = model;
        view.channel = [model channelAt:rowIndex];
        view.startTime = [model startDateForCellAt:columnIndex];
        view.endTime = [model endDateForCellAt:columnIndex];
        
       // __block int synopsisToFetch = 0;
        //__block int synopsisFetched = 0;
        
        [[EpgApi sharedInstance] getScheduleForChannel:view.channel.callSign 
                                            startingAt:view.startTime 
                                              endingAt:view.endTime
                                               andCall:^(NSArray *data, NSError *error) 
         {
             
             if(error != nil){
                 NSLog(@"Error fetching program data %@",error);
             }else{
                 [view setPrograms:data];
                 /*
                 for (Program *p in data)
                 {
                     if (p.synopsis.length == 0)
                     {
                         synopsisToFetch++;
                     }
                 }
                 if (synopsisToFetch == 0) {
                     [view setPrograms:data];
                     
                 }else{
                    for (Program *p in data) {
                        if (p.synopsis.length == 0 ){
                            [[EpgApi sharedInstance] getExtraInfo:p.extraInfoUrl andCall:^(ProgramExtraInfo *extraInfo, NSError *nserror){
                                if (nserror != nil) {
                                    p.synopsis = @"Synopsis unavailable";
                                }else{
                                    p.synopsis = extraInfo.extendedSynopsis;
                                }
                                synopsisFetched++;

                                if (synopsisFetched == synopsisToFetch) {
                                    [view setPrograms:data];
                                }
                            }];
                        }
                    }
                 }*/
             }
         }];
        
        
        view.alpha = 0.0;
        
        [UIView animateWithDuration:1 
                              delay:0 
                            options:UIViewAnimationOptionAllowUserInteraction 
                         animations:^{
                             
            view.alpha = 1;
                         
        }completion:nil];
        
        view.isAccessibilityElement = YES;
        view.accessibilityLabel = [NSString stringWithFormat:@"EPG Cell %d,%d", columnIndex,rowIndex];
        
        return view;
    }
    
    NSDate* t = [model startDateForCellAt:columnIndex];
    return [[EpgTimelineCell alloc] initWithDate:t isTopBar:gv == topTimeline];
}

#pragma mark ArcListDelegate

-(void)updateContentOffset:(CGPoint)contentOffset animated:(BOOL)animated 
{
}

-(void)updateContentOffset:(CGPoint)contentOffset {
    
}

-(void)updateArcListContentOffset:(CGPoint)contentOffset
{
    gridView.ContentOffset = CGPointMake(gridView.contentOffset.x, contentOffset.y);
}

-(void)movingUpdateActionPanelPostion {
    
}




-(void)updateDaySelectorTime
{
    NSInteger column = gridView.contentOffset.x / EpgCellSize.width;
    NSDate* time = [self.model startDateForCellAt:column];
    
    
    NSDateFormatter* dayFormatter = nil;
    if(!dayFormatter){
        dayFormatter = [[NSDateFormatter alloc] init];
        [dayFormatter setDateFormat:@"EEE"];
    }
    
    [dayIndicator setText:[dayFormatter stringFromDate:time]];
    
    NSDateFormatter* dateFormatter = nil;
    if(!dateFormatter){
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-YYYY"];
    }
    
    [dateIndicator setText:[dateFormatter stringFromDate:time]];

    NSInteger daySelectorIndex = (column / 8);
    [dayPickerView selectRow:daySelectorIndex inComponent:0 animated:YES];
}

-(void)pressedDaySelector:(UIButton *)sender
{
    if(daySelector.hidden){
        [daySelector setHidden:NO];
        [UIView animateWithDuration:0.5 animations:^{
            daySelector.alpha = 1;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            daySelector.alpha = 0;
        } completion:^(BOOL finished) {
            [daySelector setHidden:YES];
        }];

    }
}

#pragma mark UIPickerView for date selector

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return DAYS_FUTURE + DAYS_PAST + 1;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"EEEE d'th' MMMM"];
    NSInteger dayOffset = -DAYS_PAST + row;
    
    NSDate* d = [NSDate dateWithTimeIntervalSinceNow:dayOffset * 24 * 60 * 60];
    
    if(dayOffset != 0){
        
        NSString* dayLabel = [fmt stringFromDate:d];
        
        dayLabel = [dayLabel stringByReplacingOccurrencesOfString:@"1th" withString:@"1st"];
        dayLabel = [dayLabel stringByReplacingOccurrencesOfString:@"2th" withString:@"2nd"];
        dayLabel = [dayLabel stringByReplacingOccurrencesOfString:@"3th" withString:@"3rd"];
        
        return dayLabel;
    } else {
        return @"Today"; 
    }

}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component 
{
    selectedRow = row;
}

-(void)pickerTapped:(UIGestureRecognizer *)gestureRecognizer 
{
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) 
    {
        CGPoint myP = [gestureRecognizer locationInView:dayPickerView];
        CGFloat heightOfPickerRow = dayPickerView.frame.size.height/5;

        NSInteger rowToSelect =[dayPickerView selectedRowInComponent:0];

        if (myP.y<heightOfPickerRow) {
            //selected area corresponds to current_row-2 row
            //check if we can move to that row (i.e. that
            //it exists and is not blank
            if ([dayPickerView selectedRowInComponent:0] > 1)
                rowToSelect -=2;
            else
                rowToSelect = -1; //no action required code
        }
        else if (myP.y<2*heightOfPickerRow) {
            //selected area corresponds to current_row-1 row
            //check if we can move to that row (i.e. that
            //it exists and is not blank
            if ([dayPickerView selectedRowInComponent:0] > 0)
                rowToSelect -=1;
            else
                rowToSelect = -1;
        }
        else if (myP.y<3*heightOfPickerRow) {
            //selected the already highlighted row.
            //it definitely exists so no further checks needed
            rowToSelect = [dayPickerView selectedRowInComponent:0];
        }
        else if (myP.y<4*heightOfPickerRow) {
            //selected area corresponds to current_row+1 row
            //check if we can move to that row (i.e. that
            //it exists and is not blank
            if ([dayPickerView selectedRowInComponent:0] <
                ([dayPickerView numberOfRowsInComponent:0]-1))
                rowToSelect +=1;
            else
                rowToSelect = -1;
        }
        else {
            //selected area corresponds to current_row+2 row
            //check if we can move to that row (i.e. that
            //it exists and is not blank
            if ([dayPickerView selectedRowInComponent:0] <
                ([dayPickerView numberOfRowsInComponent:0]-2))
                rowToSelect +=2;
            else
                rowToSelect = -1;
        }

        if (rowToSelect!=-1) {
            //handle tap gesture.
            [dayPickerView selectRow:rowToSelect inComponent:0 animated:YES];

            //work out delay time, delay the hide day picker animation.
            double delay = 0.4 * abs(selectedRow - rowToSelect);
            selectedRow = rowToSelect;
            [self hidePickerView:delay];
        }
    }
}

-(void) hidePickerView:(double)delay
{
    NSInteger dayOffset = -DAYS_PAST + selectedRow;
    NSDate* targetTime = [NSDate dateWithTimeIntervalSinceNow: dayOffset * 24 * 60 * 60];
    
    [self gotoTimeWithAnimation:targetTime];

    [UIView animateWithDuration:0.5 delay:delay options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        daySelector.alpha = 0;
    } completion:^(BOOL finished) {
        [daySelector setHidden:YES];
    }];

}

-(BOOL)isGreedy
{
    return NO;
}

# pragma mark InfoPageDelegate

-(void)infoPageClosed {
    [self.modalInfoPage.view removeFromSuperview];
    [self setModalInfoPage:nil];
}

@end
