//
//  VideoViewController.m
//  MyspaceTVCompanion
//
//  Created by Bann Al-Jelawi on 13/08/2012.
//
//

#import "VideoViewController.h"
#import "ChannelBarViewController.h"

@implementation VideoViewController
@synthesize singleTapGesture;
@synthesize doubleTapGesture;
@synthesize pinchGesture;

-(id)initWithPlayer:(XumoVideoPlayer *)player
{
    self = [super init];
    _currentPlayer = player;
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [_currentPlayer addObserver:self];
    [super viewWillAppear:animated];
    [self isPlayerPlayingVideo];
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if([[UIApplication sharedApplication] isStatusBarHidden])
    {
        [self setControlsVisible:YES animated:YES];
    }
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(void)loadView
{
    [super loadView];
    
    UINib *nib = [UINib nibWithNibName:@"VideoViewController" bundle:nil];
    [nib instantiateWithOwner:self options:@{ UINibExternalObjects: @{ @"XumoPlayer":_currentPlayer}}];
}

-(void)initRotaryVolumeControl
{
    [_arcVolumeControl initWithDelegate:self andConfig:@{
     
     @"displaysValue" : [NSNumber numberWithBool:NO],
     @"color" : [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], //TODO
     @"min" : @0,
     @"max" : @1,
     @"doubleTapValue" : @50.0,
     @"tripleTapValue" : @100,
     @"dialValue" : @0.5,
     @"cutoutSize" : @0.0,
     @"valueArcWidth" : @43.5,
     @"direction" : @1,
     }];

    for (id current in [_volumeControl subviews]){
        if ([current isKindOfClass:[UISlider class]]) {
            _volumeControlSlider = (UISlider*) current;
        }
    }    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(volumeChanged:)
     name:@"AVSystemController_SystemVolumeDidChangeNotification"
     object:nil];
    
    self.volumeControl.showsVolumeSlider = YES;
    self.volumeControl.showsRouteButton = YES;
    [self.volumeControl setBackgroundColor:[UIColor clearColor]];
    
    [self initRotaryVolumeControl];
    
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    [doubleTapGesture requireGestureRecognizerToFail:pinchGesture];
    [singleTapGesture requireGestureRecognizerToFail:pinchGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationTimeout:) name:@"ApplicationIdle" object:nil];
}

- (void)volumeChanged:(NSNotification *)notification
{
    // Do stuff with volume
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationTimeout:) name:@"ApplicationIdle" object:nil];
    
    CGFloat newVolume = self.volumeControlSlider.value;
    [self.arcVolumeControl setDialValue:newVolume];
    [self.arcVolumeControl setNeedsDisplay]; 
}

- (void)controlValueDidChange:(float)value sender:(id)sender
{
    
    [_volumeControlSlider setValue:_arcVolumeControl.dialValue animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_currentPlayer removeObserver:self];
    [self setBottomControls:nil];
    
    [_videoView cleanupVideo];
    [self setVideoView:nil];
}

#pragma mark Action

-(void)onApplicationTimeout:(NSNotification*)n
{
    //ignore time out when channel bar info panel is showing.
    if(self.channelBar.infoPanel.view.superview == nil)
    {
        // don't hide controls if the player is paused
        if(_controlsVisible && _currentPlayer.state !=XVPPaused){
            [self setControlsVisible:NO animated:YES];
        }
    }
}

- (IBAction)onVideoViewSingleTapped:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if(!_controlsVisible){
            [self setControlsVisible:YES animated:YES];
        }else if (_currentPlayer.state != XVPPaused){
            [self setControlsVisible:NO animated:YES];
        }
    }
}

- (IBAction)onVideoViewDoubleTapped:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        //NSString *currentGravity = self.currentPlayer.videoGravity;
        
        self.currentPlayer.videoGravity = [self.currentPlayer.videoGravity isEqualToString:AVLayerVideoGravityResizeAspect]?AVLayerVideoGravityResizeAspectFill:AVLayerVideoGravityResizeAspect;
        //[self.currentPlayer setVideoGravity:currentGravity];
    }
}

- (IBAction)onVideoViewPinchedIn:(UIPinchGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded && sender.scale < 1)
    {
        [self transitionOut];
    }
}

-(IBAction)touchedPlayPause:(UIButton*)sender
{
    NSLog(@"video playing state %u", _currentPlayer.state);
    
        if(_currentPlayer.state == XVPPlaying)
        {
            _isVideoPlaying = NO;
            [_currentPlayer pause];
        }
        else if (_currentPlayer.state == XVPPaused)
        {
            _isVideoPlaying = YES;
            [_currentPlayer play];
        }
        [self isPlayerPlayingVideo];
}

-(void)isPlayerPlayingVideo
{
    if(_isVideoPlaying || _currentPlayer.state == XVPPlaying)
    {
                [self.playPauseBtn setImage:[UIImage imageNamed:@"TC_pause_btn"] forState:UIControlStateNormal];
    }else if (_isVideoPlaying || _currentPlayer.state == XVPPaused){
        
        [self.playPauseBtn setImage:[UIImage imageNamed:@"TC_play_btn"] forState:UIControlStateNormal];
    }
}

-(IBAction)touchedRewind:(UIButton*)sender
{
    CMTime timeSinceStart = CMTimeSubtract(_currentPlayer.currentTime, _currentPlayer.currentItemTimeWindow.start);
    if(CMTimeGetSeconds(timeSinceStart) < 10){
        [_currentPlayer seekTo: _currentPlayer.currentItemTimeWindow.start];
        return;
    }
    
    [_currentPlayer seekBy:-10.0];
}

