//
//  XumoVideoPlayerTest.m
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 02/07/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>

#import <SenTestingKit/SenTestingKit.h>
#import "XumoVideoPlayer.h"
#import "VideoItem.h"

#import <OCMock/OCMock.h>
#import "TestUtils.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface EpgApi(Test)
+(void)setSharedInstance:(EpgApi*)instance;
@end

@interface XumoVideoPlayer(Test)

//Expose hidden methods
-(void)addObservers;
-(void)removeObservers;

-(void)setState:(enum XumoVideoPlayerState)state;
-(void)setType:(enum XumoVideoPlayerType)type;

@property AVPlayer *player;
@property AVPlayerItem *playerItem;
-(void)setVideoItem:(id)item;

-(void)onInitialPlaybackStarted;

@property NSDate* playlistStartDate;

-(void)updateTimerFired:(NSTimer*)t;
@end

@interface XumoVideoPlayerTest : SenTestCase
@end

@implementation XumoVideoPlayerTest
{
    XumoVideoPlayer *player;
    VideoItem *videoItem;
    id mockAvPlayer;
    id mockAvPlayerItem;
}

-(void) setUp
{
    player = [[XumoVideoPlayer alloc] init];
    
    mockAvPlayer = [OCMockObject niceMockForClass:[AVPlayer class]];
    mockAvPlayerItem = [OCMockObject niceMockForClass:[AVPlayerItem class]];
    
    videoItem = [VideoItem alloc];
    
    videoItem.currentChannel = [Channel alloc];
    
    videoItem.currentProgram = [Programme alloc];
    videoItem.currentProgram.programmeID = @"program-id";
    videoItem.currentProgram.name = @"program-name";
    
    
    videoItem.streamUrl = @"http://someserver.com/playlist.m3u8";
}


-(void)tearDown
{
    [mockAvPlayer verify];
    [mockAvPlayerItem verify];
}

-(void)testInitNewPlayerObservesKeys
{
    id partial = [OCMockObject partialMockForObject:player];
    
    [[partial expect] addObservers];
    
    [partial loadVideo:videoItem andAutoPlay:YES];
    
    [partial verify];
}

-(void)testAddObservers
{
    [[mockAvPlayerItem expect] addObserver:player forKeyPath:@"status" options:0 context:0];
    [[mockAvPlayerItem expect] addObserver:player forKeyPath:@"playbackBufferEmpty" options:0 context:0];
    [[mockAvPlayerItem expect] addObserver:player forKeyPath:@"playbackLikelyToKeepUp" options:0 context:0];
    
    [player setPlayerItem:mockAvPlayerItem];
    
    [player addObservers];
}


-(void)testLoadVideoCreatesVideoItem
{
    [player loadVideo:videoItem andAutoPlay:YES];
    
    STAssertEqualObjects(player.videoItem, videoItem, @"Video item set");
    STAssertNotNil(player.playerItem, @"Player item created");
}

-(void)testLoadVideoCreatesPlayer
{
    [player loadVideo:videoItem andAutoPlay:YES];
    
    STAssertNotNil(player.player, @"New player ctreated");
}

-(void)testLoadVideoSetCorrectState
{
    [player loadVideo:videoItem andAutoPlay:YES];
    
    STAssertEquals(player.state, XVPLoading, @"State is now loading");
}

-(void)testUpdateStatusGoesToPlaying
{
    [player loadVideo:videoItem andAutoPlay:YES];

    [player setPlayerItem:mockAvPlayerItem];
    [[[mockAvPlayerItem expect] andReturnValue:[NSNumber numberWithUnsignedInt:AVPlayerItemStatusReadyToPlay]] status];
    
    [player observeValueForKeyPath:@"status" ofObject:mockAvPlayerItem change:nil context:0];
    
    STAssertEquals(player.state, XVPPlaying, @"Player should now be playing");
}

-(void)testUpdateStatusGoesToPaused
{
    [player loadVideo:videoItem andAutoPlay:NO];
    
    [player setPlayerItem:mockAvPlayerItem];
    [[[mockAvPlayerItem expect] andReturnValue:[NSNumber numberWithUnsignedInt:AVPlayerItemStatusReadyToPlay]] status];
    
    [player observeValueForKeyPath:@"status" ofObject:mockAvPlayerItem change:nil context:0];
    
    STAssertEquals(player.state, XVPPaused, @"Player should now be paused");
}

