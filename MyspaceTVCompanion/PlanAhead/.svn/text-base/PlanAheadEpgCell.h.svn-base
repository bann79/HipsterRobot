//
//  PlanAheadEpgProgram.h
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 11/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EpgApi.h"
#import "EpgProgramRenderer.h"

#import "GridView.h"

@class PlanAheadEpgModel;

@interface PlanAheadEpgCell : UIImageView<GridViewCell>

@property PlanAheadEpgModel *model;

@property BOOL loaded;
@property Channel *channel;
@property NSDate *startTime;
@property NSDate *endTime;

-(void)touchedView:(CGPoint)point;
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

-(void)setPrograms: (NSArray*) programData;

-(void)removedFromGridView:(GridView*)gv;
-(void)addedToGridView:(GridView*)gv;

-(void)highlightProgram:(Programme *)p;

-(void)update;

@end

