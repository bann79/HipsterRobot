//
//  PlanAheadEpgModel.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 11/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlanAheadEpgModel.h"
#import "PlanAheadEpgCell.h"

@interface PlanAheadEpgModel() 
@end

@implementation PlanAheadEpgModel
@synthesize delegate;

@synthesize selectedChannel;

@synthesize selectedProgram;
@synthesize channelList;
@synthesize startDate,endDate;

@synthesize totalRowsInEpg, totalColumnsInEpg;


-(PlanAheadEpgModel*) initWithDelegate:(id<PlanAheadEpgDelegate>)d
{
    self.delegate = d;
    
    [[EpgApi sharedInstance] getChannelList:[EpgApi channelListId] andCall:^(NSArray *data, NSError *error) {
               
        if(error == nil){
            channelList = data;
            
            totalRowsInEpg = [channelList count];
            
            NSTimeInterval duration = [endDate timeIntervalSinceDate:startDate];
            totalColumnsInEpg =  duration / PlanAheadEpgColDuration;
            
            [delegate onEpgModelInitialised];
        }else{
            [delegate onErrorOccured:error];
        }
    }];
    
    return [super init];
}

-(Channel*)channelAt:(NSInteger)row
{
    return [channelList objectAtIndex:row];
}

-(NSDate*)startDateForCellAt:(NSInteger)column
{
    return [startDate dateByAddingTimeInterval: PlanAheadEpgColDuration * column];
}

-(NSDate*)endDateForCellAt:(NSInteger)column
{
    return [startDate dateByAddingTimeInterval: PlanAheadEpgColDuration * (column+1)];
}

-(NSInteger)horizontalOffsetForDate:(NSDate*)date
{
    return ([date timeIntervalSinceDate:startDate] * EpgCellSize.width) / PlanAheadEpgColDuration;
}

-(void)selectProgram:(Programme*)program withChannel:(Channel *)chan
{
    NSLog(@"*** model select program ***");
    selectedChannel = chan;
    
    if (program == nil) {
        return;
    } 
    
    selectedProgram = program;
    [delegate onSelectedProgramChangedTo:program];
}


@end
