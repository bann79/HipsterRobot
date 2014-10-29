//
//  InfoPageViewController.m
//  MyspaceTVCompanion
//
//  Created by Dyfan Hughes on 26/06/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//

#import "InfoPageViewController.h"
#import "XMPPClient.h"
#import <QuartzCore/QuartzCore.h>
#import "ChannelDiscFactory.h"
#import "CatchupUrlGenerator.h"
#import "VideoItem.h"
#import "XumoVideoPlayer.h"

#import "DDLog.H"
static const int ddLogLevel = LOG_LEVEL_INFO;

#define noDisableVerticalScrollTag 836913
#define noDisableHorizontalScrollTag 836914

@implementation UIImageView (ForScrollView)

- (void) setAlpha:(float)alpha {
    
    if (self.superview.tag == noDisableVerticalScrollTag) {
        if (alpha == 0 && self.autoresizingMask == UIViewAutoresizingFlexibleLeftMargin) {
            if (self.frame.size.width < 10 && self.frame.size.height > self.frame.size.width) {
                UIScrollView *sc = (UIScrollView*)self.superview;
                if (sc.frame.size.height < sc.contentSize.height) {
                    return;
                }
            }
        }
    }
    
    if (self.superview.tag == noDisableHorizontalScrollTag) {
        if (alpha == 0 && self.autoresizingMask == UIViewAutoresizingFlexibleTopMargin) {
            if (self.frame.size.height < 10 && self.frame.size.height < self.frame.size.width) {
                UIScrollView *sc = (UIScrollView*)self.superview;
                if (sc.frame.size.width < sc.contentSize.width) {
                    return;
                }
            }
        }
    }
    
    [super setAlpha:alpha];
}
@end


@implementation InfoPageViewController
{
    @private CatchupUrlGenerator *  catchupConstructor;
    BOOL showingAvatarView;
    NSArray *friendsWatching;
}
@synthesize syncInfoButton;

@synthesize friendsWatchingAnnotation;
@synthesize startTimeLbl, startDateLbl, titleLbl, subHeadingLbl;
@synthesize durationLbl, descriptionTxt, lazyLoadImage, playVideoBtn;
@synthesize videoView, avatarHolder, channelDiscView;
@synthesize contentView, exitModalButton;
@synthesize darkBorder, lightBorder;

@synthesize channelDiscFactory,catchUpURLGenerator;
@synthesize currentChannel, currentProgram;

@synthesize videoPlayer;
@synthesize videoPlayable;
@synthesize selectedProgrammeState, correctVideoFeed;
@synthesize generatedDiscImg;
@synthesize typeOfInfoPanel;
@synthesize resultantFeed;

@synthesize infoPageDelegate;

// Watching SubView
@synthesize watchingSubView;
@synthesize watchingButton;
@synthesize watchingViewFriends;
@synthesize pigController;
@synthesize timeConverter;

#pragma mark View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self preTransitionIn];
    
    self.channelDiscFactory = [[ChannelDiscFactory alloc]init];
    self.catchUpURLGenerator = [[CatchupUrlGenerator alloc]init];
    
    lazyLoadImage.defaultImage = lazyLoadImage.image;
    
    [self.syncInfoButton setHidden:YES];
    showingAvatarView = NO;
    [self setVideoPlayable:NO];    
    [self.titleLbl setText:@""];
    [self.subHeadingLbl setText:@""];
    [self.durationLbl setText:@""];
    [self.startTimeLbl setText:@""];
    [self.startDateLbl setText:@""];
    [self.descriptionTxt setText:@""];
    
    timeConverter = [[ProgramTimeConverter alloc]init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self populateElementsWithChannel:self.currentChannel andProgram:self.currentProgram];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFriendsWatching:) name:FriendsListUpdatedNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
    
    //Ensure that the video is stopped playing if it hasn't been already
    if((self.videoPlayer.state != XVPStopped || self.videoPlayer.state != XVPFinished ) && !self.videoPlayer.isFullscreen)
    {
        [self.videoPlayer stop];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];   
    [self setVideoPlayer:nil];
    
    showingAvatarView = NO;
    [self setVideoPlayable:NO];
    [self setChannelDiscFactory:nil];
    [self setCatchUpURLGenerator:nil];
    [self setChannelDiscView:nil];
    [self setWatchingViewFriends:nil];
    [self setFriendsWatchingAnnotation:nil];
}

