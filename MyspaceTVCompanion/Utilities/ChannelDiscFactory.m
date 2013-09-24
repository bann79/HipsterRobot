//
//  Created by Elwyn Malethan on 19/06/2012.
//
//  Copyright (c) 2012 Specific Media. All rights reserved.
//
#import "ChannelDiscFactory.h"
#import "EpgModel.h"
#import "LazyLoadImageView.h"
#import <QuartzCore/CALayer.h>

@implementation ChannelDiscFactory
{

}

- (UILabel *)createChannelLabel:(Channel *)chan
{
    NSLog(@"*** createChannelLabel: %@", chan);
    UILabel *channelNumberLabel = [[UILabel alloc ] initWithFrame:CGRectMake(0.0, 0.0, 150.0, 43.0)];
    channelNumberLabel.textAlignment =  UITextAlignmentCenter;
    channelNumberLabel.textColor = [UIColor whiteColor];
    channelNumberLabel.backgroundColor = [UIColor clearColor];
    channelNumberLabel.font = [UIFont fontWithName:@"Verdana" size:(10.0)];
    channelNumberLabel.text = [NSString stringWithFormat:@"%@", chan.channelNumber];
    return channelNumberLabel;
}

- (LazyLoadImageView *)createLazyLoadingChannelLogo:(Channel *)chan
{
    //TODO[emalethan]: Lazy load the image to stop blocking the UI
    Thumbnail *channelThumbURL = chan.thumbnail;
    if(channelThumbURL.url == nil)
    {
        //TODO[emalethan]: Use a more appropriate default image
        channelThumbURL.url = @"http://news.bbcimg.co.uk/media/images/60898000/jpg/_60898913_jex_1435213_de53-1.jpg";
    }
    
    LazyLoadImageView* image = [[LazyLoadImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    [image lazyLoadImageFromURLString:channelThumbURL.url contentMode:UIViewContentModeScaleAspectFit];
    return image;
}

- (UIImageView *)createChannelDiscViewForChannel:(Channel *)channel withImageNamed:(NSString *)image atVerticalPosition:(float)yPos atHorizontalPosition:(float)xPos
{
    NSLog(@"*** createChannelDiscViewForChannel: %@", channel);
    UIImageView * channelDiscView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];

    LazyLoadImageView *channelIdentImageView = [self createLazyLoadingChannelLogo:channel];
   
    [channelIdentImageView setFrame:CGRectMake(channelIdentImageView.frame.origin.x, channelIdentImageView.frame.origin.y, channelIdentImageView.frame.size.width-20, channelIdentImageView.frame.size.height-20)];
    [channelIdentImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    //add label and channel ident image to channel blobby
    [channelDiscView addSubview:channelIdentImageView];

    UILabel *channelNumberLabel = [self createChannelLabel:channel];
    [channelDiscView addSubview:channelNumberLabel];

    //magic number to center
    /*channelNumberLabel.center = CGPointMake(55, 70);
    channelIdentImageView.center = CGPointMake(55, 40);*/
    
    channelIdentImageView.center = CGPointMake(48, 33);
    channelNumberLabel.center = CGPointMake(48, 64);

    [channelDiscView setFrame:CGRectMake(xPos, yPos, channelDiscView.frame.size.width, channelDiscView.frame.size.height)];
    
    [channelDiscView setIsAccessibilityElement:YES];
    [channelDiscView setAccessibilityLabel:[NSString stringWithFormat:@"Channel Disc %@", channel.title]];
    
    return channelDiscView;
}


@end