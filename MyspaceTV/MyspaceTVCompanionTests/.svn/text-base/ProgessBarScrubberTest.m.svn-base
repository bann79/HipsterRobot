//
//  ProgessBarScrubberTest.m
//  MyspaceTVCompanion
//
//  Created by Dyfan Hughes on 23/08/2012.
//
//

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import "ScrubberView.h"
//#import "ProgressBarScrubDelegate.h"
#import <OCMock/OCMock.h>

@interface ProgessBarScrubberTest : SenTestCase
{
    ScrubberView * scrubberView;
    id mockScrubberDelegate;
}

@end

@implementation ProgessBarScrubberTest

-(void)setUp
{
    scrubberView = [[ScrubberView alloc]initWithFrame:CGRectMake(119,8,276,23)];
    //mockScrubberDelegate = [OCMockObject niceMockForClass:[ProgressBarScrubDelegate Class]];
    
}

-(void)testSliderValueChangedToMaxDoesntPassMaxAllowedPosition
{
    scrubberView.isAbleToScrubWithinSlider = YES;
    scrubberView.value = 0.9;
    scrubberView.maximumSeekPosition = 0.8;
    
    [scrubberView sliderValueChanged:scrubberView];
    //STAssertTrue(scrubberView.value == scrubberView.maximumSeekPosition,@"not equals to each other");
}

-(void)testSliderValueChangedToMinDoesntPassMinAllowedPosition
{
    scrubberView.isAbleToScrubWithinSlider = YES;
    scrubberView.value = 0.1;
    scrubberView.minimumSeekPosition = 0.2;
    
    [scrubberView sliderValueChanged:scrubberView];
    STAssertTrue(scrubberView.value == scrubberView.minimumSeekPosition,@"not equals to each other");
}

-(void)tearDown
{
    scrubberView = nil;
}


@end