- (void)viewDidUnload {
    [self setPigController:nil];
    [self setSyncInfoButton:nil];
    [super viewDidUnload];
}

-(void)setVideoPlayer:(XumoVideoPlayer *)newVideoPlayer
{
    [videoPlayer removeObserver:self];
    videoPlayer = newVideoPlayer;
    [videoPlayer addObserver:self];
}

#pragma mark View transitions

-(void)preTransitionIn
{
    self.contentView.transform = CGAffineTransformMakeTranslation(0, 1024);
    self.avatarHolder.transform = CGAffineTransformMakeTranslation(0, 1024);
    
    //the watching sub view is zoom from center of view.
    self.watchingSubView.transform = CGAffineTransformMakeScale(0.75, 0.75);
    //hard value of the location.
    self.watchingSubView.center = CGPointMake(377, 240);

    self.exitModalButton.alpha = 0.0;
    self.lightBorder.alpha = 0.0;
}

-(void)transitionIn
{
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
        self.avatarHolder.transform = CGAffineTransformIdentity;
        self.exitModalButton.alpha = 0.75;
    }];
}

-(void)transitionOut
{
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, 1024);
        self.avatarHolder.transform = CGAffineTransformMakeTranslation(0, 1024);
        self.exitModalButton.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        
        //notify delegate infopanel closed.
        if([self.infoPageDelegate respondsToSelector:@selector(infoPageClosed)])
            [self.infoPageDelegate infoPageClosed];
    }];
}

#pragma mark Other animations

-(void)animateDropDown
{
    float duration = 0.4;
    if (!showingAvatarView && friendsWatching.count > 0) {
        // Move the panel down
        [UIView animateWithDuration:duration animations:^{
            self.contentView.transform = CGAffineTransformMakeTranslation(0, -48);
            self.avatarHolder.transform = CGAffineTransformMakeTranslation(0, 48);
            self.watchingSubView.transform = CGAffineTransformIdentity;
            self.watchingSubView.center = CGPointMake(386, 246);
            
        } completion:^(BOOL finished){
            self.avatarHolder.layer.cornerRadius = 20;
        }
         ];
        
        // Round the left hand corner
        CABasicAnimation *roundAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        [roundAnimation setToValue:[NSNumber numberWithFloat:20]];
        roundAnimation.fillMode = kCAFillModeForwards;
        roundAnimation.removedOnCompletion = NO;
        roundAnimation.duration = duration;
        [self.avatarHolder.layer addAnimation:roundAnimation forKey:@"anim"];
        
        // Fade the border images dark-light
        [UIView animateWithDuration:duration animations:^{
            self.darkBorder.alpha = 0.0;
            self.lightBorder.alpha = 1.0;
        }];
        
    } else {
        //[self.avatarHolder.layer removeAllAnimations];
        // Move the panel up
        [UIView animateWithDuration:duration animations:^{
            self.contentView.transform = CGAffineTransformIdentity;
            self.avatarHolder.transform = CGAffineTransformIdentity;
            self.watchingSubView.transform = CGAffineTransformMakeScale(0.75, 0.75);
            self.watchingSubView.center = CGPointMake(377, 240);
            
        } completion:^(BOOL finished){
            self.avatarHolder.layer.cornerRadius = 0.0;
        }];
        
        // Remove rounding from the left hand corner
        CABasicAnimation *roundAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        [roundAnimation setToValue:[NSNumber numberWithFloat:0.0]];
        roundAnimation.fillMode = kCAFillModeForwards;
        roundAnimation.removedOnCompletion = NO;
        roundAnimation.duration = duration;
        [self.avatarHolder.layer addAnimation:roundAnimation forKey:@"anim"];
        
        // Fade the border images light-dark
        [UIView animateWithDuration:duration animations:^{
            self.darkBorder.alpha = 1.0;
            self.lightBorder.alpha = 0.0;
        }];
    }
    
    showingAvatarView = !showingAvatarView;
}


