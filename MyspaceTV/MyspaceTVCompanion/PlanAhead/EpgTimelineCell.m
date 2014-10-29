//
//  EpgTimelineCell.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 22/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EpgTimelineCell.h"
#import "EpgTimelineRenderer.h"

@implementation EpgTimelineCell{
    NSDate* startTime;
    BOOL isTopBar;
}

- (id)initWithDate:(NSDate*)date isTopBar:(BOOL)topbar
{
    self = [super initWithFrame:(CGRect){ {0,0}, EpgTimeLineCellSize }];
    if (self) {
        
        
        startTime = date;
        isTopBar = topbar;
        
        [self setIsAccessibilityElement:YES];
        [self setAccessibilityLabel:@"EPG Timeline Cell"];
    }
    return self;
}


-(void)update
{
    EpgTimelineRenderer* renderer = isTopBar ? [EpgTimelineRenderer topbarRenderer] : [EpgTimelineRenderer bottombarRenderer];
  
    self.image = [renderer renderCellForTime:startTime];
}


-(void)removedFromGridView:(GridView*)gv
{
    self.image = nil;
}

-(void)addedToGridView:(GridView*)gv
{
    [self update];
}

@end
