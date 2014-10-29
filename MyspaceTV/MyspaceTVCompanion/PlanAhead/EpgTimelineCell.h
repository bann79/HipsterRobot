//
//  EpgTimelineCell.h
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 22/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridView.h"

@interface EpgTimelineCell : UIImageView<GridViewCell>

- (id)initWithDate:(NSDate*)date isTopBar:(BOOL)topbar;

-(void)update;
-(void)removedFromGridView:(GridView*)gv;
-(void)addedToGridView:(GridView*)gv;
@end
