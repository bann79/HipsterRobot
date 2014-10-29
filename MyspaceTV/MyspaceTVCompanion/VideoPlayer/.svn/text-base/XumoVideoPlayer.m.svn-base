//
//
//  XumoVideoPlayer.m
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 02/07/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//


#import <CoreFoundation/CoreFoundation.h>
#import <AVFoundation/AVFoundation.h>

#import "XumoVideoPlayer.h"
#import "XMPPClient.h"
#import "VideoItem.h"

#import "DDLog.h"

//Number of seconds we will tollerate being behind live 
static const int acceptableLiveTollerance = 10;

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation XumoVideoPlayer {
    NSMutableArray *observers;
    NSTimer* updateTimer;
    NSDate* playlistStartDate;      //Time point of which the live playist starts
    
    AVPlayer *player;
    AVPlayerItem *playerItem;
    AVPlayerLayer *playerLayer;
    
    CMTime lastSeekTime;
    
    BOOL isFetchingNewItem;
}

#pragma mark Initialisation

-(id)init
{
    self = [super init];

    isFetchingNewItem = NO;
    
    // Create a mutable set that does not retain its members
    observers = (NSMutableArray *)CFBridgingRelease(CFArrayCreateMutable(nil, 0, nil));
    return self;
}


// KVO Obsevers can be trixy, be careful make sure to match any addObserver calls with removeObserver

-(void)dealloc
{
    [self removeObservers];
}

-(void)addObservers
{
    [playerItem addObserver:self forKeyPath:@"status" options:0 context:NULL];
    [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:0 context:nil];
    [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:0 context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[player currentItem]];
}

-(void)removeObservers 
{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[player currentItem]];
}

#pragma mark State transitions


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    DDLogInfo(@"Value changed %@ to %@", keyPath, object);
    
    if([keyPath isEqualToString:@"status"])
    {
        if([playerItem status] == AVPlayerItemStatusReadyToPlay && _state == XVPLoading){
            
            DDLogInfo(@"Video item is read to play");
            
            [self setState:XVPPlaying];
            
            if(!_autoPlay){
                [self pause];
            }else{
                [player play];
            }
        }
    }
    
    if([keyPath isEqualToString:@"playbackBufferEmpty"]){
        
        DDLogVerbose(@"playerItem.isPlaybackBufferEmpty = %d", playerItem.isPlaybackBufferEmpty);
        
        if(_state == XVPPlaying && playerItem.isPlaybackBufferEmpty){
            DDLogWarn(@"Player Stall!!!");
            [self setState:XVPStalled];
        }
    }
    
    if([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){
    
        DDLogVerbose(@"playerItem.isPlaybackLikelyToKeepUp = %d", playerItem.isPlaybackLikelyToKeepUp);
        
        if(_state == XVPStalled && playerItem.isPlaybackLikelyToKeepUp){
            DDLogInfo(@"Playback resumed arfter stall");
            [self setState:XVPPlaying];
        }
    }

}

-(void)setState:(enum XumoVideoPlayerState)newState
{
    for(NSObject<XumoVideoPlayerObserver> *observer in observers){
        if([observer respondsToSelector:@selector(player:stateWillChangeTo:)])
            [observer player:self stateWillChangeTo:newState];
    }
    
    switch (newState){
        case XVPNotLoaded:
            DDLogInfo(@"State: Stopped");
            break;
        case XVPLoading:
            DDLogInfo(@"State: Loading");
            break;
        case XVPSeeking:
            DDLogInfo(@"State: Seeking");
            break;
        case XVPPaused:
            DDLogInfo(@"State: Paused");
            break;
        case XVPPlaying:
            
            DDLogInfo(@"State: Playing");
            
            if(_state == XVPLoading){
                [self onInitialPlaybackStarted];
            }
            
            break;
        case XVPFinished:
            DDLogInfo(@"State: Finished");
            break;
        case XVPStalled:
            DDLogInfo(@"State: Stalled");
            break;
        case XVPError:
            DDLogInfo(@"State: Error");
            break;
    }
    
    _state = newState;
    
    for(NSObject<XumoVideoPlayerObserver> *observer in observers){
        if([observer respondsToSelector:@selector(player:stateDidChangeTo:)])
            [observer player:self stateDidChangeTo:newState];
    }
}

-(void)setType:(enum XumoVideoPlayerType)t
{
    switch (t) {
        case XVPTypeCatchup:
            DDLogInfo(@"Video is catchup");
            break;
        case XVPTypeLive:
            DDLogInfo(@"Video is live");
            break;
        default:
            DDLogInfo(@"Treating video as unknown");
            break;
    }
    
    _type = t;
}

-(void)setVideoItem:(VideoItem *)newVideoItem
{
    _videoItem = newVideoItem;
    
    for(NSObject<XumoVideoPlayerObserver> *observer in observers){
        if([observer respondsToSelector:@selector(player:hasNewVideoItem:)])
            [observer player:self hasNewVideoItem:newVideoItem];
    }
    
    if (newVideoItem){
        [[XMPPClient sharedInstance].watchingApi setWatching:_videoItem.currentProgram onChannel:_videoItem.currentChannel];
    }else{
        [[XMPPClient sharedInstance].watchingApi setStoppedWatching];
    }
}

