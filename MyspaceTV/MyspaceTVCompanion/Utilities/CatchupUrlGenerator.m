//
//  CatchupUrlConstructor.m
//  MyspaceTVCompanion
//
//  Created by Dyfan Hughes on 09/07/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//

#import "CatchupUrlGenerator.h"

@implementation CatchupUrlGenerator

-(NSString*)generateURLWithChannel:(Channel*) channel andProgram:(Programme*) program
{    
    
    NSArray * splitUrl = [[channel.liveStreamUrls objectAtIndex:0] componentsSeparatedByString:@"/"];
    
    NSString * channelID = [splitUrl objectAtIndex:4];

    NSString * hostname = [splitUrl objectAtIndex:2];

    NSTimeInterval secondsBetween = [program.endTime timeIntervalSinceDate:program.startTime];

    NSTimeInterval secondsSinceEpoch = [program.startTime timeIntervalSince1970];

    return [NSString stringWithFormat:@"http://%@/playlist/%@/%@_16x9_multirate.m3u8?offset=%.0f&length=%.0f",
                    hostname, channelID, channelID, secondsSinceEpoch, secondsBetween];
}

@end
