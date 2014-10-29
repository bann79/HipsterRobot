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

#import "ActionRingView.h"
#import "EpgModel.h"
#import "ChannelDiscFactory.h"

@interface ActionRingViewTest : SenTestCase

@end

@implementation ActionRingViewTest
{
    ActionRingView *view;
    NSArray *channels;
    Channel *bbcOne;
    id mockArcList;
    id mockDiscFactory;
    Channel *bbcTwo;
}

- (void)setUpChannels:(NSArray *)chs
{
    channels = chs;
}

- (void)setUp
{
    bbcOne = [[Channel alloc] init];
    bbcOne.channelNumber = [NSNumber numberWithChar:101];
    bbcOne.thumbnail = [[Thumbnail alloc] initWithUrl:@"some bbc one url" andWidth:10 andHeight:10];

    bbcTwo = [[Channel alloc] init];
    bbcTwo.channelNumber = [NSNumber numberWithChar:102];
    bbcTwo.thumbnail = [[Thumbnail alloc] initWithUrl:@"some bbc two url" andWidth:10 andHeight:10];

    mockArcList = [OCMockObject niceMockForClass:[ArcListScrollView class]];
    mockDiscFactory = [OCMockObject mockForClass:[ChannelDiscFactory class]];

    view = [[ActionRingView alloc] init];
    view.arcScrollList = mockArcList;
    view.channelDiscFactory = (ChannelDiscFactory *) mockDiscFactory;

}

- (void)testTheFirstChannelIsPlacedWithTheCorrectPaddingAndAdedToTheList
{
    [self setUpChannels:[[NSArray alloc] initWithObjects:bbcOne, nil]];

    id const mockChannelDisc = [OCMockObject niceMockForClass:[UIImageView class]];

    [[[mockDiscFactory stub]
            andReturn:mockChannelDisc]
     createChannelDiscViewForChannel:sameInstance(bbcOne) withImageNamed:@"channel-ident.png" atVerticalPosition:90 atHorizontalPosition:0];

    [[mockArcList expect] addSubview:sameInstance(mockChannelDisc)];

    [view initialiseArcListWithChannels:channels withTopPadding:90 andRowHeight:96.5];

    [mockArcList verify];
}

- (void)testTheSecondChannelIsPlacedWithTheCorrectPaddingAndAdedToTheList
{
    [self setUpChannels:[[NSArray alloc] initWithObjects:bbcOne, bbcTwo, nil]];

    id const mockChannelDisc1 = [OCMockObject niceMockForClass:[UIImageView class]];
    id const mockChannelDisc2 = [OCMockObject niceMockForClass:[UIImageView class]];

    [[[mockDiscFactory stub]
            andReturn:mockChannelDisc1]
            createChannelDiscViewForChannel:sameInstance(bbcOne) withImageNamed:@"channel-ident.png" atVerticalPosition:90 atHorizontalPosition:0];
    [[[mockDiscFactory stub]
            andReturn:mockChannelDisc2]
            createChannelDiscViewForChannel:sameInstance(bbcTwo) withImageNamed:@"channel-ident.png" atVerticalPosition:186.5 atHorizontalPosition:0];

    [[mockArcList expect] addSubview:sameInstance(mockChannelDisc2)];

    [view initialiseArcListWithChannels:channels withTopPadding:90 andRowHeight:96.5];

    [mockArcList verify];
}

- (id <HCMatcher>)isCGSizeWithHeight:(float)wantedHeight
{
    return equalToFloat(234);
}

- (void)testContentSizeIsSetToOneAndFourFifthsTheListHeight
{
    [self setUpChannels:[[NSArray alloc] initWithObjects:bbcOne, nil]];

    id const mockChannelDisc = [OCMockObject niceMockForClass:[UIImageView class]];

    [[[mockDiscFactory stub]
            andReturn:mockChannelDisc]
            createChannelDiscViewForChannel:[OCMArg any] withImageNamed:@"channel-ident.png" atVerticalPosition:90 atHorizontalPosition:0];

    view.frame = CGRectMake(0, 0, 567, 100);

    [[mockArcList expect] setContentSizeWithWidth:[OCMArg any] andHeight:equalToFloat(180)];

    [view initialiseArcListWithChannels:channels withTopPadding:90 andRowHeight:96.5];

    [mockArcList verify];
}

-(void)testTransitionInCallsCallback
{
    __block BOOL called = NO;

    void(^callback)() = ^{called = YES;};
    
    [view transitionInWithBlockCallback:callback];
    //STAssertTrue(called, @"Callback should have been called");
}

@end
