//
//  ArcListScrollViewTest.m
//  MyspaceTVCompanion
//
//  Created by Michael Lewis on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "ArcListScrollView.h"
#import "ArcListDelegate.h"
#import <OCMock/OCMock.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

#define MockCellHeight 97

#define radius 438
#define ArcCenterX -250
#define ArcCenterY 320

@interface ArcListScrollViewTest : SenTestCase
@end
@implementation ArcListScrollViewTest
{
    @private
    ArcListScrollView * arcListSV;
    // Allow for weak referenced delegates
    // See: http://stackoverflow.com/questions/8675054/why-is-my-objects-weak-delegate-property-nil-in-my-unit-tests
    __weak id mockArcDelegate;
    NSArray * childCollection;
    id mockImg1,mockImg2,mockImg3,mockImg4,mockImg5,mockImg6,mockImg7,mockImg8,mockImg9,mockImg10;
}


-(void)setUp
{
    arcListSV = [[ArcListScrollView alloc] init];
    mockArcDelegate = [OCMockObject mockForProtocol:@protocol(ArcListDelegate)];
    mockImg1 = [OCMockObject niceMockForClass:[UIImageView class]];
   // [mockImg1 setFrame:CGRectMake(0.0, 0.0, 109, 107)];
    mockImg2 = [OCMockObject niceMockForClass:[UIImageView class]];
   // [mockImg2 setFrame:CGRectMake(0.0, (mockImg1.frame.origin.y+ mockImg1.frame.size.height+20), 109, 107)];
    mockImg3 = [OCMockObject niceMockForClass:[UIImageView class]];
   // [mockImg3 setFrame:CGRectMake(0.0, (mockImg2.frame.origin.y+ mockImg2.frame.size.height+20), 109, 107)];
    mockImg4 = [OCMockObject niceMockForClass:[UIImageView class]];
   // [mockImg4 setFrame:CGRectMake(0.0, (mockImg3.frame.origin.y+ mockImg3.frame.size.height+20), 109, 107)];
    mockImg5 = [OCMockObject niceMockForClass:[UIImageView class]];
   // [mockImg5 setFrame:CGRectMake(0.0, (mockImg4.frame.origin.y+ mockImg4.frame.size.height+20), 109, 107)];
    mockImg6 = [OCMockObject niceMockForClass:[UIImageView class]];
   // [mockImg6 setFrame:CGRectMake(0.0, (mockImg5.frame.origin.y+ mockImg5.frame.size.height+20), 109, 107)];
    mockImg7 = [OCMockObject niceMockForClass:[UIImageView class]];
   // [mockImg7 setFrame:CGRectMake(0.0, (mockImg6.frame.origin.y+ mockImg6.frame.size.height+20), 109, 107)];
    mockImg8 = [OCMockObject niceMockForClass:[UIImageView class]];
   // [mockImg8 setFrame:CGRectMake(0.0, (mockImg7.frame.origin.y+ mockImg7.frame.size.height+20), 109, 107)];
    mockImg9 = [OCMockObject niceMockForClass:[UIImageView class]];
   // [mockImg9 setFrame:CGRectMake(0.0, (mockImg8.frame.origin.y+ mockImg8.frame.size.height+20), 109, 107)];
    mockImg10 = [OCMockObject niceMockForClass:[UIImageView class]];
   // [mockImg10 setFrame:CGRectMake(0.0, (mockImg9.frame.origin.y+ mockImg9.frame.size.height+20), 109, 107)];
    childCollection = [NSArray arrayWithObjects:mockImg1, mockImg2, mockImg3, mockImg4, mockImg5, mockImg6, mockImg7, mockImg8, mockImg9, mockImg10, nil];
}

-(void)tearDown
{
    arcListSV.arcDelegate = nil;
    arcListSV = nil;
    mockArcDelegate = nil;
    childCollection = nil;
}

-(void)testNoAssignmentOfDelegate
{
    //STAssertFalse(arcListSV.arcDelegate == mockArcDelegate,@"Arc Delegate was expected to be not set but was.");
    //STAssertEquals(mockArcDelegate, arcListSV.arcDelegate, @"ArcDelegate has been successful assigned");
    STAssertTrue(arcListSV.arcDelegate == nil, @"Arc Delegate should not be set");
}


-(void)testThatTheArcListIsNotNil
{
    assertThat(arcListSV, notNilValue());
}



-(void)testAssignmentOfArcDelegate
{
    [arcListSV setArcDelegate:mockArcDelegate];
    STAssertEquals(mockArcDelegate, arcListSV.arcDelegate, @"ArcDelegate has been successful assigned");
}

-(void)testCellHeightHasBeenSet
{
    int testCellHeight = 100;
    
    [arcListSV setCellHeight:testCellHeight];
    
    int assignCellHeight = arcListSV.cellHeight;
    
    STAssertEquals(testCellHeight, assignCellHeight, @"the assigned cell height of %i was expected to be %i",assignCellHeight,testCellHeight);
}


-(void)testSetContentOffsetCallsDelegatesUpdateContentOffsetAnimated
{
    // This is used to detect the dragging of the list, not testing the drag because its apples problem :)
    
    [arcListSV setArcDelegate:mockArcDelegate];
    CGPoint testPoint = CGPointMake(100, 20.0);
    
    BOOL animated = YES;
    
    [[mockArcDelegate expect] updateContentOffset:testPoint animated:YES];
    
    [arcListSV setContentOffset:testPoint animated:animated];
    
    [mockArcDelegate verify];
}

