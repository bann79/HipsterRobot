//
//  DragManager.h
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DragManager;

@protocol DragDelegate <NSObject>

-(BOOL)dragManager:(DragManager*)dragManager canDragItem:(UIView*)view;
-(void)dragManager:(DragManager*)dragManager startedDraggging:(UIView*)view;
-(void)dragManager:(DragManager*)dragManager abortedDragging:(UIView*)view;
-(void)dragManager:(DragManager*)dragManager finishedDRaggging:(UIView*)view into:(UIView*)destination;
@end



@interface DragManager : NSObject

@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) id<DragDelegate> delegate;
@property (strong, nonatomic) UILongPressGestureRecognizer *pressGesture;

+(DragManager*)dragManagerForView:(UIView<DragDelegate>*)view andDelegate:(id<DragDelegate>)aDelegate;

//-(UIC

-(void)attemptDrag:(UILongPressGestureRecognizer*)longPressGesture;

@end