-(void)setPlayer:(AVPlayer *)newPlayer
{
    player = newPlayer;
    
    playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = CGRectMake(0, 0, 1024, 768);
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;

    for(NSObject<XumoVideoPlayerObserver> *observer in observers){
        if([observer respondsToSelector:@selector(player:hasNewAVPlayer:)])
            [observer player:self hasNewAVPlayer:newPlayer];
    }
}

-(void)onInitialPlaybackStarted
{
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimerFired:) userInfo:nil repeats:YES];
    
    if(_type == XVPTypeLive){
        
        CMTimeRange tr = [[playerItem.seekableTimeRanges lastObject] CMTimeRangeValue];
        
        NSTimeInterval duration = CMTimeGetSeconds(tr.duration);
        
        DDLogInfo(@"Duration of playlist is %f",duration);
        
        playlistStartDate = [NSDate dateWithTimeIntervalSinceNow:-duration];
        
        DDLogInfo(@"Live playlist start time is %@",playlistStartDate);
    }
}

-(void)setVideoGravity:(NSString *)videoGravity
{
    playerLayer.videoGravity = videoGravity;
}

-(NSString *)videoGravity
{
    return playerLayer.videoGravity;
}

#pragma mark Playback controls



-(void)loadVideo:(VideoItem *)item andAutoPlay:(BOOL)shouldAutoPlay
{
//    item.currentProgram = nil;
   //item.streamUrl = @"http://10.10.166.10/media/elephantsdream-1024-h264-st-aac.mov";
    
    if(self.state != XVPStopped){
        [self stop];
    }
    
    DDLogInfo(@"Loading video: %@",item.streamUrl);
    
    //Dont want to notify observers
    _videoItem = item;
    
    //But we do want watching information sent
    [[XMPPClient sharedInstance].watchingApi setWatching:_videoItem.currentProgram onChannel:_videoItem.currentChannel];
    
    _autoPlay = shouldAutoPlay;
    
    
    playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:item.streamUrl]];
    
    if(item.currentProgram){
        if([item.currentProgram isCatchup]){
            [self setType:XVPTypeCatchup];
        }else{
            [self setType:XVPTypeLive];
        }
    }else{
        [self setType:XVPTypeUnknown];
    }
    
     
    [self setPlayer:[AVPlayer playerWithPlayerItem:playerItem]];
    [self setState:XVPLoading];
    
    //update video item for all observer.
    [self setVideoItem:item];
    
    if(!_autoPlay){
        player.rate = 0.0f;
    }
    
    [self addObservers];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    DDLogCVerbose(@"current player notification %@", notification);
    [self setState:XVPFinished];
}

-(void)stop
{
    if(self.state != XVPStopped){
    
        [self setState:XVPStopped];
        
        [updateTimer invalidate];
        updateTimer = nil;
        
        [player pause];
        [self removeObservers];
        
        [self setPlayer:nil];
        playerItem = nil;
        [self setVideoItem:nil];
        
    }
}

-(void)play
{
    if (_state == XVPPaused) {
        [player play];
        [self setState:XVPPlaying];
    }
}

-(void)pause
{
    if(_state == XVPPlaying) {
        
        if(_type == XVPTypeLive)
        {
            [self setType:XVPTimeshift];
        }
        
        [player pause];
        [self setState:XVPPaused];
    }
}

-(CMTime)currentTime
{
    CMTime time = playerItem.currentTime;
    
    if(_state == XVPSeeking)
    {
        time = lastSeekTime;
    }
    
    if(_type == XVPTypeLive || _type == XVPTimeshift)
    {
        return CMTimeAdd(CMTimeMakeWithSeconds([playlistStartDate timeIntervalSince1970], 1000), time);
    }
    
    return time;
}


-(CMTimeRange)seekableTimeWindow
{
    //Only ever one seekable time range for HLS assets
    CMTimeRange range = [[[playerItem seekableTimeRanges] lastObject] CMTimeRangeValue];
    
    if(_type == XVPTypeLive || _type == XVPTimeshift){
       range.start = CMTimeAdd(range.start, CMTimeMakeWithSeconds([playlistStartDate timeIntervalSince1970], 1000));
    }
    
    return range;
}


-(CMTimeRange)currentItemTimeWindow
{
    if(_type == XVPTypeLive || _type == XVPTimeshift)
    {
        
        NSDate *start = _videoItem.currentProgram.startTime;
        NSDate *end = _videoItem.currentProgram.endTime;
        
        NSTimeInterval startUnix = [start timeIntervalSince1970];
        NSTimeInterval duration = [end timeIntervalSinceDate:start];
        
        return  CMTimeRangeMake(CMTimeMakeWithSeconds(startUnix, 1000),CMTimeMakeWithSeconds(duration,1000));
    }
    
    return CMTimeRangeMake(CMTimeMake(0, 1), playerItem.duration);
}

