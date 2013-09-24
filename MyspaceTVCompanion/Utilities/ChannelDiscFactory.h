//
//  Created by Elwyn Malethan on 19/06/2012.
//
//  Copyright (c) 2012 Specific Media. All rights reserved.
//
#import <Foundation/Foundation.h>

@class Channel;


@interface ChannelDiscFactory : NSObject
- (UIImageView *)createChannelDiscViewForChannel:(Channel *)channel withImageNamed:(NSString *)image atVerticalPosition:(float)yPos atHorizontalPosition:(float)xPos;
@end