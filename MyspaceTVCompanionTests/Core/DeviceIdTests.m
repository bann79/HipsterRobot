//
//  DeviceIdTests.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 03/08/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "DeviceId.h"


@interface DeviceIdTests : SenTestCase
@end

@implementation DeviceIdTests{
    
    DeviceId *deviceId;
    id mockUserDefaults;
}


-(void)setUp
{
    deviceId = [[DeviceId alloc] init];
    
    mockUserDefaults = [OCMockObject mockForClass:[NSUserDefaults class]];
    deviceId.userDefaults = mockUserDefaults;
}


-(void)tearDown
{
    [mockUserDefaults verify];
}


-(void)testGenerateUUID
{
    NSString* uuid = [deviceId generateNewDeviceId];
    
    STAssertNotNil(uuid,@"UUID not nil");
}

-(void)testStoreDeviceIDWritestoUserDefault
{
    NSString* uuid = [deviceId generateNewDeviceId];
    
    [[mockUserDefaults expect] setObject:uuid forKey:@"device-id"];
    
    [deviceId storeDeviceId:uuid];
}

-(void)testDeviceIdRetrievesStored
{
    
    id mockDeviceID = [OCMockObject partialMockForObject:deviceId];
    
    NSString *existingId = @"XXXXX-XXXXX-XXXXX";
    
    [[[mockUserDefaults expect] andReturn:existingId] objectForKey:@"device-id"];
    [[mockDeviceID reject] generateNewDeviceId];
    
    NSString *uuid = [mockDeviceID deviceId];
    
    STAssertEqualObjects(uuid,existingId, @"Retived correct uuid");
    
    
    [mockDeviceID verify];
}

-(void)testDeviceIdGeneratesNewIfStored
{
    
    
    id mockDeviceID = [OCMockObject partialMockForObject:deviceId];
    
    NSString *newId = @"XXXXX-XXXXX-XXXXX";
    [[[mockUserDefaults expect] andReturn:nil] objectForKey:@"device-id"];
    [[[mockDeviceID expect] andReturn:newId] generateNewDeviceId];
    [[mockDeviceID expect] storeDeviceId:newId];
    
    NSString *uuid = [mockDeviceID deviceId];
    
    STAssertEqualObjects(uuid,newId, @"Retived correct uuid");
    
    [mockDeviceID verify];
}

@end