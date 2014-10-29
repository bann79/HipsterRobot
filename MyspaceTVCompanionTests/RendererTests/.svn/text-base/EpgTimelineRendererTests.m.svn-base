//
//  EpgTimelineRendererTests.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 14/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <OCMock/OCMock.h>
#import <SenTestingKit/SenTestingKit.h>
#import "../AssertEventually/AssertEventually.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import <QuartzCore/QuartzCore.h>

#import "EpgTimelineRenderer.h"

@interface EpgTimelineRendererTests : SenTestCase {
    NSDate* testTime;
}
@end


@implementation EpgTimelineRendererTests

-(void)setUp
{
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    testTime = [fmt dateFromString:@"2012-01-01 11:00:00"];
} 

-(void)doTestRenderer:(EpgTimelineRenderer*)renderer
{
    UIImage* image = [renderer renderCellForTime:testTime ];;
    STAssertNotNil(image, @"Image not nil");
}

-(void)testTopbarRenderer
{
    [self doTestRenderer: [EpgTimelineRenderer bottombarRenderer]];    
}

-(void)testBottombarRenderer
{
    [self doTestRenderer: [EpgTimelineRenderer topbarRenderer]];
}


@end