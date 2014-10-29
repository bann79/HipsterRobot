//
//  GridViewTest.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 12/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>

#import "GridView.h"

@interface GridViewTest : SenTestCase {
    
    __weak id mockDataDelegate;
    __weak id mockMotionDelegate;
    GridView* gridView;
}
@end

@implementation GridViewTest

    
-(void)setUp
{
    mockDataDelegate = [OCMockObject mockForProtocol:@protocol(GridViewDataDelegate)];
    mockMotionDelegate = [OCMockObject mockForProtocol:@protocol(GridViewMotionDelegate)];
        
    gridView = [[GridView alloc] initWithFrame:CGRectMake(0,0,400,400)];
    
    gridView.motionDelegate = mockMotionDelegate;
    
}

-(void)testCreatesCells
{
    CGSize cellSize = {250 ,250};
    NSInteger rowCount = 100;
    NSInteger columnCount = 100;
    
    [[[mockDataDelegate expect] andReturnValue:OCMOCK_VALUE(cellSize)] cellSizeForGridView:gridView];
    [[[mockDataDelegate expect] andReturnValue:OCMOCK_VALUE(rowCount)] rowCountForGridView:gridView];
    [[[mockDataDelegate expect] andReturnValue:OCMOCK_VALUE(columnCount)] columnCountForGridView:gridView];
    
    UIView* mockCellView = [[UIView alloc] init];
    
    [[[mockDataDelegate expect] andReturn:mockCellView] gridView:gridView createCellViewAtRow:0 column:0];
    [[[mockDataDelegate expect] andReturn:mockCellView] gridView:gridView createCellViewAtRow:1 column:0];
    [[[mockDataDelegate expect] andReturn:mockCellView] gridView:gridView createCellViewAtRow:1 column:1];
    [[[mockDataDelegate expect] andReturn:mockCellView] gridView:gridView createCellViewAtRow:0 column:1];
    
    
    [[mockMotionDelegate stub] gridView:[OCMArg any] stoppedMovingAt:(CGPoint){0,0}];
    
    [gridView setGridDataDelegate:mockDataDelegate];
    
    
    [mockDataDelegate verify];
}




@end
