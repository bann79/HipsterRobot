//
//  GridView.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 12/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GridView.h"


@interface GridView() {
    NSMutableArray* cellDatabase;
    
    NSInteger rowCount;
    NSInteger columnCount;
    CGSize    cellSize;
    

}

@property (nonatomic, weak)   id<GridViewDataDelegate> dataDelegate;
@end


@implementation GridView
@synthesize motionDelegate,visibleCells, dataDelegate;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self proccessContentRectChanged];
    [motionDelegate gridView:self movedTo:self.contentOffset];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [motionDelegate gridView:self stoppedMovingAt:self.contentOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate){
        [motionDelegate gridView:self stoppedMovingAt:self.contentOffset];
    }
}

-(void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
}


-(void)proccessContentRectChanged
{
    NSInteger leftMostCol = self.contentOffset.x / cellSize.width;
    NSInteger rightMostCol = (self.contentOffset.x + self.frame.size.width ) / cellSize.width;
    
    NSInteger topMostRow = self.contentOffset.y / cellSize.height;
    NSInteger bottomMostRow = (self.contentOffset.y + self.frame.size.height) / cellSize.height;
    
    if(leftMostCol < 0) leftMostCol = 0;
    if(rightMostCol > columnCount-1) rightMostCol = columnCount-1;
    
    if(topMostRow < 0) topMostRow = 0;
    if(bottomMostRow > rowCount-1) bottomMostRow = rowCount-1;
    
    UIView<GridViewCell>* cell = nil;
    NSMutableSet* newVisibleCells = [[NSMutableSet alloc] init];
    
    for(NSInteger col = leftMostCol; col <= rightMostCol; col++){
        for(NSInteger row = topMostRow; row <= bottomMostRow; row++){
            
            cell = [self getCellForRow:row andColumn:col];
            if(cell)
            {
                if(cell.superview != self)
                {
                    [self addSubview:cell];
                    
                    if([cell respondsToSelector:@selector(addedToGridView:)])
                        [cell addedToGridView:self];
                }
                
                [newVisibleCells addObject:cell];
            }
        }
    }
    
    for(cell in visibleCells){
        if(![newVisibleCells containsObject:cell]){
            
            [cell removeFromSuperview];
            
            if([cell respondsToSelector:@selector(removedFromGridView:)])
                [cell removedFromGridView:self];
        }
    }
    
    visibleCells = newVisibleCells;
}

-(void)setGridDataDelegate:(id<GridViewDataDelegate>)d
{
    [self setDelegate:self];
    dataDelegate = d;
    
    rowCount    = [dataDelegate rowCountForGridView:self];
    columnCount = [dataDelegate columnCountForGridView:self];
    
    cellSize    = [dataDelegate cellSizeForGridView:self];
    
    cellDatabase = [NSMutableArray arrayWithCapacity: rowCount * columnCount];
    for(int i=0; i < rowCount * columnCount; i++){
        [cellDatabase addObject: [NSNull null]];
    }
    
    self.contentSize = CGSizeMake(cellSize.width * columnCount, cellSize.height * rowCount);

    [self proccessContentRectChanged];
    [motionDelegate gridView:self stoppedMovingAt:self.contentOffset];
}

-(UIView<GridViewCell>*)getCellForRow:(NSInteger)row andColumn:(NSInteger)column
{
    NSInteger index = row * columnCount + column;
    id cell = [cellDatabase objectAtIndex:index];
    if(cell == [NSNull null]){
        UIView* cellView = [dataDelegate gridView:self createCellViewAtRow:row column:column];
        if(cellView){
            CGRect frame = {
                {column * cellSize.width, row * cellSize.height},
                cellSize
            };
            
            cellView.frame = frame;
            cellView.tag = index;
            
            cell = cellView;
            [cellDatabase replaceObjectAtIndex:index withObject:cell];
        }
    }
    return cell;
}

@end
