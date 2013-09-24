//
//  ProgramCarouselItemViewTests.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 12/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "TestUtils.h"

#import "ProgramCarouselItemView.h"
#import "AssertEventually/AssertEventually.h"

@interface ProgramCarouselItemViewTests : SenTestCase{
    
    ProgramCarouselItemView* itemView;
    
}


@end

@implementation ProgramCarouselItemViewTests

-(void)setUp
{
    itemView = [ProgramCarouselItemView itemView];
}


-(void)testViewInitialised
{
    
    STAssertNotNil(itemView,@"View created");
    
    STAssertNotNil(itemView.programImage,@"Image not nil");
    STAssertNotNil(itemView.programTitle,@"Title not nil");
    
    STAssertNotNil(itemView.progressIndicator,@"Progress indicator not nil");
    
    STAssertNotNil(itemView.timeLabel,@"");
    
}

-(void)testSetProgramUpdatesElements
{
    __strong id mockLazyImage = [OCMockObject niceMockForClass:[LazyLoadImageView class]];
    itemView.programImage = mockLazyImage;
    
    [[mockLazyImage expect] lazyLoadImageFromURLString:[OCMArg any] contentMode:UIViewContentModeScaleAspectFit];
    
    
    Programme* p = [Programme alloc];
    
    p.startTime = [NSDate dateWithTimeIntervalSince1970:1325419200]; //12am Jan 1st 2012
    p.endTime = [NSDate dateWithTimeIntervalSince1970:1325422800]; //1pm Jan 1st 2012
    p.name = @"Test program";
 
    
    [itemView setProgram:p];
    
    STAssertEqualObjects(itemView.timeLabel.text,@"12:00 pm - 01:00 pm", @"");    
    STAssertEqualObjects(itemView.programTitle.text,p.name,@"");
    
    //[mockLazyImage verify]; 
}

-(void)testUpdateProgressIndicator
{
    Programme* p = [Programme alloc];
    
    p.startTime = [NSDate dateWithTimeIntervalSince1970:1325419200]; //12am Jan 1st 2012
    p.endTime = [NSDate dateWithTimeIntervalSince1970:1325422800]; //1pm Jan 1st 2012
    p.name = @"Test program";

    [itemView setProgram:p];
    
    
    [itemView updateProgressIndicatorForTime:p.startTime];
    STAssertEquals(itemView.progressIndicator.frame.size.width,  0.0f, @"Progress inidicator should be 0 pixels wide");
    
    [itemView updateProgressIndicatorForTime:p.endTime];
    STAssertEquals(itemView.progressIndicator.frame.size.width,  168.0f, @"Progress inidicator should be 168 pixels wide");
    
    NSDate *thirtyMinsIn = [p.startTime dateByAddingTimeInterval:30 * 60];
    [itemView updateProgressIndicatorForTime:thirtyMinsIn];
     STAssertEquals(itemView.progressIndicator.frame.size.width,  84.0f, @"Progress inidicator should be 84 pixels wide");
    
    
    NSDate* afterEnd = [p.endTime dateByAddingTimeInterval:15 * 60];
    [itemView updateProgressIndicatorForTime:afterEnd];
    STAssertEquals(itemView.progressIndicator.frame.size.width,  168.0f, @"Progress inidicator should be 168 pixels wide");
    
    NSDate* beforeStart = [p.startTime dateByAddingTimeInterval:-15 * 60];
    [itemView updateProgressIndicatorForTime:beforeStart];
    STAssertEquals(itemView.progressIndicator.frame.size.width,  0.0f, @"Progress inidicator should be 0 pixels wide");
}




@end