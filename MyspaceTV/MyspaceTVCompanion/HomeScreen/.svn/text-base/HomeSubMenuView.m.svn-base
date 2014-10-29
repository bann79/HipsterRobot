//
//  UISubView.m
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 01/06/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import "HomeSubMenuView.h"

@implementation HomeSubMenuView
@synthesize topItem;
@synthesize middleItem;
@synthesize bottomItem;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(BOOL)isInsideTextAlignLeft
{
    return self.topItem.isAlignLeft;
}

-(void) setIsInsideTextAlignLeft:(BOOL)isAlignLeft
{
    self.topItem.isAlignLeft = isAlignLeft;
    self.middleItem.isAlignLeft = isAlignLeft;
    self.bottomItem.isAlignLeft = isAlignLeft;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
