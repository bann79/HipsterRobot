//
//  XumoVideoView.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 13/08/2012.
//
//

#import "XumoVideoView.h"
#import <AVFoundation/AVFoundation.h>

@interface XumoVideoPlayer(Private)
@property AVPlayer *player;
@property AVPlayerLayer *playerLayer;
@end

@implementation XumoVideoView {
    AVPlayerLayer *playerLayer;
    CALayer *videoHolder;
    
    //Size and parent layer from where we steal the video layer
    __weak CALayer *previousViewParentLayer;
}


-(void)setXumoPlayer:(XumoVideoPlayer*)newXumoPlayer
{
    [_xumoPlayer removeObserver:self];
   
    _xumoPlayer = newXumoPlayer;
    [_xumoPlayer addObserver:self];
    [self player:newXumoPlayer stateDidChangeTo:newXumoPlayer.state];
    [self player:newXumoPlayer hasNewAVPlayer:newXumoPlayer.player];
}

-(void)cleanupVideo
{
    //remove videolayer
    [playerLayer removeFromSuperlayer];
    [videoHolder removeFromSuperlayer];
    videoHolder = nil;
    
    // Restore the old XumoVideoView
    if(previousViewParentLayer){
        [previousViewParentLayer insertSublayer:playerLayer atIndex:0];
       
        playerLayer = nil;
        previousViewParentLayer = nil;
    }
}

-(void)dealloc
{
    [self cleanupVideo];
    [_xumoPlayer removeObserver:self];
}

-(void)player:(XumoVideoPlayer*)player hasNewAVPlayer:(AVPlayer*)avPlayer
{
    
    if(!videoHolder){
        videoHolder = [CALayer layer];
        videoHolder.sublayerTransform = CATransform3DMakeScale( self.bounds.size.width / 1024,  self.bounds.size.height / 768, 1);
        [self.layer insertSublayer:videoHolder atIndex:0];
    }
    
    playerLayer = player.playerLayer;
    
    // If the playerLayer already has a superlay its because we are stealing
    // from another instance of XumoVideoView, store it for later so we can 
    // give it back
    if(playerLayer.superlayer){
        previousViewParentLayer = playerLayer.superlayer;
        //clean up current player layer; and set background as black;
        playerLayer.sublayers = nil;
        playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
        [playerLayer removeFromSuperlayer];
    }
    
    [videoHolder addSublayer:playerLayer];
}

-(void)player:(XumoVideoPlayer*)player stateDidChangeTo:(enum XumoVideoPlayerState)state
{
    _playingView.hidden  = (state == XVPNotLoaded || state == XVPLoading || state == XVPFinished);
    _initialView.hidden  = !_playingView.isHidden;
    
    if(state == XVPStalled)
    {
         NSLog(@"state Changed to : %d",state);
    }
    
   
    
    //Note: At the moment, no visual difference between stalled and loading...Need to review this.
    //_stallView.hidden    = !(state == XVPStalled);
    _loadingView.hidden  = !(state == XVPLoading || state == XVPSeeking || state == XVPStalled);
}

@end
