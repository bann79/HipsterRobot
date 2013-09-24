//
//  ChannelCarouselDataSource.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestUtils.h"

#import "EpgApi.h"
#import "ProgramCarouselModel.h"


@interface EpgApi(Test)
+(void)setSharedInstance:(id)inst;
@end



@interface ProxyProgramCarouselModelDelegate : NSObject<ProgramCarouselModelDelegate>
@property (nonatomic,strong) id<ProgramCarouselModelDelegate> object;
@end
@implementation ProxyProgramCarouselModelDelegate
@synthesize object;
-(void)modelDidLoadMoreData:(ProgramCarouselModel *)model
{
    [object modelDidLoadMoreData:model];
}
@end


@interface ProgramCarouselModelTests : SenTestCase

@end

@implementation ProgramCarouselModelTests{
    

    id mockEpgApi;
    
    id delegate;
    ProxyProgramCarouselModelDelegate* proxyDelegate;
    
    
    Channel *mockChannel;
    
    ProgramCarouselModel *model;
}


-(void)setUp
{
    proxyDelegate = [ProxyProgramCarouselModelDelegate alloc];
    proxyDelegate.object = delegate = [OCMockObject mockForProtocol:@protocol(ProgramCarouselModelDelegate)];
    
    
    mockEpgApi = [OCMockObject mockForClass:[EpgApi class]];
    [EpgApi setSharedInstance:mockEpgApi];
    
    mockChannel = [Channel alloc];
    mockChannel.callSign = @"MOCK_CHANNEL";
    
    model = [[ProgramCarouselModel alloc] initWithChannel:mockChannel];
    
    model.delegate = proxyDelegate;
    STAssertNotNil(model.delegate,@"delegate not nil");
}

-(void)tearDown
{
    [delegate verify];
    [mockEpgApi verify];
    [EpgApi setSharedInstance:nil];
}

-(void)testGetProgramForIndex0LoadsAndCallsDelegate
{
    Programme* p = [[Programme alloc] init];
    

    void (^callback)(NSArray *data, NSError *error) = nil;
    
    [[[mockEpgApi expect] andCaptureCallbackArgument:&callback at:5]
     getScheduleForChannel:mockChannel.callSign 
     startingAt:[OCMArg any] 
     endingAt:[OCMArg any] 
     andCall:[OCMArg any]];
    
    [[delegate expect] modelDidLoadMoreData:model];
    
    Programme* result = [model getProgramForIndex:0];
    
    STAssertNil(result,@"Should be nil");
    STAssertNil(model.initialProgram,@"Not set yet");

    callback([NSArray arrayWithObject:p],nil);
    
    STAssertEquals(model.initialProgram, p, @"Set after callback");
    
    result = [model getProgramForIndex:0];
    
    STAssertEquals(result, p,@"Second call returned cached value");
}

-(void)testGetProgramForIndex0DoesNotLoadWhenInitialProgramIsSet
{
    model.initialProgram = [[Programme alloc] init];
    
    Programme* result = [model getProgramForIndex:0];
    
    STAssertEquals(result, model.initialProgram, @"Result is initial program");
}

-(void)testGetProgramInFutureUpdatesAndLoads
{
    
    model.initialProgram = [[Programme alloc] init];
    model.initialProgram.startTime = [NSDate date];
    model.initialProgram.endTime = [NSDate dateWithTimeIntervalSinceNow:60 * 10];
    
    void (^callback)(NSArray *data, NSError *error) = nil;
    
    [[[mockEpgApi expect] andCaptureCallbackArgument:&callback at:5] 
     getScheduleForChannel:mockChannel.callSign 
     startingAt:model.initialProgram.endTime 
     endingAt:[OCMArg any] 
     andCall:[OCMArg any]];
    
    
    STAssertEquals(model.requiredFuturePrograms, (NSUInteger)0, @"Does not require any future porgrams yet");
    STAssertEquals(model.loadedFuturePrograms, (NSUInteger)0,@"Has yet to load any future programs");
    
    Programme* result = [model getProgramForIndex:5];
    
    STAssertEquals(model.requiredFuturePrograms,(NSUInteger)5,@"Required feild updated");
    STAssertEquals(model.loadedFuturePrograms, (NSUInteger)0,@"Has yet to load any future yet");
    
    STAssertNil(result,@"Result is nil");
    
    [[delegate expect] modelDidLoadMoreData:model];
    
    
    STAssertNotNil(callback,@"Callback captured");
    
    if(callback)
        callback([NSArray arrayWithObjects:[Programme alloc],[Programme alloc],[Programme alloc],[Programme alloc],[Programme alloc], nil],nil);
    
    STAssertEquals(model.loadedFuturePrograms, (NSUInteger)5,@"Has loaded future item");
    
}


-(void)testGetProgramInPastUpdatesAndLoads
{
    
    model.initialProgram = [[Programme alloc] init];
    model.initialProgram.startTime = [NSDate date];
    model.initialProgram.endTime = [NSDate dateWithTimeIntervalSinceNow:60 * 10];
    
    void (^callback)(NSArray *data, NSError *error) = nil;
    
    [[[mockEpgApi expect] andCaptureCallbackArgument:&callback at:5] 
     getScheduleForChannel:mockChannel.callSign 
     startingAt:[OCMArg any]
     endingAt:model.initialProgram.startTime 
     andCall:[OCMArg any]];
    
    
    STAssertEquals(model.requiredPastPrograms, (NSUInteger)0, @"Does not require any past porgrams yet");
    STAssertEquals(model.loadedPastPrograms, (NSUInteger)0,@"Has yet to load any past programs");
    
    Programme* result = [model getProgramForIndex:-5];
    
    STAssertEquals(model.requiredPastPrograms,(NSUInteger)5,@"Required feild updated");
    STAssertEquals(model.loadedPastPrograms, (NSUInteger)0,@"Has yet to load any past yet");
    
    STAssertNil(result,@"Result is nil");
    
    [[delegate expect] modelDidLoadMoreData:model];
    
    STAssertNotNil(callback,@"Callback captured");
    
    if(callback)
    callback([NSArray arrayWithObjects:[Programme alloc],[Programme alloc],[Programme alloc],[Programme alloc],[Programme alloc], nil],nil);
    
    STAssertEquals(model.loadedPastPrograms, (NSUInteger)5,@"Has loaded past item");
    
}
@end