#pragma mark Populate elements

-(void)populateElementsWithChannel:(Channel *)channel andProgram:(Programme *)program
{
    UIImageView *channelIden = [self.channelDiscFactory createChannelDiscViewForChannel:currentChannel withImageNamed:@"channel-ident.png" atVerticalPosition:4     atHorizontalPosition:8];
    
    [self.channelDiscView addSubview:channelIden];
    
    [self visualiseCorrectImageWithinImagePIGAccordingToStartTime:program.startTime AndEndTime:program.endTime AndTypeOfInfopanel:@"normalInfo"];
    
    [self.playVideoBtn setHidden:!self.videoPlayable];
    
    if ([self.typeOfInfoPanel isEqualToString:INFO_IN_CHANNEL_BAR] && self.videoPlayable) {
        self.playVideoBtn.hidden = [self.videoPlayer.videoItem.currentProgram isEqual:program];
    }
    
    [self updateFriendsWatching:program];

    currentChannel = channel;
    currentProgram = program;
    
    NSString *durationString = [timeConverter setDurationWithStartTime:program.startTime andEndTime:program.endTime];
    NSString *startTime = [timeConverter convertStartTimeToString:program.startTime];
    NSString *startDate = [timeConverter convertStartDateToString:program.startTime];
    NSString *progName = (program.name != nil) ? program.name : @"Title unavailable";
    NSString *synopsis =(program.synopsis != nil) ? program.synopsis : @"Synopsis unavailable";
    
    [self.titleLbl setText: progName];
    [self.durationLbl setText:durationString];
    [self.startTimeLbl setText:startTime];
    [self.startDateLbl setText:startDate];
    [self.descriptionTxt setText:synopsis];
    [self populateSubheadingAndSynopsis:program.extraInfoUrl];
    
    [self.lazyLoadImage lazyLoadImageFromURLString:[currentProgram getBestImageForSize:self.lazyLoadImage.bounds.size] contentMode:UIViewContentModeScaleAspectFill];
}


-(void) populateSubheadingAndSynopsis:(NSString *)url
{
    __block NSString *subHeading = @"Loading";
    __block NSString *synopsis = @"Loading";
    
    [self.subHeadingLbl setText:subHeading];

    [[EpgApi sharedInstance] getExtraInfo:url andCall:^(ProgramExtraInfo *extraInfo, NSError *error){
        if (error != nil ) {
            subHeading = @"Info unavailable";
            synopsis = @"Synopsis unavailable";
            
        } else {
            if (extraInfo.episodeInfo == nil) {
                if (extraInfo.genres.count > 0) {
                    subHeading = [extraInfo.genres componentsJoinedByString:@", "];
                    
                }else{
                    subHeading = @"Info unavailable";
                }
            }else{
                subHeading = [NSString stringWithFormat:@"Season %i: Episode %i", extraInfo.episodeInfo.season, extraInfo.episodeInfo.number ];
            }
            
            if (extraInfo.extendedSynopsis == nil || extraInfo.extendedSynopsis.length == 0){
                synopsis = (currentProgram.synopsis.length == 0) ?  @"Synopsis unavailable":currentProgram.synopsis;
            }else{
                synopsis = extraInfo.extendedSynopsis;
            }
        }
        [self.subHeadingLbl setText:subHeading];
        [self.descriptionTxt setText:synopsis];
        
        
        [self.descriptionTxt flashScrollIndicators];
        self.descriptionTxt.tag = noDisableVerticalScrollTag;
    }];
}

#pragma mark Friends watching

