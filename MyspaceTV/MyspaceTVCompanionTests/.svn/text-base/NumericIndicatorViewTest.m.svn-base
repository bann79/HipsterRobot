//
//  NumericIndicatorViewTest.m
//  MyspaceTVCompanion
//
//  Created by Bann Al-Jelawi on 17/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <OCMock/OCMock.h>
#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "NumericIndicatorView.h"


@interface NumericIndicatorViewTest : SenTestCase
{
    NumericIndicatorView *testNumericView;
}
@end


@implementation NumericIndicatorViewTest

- (void)setUp
{
    [super setUp];
    testNumericView = [[NumericIndicatorView alloc] init];
}

- (void)tearDown
{
    testNumericView = nil;
}

- (void)testThatCreatBackgroundImageViewReturnsNotNilWhenStringNilOrEmpty
{
    STAssertNotNil([testNumericView createBackgroundImageViewForIndicator:@""], @"image view should not be nil");
    STAssertNotNil([testNumericView createBackgroundImageViewForIndicator:nil], @"image view should not be nil");
}

- (void)testThatCreateLabelForIndicatorReturnsNonNilWhenStringNilOrEmpty
{
    STAssertNotNil([testNumericView createLabelForIndicator:@""], @"label should not be nil");
    STAssertNotNil([testNumericView createLabelForIndicator:nil], @"label should not be nil");
}

- (void)testThatNumericIndicatorForViewReturnsNotNilWhenBothImageAndLabelTextNil
{
    [testNumericView numericIndicatorForView:nil stringForLabel:nil];
    
    STAssertNotNil(testNumericView, @"should not be nil"); 
}

- (void)testThatNumericIndicatorForViewReturnsNotNilWhenBothImageAndLabelTextEmpty
{
    [testNumericView numericIndicatorForView:@"" stringForLabel:@""];
    
    STAssertNotNil(testNumericView, @"should not be nil"); 
}

- (void)testThatNumericIndicatorForViewReturnsNotNilWhenOnlyImageNil
{
    [testNumericView numericIndicatorForView:nil stringForLabel:@"12"];
    
    STAssertNotNil(testNumericView, @"should not be nil"); 
}

- (void)testThatNumericIndicatorForViewReturnsNotNilWhenOnlyImageEmpty
{
    [testNumericView numericIndicatorForView:@"" stringForLabel:@"12"];
    
    STAssertNotNil(testNumericView, @"should not be nil"); 
}

- (void)testThatNumericIndicatorForViewReturnsNotNilWhenOnlyLabelNil
{
    [testNumericView numericIndicatorForView:@"sub-option" stringForLabel:nil];
    
    STAssertNotNil(testNumericView, @"should not be nil"); 
}

- (void)testThatNumericIndicatorForViewReturnsNotNilWhenOnlyLabelEmpty
{
    [testNumericView numericIndicatorForView:@"sub-option" stringForLabel:@""];
    
    STAssertNotNil(testNumericView, @"should not be nil"); 
}

@end
