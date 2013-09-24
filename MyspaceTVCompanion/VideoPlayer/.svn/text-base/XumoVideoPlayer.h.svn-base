//
//  XumoVideoPlayer.h
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 02/07/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import <CoreMedia/CMTime.h>
#import <CoreMedia/CMTimeRange.h>

@class XumoVideoPlayer;
@class VideoItem;
@class AVPlayer;
@class AVPlayerLayer;

enum XumoVideoPlayerState
{
    XVPNotLoaded,               // Initial state, no video loaded
    XVPStopped = XVPNotLoaded,
    XVPLoading,                 // Currently loading video, will transition to playin or paused when done
    XVPSeeking,
    XVPPlaying,                 // Playing video, will transtion to:
                                //          paused if pause is called
                                //          stalled if network problems
                                //          stopped if stop is called
    XVPPaused,                  // Paused, will transtion to:
                                //          play if play is called
                                //          stopped if stop is called
    XVPFinished,                // Reached the end of the stream 
    XVPStalled,                 // Network problems, temporarily causing problems
    XVPError                    // Perminant un-recoverable error, call loadVideo to restart video
};

//What type of video asset are we playing?
enum XumoVideoPlayerType
{
    XVPTypeUnknown,             // Dont know yet
    XVPTypeLive,                // Livestream and at live point
    XVPTimeshift,               // Livestream but not at live point
    XVPTypeCatchup,             // Catchup asset
    XVPTypeVOD                  
};


@protocol XumoVideoPlayerObserver
@optional
-(void)player:(XumoVideoPlayer*)player hasNewAVPlayer:(AVPlayer*)avPlayer;

/**
 Play back state will change to a new state.
 */
-(void)player:(XumoVideoPlayer*)player stateWillChangeTo:(enum XumoVideoPlayerState)state;

/**
    Play back state did change to a new state.
*/
-(void)player:(XumoVideoPlayer*)player stateDidChangeTo:(enum XumoVideoPlayerState)state;

/**
    The video item has changed because either loadVideo was called or live/timeshift playback
    went to a new program in the stream. UI Should respond and update
*/
-(void)player:(XumoVideoPlayer*)player hasNewVideoItem:(VideoItem*)newVideoItem;
@end

@interface XumoVideoPlayer : NSObject

//Current video item we are playing
@property(readonly) VideoItem    *videoItem;

@property(readonly) BOOL autoPlay;      // We are gonna start playing when the video is loaded or start paused

@property(readonly) enum XumoVideoPlayerState state;
@property(readonly) enum XumoVideoPlayerType type;

@property(nonatomic) NSString *videoGravity; //indicates how the video is displayed within a player layer’s bounds rect.

@property BOOL isFullscreen;    //indicates is video play in fullscreen.


// Time properties
// - In live and timeshifted stream times are all absolute relative to unix epoc
// - In catchup and in vod the are relative to the start of the asset

// Playback time of current item
@property(readonly) CMTime currentTime;

// Time window of seekable time
@property(readonly) CMTimeRange seekableTimeWindow;

// Time window of the current playingItem
@property(readonly) CMTimeRange currentItemTimeWindow;

#pragma mark Playback controls

//Load a video and optionally start playing again
-(void)loadVideo:(VideoItem *)item andAutoPlay:(BOOL)autoPlay;

//Stop playback permanantly, will need to call loadVideo to start playback again
-(void)stop;

//If paused resume playback otherwise do nothing
-(void)play;

//If playing pause video otherwise do nothing
-(void)pause;

//Seek to an absoute time, if type is XVPLive will bcome XVPTimshift
-(void)seekTo:(CMTime)time;

// Seek by a relative amount, if type is XVPLive will bcome XVPTimshift
-(void)seekBy:(float)seconds;

// If type is XVPTimeshift, returns to live point and sets state to live
-(void)returnToLive;

#pragma mark Observers

// Observe the state of the video player, any observers added are NOT retained
// You must call removeObserver before releasing the observing object
// A good idea is to add a call to removeObsever in the objects dealloc method
-(void)addObserver:(id<XumoVideoPlayerObserver>)observer;
-(void)removeObserver:(id<XumoVideoPlayerObserver>)observer;

@end
