//
//  DataIteratorTest.m
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 11/06/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "DataIterator.h"
#import "EpgApi.h"
#import <OCMock/OCMock.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface EpgApi (Test)
+(void)setSharedInstance:(id)api;
@end

@interface DataIteratorTest : SenTestCase
@end

@implementation DataIteratorTest

DataIterator* dataIterator;
NSMutableArray *channels;
id mockEpgApi;
id mockDelegate;


-(void) setUp
{
    [super setUp];
    
    channels = [[NSMutableArray alloc] initWithCapacity:5];
    Channel *channel = [[Channel alloc] init];
    channel.callSign = @"ANPL:tribune:uk";
    channel.channelNumber = [NSNumber numberWithInt:103];
    channel.title = @"ANPL";
    channel.description = @"ANPL description";
    [channels addObject:channel];
    
    channel = [[Channel alloc] init];
    channel.callSign = @"BBC 1:ebsftp";
    channel.channelNumber = [NSNumber numberWithInt:101];
    channel.title = @"BBC1 Wales";
    channel.description = @"BBC flagship channel";
    [channels addObject:channel];
    
    channel = [[Channel alloc] init];
    channel.callSign = @"DSC:tribune:uk";
    channel.channelNumber = [NSNumber numberWithInt:102];
    channel.title = @"DSC";
    channel.description = @"DSC description";
    [channels addObject:channel];
    
    channel = [[Channel alloc] init];
    channel.callSign = @"E!TV:tribune:uk";
    channel.channelNumber = [NSNumber numberWithInt:311];
    channel.title = @"E! TV";
    channel.description = @"Celebrity news and gossip";
    [channels addObject:channel];
    
    
    channel = [[Channel alloc] init];
    channel.callSign = @"ESPNCL:tribune:uk";
    channel.channelNumber = [NSNumber numberWithInt:150];
    channel.title = @"ESPN";
    channel.description = @"Live sports";
    [channels addObject:channel];
    
    mockEpgApi = [OCMockObject mockForClass:[EpgApi class]];
    [EpgApi setSharedInstance:mockEpgApi];
    mockDelegate = [OCMockObject mockForProtocol:@protocol(DataIteratorDelegate)];
    
    dataIterator = [[DataIterator alloc] init];
}

-(void) tearDown
{
    [EpgApi setSharedInstance:nil];
    
    dataIterator._index =0;
    dataIterator._channels = nil;
    
    mockEpgApi = nil;
    mockDelegate = nil;
    
    [super tearDown];
    
}

-(void) testReset
{
    dataIterator._index = 4;
    [dataIterator reset];
    
    STAssertTrue(dataIterator._index == 0, @"Data iterator should be reset");
}

-(void) setExpectGetChannels:(NSString*) listId andReturns:(NSArray*) channelList
{
    void (^mockFunc)(NSInvocation *invocation) = ^(NSInvocation *invocation){
        void (^callback)(NSArray *channels, NSError *error) = nil;
        [invocation getArgument:&callback atIndex:3];
        
        callback(channelList, nil);
    };
    
    [[[mockEpgApi expect] andDo:mockFunc]
     getChannelList:listId 
     andCall:[OCMArg any]];
    
}


-(void) setExpectGetChannelsFail:(NSString*) listId andReturns:(NSArray*) channelList
{
    void (^mockFunc)(NSInvocation *invocation) = ^(NSInvocation *invocation){
        void (^callback)(NSArray *channels, NSError *error) = nil;
        [invocation getArgument:&callback atIndex:3];
        NSError* error = [NSError errorWithDomain:@"Test error" code:-1 userInfo:nil];
        callback(nil,  error);
    };
    
    [[[mockEpgApi expect] andDo:mockFunc]
     getChannelList:listId 
     andCall:[OCMArg any]];
    
}

-(void) testInitialise
{
    [self setExpectGetChannels:@"9999" 
                    andReturns:channels];
    
    [[mockDelegate expect] onInitialised];
    
    [dataIterator initialise:mockDelegate];
    
    [mockDelegate verify];
    
    STAssertTrue(dataIterator._channels.count == 5, @"Got channel list");
}

-(void) testInitialiseFail
{
    [self setExpectGetChannelsFail:@"9999" 
                        andReturns:channels];
    
    [[mockDelegate expect] onErrorOccurred:instanceOf([NSString class])];
    
    [dataIterator initialise:mockDelegate];
    
    [mockDelegate verify];
}

-(void) testSuperNext
{
    dataIterator._channels = channels;
    dataIterator._index = 2;
    
    @try {
        [[mockDelegate expect] onRequestingScheduleItemForSlot:@"slot3"];
        [dataIterator next:mockDelegate forSlot:@"slot3"];
    }
    @catch (NSException *exception) {
        // You should test the exception however it makes sense in your application...
        STAssertEqualObjects([NSException class], [exception class], @"Exception Class.");

        STAssertEqualObjects(@"MethodNeedBeOverridden", exception.name, @"Exception name.");
        STAssertEqualObjects(@"Method need be overridden by sub class.", exception.reason, @"Exception reason.");
        
        [mockDelegate verify];
        return;
    }
    
    NSAssert(NO, @"The data iterator should throw an exception.");
}

@end
