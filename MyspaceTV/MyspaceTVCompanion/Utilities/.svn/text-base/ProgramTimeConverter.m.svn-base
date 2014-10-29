//
//  ProgramTimeConverter.m
//  MyspaceTVCompanion
//
//  Created by Dyfan Hughes on 12/09/2012.
//
//

#import "ProgramTimeConverter.h"

@implementation ProgramTimeConverter

-(NSString*)convertStartTimeToString:(NSDate*)p_startTime
{
    NSString * startTimeToString;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"h:mma"];
    
    startTimeToString = [[formatter stringFromDate:p_startTime]lowercaseString];
    return startTimeToString;
}

-(NSString*)convertEndTimeToString:(NSDate*)p_endTime
{
    NSString * endTimeToString;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"h:mma"];
    
    endTimeToString = [[formatter stringFromDate:p_endTime]lowercaseString];
    return endTimeToString;
}

-(NSString*)setDurationWithStartTime:(NSDate*) startTime andEndTime:(NSDate*) endTime
{
    NSInteger seconds = (NSInteger)[endTime timeIntervalSinceDate:startTime];
    NSInteger minutes = (seconds/60) % 60;
    NSInteger hours = ((seconds/60) - minutes) / 60;
    
    NSString * programTimeLabel = [NSString stringWithFormat:@"%d.%d hr", hours, minutes];
    return programTimeLabel;
}

-(NSString*)setTimeRemaining:(NSDate*) startTime andEndTime:(NSDate*) endTime
{
    NSInteger seconds = (NSInteger)[endTime timeIntervalSinceDate:startTime];
    NSInteger minutes = (seconds/60) % 60;
    NSInteger hours = ((seconds/60) - minutes) / 60;
    
    if(hours == 0)
    {
        NSString * programTimeLabel = [NSString stringWithFormat:@"%d mins", minutes];
        return programTimeLabel;
    }
    else
    {
        NSString * programTimeLabel = [NSString stringWithFormat:@"%d.%d hr", hours, minutes];
        return programTimeLabel;
    }
}

-(NSString*)convertStartDateToString:(NSDate*)p_startDate
{
    NSString * startDateString;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"dd-MM-yy"];
    
    
    startDateString = [formatter stringFromDate:p_startDate];
    
    return startDateString;
}

@end
