//
// Created by emalethan on 06/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PlanAheadDataIterator.h"

@implementation PlanAheadDataIterator
@synthesize _queryAt;

- (void)next:(id <DataIteratorDelegate>)delegate forSlot:(NSString* )rowId
{
    if(self._channels != nil && self._index < self._channels.count)
    {   
        Channel *targetChannel = [self._channels objectAtIndex:self._index];
        
        //Update iterator index, when view controller call next method. 
        self._index++;
        _queryAt = [NSDate date];

        //notify view controller going to fentch epg data for it.
        [delegate onRequestingScheduleItemForSlot:rowId];
        [self getScheduleForChannel:targetChannel startingAt:_queryAt dIDelegate:delegate forSlot:rowId];

    }else {
        //tell delegate that there is no channel available.
        [delegate onErrorOccurred:@"There are no more channels" forSlot:rowId];
    }
}


- (void)getScheduleForChannel:(Channel*)channel startingAt:(NSDate*)startTime dIDelegate:(id<DataIteratorDelegate>)delegate forSlot:(NSString* )rowId
{
    __block NSDate *endTime = [NSDate dateWithTimeInterval:1 sinceDate:startTime];
    
    [[EpgApi sharedInstance] getScheduleForChannel:channel.callSign startingAt:startTime endingAt:endTime andCall:^(NSArray *programmes, NSError *error) {
        if(error == nil)
        {
            if(programmes.count == 1 )
            {
                Programme *program = [programmes objectAtIndex:0];
                ScheduleItem *schedule = [ScheduleItem alloc];
                
                if ([program.startTime compare:_queryAt] > 0) {    
                    schedule.heading = program.name;
                    
                    
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    [format setDateFormat:@" - HH:mm"];
                    
                    schedule.heading = program.name;
                    schedule.subHeading = [channel.title stringByAppendingString:[format stringFromDate:program.startTime]];
                    schedule.program = program;
                    schedule.channel = channel;
                    schedule.thumbnailUrl = [program getBestImageForSize:CGSizeMake(70, 70)];
                    
                    [delegate onReceivedScheduleItem:schedule forSlot:rowId];
                    
                }else {
                    //program is on now, request again, the start time will be current promgram endTime;
                    [self getScheduleForChannel:channel startingAt:program.endTime dIDelegate:delegate forSlot:rowId];
                }
                
            }else{
                //fail to get any program
                NSString *info =[NSString stringWithFormat:@"%@%d%@", @"Epg api return ", programmes.count, @" programmes."];
                [delegate onErrorOccurred:info];
            }
            
        }else {
            //there is error return by epg api.
            [delegate onErrorOccurred:[NSString stringWithFormat:@"Epg api met an error: %@",error]];
        }
    }];
}

@end