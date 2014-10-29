//
//  VideoItem.h
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 02/07/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CatchupUrlGenerator.h"

@class Channel;
@class Programme;
@class VideoItem;

@interface VideoItemFactory : NSObject
@property CatchupUrlGenerator* urlGenerator;

-(VideoItemFactory*)init;
-(VideoItem*)videoItemFor:(Programme*)program onChannel:(Channel*)channel;
@end

@interface VideoItem : NSObject

@property(strong, nonatomic) Programme *currentProgram;
@property(strong, nonatomic) Channel *currentChannel;
@property(strong, nonatomic) NSString *streamUrl;

@end
