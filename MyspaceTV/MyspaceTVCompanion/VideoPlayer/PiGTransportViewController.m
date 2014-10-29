//
//  PiGTransportViewController.m
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 15/08/2012.
//
//

#import "PiGTransportViewController.h"
#import "DDLog.H"

static const int ddLogLevel = LOG_LEVEL_INFO;

@implementation PiGTransportViewController
@synthesize playerControllerView;
@synthesize playPauseBtn;
@synthesize goFullscreen;
@synthesize xumoPlayer;
@synthesize controlsVisible;
@synthesize scrubView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setControlsVisible:YES];
    [xumoPlayer addObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ApplicationIdle" object:nil];
    
    [super viewDidDisappear:animated];
    [xumoPlayer removeObserver:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void) setControlsVisible:(BOOL)visible
{
    controlsVisible = visible;
    
    [UIView animateWithDuration:0.3 animations:^{
        playerControllerView.alpha = visible;
    }];
}

#pragma mark XumoVideoPlayerObserver handling
-(void)player:(XumoVideoPlayer *)player stateWillChangeTo:(enum XumoVideoPlayerState)newState
{
    //NSLog(@"state will change from %i to %i ", player.state, newState);
    
    if (player.state == XVPLoading && newState == XVPPlaying) {
        //video start to play;
        [(MSTVApplication *)[UIApplication sharedApplication] resetIdleTimer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onApplicationIdle:)
                                                     name:@"ApplicationIdle"
                                                   object:nil];
    }
    
    if (player.state == XVPStalled && newState == XVPPlaying) {
        //video stalled a while, then start to play;
        [(MSTVApplication *)[UIApplication sharedApplication] resetIdleTimer];
    }
}

-(void)player:(XumoVideoPlayer *)player stateDidChangeTo:(enum XumoVideoPlayerState)state
{
    if (state == XVPStalled) {
        [self setControlsVisible:YES];
    }
    
    if(state == XVPPlaying || state == XVPPaused)
    {
        [self isPlayerPlayingVideo];
    }
}

#pragma mark control handling
-(void)onApplicationIdle:(NSNotification *)notification
{
    if (controlsVisible && xumoPlayer.state != XVPStalled && xumoPlayer.state != XVPPaused)
    {
        [self setControlsVisible:NO];
    }
}

-(void)launchFullscreenVideoPlayer
{   
    //create one bann's fullscreen video. set the view.
    [[[VideoViewController alloc] initWithPlayer:self.xumoPlayer] transitionInFromView:self.view withPlayerStatus:_isPIGVideoPlaying];
}

- (IBAction)onPlayPauseTouched:(id)sender
{
    if (xumoPlayer.state == XVPPlaying) {
        [xumoPlayer pause];
    }else if(xumoPlayer.state == XVPPaused){
        [xumoPlayer play];
    }
    [self isPlayerPlayingVideo];
}

-(void)isPlayerPlayingVideo
{
    if(xumoPlayer.state == XVPPlaying)
    {
        _isPIGVideoPlaying = YES;
        [self.playPauseBtn setImage:[UIImage imageNamed:@"PIG_pause"] forState:UIControlStateNormal];
    }else if(xumoPlayer.state == XVPPaused)
    {
        _isPIGVideoPlaying = NO;
        [self.playPauseBtn setImage:[UIImage imageNamed:@"PIG_play"] forState:UIControlStateNormal];
    }
}

- (IBAction)onFullscreenTouched:(id)sender
{
    [self launchFullscreenVideoPlayer];
}

- (IBAction)onPlayerTouched:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if (!controlsVisible) {
            [self setControlsVisible:YES];

        }else if(xumoPlayer.state != XVPPaused){
            [self setControlsVisible:NO];
        }
    }
}

- (IBAction)onPlayerPinched:(UIPinchGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded && sender.scale > 1)
    {
        [self launchFullscreenVideoPlayer];
    }
}

-(void)player:(XumoVideoPlayer *)player hasNewVideoItem:(VideoItem *)newVideoItem
{
    [self.scrubView.scrubberView setValue:0];
}
@end
