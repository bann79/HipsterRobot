//
//  LazyLoadImageView.m
//  MyspaceTVCompanion
//
//  Created by Bann Al-Jelawi on 14/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LazyLoadImageView.h"


@implementation LazyLoadImageView

@synthesize activityView, ril;
@synthesize defaultImage;

-(void)awakeFromNib
{
    //Use the image set in the nib as the default image
    self.defaultImage = self.image;
}

- (void)lazyLoadImageFromURLString:(NSString *)theUrlString contentMode:(UIViewContentMode)theContentMode
{
    self.ril = [[RemoteImageLoader alloc] init];
    
    //load default image initially
    [self loadDefaultImage];
    
    if([theUrlString length] != 0)
    {
        
        self.contentMode = theContentMode;
        
        //Not http or https then load from bundle
        if(![[theUrlString substringToIndex:4] isEqual:@"http"]){
            UIImage* img = [UIImage imageNamed:theUrlString];
            if(img){
                [self didLoadImage:img];
            }
            return;
        }
        
        
        BOOL urlIsWellFormed = [self checkThatURLIsWellFormed:theUrlString];
        if(urlIsWellFormed)
        {
            [self.activityView setHidden:NO];
            [self performSelectorInBackground:@selector(doLazyLoadImage:) withObject:theUrlString]; 
        }
    }
}


- (void)doLazyLoadImage:(NSString*)url
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString* fullPath = nil;
    
    NSString *fileName = [url stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    
    fullPath = [cacheDirectory stringByAppendingPathComponent:fileName];
    
    UIImage* image = nil;
    
 	if ((fullPath != nil) && ([fm fileExistsAtPath:fullPath isDirectory:false]))
    {
        image = [UIImage imageWithContentsOfFile:fullPath];
	}
    else
    {
        image = [self.ril getRemoteImage:url];
        [self saveImage:image toCache:fullPath];
	}
    
    if(image == nil){
        image = defaultImage;
    }
    
    [self performSelectorOnMainThread:@selector(didLoadImage:) withObject:image waitUntilDone:YES];
}

-(void)didLoadImage:(UIImage*)img
{
    NSAssert([NSThread isMainThread],@"MUST BE MAIN THREAD!?!?!?!?");
    
    self.image = img;
    [self.activityView setHidden:YES];
}

-(BOOL)checkThatURLIsWellFormed:(NSString*)url
{
    NSString *urlRegEx = @"(?i)\\b((?:((https?)|(file))://|d{0,3}[.]|[a-z0-9.\\-]+[.][a-z]{2,4}/)(?:[^\\s()<>]+|\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\))+(?:\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\)|[^\\s`!()\\[\\]{};:'\".,<>?«»“”‘’]))";
    
    
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx]; 
    
    return [urlTest evaluateWithObject:url];
}


-(void)saveImage:(UIImage*)image toCache:(NSString*)fullPath
{
    NSData *imageData = UIImagePNGRepresentation(image);
    
    if (imageData != nil)
    {
        [imageData writeToFile:fullPath atomically:YES];
    }
}


-(void)loadDefaultImage
{
    if(defaultImage != nil){
        [self didLoadImage:defaultImage];
    }
}


@end