-(void)testSetStateCallsObservers
{
    id mockObserver = [OCMockObject mockForProtocol:@protocol(XumoVideoPlayerObserver)];
    [player addObserver:mockObserver];
    
    [[mockObserver expect] player:player stateWillChangeTo:XVPLoading];
    [[mockObserver expect] player:player stateDidChangeTo:XVPLoading];
    [player setState:XVPLoading];
    
    
    [[mockObserver expect] player:player stateWillChangeTo:XVPPlaying];
    [[mockObserver expect] player:player stateDidChangeTo:XVPPlaying];
    [player setState:XVPPlaying];
    
    
    [[mockObserver expect] player:player stateWillChangeTo:XVPStopped];
    [[mockObserver expect] player:player stateDidChangeTo:XVPStopped];
    [player setState:XVPStopped];
    
    [[mockObserver expect] player:player stateWillChangeTo:XVPStalled];
    [[mockObserver expect] player:player stateDidChangeTo:XVPStalled];
    [player setState:XVPStalled];
    
    [[mockObserver expect] player:player stateWillChangeTo:XVPPaused];
    [[mockObserver expect] player:player stateDidChangeTo:XVPPaused];
    [player setState:XVPPaused];
                       
    [player removeObserver:mockObserver];
    [mockObserver verify];
}

-(void)testObserverCalledOnNewPlayer
{
    id mockObserver = [OCMockObject niceMockForProtocol:@protocol(XumoVideoPlayerObserver)];
    [player addObserver:mockObserver];
    
    [[mockObserver expect] player:player hasNewAVPlayer:instanceOf([AVPlayer class])];
    
    [player loadVideo:videoItem andAutoPlay:YES];
    
    [player removeObserver:mockObserver];
    [mockObserver verify];
}

-(void)testObserverCalledOnNewVideoItem
{
    id mockObserver = [OCMockObject niceMockForProtocol:@protocol(XumoVideoPlayerObserver)];
    [player addObserver:mockObserver];
    
    [[mockObserver expect] player:player hasNewVideoItem:videoItem];
    
    [player setVideoItem:videoItem];
    
    [player removeObserver:mockObserver];
    [mockObserver verify];

}

-(void)testPlayDoesNothingWhenStopped
{
    [player play];
    
    STAssertEquals(player.state, XVPStopped, @"Should still be stopped");
}

-(void)testPlayDoesNothingWhenLoading
{
    [player setState:XVPLoading];
    
    [player play];
    
    STAssertEquals(player.state, XVPLoading, @"Should still be loading");
}

-(void)testPlayGoesToPlayingWhenPaused
{
    [player setState:XVPPaused];
    
    [player play];
    
    STAssertEquals(player.state, XVPPlaying, @"Should be playing");
}

-(void)testPauseDoesNothingWhenStopped
{
    [player pause];
    STAssertEquals(player.state, XVPStopped, @"Should still be stopped");
}

-(void)testPauseDoesNothingWhenLoading
{
    [player setState:XVPLoading];
    
    [player pause];
    
    STAssertEquals(player.state, XVPLoading, @"Should still be loading");
}

-(void)testPauseGoesToPausedWhenPlaying
{
    [player setState:XVPPlaying];
    
    [player pause];
    
    STAssertEquals(player.state, XVPPaused, @"Should be playing");
}

-(void)testObservingPlaybackBufferEmptyGoesToStalled
{
    [player setPlayerItem:mockAvPlayerItem];
    [[[mockAvPlayerItem stub] andReturnValue:[NSNumber numberWithBool:YES]] isPlaybackBufferEmpty];
    
    [player setState:XVPPlaying];

    [player observeValueForKeyPath:@"playbackBufferEmpty" ofObject:mockAvPlayerItem change:nil context:0];
    
    STAssertEquals(player.state, XVPStalled, @"Player is now stalled");
}

