//
//  PlanAheadEpgProgram.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 11/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlanAheadEpgCell.h"
#import "EpgApi.h"
#import "PlanAheadEpgModel.h"
#import <QuartzCore/QuartzCore.h>

@implementation PlanAheadEpgCell {
    NSArray* data;
    NSOperation* pendingDrawOp;
}


@synthesize channel,startTime,endTime,model,loaded;

-(PlanAheadEpgCell*) init
{
    loaded = NO;
    
    CGRect frame = {0,0, EpgCellSize.width, EpgCellSize.height};
    
    self = [super initWithFrame:frame];
    self.userInteractionEnabled = YES;
    
    /*
    self.layer.borderColor = [[UIColor redColor] CGColor];
    self.layer.borderWidth = 1.0;
    */
    
    [self setImage:[[EpgProgramRenderer sharedRenderer] getLoadingImage]];
    
    return self;
}

-(NSInteger) getXForDate:(NSDate*)d
{   
    return  (EpgCellSize.width * [d timeIntervalSinceDate: startTime]) / 
                [endTime timeIntervalSinceDate: startTime];
}

-(void)cancelPendingRender
{
    if(pendingDrawOp){
        [pendingDrawOp cancel];
        pendingDrawOp = nil;
    }
}

-(void)update
{
    [self cancelPendingRender];
    pendingDrawOp = [[EpgProgramRenderer sharedRenderer]
                     renderPrograms:data 
                     beginingAt:startTime 
                     endingAt:endTime 
                     andCall:^(UIImage *result) {
                       
        pendingDrawOp = nil;
                       
        if(self.superview == nil){
            self.image = nil;
        }else{
            self.image = result;
        }
    }];
}

-(void)setPrograms:(NSArray *)programData
{   
    data = programData;
    
    if(self.superview){ //Is on screen
        [self update];
    }
    
    loaded = YES;
}


-(void)removedFromGridView:(GridView*)gv {
    
    [self cancelPendingRender];
    [self setImage:nil];
}

-(void)addedToGridView:(GridView*)gv 
{
    if(!self.image) {

        [self setImage:[[EpgProgramRenderer sharedRenderer] getLoadingImage]];
        
        if(loaded){
            [self update];
        }
    }
}

-(void)touchedView:(CGPoint)point 
{
    NSLog(@"touchedView");
    NSTimeInterval offset = (point.x * [endTime timeIntervalSinceDate:startTime]) / EpgCellSize.width;    
    NSDate *time = [startTime dateByAddingTimeInterval:offset];

    for(Programme* p in data){
        
        if([time timeIntervalSinceDate:p.startTime] > 0 &&
           [time timeIntervalSinceDate:p.endTime] < 0)
        {
            [self highlightProgram:p];
            
            return;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded");
    int x = 0;
    for(UITouch* touch in touches)
    {
        NSLog(@"count: %d", x);
        x++;
        [self touchedView:[touch locationInView:self]];
    }
    [super touchesEnded:touches withEvent:event];
}

-(void)highlightProgram:(Programme *)p
{
    //Are we currently higlighting a cell, globally across all cells in the app
    static BOOL isHighlighting = NO;
    
    if(isHighlighting)
        return;
    
    isHighlighting = YES;
    
    NSInteger x1 = [self getXForDate:p.startTime];
    NSInteger x2 = [self getXForDate:p.endTime];
    
    CGRect frame = CGRectMake(x1-1, 1, x2-x1, 98);
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:0.0 green:147.0/255.0 blue:237.0/255.0 alpha:0.75];
    view.alpha = 0.0;
    [view setClipsToBounds:NO];
    
    [self.superview bringSubviewToFront:self];
    [self addSubview:view];
    
    [UIView animateWithDuration:0.25 animations:^{
        view.alpha = 1.0;
    } completion:^(BOOL f1) {
        [UIView animateWithDuration:0.25 animations:^{
            view.alpha = 0.0;
        } completion:^(BOOL f2) {
            isHighlighting = NO;
            [view removeFromSuperview];
            [model selectProgram:p withChannel:channel];
        }];
    }];
}

@end
