//
//  ScrubberTest.m
//  MyspaceTVCompanion
//
//  Created by Michael Lewis on 14/08/2012.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "ProgressBarView.h"
#import "XumoVideoPlayer.h"
#import "ScrubberView.h"
#import "ProgramExtraInfo.h"
#import <OCMock/OCMock.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <CoreMedia/CoreMedia.h>


@interface ProgressBarTest : SenTestCase
{
    ProgressBarView * progressBar;

     id mockScrubber;
     id mockEclipsedTimeLbl;
     id mockDurationLbl;
     id mockPlayer;
    id mockUIProgressView;
}
@end

@implementation ProgressBarTest

-(void)setUp
{
    mockDurationLbl = [OCMockObject niceMockForClass:[UILabel class]];
    mockEclipsedTimeLbl = [OCMockObject niceMockForClass:[UILabel class]];
    mockScrubber = [OCMockObject niceMockForClass:[ScrubberView class]];
    mockPlayer = [OCMockObject niceMockForClass:[XumoVideoPlayer class]];
    mockUIProgressView = [OCMockObject niceMockForClass:[UIProgressView class]];

    progressBar = [[ProgressBarView alloc] initWithFrame:CGRectMake(0, 0, 1024, 300)];
    [progressBar setScrubberView:mockScrubber];
    [progressBar setDurationLbl:mockDurationLbl];
    [progressBar setEclipsedTimeLbl:mockEclipsedTimeLbl];
    [progressBar setXumoPlayer:mockPlayer];

}

-(void)testFormatTime
{
    NSString* result = [progressBar formatTime:CMTimeMakeWithSeconds(600, 1000)];
    
    STAssertEqualObjects(result, @"10:00", @"600 seconds is 10:00");

    result = [progressBar formatTime:CMTimeMakeWithSeconds((1.56 * 3600), 1000)];
    
    STAssertEqualObjects(result, @"1:33:36", @"3600 seconds is 1:33:36");
    
    result = [progressBar formatTime:CMTimeMakeWithSeconds((1.26 * 3600), 1000)];
    
    STAssertEqualObjects(result, @"1:15:36", @"3600 seconds is 1:15:36");
}

-(void)testEclipsedTimeOnSynOfScrubber
{
    CMTime programmeStartTime = CMTimeMakeWithSeconds(800, 1000);
    CMTime seekPossibleStartTime =  CMTimeMakeWithSeconds(600, 1000);
    CMTime mockCurrentTime =  CMTimeMakeWithSeconds(810, 1000);
    CMTimeRange currentTimeWindowRange = CMTimeRangeMake(programmeStartTime, kCMTimeInvalid);
    CMTimeRange seekableTimeWindowRange = CMTimeRangeMake(seekPossibleStartTime, kCMTimeInvalid);

    [[[mockPlayer stub] andReturnValue:OCMOCK_VALUE(currentTimeWindowRange)] currentItemTimeWindow];
    [[[mockPlayer stub] andReturnValue:OCMOCK_VALUE(seekableTimeWindowRange)] seekableTimeWindow];
    [[[mockPlayer stub] andReturnValue:OCMOCK_VALUE(mockCurrentTime)] currentTime];

    CMTime time = CMTimeClampToRange(mockCurrentTime, currentTimeWindowRange);

    CMTime livePoint =CMTimeAdd(seekableTimeWindowRange.start, seekableTimeWindowRange.duration);
    livePoint = CMTimeClampToRange(livePoint, currentTimeWindowRange);

    //Convert to time relative to start of asset
    CMTime eclipsedTime = CMTimeSubtract(time, currentTimeWindowRange.start);
    livePoint = CMTimeSubtract(livePoint,currentTimeWindowRange.start);

    CMTime durationTime = CMTimeSubtract(currentTimeWindowRange.duration, time);

    NSString *expectedEclipsedTimeLblText = [progressBar formatTime:eclipsedTime];
    NSString *expectedDurationTimeLblText = [progressBar formatTime:durationTime];

    double mockPercentageVal =  CMTimeGetSeconds(eclipsedTime) / CMTimeGetSeconds(currentTimeWindowRange.duration);
    float mockPercentageValOfLive = CMTimeGetSeconds(livePoint) / CMTimeGetSeconds(currentTimeWindowRange.duration);

    //Ask lisa about type issues.
    //[[mockScrubber expect] setValue:mockPercentageVal];
    [[mockScrubber expect] setLivePoint:mockPercentageValOfLive];
    [[mockUIProgressView expect] setProgress:mockPercentageVal];
    [[mockEclipsedTimeLbl expect] setText:expectedEclipsedTimeLblText];
    [[mockDurationLbl expect] setText:expectedDurationTimeLblText];

    [progressBar syncScrubber];

    [mockEclipsedTimeLbl verify];
    [mockDurationLbl verify];
    [mockScrubber verify];
    [mockPlayer verify];
}

