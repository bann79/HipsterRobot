//
//  BaseInfoPanelViewControllerTest.m
//  MyspaceTVCompanion
//
//  Created by Dyfan Hughes on 20/07/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <SenTestingKit/SenTestingKit.h>
#import "BaseInfoPanelViewController.h"
#import <OCMock/OCMock.h>
#import "PlanAheadEpgViewController.h"
#import "OnNowViewController.h"

@interface BaseInfoPanelViewControllerTest : SenTestCase
{
    @private BaseInfoPanelViewController * controller;
}
@end

@implementation BaseInfoPanelViewControllerTest



-(void)setUp
{
    [super setUp];
    controller = [[BaseInfoPanelViewController alloc]init];
    
}

-(void)tearDown
{
    [super tearDown];
    controller = nil;
}

-(void)testOnNowViewControllerNotNil
{
    STAssertNotNil(controller, @"Controller doesn't exist");
}

-(void)testCorrectClassesAreCreatedOnViewDidAppear
{
    [controller viewDidAppear:NO];
    STAssertNotNil(controller.channelDiscFactory,@"channelDiscFactory not created!");
    STAssertNotNil(controller.catchUpURLGenerator,@" catchUpURLGenerator not created!");
    STAssertNotNil(controller.videoAsset,@"videoAsset not created!");
    STAssertNotNil(controller.videoPlayer,@"videoPlayer not created!");
}

-(void)testAllBoolenValuesAreCorrectAtStartOfviewAppearing
{
    [controller viewDidAppear:NO];
    STAssertFalse(controller.userRequestedVideoPlayback,@"boolean not false");
    STAssertFalse(controller.videoPlayable,@"boolean not false");
    STAssertFalse(controller.videoReady,@"boolean not false");
    
}

-(void)testPopulateCorrectChannelAndProgramDataIsDisplayedOnScreen
{
        
}

-(void)testCalculateProgrammeDurationWithStartTimeReturnsCorrectString
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"hh:mma"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate * startTime1 = [dateFormatter dateFromString:@"10:00am"];
    NSDate * endTime1 = [dateFormatter dateFromString:@"11:00am"];
    
    NSDate * startTime2 = [dateFormatter dateFromString:@"10:00am"];
    NSDate * endTime2 = [dateFormatter dateFromString:@"10:30am"];
    
    NSDate * startTime3 = [dateFormatter dateFromString:@"10:00am"];
    NSDate * endTime3 = [dateFormatter dateFromString:@"11:30am"];
    
    NSLog(@"date: %@", startTime1);
    NSLog(@"date: %@", endTime1);
    
    NSLog(@"date: %@", startTime2);
    NSLog(@"date: %@", endTime2);
    
    NSLog(@"date: %@", startTime3);
    NSLog(@"date: %@", endTime3);
    
    NSString * result1 = [controller calculateProgrammeDurationWithStartTime:startTime1 andEndTime:endTime1];
    NSString * result2 = [controller calculateProgrammeDurationWithStartTime:startTime2 andEndTime:endTime2];
    NSString * result3 = [controller calculateProgrammeDurationWithStartTime:startTime3 andEndTime:endTime3];
    
    // Test to ensure different outcomes of duration are printed correctly.
    
    STAssertTrue([result1 isEqualToString:@"Duration 1.00hr"],@"not equal to each other");
    STAssertTrue([result2 isEqualToString:@"Duration 30min"],@"not equal to each other");
    STAssertTrue([result3 isEqualToString:@"Duration 1.30min"],@"not equal to each other");
}



-(void)testConvertStartDateToStringWorkCorrectlyReturningString
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-yy"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate * date = [dateFormatter dateFromString:@"12-06-12"];
    NSLog(@"date: %@", date);
    
    NSString * result = [controller convertStartDateToString:date];
    
    STAssertTrue([result isEqualToString:@"12-06-12"],@"not equal to each other");
}

-(void)testConvertStartTimeToStringWorksCorrectlyGivingString
{
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"hh:mma"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate * date = [dateFormatter dateFromString:@"10:00am"];
    NSLog(@"date: %@", date);
    
    NSString * result = [controller convertStartTimeToString:date];
    
    STAssertTrue([result isEqualToString:@"10:00am"],@"not equal to each other");
    
}

