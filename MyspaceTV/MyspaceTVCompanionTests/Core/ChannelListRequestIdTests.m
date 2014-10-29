//
//  ChannelListRequestIdTests.m
//  MyspaceTVCompanion
//
//  Created by Michael Lewis on 12/09/2012.
//
//


#import <OCMock/OCMock.h>
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "ChannelListRequestId.h"

@interface ChannelListRequestIdTests : SenTestCase

@end

@implementation ChannelListRequestIdTests{
    
    ChannelListRequestId *channelListRequestId;
    id mockUserDefaults;
}

-(void)setUp
{
    channelListRequestId = [[ChannelListRequestId alloc] init];
    mockUserDefaults = [OCMockObject mockForClass:[NSUserDefaults class]];
    channelListRequestId.userDefaults = mockUserDefaults;
}

-(void)tearDown
{
    [mockUserDefaults verify];
    
    channelListRequestId = nil;
}

-(void)testChannelListIdRetrievesStored
{
    NSString * testId = @"1234";
    
    [[[mockUserDefaults expect] andReturn:testId] objectForKey:@"channel-list-id"];
    
    NSString * clistRequestId = [channelListRequestId getStoredChannelListId];
    
    STAssertEqualObjects(clistRequestId, testId, @"Retrieved correct channel list request id");
    
    [mockUserDefaults verify];
}

-(void)testChannelListSetsDefaultIfNilIsReturned
{
    id pmockChanListId = [OCMockObject partialMockForObject:channelListRequestId];
    NSString *expectedId = @"9999";
    [[[mockUserDefaults expect] andReturn:nil] objectForKey:@"channel-list-id"];
    
    [[pmockChanListId expect] storeChannelListId:expectedId];

    NSString *returnedId = [channelListRequestId getStoredChannelListId];

    STAssertEqualObjects(expectedId, returnedId, @"Stored the default id 9999 and returned it");
    [mockUserDefaults verify];
}

-(void)testSettingANewChannelList
{
    NSString * testId = @"1234";
    [[mockUserDefaults expect] setObject:testId forKey:@"channel-list-id"];
    [channelListRequestId storeChannelListId:testId];
    [mockUserDefaults verify];
}

@end
