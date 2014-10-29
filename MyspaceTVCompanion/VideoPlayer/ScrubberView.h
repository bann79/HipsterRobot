//
//  ScrubberView.h
//  MyspaceTVCompanion
//
//  Created by Michael Lewis on 14/08/2012.
//
//

#import <UIKit/UIKit.h>
#import "ProgressBarScrubDelegate.h"

@interface ScrubberView : UISlider

@property (nonatomic, weak) IBOutlet id<ProgressBarScrubDelegate> scrubDelegate;
@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;
@property (nonatomic) float maximumSeekPosition;
@property (nonatomic) float minimumSeekPosition;
@property (nonatomic) BOOL  isAbleToScrubWithinSlider;
@property (nonatomic) float livePoint;

@property (nonatomic, strong) UIView * scrubableArea;

-(void)drawSeekableAreaWithStartPoint:(float)startPoint andDurationLength:(float) druation;
-(void)sliderValueChanged:(UISlider*) sender;

@end