-(void)testInvalidDurationOnScrubTo
{
    CMTimeRange range = CMTimeRangeMake(CMTimeMakeWithSeconds(4, 1000), kCMTimeInvalid);

    [[[mockPlayer stub] andReturnValue:OCMOCK_VALUE(range)] currentItemTimeWindow];

    [[mockEclipsedTimeLbl reject] setText:[OCMArg any]];

    [progressBar scrubTo:0.3];

    [mockEclipsedTimeLbl verify];
}

-(void)testScrubTo
{
    float testPercentTime = 0.5;
    CMTimeRange range = CMTimeRangeMake(CMTimeMakeWithSeconds(4, 1000), CMTimeMakeWithSeconds(400, 1000));
    CMTime expectedTime = CMTimeMakeWithSeconds( testPercentTime * CMTimeGetSeconds(range.duration), NSEC_PER_SEC);

    [[[mockPlayer stub] andReturnValue:OCMOCK_VALUE(range)] currentItemTimeWindow];

    id pMock = [OCMockObject partialMockForObject:progressBar];

    [[pMock expect] formatTime:expectedTime];
    [[mockPlayer expect] seekTo: CMTimeAdd(range.start, expectedTime)];

    [progressBar scrubTo:testPercentTime];

    [pMock verify];
    [mockPlayer verify];
}

-(void)testScrubbableAreaDiffIsNotSeekableWithinSlider
{
    CMTime programmeStartTime = CMTimeMakeWithSeconds(800, 1000);
    CMTime seekPossibleStartTime =  CMTimeMakeWithSeconds(-800, 1000);

    CMTimeRange currentTimeWindowRange = CMTimeRangeMake(programmeStartTime, kCMTimeInvalid);
    CMTimeRange seekableTimeWindowRange = CMTimeRangeMake(seekPossibleStartTime, kCMTimeInvalid);

    [[[mockPlayer stub] andReturnValue:OCMOCK_VALUE(currentTimeWindowRange)] currentItemTimeWindow];
    [[[mockPlayer stub] andReturnValue:OCMOCK_VALUE(seekableTimeWindowRange)] seekableTimeWindow];

    progressBar.percentageValOfLive = 0.4;

    [[mockScrubber expect] setIsAbleToScrubWithinSlider:NO];
    [[mockScrubber expect] drawSeekableAreaWithStartPoint:0 andDurationLength:progressBar.percentageValOfLive];

    [progressBar setScrubbableArea];

    [mockScrubber verify];
}


-(void)testScrubbableAreaIsSeekableWithinSlider
{
    CMTime programmeStartTime = CMTimeMakeWithSeconds(800, 1000);
    CMTime seekPossibleStartTime =  CMTimeMakeWithSeconds(800, 1000);
    CMTime programmeDurationTime = CMTimeMakeWithSeconds(1800, 1000);
    CMTime seekPossibleDurationTime =  CMTimeMakeWithSeconds(1600, 1000);
    CMTimeRange currentTimeWindowRange = CMTimeRangeMake(programmeStartTime, programmeDurationTime);
    CMTimeRange seekableTimeWindowRange = CMTimeRangeMake(seekPossibleStartTime, seekPossibleDurationTime);

    float diff = (int)((int)CMTimeGetSeconds(seekableTimeWindowRange.start) - (int)CMTimeGetSeconds(currentTimeWindowRange.start)) / 60;

    float durationMinutes = ((int)CMTimeGetSeconds(currentTimeWindowRange.duration) / 60);
    float startPercentage = diff / durationMinutes;

    float seekDuration = ((int)CMTimeGetSeconds(seekableTimeWindowRange.duration) / 60);
    float durationPercentage = seekDuration / durationMinutes;

    [[[mockPlayer stub] andReturnValue:OCMOCK_VALUE(currentTimeWindowRange)] currentItemTimeWindow];
    [[[mockPlayer stub] andReturnValue:OCMOCK_VALUE(seekableTimeWindowRange)] seekableTimeWindow];

    [[mockScrubber expect] setIsAbleToScrubWithinSlider:YES];

    [[mockScrubber expect] drawSeekableAreaWithStartPoint:startPercentage andDurationLength:durationPercentage];

    [progressBar setScrubbableArea];

    [mockScrubber verify];
}


-(void)tearDown
{
    [progressBar setScrubberView:nil];
    [progressBar setEclipsedTimeLbl:nil];
    [progressBar setDurationLbl:nil];
    [progressBar setXumoPlayer:nil];
    progressBar = nil;
}

@end