-(void)doSeekTo:(CMTime)streamTime
{
    if(_state != XVPPlaying &&
       _state != XVPPaused &&
       _state != XVPSeeking &&
       _state != XVPStalled)
        return;
    
    if(_type == XVPTypeLive){
        [self setType:XVPTimeshift];
    }
    
    lastSeekTime = streamTime;
    
    BOOL wasPaused = (_state == XVPPaused);
    
    [self setState:XVPSeeking];
    
    DDLogInfo(@"seeking to time: %f", CMTimeGetSeconds(streamTime));
    
    [playerItem seekToTime:streamTime completionHandler:^(BOOL finished) {
        
        if(wasPaused)
        {
            
            [self setState:XVPPaused];
        }else{
            [self setState:XVPPlaying];
        }
    }];
}


-(void)seekBy:(float)seconds
{
    CMTime t = CMTimeAdd(playerItem.currentTime, CMTimeMakeWithSeconds(seconds, 1000));
    
    if(_state == XVPSeeking)
    {
        [playerItem cancelPendingSeeks];
        t = CMTimeAdd(lastSeekTime, CMTimeMakeWithSeconds(seconds, 1000));
    }
    
    [self doSeekTo:t];
}

-(void)seekTo:(CMTime)time
{
    if(_type == XVPTimeshift || _type == XVPTypeLive){
        time = CMTimeSubtract(time, CMTimeMakeWithSeconds([playlistStartDate timeIntervalSince1970], 1000));
    }
    
    if(_state == XVPSeeking)
    {
        [playerItem cancelPendingSeeks];
    }
    
    [self doSeekTo:time];
}

-(void)returnToLive
{
    if(_type != XVPTimeshift)
        return;
    
    [self setType:XVPTypeLive];
    [self doReturnToLive];
}

-(void)doReturnToLive
{
    //Only ever one seekable time range for HLS assets
    CMTimeRange range = [[[playerItem seekableTimeRanges] lastObject] CMTimeRangeValue];
    
    CMTime t = CMTimeRangeGetEnd(range);
    
    [self setState:XVPSeeking];
    [playerItem seekToTime:t completionHandler:^(BOOL finished) {
        [self setState:XVPPlaying];
    }];
}

#pragma mark Observers


-(void)addObserver:(id<XumoVideoPlayerObserver>)observer
{
    [observers addObject:observer];
}

-(void)removeObserver:(id<XumoVideoPlayerObserver>)observer
{
    [observers removeObject:observer];
}

#pragma mark Program transitions


-(void)updateTimerFired:(NSTimer*)t
{
    //When live streaming maintain 
    if(_type == XVPTypeLive && _state == XVPPlaying){
        
        double timeFromLive = CMTimeGetSeconds(self.currentTime) - [[NSDate date] timeIntervalSince1970];
        
        if(-timeFromLive > acceptableLiveTollerance){
            DDLogWarn(@"Fell to far behind live, seeking to catchup");
            [self doReturnToLive];
        }
    }
    
    if((_type == XVPTypeLive || _type == XVPTimeshift) && !isFetchingNewItem && _state == XVPPlaying)
    {
        CMTime now = self.currentTime;
        
        CMTimeRange range = self.currentItemTimeWindow;
        
        range.start = CMTimeSubtract(range.start, CMTimeMakeWithSeconds(20,1000));
        range.duration = CMTimeAdd(range.duration, CMTimeMakeWithSeconds(40,1000));
        
        if(!CMTimeRangeContainsTime(range, now)){
         
            DDLogInfo(@"Playback time outside of current item ... getting new item");
            
            NSDate *start = [NSDate dateWithTimeIntervalSince1970:CMTimeGetSeconds(now)];
            NSDate *end = [NSDate dateWithTimeIntervalSince1970:CMTimeGetSeconds(now) + 60 * 5];
            
            isFetchingNewItem = YES;
            
            [[EpgApi sharedInstance] getScheduleForChannel:_videoItem.currentChannel.callSign startingAt:start endingAt:end andCall:^(NSArray *data, NSError *error){
               
                isFetchingNewItem = NO;
                
                if(error){
                    DDLogError(@"Unable to get new video program!!!!! \r\n%@",error);
                }else{
                    
                    Programme *newProgam = [data objectAtIndex:0];
                    
                    DDLogInfo(@"New program is %@",newProgam.name);
                    
                    VideoItem *newVideoItem = [VideoItem alloc];
                    newVideoItem.currentChannel = _videoItem.currentChannel;
                    newVideoItem.currentProgram = newProgam;
                    newVideoItem.streamUrl = _videoItem.streamUrl;
                    
                    [self setVideoItem:newVideoItem];
                }
                
            }];
            
        }
    }
}

#pragma mark Test support

-(AVPlayer*)player
{
    return player;
}

-(AVPlayerLayer*)playerLayer
{
    return playerLayer;
}

-(AVPlayerItem*)playerItem
{
    return playerItem;
}

-(void)setPlayerItem:(id)_playerItem
{
    playerItem = _playerItem;
}

-(NSDate*)playlistStartDate
{
    return playlistStartDate;
}
-(void)setPlaylistStartDate:(NSDate*)d
{
    playlistStartDate = d;
}



@end
