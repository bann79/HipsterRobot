//
//  ImageUtils.m
//  MyspaceTVCompanion
//
//  Created by Bann Al-Jelawi on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageUtils.h"

@implementation ImageUtils


/*- (UIImage *) scaleImage:(UIImage *)imageToScale scale:(CGSize)scale
{
    
}*/


- (UIImage *) maskimage:(UIImage *)imageToMask mask:(UIImage *)mask
{
    
    //convert image and the mask to CGImage type
    CGImageRef imageNoAlpha = imageToMask.CGImage;
    CGImageRef imageMask = mask.CGImage;
    
    //do this because we need to account for images with no alpha so they get processed correctly
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    
    CGFloat width = CGImageGetWidth(imageNoAlpha);
    CGFloat height = CGImageGetWidth(imageNoAlpha);
    
    CGContextRef ctxWithAlpha = CGBitmapContextCreate(nil, width, height, 8, 4*width, cs, kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(ctxWithAlpha, CGRectMake(0, 0, width, height), imageNoAlpha);
    
    CGImageRef imageWithAlpha = CGBitmapContextCreateImage(ctxWithAlpha);
    
    //create mask
    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, imageMask);
    
    //convert CGImage back to UIImage
    UIImage *newImage = [UIImage imageWithCGImage:masked];
    
    CGImageRelease(imageNoAlpha);
    CGImageRelease(imageMask);
    CGImageRelease(imageWithAlpha);
    CGImageRelease(masked);
    CGColorSpaceRelease(cs);
    CGContextRelease(ctxWithAlpha);
    
    return newImage;
    
}


- (UIImage *) resizeImage:(UIImage *)imageToResize specifiedWidth:(int)width specifiedHeight:(int)height
{
    //create an empty image
    CGRect imageRect = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(imageRect.size);
    
    // Render the big image onto the image context[image drawInRect:imageRect];
    // Make a new one from the image context
    UIImage* thumbnail = UIGraphicsGetImageFromCurrentImageContext();

    // Make a new data object from the image
    // number represents quality of image from 0 to 1 
    NSData* thumbnailData = UIImageJPEGRepresentation(thumbnail, 1);
    
    UIImage* newImage = [UIImage imageWithData:thumbnailData];
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake((int)(roundedView.frame.origin.x), (int)(roundedView.frame.origin.y), (int)(newSize), (int)(newSize));
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}



@end
