//
//  ProgramTimeConverter.m
//  MyspaceTVCompanion
//
//  Created by Dyfan Hughes on 12/09/2012.
//
//
#import <Foundation/Foundation.h>
#import <OCMock/OCMock.h>
#import <SenTestingKit/SenTestingKit.h>
#import "ProgramTimeConverter.h"

@interface ProgramTimeConverterTest : SenTestCase
{
    ProgramTimeConverter * converter;
}

@end

@implementation ProgramTimeConverterTest

-(void)setUp
{
    converter = [[ProgramTimeConverter alloc]init];
}

-(void)tearDown
{
    converter = nil;
}

-(void)testStartTimeConvertWorks
{
    NSString * startTime = @"0900";
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"hhmm"];
    NSDate * startDate = [dateFormat dateFromString:startTime];
    
    NSString * convertedStartTime = [converter convertStartTimeToString:startDate];
    STAssertTrue([convertedStartTime isEqualToString:@"9:00am"], @"time isn't as expected");
}

-(void)testEndTimeWorksCorrectly
{
    NSString * endTime = @"1130";
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"hhmm"];
    NSDate * endDate = [dateFormat dateFromString:endTime];
    
    NSString * convertedStartTime = [converter convertStartTimeToString:endDate];
    STAssertTrue([convertedStartTime isEqualToString:@"11:30am"], @"time isn't as expected");
}

-(void)testDurationWorks
{
    NSString * startTime = @"0900";
    NSString * endTime = @"1000";
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"hhmm"];
    
    NSDate * startDate = [dateFormat dateFromString:startTime];
    NSDate * endDate = [dateFormat dateFromString:endTime];
    
    NSString * durationString = [converter setDurationWithStartTime:startDate andEndTime:endDate];
    STAssertTrue([durationString isEqualToString:@"1.0 hr"],@"duration isn't correct, should be %@",durationString);
}

-(void)testTimeRemainingWorks
{
    NSString * startTime = @"0900";
    NSString * endTime = @"1000";
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"hhmm"];
        
    NSDate * startDate = [dateFormat dateFromString:startTime];
    NSDate * endDate = [dateFormat dateFromString:endTime];
        
    NSString * timeLeftString = [converter setTimeRemaining:startDate andEndTime:endDate];
    STAssertTrue([timeLeftString isEqualToString:@"1.0 hr"],@"duration isn't correct, should be %@",timeLeftString);
}

-(void)testTimeRemainingWorksWithlessThanOneHourRemaining
{
    NSString * startTime = @"0900";
    NSString * endTime = @"0923";
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"hhmm"];
    
    NSDate * startDate = [dateFormat dateFromString:startTime];
    NSDate * endDate = [dateFormat dateFromString:endTime];
    
    NSString * timeLeftString = [converter setTimeRemaining:startDate andEndTime:endDate];
    STAssertTrue([timeLeftString isEqualToString:@"23 mins"],@"duration isn't correct, should be %@",timeLeftString);
}

@end
