//
//  EpgTopBarRenderer.h
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageUtils.h"

static const CGSize EpgTimeLineCellSize = {900,60};

@interface EpgTimelineRenderer : NSObject

@property UIImage* image;
@property CGRect textPos;

+(EpgTimelineRenderer*) topbarRenderer;
+(EpgTimelineRenderer*) bottombarRenderer;

-(UIImage*)renderCellForTime:(NSDate *)date;

@end
