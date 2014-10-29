//
//  OnNowViewController.m
//  MyspaceTVCompanion
//
//  Created by Bann Al-Jelawi on 01/06/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//

#import "OnNowViewController.h"
#import "OnNowReusableTableViewCell.h"
#import "UserProfile.h"

#import "InfoPageViewController.h"
#import "AppDelegate.h"

#import "XMPPClient.h"

#import "DDLog.h"
#import "NSArray+Map.h"
#import "ProgramExtraInfo.h"

static const NSInteger ArcCenterX = -165;
static const NSInteger ArcCenterY = 320;

//Change this to enable logging for this file
static const int ddLogLevel = LOG_LEVEL_ERROR; //VERBOSE;


@implementation OnNowViewController

@synthesize tableView;
@synthesize actionRing;
@synthesize activityIndicator;
@synthesize modalInfoPage;

@synthesize dataService;
@synthesize programData;
@synthesize channelData;
@synthesize fingerPosInApp;

@synthesize dayViewIndicator;
@synthesize dayLbl;
@synthesize dateLbl;


#pragma mark Initialisation

- (void)initialiseProgrammesForChannels:(NSArray *)channels
{
    NSArray *callSigns = [channels mapWithBlock:^id(Channel* chan) {
        return chan.callSign;
    }];
    
    self.channelData = channels;
    
    //now request the dataService to get the Schedule, passing it our callSigns array
    [self.dataService getSchedule:callSigns onNowTBVDelegate:self];
}

#pragma mark OnNowTableViewDelegate

-(void)onInitialised:(NSArray *)channels
{
    const float rowHeight = 110;
    const int topPadding = 105;
    
    [self.actionRing initialiseArcListWithChannels:channels withTopPadding:topPadding andRowHeight:rowHeight];
    
    [self initialiseProgrammesForChannels:channels];
}

-(void)onRecievedOnNowData:(NSDictionary*)onNowData withExtraInfo:(NSDictionary*)extraInfo
{
    DDLogVerbose(@"*** on now onreceived on now date");
    
    self.programData = [channelData mapWithBlock:^id(Channel* chan){
        return [onNowData objectForKey:chan.callSign];        
    }];
    
    self.extroInfoData = [channelData mapWithBlock:^id(Channel* chan){
        return [extraInfo objectForKey:chan.callSign];
    }];
    
    [self updateProgramDataSynopsis];
    
    [tableView reloadData];
    
    if (!hasAnimatedIn) {
        [self transitionIn];
        hasAnimatedIn = YES;
    }
    
    [activityIndicator stopAnimating];
}

-(void)updateProgramDataSynopsis
{
    for (int i=0; i<[programData count]; i++) {
        Programme *prog = [programData objectAtIndex:i];
        
        if(prog.synopsis == nil || prog.synopsis.length == 0)
        {
            if ([self.extroInfoData objectAtIndex:i] != [NSNull null] ) {
                prog.synopsis = ((ProgramExtraInfo *)[self.extroInfoData objectAtIndex:i]).extendedSynopsis;
            }
        }
    }
}

#pragma mark View life cycle

-(void)viewDidLoad
{
    NSLog(@"*** on now view did load");
    self.dataService = [[OnNowTableViewService alloc] init];
    [self.dataService initialise:self];
    
    UITapGestureRecognizer * tapGesutre = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableTapped:)];
    tapGesutre.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGesutre];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    DDLogVerbose(@"*** on now view will appear");
    //set all alpha 0;
    hasAnimatedIn = NO;
    [self preTransitionIn];
    [self getTodaysDateAndSetLabels];
}


-(void)getTodaysDateAndSetLabels
{
    NSDate *today = [NSDate date];
    NSDateFormatter *weekdayFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"dd-MM-yyyy"];
    [weekdayFormatter setDateFormat: @"EEE"];
    NSString *formattedDate = [formatter stringFromDate: today];
    NSString *weekday = [weekdayFormatter stringFromDate: today];
    
    self.dayLbl.text = weekday;
    self.dateLbl.text = formattedDate;
    
    today = nil;
    weekdayFormatter = nil;
    formatter = nil;
    formattedDate = nil;
    weekday = nil;
}


- (void)viewDidAppear:(BOOL)animated
{
    DDLogVerbose(@"*** on now view did appear");
    // Do any additional setup after loading the view from its nib.
    //[self.actionRing targetViewID:@"PlanAheadEpgViewController"];
    [self.actionRing initBackButtonActionTargetWithTargetViewID:@"PlanAheadEpgViewController"];
    
    isScrollingFromArcList = NO;
    
    self.tableView.tag = 1;
    tableView.accessibilityLabel = @"onNowTable";
    self.actionRing.arcScrollList.tag = 2;
    [self.actionRing.arcScrollList setArcCenterX:ArcCenterX];
    [self.actionRing.arcScrollList setArcCenterY:ArcCenterY];
    [self.tableView setDelegate:self];
    [self.tableView setArcDelegate:self];
    
    //BA: changed the Y value here to create a frame offset so channel idents sit central to tableView rows
    [self.actionRing.arcScrollList setFrame:CGRectMake(0,0,self.actionRing.frame.size.width, self.actionRing.frame.size.height)];
    [self.actionRing.arcScrollList setDelegate:self];
    [self.actionRing.arcScrollList setArcDelegate:self];
    [self.actionRing.arcScrollList setScrollEnabled:YES];
    
    self.activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.activityIndicator startAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFriendWatching:) name:FriendsListUpdatedNotification object:nil];
    
    //[self showLostConnectionNotifier];
}


- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"viewDidDisappear >>> ");
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:FriendLoggedInNotification object:nil];
    
    DDLogVerbose(@"*** on now view did disappear");
    [self.tableView setDelegate:nil];
    [self.tableView setArcDelegate:nil];
    [self setTableView:nil];
    
    [self.actionRing.arcScrollList setArcDelegate:nil];
    [self setActionRing:nil];
    
    [self setActivityIndicator:nil];
    [self setModalInfoPage:nil];
    
    [self setChannelData:nil];
    [self setDataService:nil];
    
    [super viewDidDisappear:animated];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{
    NSLog(@"dealloc called");
    [self.tableView setDelegate:nil];
    [self.tableView setArcDelegate:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:FriendLoggedInNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FriendWatchingNotification object:nil];
    self.dataService = nil;
}

#pragma mark Error handling


-(void)onErrorOccurred:(NSString *)errorInfo
{
    //log out error message to console
    DDLogVerbose(@"BA OnNowDataService ERROR:: %@", errorInfo);
    
    if (!hasAnimatedIn) {
        [self transitionIn];
        hasAnimatedIn = YES;
    }
    
    //[self showLostConnectionNotifier];
    
    //[activityIndicator stopAnimating];
}


-(void)showLostConnectionNotifier
{
    LostConnectionIndicatorViewController *errorView = [[LostConnectionIndicatorViewController alloc]initWithNibName:@"LostConnectionIndicatorViewController" bundle:nil];
    
    [errorView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [errorView setModalPresentationStyle:UIModalPresentationFormSheet];

    [self presentModalViewController:errorView animated:YES];
    
    errorView.view.superview.frame = CGRectMake(errorView.view.superview.frame.origin.x, errorView.view.superview.frame.origin.y,472.0f,471.0f);
    errorView.view.superview.center = self.view.center;
}



#pragma mark UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return channelData.count;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OnNowReusableTableViewCell *cell = (OnNowReusableTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"OnNowReusableTableViewCell"];
    
    //get current programme
    Programme *currentProgram = [self.programData objectAtIndex:indexPath.row];
    
    //create
    if (cell == nil)
    {
        cell = [OnNowReusableTableViewCell cellView];
        [cell.watchButton addTarget:self action:@selector(watchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [cell reset];
    }
    
    [cell.watchButton setTag:indexPath.row];
    
    NSArray *friends = [[[XMPPClient sharedInstance] watchingApi] friendsWatchingProgram:currentProgram.programmeID];
    
    [cell setWatchingFriends:friends];
    
    [cell setProgram:currentProgram];
    return cell;
}

-(BOOL)pressedOnChannelLogo
{
    NSLog(@"finger pos in app %f",self.fingerPosInApp.x);
    return (self.fingerPosInApp.x < 400);
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CGPoint touchPoint = [locationInView:self.view];
    
    if([self pressedOnChannelLogo])
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
        Channel *currentChannel = [self.channelData objectAtIndex:indexPath.row];
        Programme *currentProgram = [self.programData objectAtIndex:indexPath.row];
    
        [self showInfoPanelWithProgram:currentProgram andChannel:currentChannel];
    }
}

-(void)showInfoPanelWithProgram:(Programme *)program andChannel:(Channel*)channel
{
    self.modalInfoPage = [[InfoPageViewController alloc] initWithNibName:@"InfoPageView" bundle:[NSBundle mainBundle]];
    [self.modalInfoPage setTypeOfInfoPanel:INFO_IN_NORMAL_MODE];
    [self.modalInfoPage setCurrentChannel:channel];
    [self.modalInfoPage setCurrentProgram:program];
    [self.modalInfoPage setInfoPageDelegate:self];
    
    [self.view addSubview:modalInfoPage.view];
    [self.modalInfoPage transitionIn];
}



#pragma mark Actions

-(void)onFriendWatching:(NSNotification*)notification
{
    for(OnNowReusableTableViewCell* cell in tableView.visibleCells){
        
        NSArray *friends = [[[XMPPClient sharedInstance] watchingApi] friendsWatchingProgram:cell.program.programmeID];
        [cell setWatchingFriends:friends];
    }
}

-(void)hideAllFriendsWatching
{ 
    for(OnNowReusableTableViewCell *cell in tableView.visibleCells){
    if(cell.watchButton.isSelected){
        [cell hideWatchingAvatars];
        cell.watchButton.selected = NO;
    }
    }
}

-(IBAction)watchButtonClicked:(UIButton *)sender
{
    DDLogVerbose(@"sender.tag: %d", sender.tag);
    
    OnNowReusableTableViewCell* tableCell = (OnNowReusableTableViewCell*)sender.superview.superview;
    
    if(!sender.isSelected)
    {
        [self hideAllFriendsWatching];
        
        [tableCell showWatchingAvatars];
    }
    else
    {   
        [tableCell hideWatchingAvatars];
    }
    
    sender.selected = !sender.isSelected;
}



-(IBAction)swipeActionRingOut:(UISwipeGestureRecognizer *)recognizer
{
    [self.actionRing updateActionRingPosition];
    CGPoint fingerPos = [recognizer locationInView:self.view];
    
    if((fingerPos.x < 400) && (self.actionRing.lastestActionViewOriginPoints.x == 0))
    {
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             actionRing.frame = CGRectMake(-180,0,actionRing.frame.size.width,actionRing.frame.size.height);
                             
                             
                             CGRect f = tableView.frame;
                             
                             f.origin.x = 90;
                             f.size.width = 1024 - f.origin.x;
                             
                             self.tableView.frame = f;
                             
                             [self.actionRing transitionOut];
                         }
                         completion:^(BOOL finished){
                             [self.actionRing updateActionRingPosition];
                         }];
    }
}


