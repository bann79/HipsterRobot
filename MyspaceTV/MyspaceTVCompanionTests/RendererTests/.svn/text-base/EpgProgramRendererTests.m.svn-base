//
//  EpgProgramRendererTests.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 14/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import <OCMock/OCMock.h>
#import <SenTestingKit/SenTestingKit.h>
#import "../AssertEventually/AssertEventually.h"
#import "TestUtils.h"


#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "EpgApi.h"
#import "EpgProgramRenderer.h"

@interface EpgProgramRendererTests : SenTestCase{
    EpgProgramRenderer* renderer;
}
@end 


@implementation EpgProgramRendererTests


-(void)setUp
{
    renderer =[[EpgProgramRenderer alloc] init];
   
}

-(void)tearDown
{
    
}


-(NSArray*)getMockProgramData
{
    
    Programme* p1 = [[Programme alloc] init];
    p1.programmeID = @"p1";
    p1.startTime = [NSDate dateWithTimeIntervalSinceNow: 60 * -5]; // 5 Minutes ago
    p1.endTime = [NSDate dateWithTimeIntervalSinceNow: 60 * 20]; // 20 Minutes time
    p1.name = @"Cash in the attic";
    p1.synopsis = @"Old people desperatly try to flog their worthless crap";
    
    Programme* p2 = [[Programme alloc] init];
    p2.programmeID = @"p2";
    p2.startTime = p1.endTime;
    p2.endTime = [NSDate dateWithTimeIntervalSinceNow:60 * 60]; // 1 Hours times
    p2.name = @"Telly tubbies";
    p2.synopsis = @"Weird alien kidddy show";
    
    Programme* p3 = [[Programme alloc] init];
    p3.programmeID = @"p3";
    p3.startTime = p2.endTime;
    p3.endTime = [NSDate dateWithTimeIntervalSinceNow:60 * 90]; // 90 Minutes time;
    p3.name = @"BBC Brunchtime news";
    p3.synopsis = @"Depresing news at mid morning";
    
   return @[p1,p2,p3];
}


-(void)testGetLoadingImage
{   
    
    UIImage* img = [renderer getLoadingImage];
    
    STAssertNotNil(img,@"Image was not nil");
    STAssertEquals(img.size, EpgCellSize,@"Size was correct");
        
    [TestUtils saveImage:img forTestCase:self named:@"result"];
}

-(void)testRenderPrograms
{
    UIImage* img =  [renderer renderPrograms:[self getMockProgramData] beginingAt:[NSDate date] endingAt:[NSDate dateWithTimeIntervalSinceNow:120 * 60]  programImages:nil];

    STAssertNotNil(img,@"Image was not nil");
    STAssertEquals(img.size, EpgCellSize,@"Size was correct");
                         
                         
    [TestUtils saveImage:img forTestCase:self named:@"result"];
    
}


-(void)testShouldNotDisplaySynopsisForShortProgram
{
    Programme* p1 = [[Programme alloc] init];
    p1.startTime = [NSDate date]; // Now
    p1.endTime = [NSDate dateWithTimeIntervalSinceNow: 60 * 10]; // 10 Minutes time
    
    BOOL shouldDisplay = [renderer shouldDisplaySynposisForProgram:p1];
    
    STAssertFalse(shouldDisplay, @"Should not display synopsis for 10 minute program");
}


-(void)testShouldDisplaySynopsisForLongerProgram
{
    Programme* p1 = [[Programme alloc] init];
    p1.startTime = [NSDate date]; // Now
    p1.endTime = [NSDate dateWithTimeIntervalSinceNow: 60 * 60]; // 1 Hours time
    
    BOOL shouldDisplay = [renderer shouldDisplaySynposisForProgram:p1];
    
    STAssertTrue(shouldDisplay, @"Should not display synopsis for 1 hour program");
}

-(void)testShouldNotDisplayProgramImageForShortProgram
{
    Programme* p1 = [[Programme alloc] init];
    p1.startTime = [NSDate date]; // Now
    p1.endTime = [NSDate dateWithTimeIntervalSinceNow: 60 * 40]; // 40 Minutes time
    
    BOOL shouldDisplay = [renderer shouldDisplayProgramImageForProgram:p1];
    
    STAssertFalse(shouldDisplay, @"Should not display image for 40 minute program");
}

-(void)testShouldDisplayProgramImageForLongerProgram
{
    Programme* p1 = [[Programme alloc] init];
    p1.startTime = [NSDate date]; // Now
    p1.endTime = [NSDate dateWithTimeIntervalSinceNow: 60 * 60]; // 1 Hours time
    
    BOOL shouldDisplay = [renderer shouldDisplayProgramImageForProgram:p1];
    
    STAssertTrue(shouldDisplay, @"Should not display image for 60 minute program");
}

-(void)testRenderProgramsAddOperationsToQueue
{
 
    id mockQueue = [OCMockObject mockForClass:[NSOperationQueue class]];
    renderer.opQueue = mockQueue;
    
    
    [[mockQueue expect] addOperation:instanceOf([NSBlockOperation class])];
    

    [renderer renderPrograms:[self getMockProgramData]  beginingAt:[NSDate date] endingAt:[NSDate dateWithTimeIntervalSinceNow:120 * 60] andCall:^(UIImage *i) {
        
    }];

    
    [mockQueue verify];
}


-(void)testRenderProgramsFetchesImageForLongProgram
{
    id mockUrlLoader = [OCMockObject mockForClass:[URLLoader class]];
    renderer.urlLoader = mockUrlLoader;
    
    Programme* p = [[Programme alloc] init];
    p.programmeID = @"object-id";
    p.images = @[ [[Thumbnail alloc] initWithUrl:@"http://example.com/test.png" andWidth:100 andHeight:100]];
    p.startTime = [NSDate date];
    p.endTime   = [NSDate dateWithTimeIntervalSinceNow:180 * 60];
    
    
    [[mockUrlLoader expect] loadUrl:@"http://example.com/test.png" withAcceptType:nil andCalls:[OCMArg any]];
    
    [renderer renderPrograms:@[p] beginingAt:p.startTime endingAt:p.endTime andCall:^(UIImage *i){}];
    
    [mockUrlLoader verify];
}

@end
