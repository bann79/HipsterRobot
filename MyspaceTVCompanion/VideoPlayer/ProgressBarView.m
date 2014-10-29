//
//  ScrubberView.m
//  MyspaceTVCompanion
//
//  Created by Michael Lewis on 14/08/2012.
//
//

#import "ProgressBarView.h"


@implementation ProgressBarView


-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if(newSuperview){
        [self startTimer];
    }else{
        [self removeTimer];
    }
}

-(NSString*)formatTime:(CMTime)_time
{
    int time = (int)CMTimeGetSeconds(_time);
    
    int seconds = time % 60;
    int mins    = (time / 60) % 60;
    int hours = floor(time/3600);
    
    NSString *timeStr;
    if ( hours == 0) {
        timeStr = [NSString stringWithFormat:@"%02d:%02d",mins,seconds];
        
    }else{
        timeStr = [NSString stringWithFormat:@"%d:%02d:%02d",(int)hours,mins,seconds];
    }
    return timeStr;
}

- (void)syncScrubber
{
    CMTimeRange currentItem = _xumoPlayer.currentItemTimeWindow;
    CMTime time = CMTimeClampToRange([self.xumoPlayer currentTime], currentItem);
    
    CMTime livePoint =CMTimeAdd(self.xumoPlayer.seekableTimeWindow.start, self.xumoPlayer.seekableTimeWindow.duration);
    livePoint = CMTimeClampToRange(livePoint, currentItem);
    
    //Convert to time relative to start of asset
    time = CMTimeSubtract(time, currentItem.start);
    livePoint = CMTimeSubtract(livePoint,currentItem.start);

    _eclipsedTimeLbl.text = [self formatTime:time];
    _durationLbl.text = [self formatTime:CMTimeSubtract(currentItem.duration, time)];
    
    double percentageVal =  CMTimeGetSeconds(time) / CMTimeGetSeconds(currentItem.duration);
    _percentageValOfLive = CMTimeGetSeconds(livePoint) / CMTimeGetSeconds(currentItem.duration);
    
    if (isnan(percentageVal)) {
        percentageVal = 0;
    }
    
    //Dont set the position mid seek ... all kinds of weirdness happens
    if(self.xumoPlayer.state != XVPSeeking){
        _scrubberView.value = percentageVal;
        _scrubberView.livePoint = _percentageValOfLive;
        _progressView.progress = percentageVal;
    }
}

-(void)removeTimer
{
	if (self.timer)
	{
        [self.timer invalidate];
        self.timer = nil;
	}
}

-(void)startTimer
{
    if(!self.timer){
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    }
}

-(void)onTimer:(NSTimer*)t
{
    [self syncScrubber];
}


-(void)beginScrubbing
{
	[self removeTimer];

}
-(void)scrubTo:(float)percentTime;
{
        CMTime assetStart = self.xumoPlayer.currentItemTimeWindow.start;
		CMTime playerDuration = self.xumoPlayer.currentItemTimeWindow.duration;
		if (CMTIME_IS_INVALID(playerDuration)) {
			return;
		}
		
		double duration = CMTimeGetSeconds(playerDuration);
		if (isfinite(duration))
		{
            CMTime time = CMTimeMakeWithSeconds( percentTime * duration, NSEC_PER_SEC);

            _eclipsedTimeLbl.text = [self formatTime:time];
			[self.xumoPlayer seekTo: CMTimeAdd(assetStart, time)];
		}
}

-(void)endScrubbing
{
    [self startTimer];
}

-(void)setScrubbableArea
{   
    CMTimeRange currentTimeWindow = _xumoPlayer.currentItemTimeWindow;
    _programmeStartTime = currentTimeWindow.start;
    _seekableStartTime = self.xumoPlayer.seekableTimeWindow.start;
    
    float diff = (int)((int)CMTimeGetSeconds(_seekableStartTime) - (int)CMTimeGetSeconds(_programmeStartTime)) / 60;

    NSLog(@"diff %f",diff);
    if(diff < 0)
    {
        [self.scrubberView setIsAbleToScrubWithinSlider:NO];
        [self.scrubberView drawSeekableAreaWithStartPoint:0 andDurationLength:_percentageValOfLive];
    }
    
    else if( diff >= 0)
    {
        float durationMinutes = ((int)CMTimeGetSeconds(currentTimeWindow.duration) / 60);
        float startPercentage = diff / durationMinutes;
        
        float seekDuration = ((int)CMTimeGetSeconds(self.xumoPlayer.seekableTimeWindow.duration) / 60);
        float durationPercentage = seekDuration / durationMinutes;
        
        [self.scrubberView setIsAbleToScrubWithinSlider:YES];
        [self.scrubberView drawSeekableAreaWithStartPoint:startPercentage andDurationLength:durationPercentage];
    }
}

@end
