//
//  VideoItem.m
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 02/07/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import "VideoItem.h"
#import "EpgModel.h"

@implementation VideoItem
@synthesize currentChannel;
@synthesize currentProgram;
@synthesize streamUrl;

@end



@implementation VideoItemFactory
@synthesize urlGenerator;

-(VideoItemFactory*)init{
    urlGenerator = [[CatchupUrlGenerator alloc] init];
    return self;
}

-(VideoItem*)videoItemFor:(Programme*)program onChannel:(Channel*)channel
{
    VideoItem* v = [VideoItem alloc];
    
    v.currentChannel = channel;
    v.currentProgram = program;
    
    if(![program isCatchup]){
        
        v.streamUrl = [channel.liveStreamUrls lastObject];
    }else{
        v.streamUrl = [urlGenerator generateURLWithChannel:channel andProgram:program];
    }
    
    return v;
}


@end