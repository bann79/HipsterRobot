//
//  EpgTopBarRenderer.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EpgTimelineRenderer.h"
#import "PlanAheadEpgModel.h"
#import <QuartzCore/QuartzCore.h>


@implementation EpgTimelineRenderer

static EpgTimelineRenderer* topbarRenderer = nil;   
static EpgTimelineRenderer* bottombarRenderer = nil;   


+(EpgTimelineRenderer*) topbarRenderer
{
    if(topbarRenderer == nil){
        topbarRenderer = [[EpgTimelineRenderer alloc] init];
        topbarRenderer.image = [UIImage imageNamed:@"epg_timeline_top_bg"];
        topbarRenderer.textPos = CGRectMake(-25, 18, 70, 50);
    }
    return topbarRenderer;
}

+(void)setTopbarRenderer:(EpgTimelineRenderer*)renderer
{
    topbarRenderer = renderer;
}
  
+(EpgTimelineRenderer*) bottombarRenderer
{
    if(bottombarRenderer == nil){
        bottombarRenderer = [[EpgTimelineRenderer alloc] init];
        bottombarRenderer.image = [UIImage imageNamed:@"epg_timeline_bottom_bg"];
        bottombarRenderer.textPos = CGRectMake(-25, 25, 70, 50);
    }
    return bottombarRenderer;
}

+(void)setBottombarRenderer:(EpgTimelineRenderer*)renderer
{
    bottombarRenderer = renderer;
}

-(UIImage*) renderCellForTime:(NSDate *)date
{
    UIGraphicsBeginImageContext(EpgTimeLineCellSize);

    [_image drawAtPoint:CGPointMake(0, 0)];
    
    NSInteger baseMinutes = ([date timeIntervalSince1970] + [[NSTimeZone localTimeZone] secondsFromGMT]) / 60;
   
    for(int i =0; i < 7; i++)
    {
        
        NSInteger minutes = (i * 30 + baseMinutes) % (24 * 60);
        NSInteger hour = minutes / 60;
        
        NSString* text = [NSString stringWithFormat:@"%02d:%02d %s",
                    hour <= 12 ? hour == 0 ? 12 : hour : hour-12,
                    minutes % 60,
                    (hour < 12 ? "am":"pm")
                    ];
        
        
        if(i % 2 == 0)
        {
            [[UIColor grayColor] setFill];
            [text drawInRect:_textPos withFont:[UIFont systemFontOfSize:13]];
        }
        else
        {
            [[UIColor whiteColor] setFill];
            [text drawInRect:_textPos withFont:[UIFont systemFontOfSize:15]];
        }
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 150, 0);
        
    }
    
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return  img;
}



@end
