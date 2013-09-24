//
//  PigTransportViewControllerTest.
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 15/08/2012.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "PiGTransportViewController.h"
#import <OCMock/OCMock.h>


@interface PiGTransportViewControllerTest : SenTestCase
{
    PiGTransportViewController *controller;
    __weak id mockPlayer;
}
@end

@implementation PiGTransportViewControllerTest

-(void)setUp
{
    mockPlayer = [OCMockObject niceMockForClass:[XumoVideoPlayer class]];
    
    controller = [PiGTransportViewController alloc];
    controller.xumoPlayer = mockPlayer;
}

-(void)testVideoPlayerPauseWhenPlay
{
    [[[mockPlayer expect] andReturnValue:[NSNumber numberWithInt:XVPPlaying]] state];
    [[mockPlayer expect]pause];
    [controller onPlayPauseTouched:nil];
}

-(void)testVideoPlayerPlayWhenPause
{
    //as product codes use if else if, so state has been accessed twice.
    [[[mockPlayer expect] andReturnValue:[NSNumber numberWithInt:XVPPaused]] state];
    [[[mockPlayer expect] andReturnValue:[NSNumber numberWithInt:XVPPaused]] state];
    [(XumoVideoPlayer*)[mockPlayer expect] play];
    [controller onPlayPauseTouched:nil];
}


-(void)tearDown
{    
    [mockPlayer verify];
}

@end