-(void)testChannelDiscAddedToSubViewWithData
{
    id mockChannelDiscImg = [OCMockObject niceMockForClass:[UIView class]];
    [controller setGeneratedDiscImg:mockChannelDiscImg];
    [[mockChannelDiscImg expect] addSubview:[OCMArg any]];
    
    Channel * channelInfoObject = [[Channel alloc]init];
    channelInfoObject.channelNumber =[NSNumber numberWithChar:101];
    channelInfoObject.thumbnail = [[Thumbnail alloc] initWithUrl:@"some bbc one url" andWidth:10
                                                       andHeight:10];
    
    [controller createChannelDiscWithChannelObject:channelInfoObject WithXPos:10 AndYPos:10 AndAddedToView:controller.generatedDiscImg];
    [mockChannelDiscImg verify];    
}

-(void)testDetermineCorrectVideoFeedToUse
{
    Channel * channel = [[Channel alloc]init];
    Program * program = [[Program alloc]init];
    NSMutableArray * array = [[NSMutableArray alloc]init];
    [array insertObject:@"liveFeed" atIndex:0];
    channel.liveStreamUrls = array;
    
   // NSString * string = @"liveFeed"; 
    
   // NSArray * newArray = [channel.liveStreamUrls initWithArray: array];
    
    controller.selectedProgrammeState = @"live";
    //NSArray * newArray = [channel.liveStreamUrls arrayByAddingObjectsFromArray:array];

    NSLog(@"object at index 0 %@",[channel.liveStreamUrls objectAtIndex:0]);
    [controller determineVideoFeedToUseWithinPIG:program AndChannel:channel];
    STAssertTrue([controller.resultantFeed isEqualToString:@"liveFeed"], @"shouldnt return live feed but didn't");
    
    STAssertEquals(controller.videoAsset.currentChannel, controller.currentChannel,@"");
    STAssertEquals(controller.videoAsset.currentProgram, controller.currentProgram,@"");
    STAssertEquals(controller.videoPlayer.videoItem,controller.videoAsset,@"");
}

-(void)testAllInstancesAreNulledUponViewDidUnload
{
      STAssertNil(controller.startTimeLbl, @"Controller doesn't exist");
      STAssertNil(controller.startDateLbl, @"Controller doesn't exist");
      STAssertNil(controller.titleLbl, @"Controller doesn't exist");
      STAssertNil(controller.subHeadingLbl, @"Controller doesn't exist");
      STAssertNil(controller.durationLbl, @"Controller doesn't exist");

      STAssertNil(controller.channelDiscFactory, @"Controller doesn't exist");
}

-(void)testViewControllerCapableOfDeterminingDifferenceBetweenLiveAndCatchUp
{
    NSString * expectedResult = @"catchup";
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"hh:mma"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate * startTestTime = [NSDate date];
    NSDate * endTestTime = [dateFormatter dateFromString:@"11:30am"];
    
    [controller visualiseCorrectImageWithinImagePIGAccordingToStartTime:startTestTime AndEndTime:endTestTime AndTypeOfInfopanel:@"miniInfo"];
    
    NSString * actualResult = controller.selectedProgrammeState;
    
    STAssertTrue([expectedResult isEqualToString:actualResult],@"holderForprogrammeState should be live but isn't");
}

-(void)testVideoSetup
{
    Program * program;
    Channel * channel;
    
    [controller setUpVideoPlayerUsingChannel:channel AndProgram:program];
    
    STAssertFalse([controller.videoLoadIndicator isHidden],@"videoLoadIndicator should be hidden but isn't");
}

-(void)testGraphicalElementsAreAddedToScreenCorrectly
{
    
    id startTimeLbl = [OCMockObject mockForClass:[UILabel class]];
    [controller setStartTimeLbl:startTimeLbl];
    
    id startDateLbl = [OCMockObject mockForClass:[UILabel class]];
    [controller setStartDateLbl:startDateLbl];
    
    id titleLbl = [OCMockObject mockForClass:[UILabel class]];
    [controller setTitleLbl:titleLbl];
    
    id subHeadingLbl = [OCMockObject mockForClass:[UILabel class]];
    [controller setSubHeadingLbl:subHeadingLbl];
    
    id durationLbl = [OCMockObject mockForClass:[UILabel class]];
    [controller setDurationLbl:durationLbl];
    
    id descriptionTxt = [OCMockObject mockForClass:[UITextView class]];
    [controller setDescriptionTxt:descriptionTxt];
    
    id lazyLoadImage = [OCMockObject mockForClass:[LazyLoadImageView class]];
    [controller setLazyLoadImage:lazyLoadImage];
    
    
}


@end
