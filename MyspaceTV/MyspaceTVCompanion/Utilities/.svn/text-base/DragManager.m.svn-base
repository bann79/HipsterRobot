//
//  DragManager.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DragManager.h"

@implementation DragManager

@synthesize view,pressGesture,delegate;


+(DragManager*)dragManagerForView:(UIView*)theView andDelegate:(id<DragDelegate>)aDelegate
{
    DragManager* dm = [DragManager alloc];
    dm.view = theView;
    dm.delegate = aDelegate;
    
    dm.pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(attemptDrag:)];
    
    [dm.view addGestureRecognizer:dm.pressGesture];

    return dm;
}


-(void)attemptDrag:(UILongPressGestureRecognizer*)longPressGesture
{
    UIView* draggedObject = [longPressGesture.view.subviews lastObject];
    if([delegate dragManager:self canDragItem:draggedObject]){
        
        
        
        
    }
}


@end
