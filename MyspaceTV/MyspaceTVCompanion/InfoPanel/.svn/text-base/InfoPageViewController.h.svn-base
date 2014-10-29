//
//  InfoPageViewController.h
//  MyspaceTVCompanion
//
//  Created by Dyfan Hughes on 26/06/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LazyLoadImageView.h"
#import "CircularImageButton.h"
#import "XMPPClient.h"
#import "XumoVideoView.h"
#import "PiGTransportViewController.h"
#import "ProgramTimeConverter.h"

@class Channel, Programme;
@class ChannelDiscFactory;
@class CatchupUrlGenerator;
@class VideoItem, XumoVideoPlayer;
@class PiGTransportViewController;

@protocol InfoPageDelegate <NSObject>

-(void)infoPageClosed;

@end

static NSString *const INFO_IN_CHANNEL_BAR = @"InfoPanelInChannelBarMode";
static NSString *const INFO_IN_NORMAL_MODE = @"InfoPanelInNormalMode";

@interface InfoPageViewController : UIViewController<XumoVideoPlayerObserver>


@property (weak, nonatomic) IBOutlet UILabel *startTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *startDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *subHeadingLbl;
@property (weak, nonatomic) IBOutlet UILabel *durationLbl;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTxt;
@property (weak, nonatomic) IBOutlet LazyLoadImageView *lazyLoadImage;
@property (weak, nonatomic) IBOutlet UIButton *playVideoBtn;
@property (weak, nonatomic) IBOutlet XumoVideoView *videoView;
@property (weak, nonatomic) IBOutlet UIView *avatarHolder;
@property (weak, nonatomic) IBOutlet UIButton *syncInfoButton;

@property (weak, nonatomic) IBOutlet UIView *channelDiscView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *exitModalButton;
@property (weak, nonatomic) IBOutlet UIImageView *darkBorder;
@property (weak, nonatomic) IBOutlet UIImageView *lightBorder;

// Watching SubView
@property (weak, nonatomic) IBOutlet UIView *watchingSubView;
@property (weak, nonatomic) IBOutlet UIButton *watchingButton;
@property (weak, nonatomic) IBOutlet UILabel *friendsWatchingAnnotation;

//Data handlers / Models
@property (strong, nonatomic)ChannelDiscFactory * channelDiscFactory;
@property (strong, nonatomic)CatchupUrlGenerator * catchUpURLGenerator;
@property (strong, nonatomic)Programme * currentProgram;
@property (strong, nonatomic)Channel * currentChannel;

@property (strong, nonatomic) UIImageView * generatedDiscImg;


// VideoConsumption
@property (strong, nonatomic) IBOutlet XumoVideoPlayer* videoPlayer;

@property BOOL videoPlayable;
@property (strong, nonatomic)NSString * selectedProgrammeState;
@property (strong, nonatomic)NSString * correctVideoFeed;
@property (strong, nonatomic)NSString * resultantFeed;

@property (strong, nonatomic)NSString * typeOfInfoPanel;

@property (weak, nonatomic) id infoPageDelegate;
@property (weak, nonatomic) IBOutlet UIScrollView *watchingViewFriends;

@property (strong, nonatomic) IBOutlet PiGTransportViewController *pigController;
@property (strong, nonatomic) ProgramTimeConverter * timeConverter;

-(void)transitionIn;
-(void)transitionOut;
-(void)populateElementsWithChannel:(Channel *)channel andProgram:(Programme *)program;
-(void) populateSubheadingAndSynopsis:(NSString *)url;

-(void)updateFriendsWatching:(Programme*)program;


-(void)createChannelDiscWithChannelObject:(Channel*)channel 
                                 WithXPos:(int) Xpos 
                                  AndYPos:(int) Ypos
                           AndAddedToView:(UIView*) view;
-(void)visualiseCorrectImageWithinImagePIGAccordingToStartTime:(NSDate *) programStartTime
                                                    AndEndTime:(NSDate*) programEndTime AndTypeOfInfopanel:(NSString*) infoPanelType;


-(IBAction)onWatchingTouched;
-(IBAction)onPlayTouched:(id)sender;
-(IBAction)onExitModalAreaTouched:(UIButton *)sender;
-(IBAction)onSyncInfoPressed:(id)sender;

-(void)transitionIn;
-(void)transitionOut;

-(void)player:(XumoVideoPlayer *)player hasNewVideoItem:(VideoItem *)newVideoItem;

@end
