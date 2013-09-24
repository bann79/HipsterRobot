//
//  ScrubberView.h
//  MyspaceTVCompanion
//
//  Created by Michael Lewis on 14/08/2012.
//
//

#import <UIKit/UIKit.h>
#import "XumoVideoPlayer.h"
#import "ScrubberView.h"
#import "ProgressBarScrubDelegate.h"

@interface ProgressBarView : UIView<ProgressBarScrubDelegate>
@property (strong) NSTimer *timer;

@property (nonatomic, strong) IBOutlet ScrubberView *scrubberView;
@property (nonatomic, strong) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) IBOutlet UILabel *durationLbl;
@property (nonatomic, strong) IBOutlet UILabel *eclipsedTimeLbl;
@property (nonatomic, strong) IBOutlet XumoVideoPlayer * xumoPlayer;

@property (nonatomic) CMTime programmeStartTime;
@property (nonatomic) CMTime seekableStartTime;
@property  double percentageValOfLive;

- (void)syncScrubber;

-(NSString*)formatTime:(CMTime)time;


@end
