//
//  DataIterator.h
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 11/06/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EpgApi.h"
#import "ScheduleItem.h"

@protocol DataIteratorDelegate
@required - (void) onInitialised;
@property(nonatomic, assign) BOOL isRunOutOfChannels;
@property(nonatomic, assign) BOOL isDataReady;
@required - (void) onErrorOccurred:(NSString *)errorInfo;
@required - (void) onErrorOccurred:(NSString *)errorInfo forSlot:(NSString *)slotId;
@required - (void) onRequestingScheduleItemForSlot:(NSString *)slotId;
@required - (void) onReceivedScheduleItem:(ScheduleItem *)scheduleItem forSlot:(NSString *)slotId;
@end

//super data iterator class.
@interface DataIterator : NSObject
@property(strong) NSArray* _channels;
@property int _index;

- (void) initialise:(id <DataIteratorDelegate>) delegate;
- (void) reset;
- (void) next:(id <DataIteratorDelegate>)delegate forSlot:(NSString*)rowId;
- (void) getScheduleForChannel:(Channel*)channel startingAt:(NSDate*)startTime dIDelegate:(id<DataIteratorDelegate>)delegate forSlot:(NSString* )rowId;

@end