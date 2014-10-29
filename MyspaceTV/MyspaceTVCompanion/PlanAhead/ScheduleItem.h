//
//  ScheduleItem.h
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 13/06/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Programme;
@class Channel;

@interface ScheduleItem : NSObject

@property(strong, nonatomic) NSString *thumbnailUrl;
@property(strong, nonatomic) NSString *heading;
@property(strong, nonatomic) NSString *subHeading;
@property(strong, nonatomic) NSString *programeExtraInfoUrl;
@property(strong, nonatomic) Channel *channel;
@property(strong, nonatomic) Programme  *program;

@end