-(IBAction)touchedDone:(UIButton*)sender
{
    [self transitionOut];
}

#pragma mark XumoVideoPlayerDelegate

-(void)player:(XumoVideoPlayer *)player stateDidChangeTo:(enum XumoVideoPlayerState)state
{
    // disable the button if the player is seeking / stalling / loading
    [_playPauseBtn setEnabled:(!player.state == XVPStalled) || !player.state == XVPSeeking || !player.state == XVPLoading];
    [_playPauseBtn setEnabled:(player.state == XVPPaused || player.state == XVPPlaying)];
    [_playPauseBtn setSelected:(player.state == XVPPlaying)];
    
    if(state == XVPFinished){
        [self transitionOut];
    }
    
    [self isPlayerPlayingVideo];
 

}

#pragma mark circl volume control tap handlers.
-(void)doubleTap:(UIMaskedArcControl *) control
{
    NSLog(@"in ViewController doubleTap: callback");
    
    void (^anim) (void) = ^{
        NSLog(@"here");
        control.center = CGPointMake(0,0);
        control.dialValue = 1.0;
    };
    void (^after) (BOOL) = ^(BOOL f) {
        control.center = CGPointMake(100,100);
    };
    NSUInteger opts = UIViewAnimationOptionAutoreverse;
    [UIView animateWithDuration:1 delay:0 options:opts
                     animations:anim completion:after];
}

#pragma mark Transitions
CGPoint CGRectCenter(CGRect r){
    return CGPointMake(r.origin.x + (r.size.width/2) , r.origin.y + (r.size.height/2));
}

-(void)transitionInFromView:(UIView*)view withPlayerStatus:(BOOL) playerState
{
    _isVideoPlaying = playerState;
    
    //default video play in 16:9 in fullscreen mode.
    [_currentPlayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    
    AppViewController *appVC = [(AppDelegate *)[[UIApplication sharedApplication] delegate] viewController];

    _piGBound = [view.superview convertRect:view.frame toView:appVC.screenContainer];
    
    self.view.transform = CGAffineTransformMakeScale(_piGBound.size.width/self.view.frame.size.width, _piGBound.size.height/self.view.frame.size.height);
    //self.view.center = [view.superview convertPoint:view.center toView:appVC.view];
    self.view.center = CGRectCenter(_piGBound);
    
    [appVC.screenContainer addSubview:self.view];
    [appVC addChildViewController:self];
    
    [self setControlsVisible:NO animated:NO];
    
    [self.currentPlayer setIsFullscreen:YES];
    
    [appVC performSelector:@selector(transitionOutTopAndBottomBar) withObject:nil afterDelay:0];

    [UIView animateWithDuration:0.8 animations:^{
        self.view.alpha = 1;
        self.view.center = appVC.screenContainer.center;
        self.view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
    
        //[[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        [self setControlsVisible:YES animated:YES];
    }];
}

-(void)transitionOut
{
    if (_controlsVisible) {
        [self setControlsVisible:NO animated:NO];
    }
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];

    [self.currentPlayer setIsFullscreen:NO];

    [UIView animateWithDuration:1.0 animations:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        self.view.transform = CGAffineTransformMakeScale(_piGBound.size.width/self.view.frame.size.width, _piGBound.size.height/self.view.frame.size.height);
        self.view.center = CGRectCenter(_piGBound);
        
        [_currentPlayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
        AppViewController *appVC = [(AppDelegate *)[[UIApplication sharedApplication] delegate] viewController];
        [appVC transitionInTopAndBottomBar];
    }];
}
-(void)setControlsVisible:(BOOL)visible animated:(BOOL)animated
{
    _controlsVisible = visible;

    void (^visiblepos)() = ^{
        _bottomControls.transform = CGAffineTransformIdentity;
        _topControls.transform = CGAffineTransformIdentity;
    };
    
    void (^hiddenpos)() = ^{
        _bottomControls.transform = CGAffineTransformMakeTranslation(0, 400);
        _topControls.transform = CGAffineTransformMakeTranslation(0, -400);
    };
    
    if(visible){
        
        [_channelBar setActiveChannel:_currentPlayer.videoItem.currentChannel startingAtProgram:_currentPlayer.videoItem.currentProgram];
        
        [self.topControls insertSubview:self.volumeControl atIndex:4];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        
        if(animated){
            hiddenpos();
            
            self.channelBar.view.userInteractionEnabled = YES;
            [UIView animateWithDuration:0.5 animations:visiblepos];
        }
        else{
            visiblepos();
        }
    }else{
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        
        self.channelBar.view.userInteractionEnabled = NO;
        
        if(animated){
            visiblepos();
            
            [UIView animateWithDuration:0.5 animations:hiddenpos completion:^(BOOL finished){ [self.volumeControl removeFromSuperview];}];
        }else{
            hiddenpos();
        }
    }
}

-(void)viewDidUnload
{
    [self setSingleTapGesture:nil];
    [self setDoubleTapGesture:nil];
    [self setPinchGesture:nil];
    [super viewDidUnload];
    [self setVolumeControl:nil];
    [self setVolumeControl:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)player:(XumoVideoPlayer *)player hasNewVideoItem:(VideoItem *)newVideoItem
{
    [self.scrubberView.scrubberView setValue:0];
    [self isPlayerPlayingVideo];
}
@end
