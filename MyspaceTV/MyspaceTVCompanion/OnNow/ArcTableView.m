//
//  ArcTableView.m
//  ArcTest
//
//  Created by Michael Lewis on 12/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArcTableView.h"

@implementation ArcTableView
@synthesize arcDelegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/




- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    
    [self.arcDelegate updateArcListContentOffset:contentOffset];
}

-(void)updateArcListContentOffset:(CGPoint)contentOffset
{
    //NSLog(@"updateContentOffset: %f, %f", contentOffset.x, contentOffset.y);
}


@end
