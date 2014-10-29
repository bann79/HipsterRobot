//
//  VideoViewController.h
//  MyspaceTVCompanion
//
//  Created by Bann Al-Jelawi on 13/08/2012.
//
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "XumoVideoPlayer.h"
#import "XumoVideoView.h"
#import "AppDelegate.h"
#import "AppViewController.h"
#import "ProgressBarView.h"
#import "ChannelBarViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "UIMaskedArcControl.h"

@class ChannelBarViewController;

@interface VideoViewController : UIViewController<XumoVideoPlayerObserver>

@property(weak, nonatomic) IBOutlet ProgressBarView *scrubberView;

@property(weak, nonatomic) IBOutlet UIView *topControls;
@property (weak, nonatomic) IBOutlet UIView *bottomControls;

@property(setter = addChildViewController:, nonatomic) IBOutlet ChannelBarViewController *channelBar;

#pragma mark Transport Controls
@property(weak, nonatomic) IBOutlet UIButton *doneBtn;
@property(weak, nonatomic) IBOutlet UIButton *rewindBtn;
@property(weak, nonatomic) IBOutlet UIButton *playPauseBtn;
@property(strong, nonatomic) IBOutlet MPVolumeView *volumeControl;

@property(weak, nonatomic) IBOutlet XumoVideoView *videoView;
@property(weak, nonatomic) IBOutlet XumoVideoPlayer *currentPlayer;
@property(weak, nonatomic) IBOutlet UIMaskedArcControl * arcVolumeControl;

@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *singleTapGesture;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapGesture;
@property (weak, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchGesture;

@property BOOL isVideoPlaying;

@property(strong, nonatomic) UISlider * volumeControlSlider;

@property BOOL controlsVisible;
@property CGRect piGBound;

-(id)initWithPlayer:(XumoVideoPlayer*)player;

#pragma mark Transport Control Methods
-(IBAction)touchedPlayPause:(UIButton *)sender;
-(IBAction)touchedRewind:(UIButton *)sender;
-(IBAction)touchedDone:(UIButton *)sender;

#pragma mark gestures handling
- (IBAction)onVideoViewSingleTapped:(UITapGestureRecognizer *)sender;
- (IBAction)onVideoViewDoubleTapped:(UITapGestureRecognizer *)sender;
- (IBAction)onVideoViewPinchedIn:(UIPinchGestureRecognizer *)sender;

#pragma mark XumoVideoPlayerObserver
-(void)player:(XumoVideoPlayer *)player stateDidChangeTo:(enum XumoVideoPlayerState)state;

#pragma mark Transitions

-(void)transitionInFromView:(UIView*)view withPlayerStatus:(BOOL) playerState;
-(void)transitionOut;

-(void)setControlsVisible:(BOOL)visible animated:(BOOL)animated;

@end
