//
//  NumericIndicatorView.m
//  MyspaceTVCompanion
//
//  Created by Bann Al-Jelawi on 17/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NumericIndicatorView.h"

@implementation NumericIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (UIImageView *)numericIndicatorForView:(NSString *)backgroundImageToUse stringForLabel:(NSString *)theStringForLabel
{
    UIImageView *backgroundImageView = [self createBackgroundImageViewForIndicator:backgroundImageToUse];
    
    UILabel *indicatorLabel = [self createLabelForIndicator:theStringForLabel];
    
    [backgroundImageView addSubview:indicatorLabel];
    
    [self addSubview:backgroundImageView];
    
    return self;
}


- (UIImageView *)createBackgroundImageViewForIndicator:(NSString *)theBackgroundImageToUse
{
    UIImageView *bgImgView;
    
    if(theBackgroundImageToUse != nil || theBackgroundImageToUse != @"")
    {
        bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:theBackgroundImageToUse]];
    }
    else
    {
        bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"on-now-btn"]];
    }
    
    return bgImgView;
}


- (UILabel *)createLabelForIndicator:(NSString *)theStringForLabel
{
    UILabel *indicatorLabelFromString = [[UILabel alloc]init];
    
    if(theStringForLabel != nil || theStringForLabel !=@"")
    {
        indicatorLabelFromString.text = theStringForLabel;
    }
    else
    {
        indicatorLabelFromString.text = @"00";
    }
    
    indicatorLabelFromString.textColor = [UIColor whiteColor];
    
    return indicatorLabelFromString;
}


@end
