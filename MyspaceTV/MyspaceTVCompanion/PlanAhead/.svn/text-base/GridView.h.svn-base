//
//  GridView.h
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 12/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GridView;


@protocol GridViewCell <NSObject>
@optional
-(void)removedFromGridView:(GridView*)gv;
-(void)addedToGridView:(GridView*)gv;
@end
@protocol GridViewDataDelegate

-(CGSize)cellSizeForGridView:(GridView*)gridView;

-(NSInteger)rowCountForGridView:(GridView*)gridView;
-(NSInteger)columnCountForGridView:(GridView*)gridView;

-(UIView<GridViewCell>*)gridView:(GridView*)gridView createCellViewAtRow:(NSInteger)row column:(NSInteger)col;

@end

@protocol GridViewMotionDelegate <NSObject>

-(void)gridView:(GridView*)gridView movedTo:(CGPoint)offset;
-(void)gridView:(GridView*)gridView stoppedMovingAt:(CGPoint)offset;

@end



@interface GridView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, weak) id<GridViewMotionDelegate> motionDelegate; 

@property(readonly) NSSet* visibleCells;

-(void)setGridDataDelegate:(id<GridViewDataDelegate>)gridDataDelegate;

//UIScollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end
