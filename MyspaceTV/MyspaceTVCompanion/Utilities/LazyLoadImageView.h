//
//  LazyLoadImageView.h
//  MyspaceTVCompanion
//
//  Created by Bann Al-Jelawi on 14/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteImageLoader.h"

@interface LazyLoadImageView : UIImageView 

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (strong, nonatomic) RemoteImageLoader *ril;

//Specify a default image t load if we cannot get the image we want
@property (strong, nonatomic) UIImage *defaultImage;

- (void)loadDefaultImage;
- (void)lazyLoadImageFromURLString:(NSString *)theUrlString contentMode:(UIViewContentMode)theContentMode;
- (void)doLazyLoadImage:(NSString*)url;
- (BOOL)checkThatURLIsWellFormed:(NSString*)url;
//- (void)startActivityViewAnimating;
//- (void)stopActivityViewAnimating;
//- (UIImage*)getRemoteImage:(NSString*)input;

@end
