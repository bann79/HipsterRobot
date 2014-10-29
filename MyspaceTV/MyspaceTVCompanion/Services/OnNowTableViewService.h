//
//  OnNowTableViewService.h
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 13/06/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EpgApi.h"
#import "ScheduleItem.h"
#import "ChannelListRequestId.h"


@protocol OnNowTableViewDelegate

@required -(void) onInitialised:(NSArray *)channels;
@required -(void) onErrorOccurred:(NSString *)errorInfo;
@required -(void) onRecievedOnNowData:(NSDictionary *)onNowData withExtraInfo:(NSDictionary*)extraInfo;
//@required -(void) onRecievedOnNowData:(NSDictionary *)onNowData;

@end


@interface OnNowTableViewService : NSObject

- (void) initialise:(id<OnNowTableViewDelegate>) delegate;
- (void) getSchedule:(NSArray *)channelCallSigns onNowTBVDelegate:(id<OnNowTableViewDelegate>) delegate;
@end