-(void)testObservingPlaybackLikelyToKeepUpRecoversFromStall
{
    
    [player setPlayerItem:mockAvPlayerItem];
    [[[mockAvPlayerItem stub] andReturnValue:[NSNumber numberWithBool:YES]] isPlaybackLikelyToKeepUp];
    
    [player setState:XVPStalled];

    [player observeValueForKeyPath:@"playbackLikelyToKeepUp" ofObject:mockAvPlayerItem change:nil context:0];
    
    STAssertEquals(player.state, XVPPlaying, @"Playing again");
}

-(void)testOnInitialPlaybackSetLivePlayListStart
{
    [player setType:XVPTypeLive];
    
    CMTimeRange mockSeekableRange = CMTimeRangeMake(CMTimeMake(0, 1), CMTimeMake(3600,1));
    
    NSArray *ranges = [NSArray arrayWithObject:[NSValue valueWithCMTimeRange:mockSeekableRange]];
    
    [[[mockAvPlayerItem expect] andReturn:ranges] seekableTimeRanges];
    
    [player setPlayerItem:mockAvPlayerItem];
    
    
    [player onInitialPlaybackStarted];
    
    STAssertNotNil(player.playlistStartDate, @"Live playlist start not nil");
    
    STAssertEqualsWithAccuracy([player.playlistStartDate timeIntervalSinceNow], -3600.0, 1, @"Live play list start time is correct");
}

-(void)testCurrentLiveTimeIsPlayerTimePlusLivePlaylistStart
{
    player.playlistStartDate = [NSDate dateWithTimeIntervalSince1970:10000];
    
    [player setType:XVPTypeLive];
    
    //10 Seconds in
    [(AVPlayerItem*)[[mockAvPlayerItem expect]
      andReturnValue:[NSValue valueWithCMTime:CMTimeMakeWithSeconds(10, 1000)]] currentTime];
    
    [player setPlayerItem:mockAvPlayerItem];
    
    
    CMTime current = [player currentTime];
    
    STAssertEquals(CMTimeGetSeconds(current), 10010.0, @"Correct current time returned");
}

-(void)testSeekBySetsStateToSeeking
{
   [player setState:XVPPlaying];
   
   [player seekBy:-10];
   
    STAssertEquals(player.state, XVPSeeking, @"Now seeking");
}

-(void)testSeekByDoesNothingIfStopped
{
    [player seekBy:-10];
    
    STAssertEquals(player.state, XVPStopped, @"Still stopped");
}

-(void)testUpdateTimerChangesToNewProgramWhenLive
{
    [player setState:XVPPlaying];
    [player setType:XVPTypeLive];
    [player setPlaylistStartDate:[NSDate date]];
    
    videoItem.currentChannel.callSign = @"callsign";
    
    videoItem.currentProgram.startTime = [NSDate dateWithTimeIntervalSinceNow:-60 * 10];
    videoItem.currentProgram.endTime = [NSDate dateWithTimeIntervalSinceNow:60 * 10];
    
    [player setVideoItem:videoItem];
    
    [(XumoVideoPlayer*)[[mockAvPlayerItem expect] andReturnValue:[NSValue valueWithCMTime:CMTimeMake(60*20000,1000)]] currentTime];
    [player setPlayerItem:mockAvPlayerItem];
    
    
    id mockEpgApi = [OCMockObject mockForClass:[EpgApi class]];
    [EpgApi setSharedInstance:mockEpgApi];
    
    
    void (^epgCallback)(NSArray*, NSError*) = nil;
    [[[mockEpgApi expect] andCaptureCallbackArgument:&epgCallback at:5] getScheduleForChannel:@"callsign" startingAt:[OCMArg any] endingAt:[OCMArg any] andCall:[OCMArg any]];
    
    
    [player updateTimerFired:nil];

    Programme* newProgram = [Programme alloc];
    newProgram.name = @"new-program";
    
    if(epgCallback){

        epgCallback([NSArray arrayWithObject:newProgram],nil);
    }
    
    STAssertEqualObjects(player.videoItem.currentProgram, newProgram, @"New program is currentProgram");
    
    
    [mockEpgApi verify];
    [EpgApi setSharedInstance:nil];
}

@end
