//
//  XumoVideoView.h
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 13/08/2012.
//
//

#import <UIKit/UIKit.h>
#import "XumoVideoPlayer.h"

@interface XumoVideoView : UIView<XumoVideoPlayerObserver>

@property(weak) IBOutlet UIView *loadingView;     // View to show when loading
@property(weak) IBOutlet UIView *playingView;     // View to show when playing video
@property(weak) IBOutlet UIView *initialView;     // View to show when not playing video
//@property(weak) IBOutlet UIView *stallView;       // View to show when player stalls
@property(weak) IBOutlet UIView * stallView;

@property(weak,nonatomic) IBOutlet XumoVideoPlayer *xumoPlayer;

-(void)cleanupVideo;

#pragma mark XumoVideoPlayerObserver
-(void)player:(XumoVideoPlayer*)player hasNewAVPlayer:(AVPlayer*)avPlayer;
-(void)player:(XumoVideoPlayer*)player stateDidChangeTo:(enum XumoVideoPlayerState)state;

@end
