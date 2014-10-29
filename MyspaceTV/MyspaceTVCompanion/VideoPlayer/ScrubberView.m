//
//  ScrubberView.m
//  MyspaceTVCompanion
//
//  Created by Michael Lewis on 14/08/2012.
//
//

#import "ScrubberView.h"

@implementation ScrubberView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventAllEvents];
    
    UIImage * minSliderImage = [[UIImage imageNamed:@"PIG_progress_back"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,5,0,0)];
    UIImage * maxSliderImage = [[UIImage imageNamed:@"PIG_progress_front"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,5,0,0)];
    UIImage * thumbImage = [UIImage imageNamed:@"PIG_handle"];
    
    [[UISlider appearance] setMinimumTrackImage:maxSliderImage forState:UIControlStateNormal];
    
    [[UISlider appearance] setMaximumTrackImage:minSliderImage forState: UIControlStateNormal];
    
    [[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateNormal];
}

-(void)sliderValueChanged:(UISlider*) sender
{
    if(self.value > _livePoint + 0.02)
    {
        self.value = _livePoint;
    }
    
    if(self.value < _minimumSeekPosition - 0.02)
    {
        self.value = _minimumSeekPosition;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.scrubDelegate beginScrubbing];
    
    [self.scrubDelegate setScrubbableArea];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self.scrubDelegate scrubTo:self.value];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.scrubDelegate endScrubbing];
    
    [UIView animateWithDuration:0.3 animations:^
    {
        [_scrubableArea setAlpha:0];
        [self setScrubableArea:nil];
    }
    ];
}

-(void)drawSeekableAreaWithStartPoint:(float)startPoint andDurationLength:(float) druation
{
    float seekStartPos = (self.frame.size.width * startPoint);
    float seekLengthPos = (self.frame.size.width * druation);
    float endSeekPosition = (seekStartPos + seekLengthPos);
    
    _maximumSeekPosition = (seekStartPos + seekLengthPos) / self.frame.size.width;
    _minimumSeekPosition = startPoint;
    
    if(endSeekPosition > self.frame.size.width)
    {
        endSeekPosition -= self.frame.size.width;
        seekLengthPos = (seekLengthPos - endSeekPosition) - 4;
    }
    
    else if(seekStartPos <= 0.0)
    {
        //set to 1 to ensure the scrubbable area lines up correctly with the slider and doesn't overlap
        seekStartPos = 1.0;
    }
    
    [self displayScrubAreaOnScreenUsingStartPoint:seekStartPos And:seekLengthPos];
}

-(void)displayScrubAreaOnScreenUsingStartPoint:(float)seekStartPos And:(float)seekLengthPos
{
    _scrubableArea = [[UIView alloc] initWithFrame:CGRectMake(seekStartPos,7,seekLengthPos,9)];
    UIImageView * viewImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TC_scrub_area"]];
    [self.scrubableArea addSubview:viewImage];
    [_scrubableArea setClipsToBounds:YES];
    [self insertSubview:_scrubableArea atIndex:2];
    [_scrubableArea setAlpha:0];
    
    [UIView animateWithDuration:0.3 animations:^
     {
         [_scrubableArea setAlpha:1];
     }];
}

@end
