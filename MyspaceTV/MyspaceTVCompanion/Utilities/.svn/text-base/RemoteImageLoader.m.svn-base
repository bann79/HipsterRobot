//
//  RemoteImageLoader.m
//  MyspaceTVCompanion
//
//  Created by Bann Al-Jelawi on 09/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RemoteImageLoader.h"

@implementation RemoteImageLoader


-(UIImage*)getRemoteImage:(NSString*)input
{
	NSURL *url = [NSURL URLWithString:input];
	NSData *data = [NSData dataWithContentsOfURL:url];

	
	if (data != nil) {
        return [[UIImage alloc] initWithData:data];
	}
    
    return nil;
}

@end
