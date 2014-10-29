//
//  EpgModelTests.m
//  MyspaceTVCompanion
//
//

#import "TestUtils.h"

#import "EpgModel.h"


@interface EpgModelTests : SenTestCase
@end


@implementation EpgModelTests


-(void)testProgramIsCatchup
{
    
    Programme* prog = [Programme alloc];

    
    prog.startTime = [NSDate dateWithTimeIntervalSinceNow:-60];
    prog.endTime = [NSDate dateWithTimeIntervalSinceNow:60];
    
    STAssertEquals(NO, [prog isCatchup],@"Program still on is not catchup");
    
    prog.endTime = [NSDate dateWithTimeIntervalSinceNow:-40];
    
    STAssertEquals(YES, [prog isCatchup],@"Program that already ended is catchup");

    
    prog.startTime = [NSDate dateWithTimeIntervalSinceNow:60];
    prog.endTime = [NSDate dateWithTimeIntervalSinceNow:120];

    STAssertEquals(NO, [prog isCatchup],@"Program in future is not catchup");
}

-(void)testProgramIsLive
{
    Programme* prog = [Programme alloc];
    
    
    prog.startTime = [NSDate dateWithTimeIntervalSinceNow:-60];
    prog.endTime = [NSDate dateWithTimeIntervalSinceNow:60];
    
    STAssertEquals(YES, [prog isLive],@"Program still on is live");
    
    prog.endTime = [NSDate dateWithTimeIntervalSinceNow:-40];
    
    STAssertEquals(NO, [prog isLive],@"Program that already ended is not live");
    
    
    prog.startTime = [NSDate dateWithTimeIntervalSinceNow:60];
    prog.endTime = [NSDate dateWithTimeIntervalSinceNow:120];
    
    STAssertEquals(NO, [prog isLive],@"Program in future is not live");  
}

-(void)testProgramIsFuture
{
    Programme* prog = [Programme alloc];
    
    
    prog.startTime = [NSDate dateWithTimeIntervalSinceNow:-60];
    prog.endTime = [NSDate dateWithTimeIntervalSinceNow:60];
    
    STAssertEquals(NO, [prog isFuture],@"Program still on is not future");
    
    prog.endTime = [NSDate dateWithTimeIntervalSinceNow:-40];
    
    STAssertEquals(NO, [prog isFuture],@"Program that already ended is not future");
    
    
    prog.startTime = [NSDate dateWithTimeIntervalSinceNow:60];
    prog.endTime = [NSDate dateWithTimeIntervalSinceNow:120];
    
    STAssertEquals(YES, [prog isFuture],@"Program in future is correct");  
}


@end