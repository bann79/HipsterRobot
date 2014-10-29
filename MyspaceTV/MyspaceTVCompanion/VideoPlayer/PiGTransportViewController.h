//
//  PiGTransportViewController.h
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 15/08/2012.
//
//

#import <UIKit/UIKit.h>
#import "XumoVideoPlayer.h"
#import "VideoViewController.h"

@class VideoViewController;


@interface PiGTransportViewController : UIViewController<XumoVideoPlayerObserver>

@property (weak, nonatomic) IBOutlet UIView *playerControllerView;
@property (weak, nonatomic) IBOutlet UIButton *playPauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *goFullscreen;
@property (weak, nonatomic) IBOutlet XumoVideoPlayer *xumoPlayer;
@property (nonatomic) BOOL controlsVisible;
@property BOOL isPIGVideoPlaying;

@property (weak, nonatomic) IBOutlet ProgressBarView *scrubView;

-(void) setControlsVisible:(BOOL)controlsVisible;

- (IBAction)onPlayPauseTouched:(id)sender;
- (IBAction)onFullscreenTouched:(id)sender;

- (IBAction)onPlayerTouched:(UITapGestureRecognizer *)sender;
- (IBAction)onPlayerPinched:(UIPinchGestureRecognizer *)sender;

-(void)player:(XumoVideoPlayer *)player stateDidChangeTo:(enum XumoVideoPlayerState)state;

#pragma mark control handling
-(void)launchFullscreenVideoPlayer;

@end