-(void)updateFriendsWatching:(id)sender
{
    //init friends watching
    NSArray *friends = [[[XMPPClient sharedInstance] watchingApi] friendsWatchingProgram:currentProgram.programmeID];
    
    //friends = [self getMockedFriendsWatching];
    [self setWatchingFriends:friends];
    
}

-(void)setWatchingFriends:(NSArray *)friends
{
    if([friends count] != [friendsWatching count])
    {
        
        if(showingAvatarView)
        {
            [self animateDropDown];
        }
        
        if (friends.count == 0) {
            [watchingButton setUserInteractionEnabled:NO];
            [watchingButton setEnabled:NO];
        }
        else {
            [watchingButton setUserInteractionEnabled:YES];
            [watchingButton setEnabled:YES];
        }
        
        friendsWatchingAnnotation.text = [NSString stringWithFormat:@"%u", friends.count];
        friendsWatching = friends;
        
        //updates avatars.
        if (friendsWatching.count > 0) {
            [self createFriendsWatchingViews];
        }
    }
}


-(NSArray*)getMockedFriendsWatching
{
    NSMutableArray *mockFriends = [[NSMutableArray alloc] init];
    
    UserProfile *mockF = [[UserProfile alloc] init];
    mockF.name = @"Friends1";
    mockF.email = @"mock@ronk.com";
    mockF.avatarURL = @"http://a1-dfsalpha.myspacecdn.com/dfsalphaimages01/3/2742c485b6124282959c6f6c89ed308f/o.jpg";
    
    for (int i=0; i<15; i++) {
        mockF.name = [@"friends" stringByAppendingFormat:@"%d", i];
        [mockFriends addObject:mockF];
    }
    
    return mockFriends;
}

-(void)createFriendsWatchingViews
{
    UIImage *holderImage = [UIImage imageNamed:@"on_now_bar_watch_out_holder.png"];
    CGPoint avatarPosition = { holderImage.size.width / 2 , holderImage.size.height/2 };
    
    for(UserProfile *friend in friendsWatching)
    {
        UIImageView *holder = [[UIImageView alloc] initWithImage:holderImage];
        
        holder.center = avatarPosition;
        [watchingViewFriends addSubview:holder];
        CircularImageButton *avatar = [CircularImageButton avatarFrameForUrl:friend.avatarURL];
        avatar.center = avatarPosition;
        [watchingViewFriends addSubview:avatar];
        avatarPosition.x += holderImage.size.width;

    }
    
    NSInteger emptyAvatarsToAdd = 7 - friendsWatching.count;
    while (emptyAvatarsToAdd-- > 0) {
        UIImageView *holder = [[UIImageView alloc] initWithImage:holderImage];
        
        holder.center = avatarPosition;
        
        [watchingViewFriends addSubview:holder];
        
        avatarPosition.x += holderImage.size.width;
    }
    
    watchingViewFriends.contentSize = CGSizeMake(holderImage.size.width * friendsWatching.count, holderImage.size.height);
}



#pragma mark XumoVideoPlayerObserver

-(void)player:(XumoVideoPlayer *)player hasNewVideoItem:(VideoItem *)newVideoItem
{
    //If the playing video item is not the current item, show the sync button
    if (newVideoItem != nil)
    {
        if(!self.videoPlayer.isFullscreen)
        {
            //playing in PiG. new playing video item. set button alpha zero, show it. animation it in.
            syncInfoButton.alpha = 0;
            syncInfoButton.hidden = [currentProgram isEqual:newVideoItem.currentProgram];
            if (![currentProgram isEqual:newVideoItem.currentProgram]) {
                [UIView animateWithDuration:0.3 animations:^{
                    syncInfoButton.alpha = 1;
                }];
            }
        }else{
            //playing in fullscreen mode;
            [self populateElementsWithChannel:newVideoItem.currentChannel andProgram:newVideoItem.currentProgram];
        }
    }
}