-(void)testSetContentOffsetCallsDelegatesUpdateContentOffset
{
    // This is used to detect the dragging of the list.
    [arcListSV setArcDelegate:mockArcDelegate];
    CGPoint testPoint = CGPointMake(100, 20.0);
    
    [[mockArcDelegate expect] updateContentOffset:testPoint];
    
    [arcListSV setContentOffset:testPoint];
    
    [mockArcDelegate verify];
}

-(void)testSetContentOffsetCallsDelegatesUpdateContentOffsetAnimatedWithoutDelegate
{
    CGPoint testPoint = CGPointMake(100, 20.0);
    
    BOOL animated = YES;
    
    STAssertNoThrow([arcListSV setContentOffset:testPoint animated:animated], @"Should not throw an exception if the arcdelegate did not set");
}

-(void)testSetContentOffsetCallsDelegatesUpdateContentOffsetWithoutDelegate
{
    CGPoint testPoint = CGPointMake(100, 20.0);

    STAssertNoThrow([arcListSV setContentOffset:testPoint], @"Should not throw an exception if the arcdelegate did not set");
}

-(void)testChildCollectionIsNotEmpty
{
    CGPoint testOffsetPoint = CGPointMake(0, 0);
    [arcListSV setArcLayout:childCollection withOffset:testOffsetPoint];
    int arcChildCount = [arcListSV.childCollection count];
    float yOffset = arcListSV.currentArcYOffset;
    float expectedYOffset = 0.0;
    STAssertTrue(arcChildCount>0,@"the child collection should not be 0 it was %i", arcChildCount);
    STAssertTrue(yOffset==expectedYOffset,@"the offset of the scrolls content initial offset should be %f but is %f", expectedYOffset ,yOffset);
}

-(void)testTheArcLayout
{
    CGPoint testPoint = CGPointMake(0, 200);
    CGSize mockViewPortSize = CGSizeMake(500, 748);
    CGRect mockFrame = CGRectMake(testPoint.x,testPoint.y, mockViewPortSize.width, mockViewPortSize.height);
    [arcListSV setFrame:mockFrame];

    int mockPaddingCellTop = 10;
    int mockPaddingCellBottom = 10;

    int mockFirstChildIndex = (int)floor(testPoint.y/(MockCellHeight+mockPaddingCellTop+mockPaddingCellBottom));
    [arcListSV setArcCenterX:ArcCenterX];
    [arcListSV setArcCenterY:ArcCenterY];
    [arcListSV setCellPaddingBottom:mockPaddingCellBottom];
    [arcListSV setCellPaddingTop:mockPaddingCellTop];
    [arcListSV setCellHeight:MockCellHeight];
    [arcListSV setArcLayout:childCollection withOffset:testPoint];

    float mockCompleteCellSize = MockCellHeight+mockPaddingCellTop+mockPaddingCellBottom;
    int expectedVisibleChildren = (int)round(mockViewPortSize.height/mockCompleteCellSize)+1;

    STAssertEquals(expectedVisibleChildren, arcListSV.visibleAmountOfChildren, @"expected visible children to be %i but got %i", expectedVisibleChildren, arcListSV.visibleAmountOfChildren);
    STAssertEquals(mockPaddingCellBottom, arcListSV.cellPaddingBottom, @"Cell bottom padding should be %i but was %i ", mockPaddingCellBottom,arcListSV.cellPaddingBottom);
    STAssertEquals(mockPaddingCellTop, arcListSV.cellPaddingTop, @"Cell top padding should be %i but was %i ", mockPaddingCellTop,arcListSV.cellPaddingTop);

    int firstChildIndex = arcListSV.firstChildIndex;

    STAssertTrue(firstChildIndex == 1, @"Expect array index to be 1 but was %i",firstChildIndex);
    STAssertTrue(firstChildIndex == mockFirstChildIndex, @"firstChildIndex should be equal to %i but was %i", mockFirstChildIndex, firstChildIndex);

    //TODO: Need to add a test that checks that setFrame was called.
}

-(void)testPositionChildOnAppropriateArcX
{
    //[[mockImg3 expect] setFrame:CGRectMake(107 , 0.0 , 109, 107)];
     //TODO: Need to add a test that checks that setFrame was called.
    float mockY = 200;
    float expectedX = (float)round(ArcCenterX + sqrt( radius*radius - (mockY-ArcCenterY)*(mockY-ArcCenterY)));

    int arcX = ArcCenterX;
    int arcY = ArcCenterY;

    [arcListSV setArcCenterX:arcX];
    [arcListSV setArcCenterY:arcY];
    float returnedX = (float)round([arcListSV getTargetX:mockY]);

    [arcListSV positionChildOnAppropriateArcX:(UIImageView *)mockImg3];
    int tArcCenterX = arcListSV.arcCenterX;
    int tArcCenterY = arcListSV.arcCenterY;
    STAssertEquals(tArcCenterX, ArcCenterX, @"arcListSV.arcCenterX should be %i but was %i", ArcCenterX, tArcCenterX);
    STAssertEquals(tArcCenterY, ArcCenterY, @"arcListSV.arcCenterY should be %i but was %i", ArcCenterY, tArcCenterY);

    STAssertEquals(expectedX, returnedX, @"Expected a new X position of %f but got %f instead.",expectedX, returnedX);

    //[mockImg3 verify];
}





@end
