//
//  PlanAheadEpgModel.h
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 11/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EpgApi.h"
#import "GridView.h"

static const NSInteger PlanAheadEpgColDuration = 3600 * 3;
static const NSInteger PlanAheadEpgColsPerDay = 4;

@protocol PlanAheadEpgDelegate <NSObject>

-(void) onEpgModelInitialised;
-(void) onErrorOccured: (NSError*) error;
-(void) onSelectedProgramChangedTo: (Programme*)program;
@end

@interface PlanAheadEpgModel : NSObject

@property(weak,nonatomic) id<PlanAheadEpgDelegate> delegate;

@property(readonly) NSArray *channelList;
@property NSDate *startDate;
@property NSDate *endDate;

@property(readonly) NSInteger totalRowsInEpg;
@property(readonly) NSInteger totalColumnsInEpg;


@property(readonly) Programme *selectedProgram;
@property(readonly) Channel *selectedChannel;

-(PlanAheadEpgModel*) initWithDelegate: (id<PlanAheadEpgDelegate>) delegate;

-(void)selectProgram:(Programme*)newProgram withChannel:(Channel*)chan;

-(NSInteger)horizontalOffsetForDate:(NSDate*)date;

-(NSDate*)startDateForCellAt:(NSInteger)columns;
-(NSDate*)endDateForCellAt:(NSInteger)columns;
-(Channel*)channelAt:(NSInteger)row;
@end
