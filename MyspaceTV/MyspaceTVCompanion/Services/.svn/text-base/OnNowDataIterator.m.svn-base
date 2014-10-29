//
//  OnNowDataIterator.m
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 11/06/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import "OnNowDataIterator.h"

@implementation OnNowDataIterator

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
                
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@" - HH:mm"];
                
                schedule.heading = program.name;
                schedule.subHeading = [channel.title stringByAppendingString:[format stringFromDate:program.startTime]];
                schedule.program = program;
                schedule.channel = channel;
                schedule.thumbnailUrl = [program getBestImageForSize:CGSizeMake(70, 70)];
                
                [delegate onReceivedScheduleItem:schedule forSlot:rowId];
                
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