-(void)player:(XumoVideoPlayer *)player stateDidChangeTo:(enum XumoVideoPlayerState)state
{
    if(state == XVPFinished){
        [self.playVideoBtn setHidden:NO];
    }
}

#pragma mark Buttons
- (IBAction)onExitModalAreaTouched:(UIButton *)sender {
    //NSLog(@"*** exit exit exit");
    if (!self.videoPlayer.isFullscreen && (self.videoPlayer.state != XVPFinished || self.videoPlayer.state != XVPStopped)) {
        [self.videoPlayer stop];
    }
    [self transitionOut];
}

- (IBAction)onSyncInfoPressed:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        syncInfoButton.alpha = 0;
        
    }completion:^(BOOL finished) {
        syncInfoButton.hidden = YES;
    }];
    [self populateElementsWithChannel:videoPlayer.videoItem.currentChannel andProgram:videoPlayer.videoItem.currentProgram];
}

-(IBAction)onPlayTouched:(id)sender
{
    VideoItem* videoAsset = [[VideoItem alloc] init];
    
    if([selectedProgrammeState isEqualToString:@"live"])
    {
        resultantFeed = [self.currentChannel.liveStreamUrls objectAtIndex:0];
    }
    else if ([selectedProgrammeState isEqualToString:@"catchup"]) {
        resultantFeed = [catchUpURLGenerator generateURLWithChannel:self.currentChannel andProgram:self.currentProgram];
    }
    
    videoAsset.currentChannel = currentChannel;
    videoAsset.currentProgram = currentProgram;
    videoAsset.streamUrl = resultantFeed;
    
    //NSLog(@"*** play button touched");
    [self.playVideoBtn setHidden:YES];
    
    [self.videoPlayer loadVideo:videoAsset andAutoPlay:YES];
        
    if ([typeOfInfoPanel isEqualToString:INFO_IN_CHANNEL_BAR]) {
        [self transitionOut];
        //info panel launched from channel bar, the video will play in fullscreen mode;
        [self.videoPlayer setIsFullscreen:YES];
    }else{
        [self.videoPlayer setIsFullscreen:NO];
        //play video in 4:3 mode in PiG mode;
        [self.videoPlayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    }
}

-(IBAction)onWatchingTouched {
    [self animateDropDown];
}


#pragma mark Utils

#pragma mark --------------------------
// From base

-(void)createChannelDiscWithChannelObject:(Channel*)channel
                                 WithXPos:(int) Xpos 
                                  AndYPos:(int) Ypos
                           AndAddedToView:(UIView*) view
{
    if(generatedDiscImg)
    {
        [generatedDiscImg removeFromSuperview];
    }
    
    generatedDiscImg = [self.channelDiscFactory createChannelDiscViewForChannel:channel withImageNamed:@"channel-ident.png" atVerticalPosition:Ypos atHorizontalPosition:Xpos];
    
    [self.channelDiscView addSubview:generatedDiscImg];
}


-(void)visualiseCorrectImageWithinImagePIGAccordingToStartTime:(NSDate *) programStartTime
                                                    AndEndTime:(NSDate*) programEndTime
                                            AndTypeOfInfopanel:(NSString*) infoPanelType
{
    NSDate *currentTime = [NSDate date];
    
    if ([currentTime compare:programStartTime] == NSOrderedAscending) {
        videoPlayable = NO;
        
    }else if ([currentTime compare:programEndTime] == NSOrderedDescending) {
        videoPlayable = YES;
        selectedProgrammeState = @"catchup";
        
        [self.playVideoBtn setImage:[UIImage imageNamed:@"channel-info-catchup-btn"] forState:UIControlStateNormal];
        [self.playVideoBtn setHidden:NO];
        
    }else {
        videoPlayable = YES;
        selectedProgrammeState = @"live";
        
        [self.playVideoBtn setImage:[UIImage imageNamed:@"channel-info-play-btn"] forState:UIControlStateNormal];
        [self.playVideoBtn setHidden:NO];
    }
}

@end