-(IBAction)swipeActionRingIn:(UISwipeGestureRecognizer *)recognizer
{   
    [self.actionRing updateActionRingPosition];
    CGPoint fingerPos = [recognizer locationInView:self.view];
    
    if((fingerPos.x < 100) && (self.actionRing.lastestActionViewOriginPoints.x == -180))
    {
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.actionRing.frame = CGRectMake(0,0,actionRing.frame.size.width,actionRing.frame.size.height);
                             
                             
                             CGRect f = tableView.frame;
                             
                             f.origin.x = 255;
                             f.size.width = 1024 - f.origin.x;
                             
                             self.tableView.frame = f;
                             
                             [self.actionRing fadeIn];
                             
                         }
                         completion:^(BOOL finished){
                             [self.actionRing updateActionRingPosition];
                         }];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


#pragma mark AppViewProtocol
-(void)preTransitionIn
{
    self.actionRing.alpha = 0;
    self.tableView.alpha =0;
    //actionRing.filterPanel.alpha = 0.0;
    [self.actionRing preTransitionIn];
    self.actionRing.transform = CGAffineTransformMakeTranslation(-400, 0);
}

-(void)transitionIn
{
    self.tableView.contentOffset = CGPointMake(0, -800);
    self.actionRing.arcScrollList.contentOffset = CGPointMake(0, -800);
    
    [UIView animateWithDuration:0.5 animations:[self transitionInActionRingView] completion:[self transitionInActionRing]];
}

-(void (^)(void))transitionInActionRingView
{
    return ^{
        self.actionRing.transform = CGAffineTransformIdentity;
        self.actionRing.alpha = 1;
        self.tableView.alpha = 1;
    };
}

-(void (^)(BOOL))transitionInActionRing
{
    return ^(BOOL finished){
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.actionRing.arcScrollList setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.actionRing transitionInWithBlockCallback:nil];
        [[self getAppViewController] enableHomeButton];
    };
}    

- (void)transitionOut:(void (^)())callback
{
    [self.tableView setContentOffset:CGPointMake(0, -800) animated:YES];
    [self.actionRing.arcScrollList setContentOffset:CGPointMake(0, -800) animated:YES];
    
    [self.modalInfoPage transitionOut];
    
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




-(BOOL)isGreedy
{
    return NO;
}


#pragma mark ArcListProtocol

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView.tag == 2)
    {
        isScrollingFromArcList = YES;
    }
 
    [self hideAllFriendsWatching];
   
    DDLogVerbose(@"scrollViewWillBeginDragging::::: %i   scrollView.tag::: %i",isScrollingFromArcList, scrollView.tag);
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    isScrollingFromArcList = NO;
    DDLogVerbose(@"scrollViewDidEndDecelerating::::: %i",isScrollingFromArcList);
}

-(void)updateContentOffset:(CGPoint)contentOffset animated:(BOOL)animateds
{
    
}

-(void)updateContentOffset:(CGPoint)contentOffset
{
    DDLogVerbose(@"arclist is dragging from list drag: %i ",isScrollingFromArcList);
    if(isScrollingFromArcList)
    {
        [self.tableView setContentOffset:contentOffset];
    }
}



-(void)updateArcListContentOffset:(CGPoint)contentOffset
{
    
    DDLogVerbose(@"arclist is dragging from table drag: %i ",isScrollingFromArcList);
    if(!isScrollingFromArcList)
    {
        [self.actionRing.arcScrollList setContentOffset:contentOffset];
    }
}

-(void)movingUpdateActionPanelPostion
{
    
}

# pragma mark InfoPageDelegate

-(void)infoPageClosed {
    [self.modalInfoPage.view removeFromSuperview];
    [self setModalInfoPage:nil];
}

-(void)tableTapped:(UITapGestureRecognizer*)sender
{
   // [self setFingerPosInApp:[sender locationInView:self.tableView]];
}


@end
