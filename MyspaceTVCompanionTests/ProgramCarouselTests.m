//
//  ActionRingViewTest.m
//  MyspaceTVCompanion
//
//  Created by Elwyn Malethan on 06/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "ProgramCarousel.h"
#import "ProgramCarouselItemView.h"


@interface ProgramCarouselTests : SenTestCase {
    
    id mockModel;
    id mockCarousel;
    
    Channel* mockChannel;
    
    ProgramCarousel *controller;
}

@end

@implementation ProgramCarouselTests


-(void)setUp
{
    mockModel = [OCMockObject mockForClass:[ProgramCarouselModel class]];
    mockCarousel = [OCMockObject mockForClass:[iCarousel class]];
    
 
    mockChannel = [Channel alloc];
    mockChannel.callSign = @"CALLSIGN";
    mockChannel.title = @"Mock Channel";
    
    controller = [[ProgramCarousel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    controller.carousel = mockCarousel;
    controller.model = mockModel;
}

-(void)tearDown 
{
    [mockModel verify];
    [mockCarousel verify];
}

-(void)testViewForItemCallsViewFactory
{
    [[mockModel expect] getProgramForIndex:0];
    
    UIView* result = [controller carousel:mockCarousel viewForItemAtIndex:0 reusingView:nil];
    
    STAssertNotNil(result,@"Result is view creted by factory");
}

-(void)testViewForItemResusesExistingItem
{
    
    id view = [OCMockObject mockForClass:[ProgramCarouselItemView class]];
    
    [[view expect] setTag:0];
    [[view expect] setIsLoading:YES];
    
    [[mockModel expect] getProgramForIndex:0];
    
    UIView* result = [controller carousel:mockCarousel viewForItemAtIndex:0 reusingView:view];
    
    STAssertEquals(result, view,@"result is existing view");
    [view verify];
}

-(void)testFakeIndex
{
    STAssertEquals( [controller fakeIndex:0]   , (NSUInteger)(0),             @"0");
    STAssertEquals( [controller fakeIndex:10]  , (NSUInteger)(10),            @"10");
    STAssertEquals( [controller fakeIndex:-10] , (NSUInteger)(0xFFFF - 10),   @"-10");
}

-(void)testRealIndex
{
    STAssertEquals( [controller realIndex:0]        , (NSInteger)(0),             @"0");
    STAssertEquals( [controller realIndex:10]       , (NSInteger)(10),            @"10");
    STAssertEquals( [controller realIndex:0xFFFF-10], (NSInteger)(-10),   @"-10");
}

-(void)testDataSourceSetsLoadedData
{
    
    id view = [OCMockObject mockForClass:[ProgramCarouselItemView class]];
    
    
    [[[view expect] andReturnValue:[NSNumber numberWithInteger:0]] tag];
    [[[view expect] andReturnValue:[NSNumber numberWithBool:YES]] isLoading];
    [[view expect] setProgram:[OCMArg any]];
    
    [[[mockModel expect] andReturn:[Programme alloc]] getProgramForIndex:0];
    
    [controller setItemViews:[NSMutableSet setWithObject:view]];
    
    [controller modelDidLoadMoreData:mockModel];
    
    [view verify];
}

-(void)testAnimateOutUp
{
    
    id mockView = [OCMockObject mockForClass:[ProgramCarouselItemView class]];
    controller.itemViews = [NSMutableSet setWithObject:mockView];
    
    [(ProgramCarouselItemView*)[mockView expect] setTransform:CGAffineTransformMakeTranslation(0, -100)];
    [[mockView expect] setAlpha:0.0f];
    
    void (^block)(void) = [controller animateOutWithDirection:Up];
    
    STAssertNotNil(block,@"Block is not nil");
    
    block();
    
    [mockView verify];
}


-(void)testAnimateOutDown
{
    
    id mockView = [OCMockObject mockForClass:[ProgramCarouselItemView class]];
    controller.itemViews = [NSMutableSet setWithObject:mockView];
    
    [(ProgramCarouselItemView*)[mockView expect] setTransform:CGAffineTransformMakeTranslation(0, 100)];
    [[mockView expect] setAlpha:0.0f];
    
    void (^block)(void) = [controller animateOutWithDirection:Down];
    
    STAssertNotNil(block,@"Block is not nil");
    
    block();
    
    [mockView verify];
}

-(void)testAnimateOutComplete
{
    id mockView = [OCMockObject mockForClass:[ProgramCarouselItemView class]];
    controller.itemViews = [NSMutableSet setWithObject:mockView];
    
    [[mockView expect] setIsLoading:YES];
    
    __block BOOL completeCalled = NO;
    
    void (^block)(BOOL) = [controller animateOutCompleteBlock:^{
        completeCalled = YES;
    }];
    
    STAssertFalse(completeCalled,@"Complete not called");
    
    block(YES);
    
    STAssertTrue(completeCalled,@"Complete called");
    
    [mockView verify];
}

-(void)testAnimateInUp
{
    
    id mockView = [OCMockObject mockForClass:[ProgramCarouselItemView class]];
    controller.itemViews = [NSMutableSet setWithObject:mockView];
 
    
    [[mockCarousel expect] scrollToItemAtIndex:0 animated:NO];
    [(ProgramCarouselItemView*)[mockView expect] setTransform:CGAffineTransformMakeTranslation(0, 100)];
    
    void (^block)(void) = [controller animateInWithDirection:Up];
    
    [mockView verify];
    
    
    
    
    [(ProgramCarouselItemView*)[mockView expect] setTransform:CGAffineTransformIdentity];
    
    [[mockView expect] setAlpha:1.0f];
    
    
    block();
    
    [mockView verify];
    
}

-(void)testAnimateInDown
{
    
    id mockView = [OCMockObject mockForClass:[ProgramCarouselItemView class]];
    controller.itemViews = [NSMutableSet setWithObject:mockView];
    
    [[mockCarousel expect] scrollToItemAtIndex:0 animated:NO];
    [(ProgramCarouselItemView*)[mockView expect] setTransform:CGAffineTransformMakeTranslation(0, -100)];
    
    void (^block)(void) = [controller animateInWithDirection:Down];
    
    [mockView verify];
    
    
    [(ProgramCarouselItemView*)[mockView expect] setTransform:CGAffineTransformIdentity];
    
    [[mockView expect] setAlpha:1.0f];
    
    
    block();
    
    [mockView verify];
    
}

-(void)testAnimationInCompleteBlock
{
    [[mockCarousel expect] reloadData];
    __block BOOL comepleteCalled = NO;
    
    void (^block)(BOOL) = [controller animateInCompleteBlock:^{
        comepleteCalled = YES;
    }];
    
    STAssertFalse(comepleteCalled,@"Complete not called yet");
    
    block(YES);
    
    STAssertTrue(comepleteCalled,@"Complete was called");
}


@end
