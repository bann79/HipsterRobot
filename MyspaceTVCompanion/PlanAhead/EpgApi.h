//
//  EpgApi.h
//  LisasTestApp
//
//  Created by Lisa Croxford on 29/05/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLLoader.h"

#import "EpgModel.h"
#import "EpgDataTransformer.h"
#import "ChannelListRequestId.h"


@interface ScheduleCriteria : NSObject
@property(strong) NSArray* channelCallSigns;
@property(strong) NSDate* startTime;
@property(strong) NSDate* endTime;
@end

@interface EpgApi : NSObject

@property URLLoader *urlLoader;
@property EpgDataTransformer *transformer;
@property NSString *serverHost;
@property NSMutableDictionary* channelListCache;

+(EpgApi*)sharedInstance;

+(NSString*)channelListId;



/* Public api */

-(void)getChannelList:(NSString*) listId andCall:(void (^)(NSArray*, NSError*)) handler;

-(void)getScheduleForChannel:(NSString*)callSign startingAt:(NSDate*)startTime endingAt:(NSDate*)endTime andCall:(void (^)(NSArray*, NSError*)) handler;

-(void)getSchedule:(ScheduleCriteria*) criteria andCall:(void (^)(NSDictionary*,NSError*)) handler;

-(void)getExtraInfo:(NSString *)extraInfoUrl andCall:(void (^)(ProgramExtraInfo*, NSError *))handler;
@end
