//
//  EpgApiTests.m
//  LisasTestApp
//
//  Created by Lisa Croxford on 29/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "AssertEventually/AssertEventually.h"

#import "TestUtils.h"
#import "EpgApi.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface EpgApiTests : SenTestCase
@end

@implementation EpgApiTests{
    
    EpgApi *api;
    EpgDataTransformer *transformer;
    
    id mockTransformer;
    id urlConnection;
    int urlsLoaded;
}

- (void)setUp
{
    [super setUp];
    
    urlsLoaded = 0;
    
    transformer = [[EpgDataTransformer alloc] init];
    
    mockTransformer = [OCMockObject mockForClass:[EpgDataTransformer class]];
    urlConnection = [OCMockObject mockForClass:[URLLoader class]];
    
    
    api = [[EpgApi alloc] init];
    
    api.channelListCache = nil;//Disable caching
    api.urlLoader = urlConnection;
    api.transformer = mockTransformer;
}

-(void)tearDown
{
    [mockTransformer verify];
    [urlConnection verify];
}


-(void)setExpectLoadsUrl:(NSString*) requestPath withType:(NSString*) acceptType andReturns:(NSString*) dataFile
{
    void (^mockFunc)(NSInvocation *invocation) = ^(NSInvocation *invocation){
        void (^callback)(NSURLResponse *response, NSData *data, NSError *error) = nil;
        [invocation getArgument:&callback atIndex:4];
        
        [[NSOperationQueue currentQueue] addOperationWithBlock:^{
            
            urlsLoaded++;
            callback(nil,[TestUtils loadTestData:dataFile],nil);
        }];
    };
    
    [[[urlConnection expect] andDo:mockFunc]
     loadUrl: (NSString *)endsWith(requestPath)
     withAcceptType:acceptType 
     andCalls:[OCMArg any]];
}

-(void)setExpectFailToLoadUrl:(NSString*) requestPath
{
    
    [[[urlConnection expect] andDo:^(NSInvocation *invocation){
        
        void (^handler)(NSURLResponse *response, NSData *data, NSError *error) = nil;
        [invocation getArgument:&handler atIndex:4];
        
        [[NSOperationQueue currentQueue] addOperationWithBlock:^{
            urlsLoaded++;
            NSError* error = [NSError errorWithDomain:@"Test error" code:404 userInfo:nil];
            handler(nil,nil,error);
        }];
        
    }] loadUrl:(NSString *)endsWith(requestPath) withAcceptType:[OCMArg any] andCalls:[OCMArg any]];
}

-(void)testGetChannelsCallsURLoader
{
    [[urlConnection expect] loadUrl:[OCMArg any] withAcceptType:[OCMArg any] andCalls:[OCMArg any]];
    [api getChannelList:@"9999" andCall:nil];
}



-(void)testGetChannelsCallsback
{
    [self setExpectLoadsUrl:@"ChannelAssetManagerService/channelassetmanagerclient/channellist/9999"
                   withType:nil
                 andReturns:@"epg/serverChannelList9999.json"];

    __block bool called = false;

    [[[mockTransformer stub] andReturn: [Channel alloc]] transformChannel:[OCMArg any]];
         
    [api getChannelList:@"9999" andCall:^(NSArray *channels, NSError *error) {

        called = true;

        STAssertNil(error,@"Error was not nil");
        STAssertTrue([channels count] > 0, @"Channel list was empty");
    }];

    assertEventuallyWithBlockAndTimeout(^BOOL{return called; },5);
}

-(void)testGetInvalidChannelListIdCallsWithError
{
    [self setExpectFailToLoadUrl:@"ChannelAssetManagerService/channelassetmanagerclient/channellist/1234"];
    
    __block bool called = false;
    
    [api getChannelList:@"1234" andCall:^(NSArray *result, NSError *error){
        
        called = true;
        
        STAssertNotNil(error,   @"Error was not nil");
        STAssertNil(result,     @"Result array was nil");
    }];
    
    assertEventuallyWithBlock(^BOOL{return called; });   
}

-(void)testGetInvalidDataFromServerCallsWithSyntaxError
{
    [self setExpectLoadsUrl:@"ChannelAssetManagerService/channelassetmanagerclient/channellist/9999" 
                   withType:[OCMArg any] 
                 andReturns:@"epg/channelList9999_mangled.json"];
    
    __block bool called = false;
    
    [api getChannelList:@"9999" andCall:^(NSArray *result, NSError *error){
        
        called = true;
        
        STAssertNotNil(error,   @"Error was not nil");
        STAssertNil(result,     @"Result array was nil");
    }];
    
    assertEventuallyWithBlock(^BOOL{return called; });      
}




-(void)testGetScheduleReturnsData
{
    [self setExpectLoadsUrl:@"EpgManagerService/epgmanagerservice/BBC 1:ebsftp/2012-05-16/0" 
                   withType:[OCMArg any] 
                 andReturns:@"epg/epgChannelData0.json"];
    
    ScheduleCriteria* criteria = [[ScheduleCriteria alloc] init];
    criteria.channelCallSigns = [NSArray arrayWithObject:@"BBC 1:ebsftp"];
    criteria.startTime = [transformer parseDateString:@"Wed, 16 May 2012 00:15:00 +0000"];
    criteria.endTime = [transformer parseDateString:@"Wed, 16 May 2012 01:15:00 +0000"];
    
    __block BOOL called = NO;
    
    [[[mockTransformer stub] andReturn:[Programme alloc]] transformProgram:[OCMArg any]];
    
    [api getSchedule:criteria andCall:^(NSDictionary *data, NSError *err) {
        called = YES; 
    }];
    
    
    assertEventuallyWithBlock(^BOOL{ return called; });       
}

-(void)testGetScheduleAcrossMutiplePages
{
    [self setExpectLoadsUrl:@"EpgManagerService/epgmanagerservice/BBC 1:ebsftp/2012-05-16/12" 
                   withType:[OCMArg any] 
                 andReturns:@"epg/epgChannelData12.json"];
    
    [self setExpectLoadsUrl:@"EpgManagerService/epgmanagerservice/BBC 1:ebsftp/2012-05-16/15" 
                   withType:[OCMArg any] 
                 andReturns:@"epg/epgChannelData15.json"];
    
    [self setExpectLoadsUrl:@"EpgManagerService/epgmanagerservice/BBC 1:ebsftp/2012-05-16/18"
                   withType:[OCMArg any] 
                 andReturns:@"epg/epgChannelData18.json"];
    
    [[[mockTransformer stub] andReturn:[Programme alloc]] transformProgram:[OCMArg any]];
    
    ScheduleCriteria* criteria = [[ScheduleCriteria alloc] init];
    criteria.channelCallSigns = [NSArray arrayWithObject:@"BBC 1:ebsftp"];
    criteria.startTime = [transformer parseDateString:@"Wed, 16 May 2012 13:21:00 +0000"];
    criteria.endTime = [transformer parseDateString:@"Wed, 16 May 2012 18:30:00 +0000"];
    
    __block bool called = NO;
    
    [api getSchedule:criteria andCall:^(NSDictionary *data, NSError *err) {
        STAssertNil(err,@"No Error");
        called = YES; 
    }];
    
    assertEventuallyWithBlock(^BOOL{ return called; });      
}


-(void)testGetScheduleFailsOnceAndOnlyOnce
{
    
    [self setExpectFailToLoadUrl:@"EpgManagerService/epgmanagerservice/BBC 1:ebsftp/2012-05-16/12"];
    [self setExpectFailToLoadUrl:@"EpgManagerService/epgmanagerservice/BBC 1:ebsftp/2012-05-16/15"];
    [self setExpectFailToLoadUrl:@"EpgManagerService/epgmanagerservice/BBC 1:ebsftp/2012-05-16/18"];
    
    ScheduleCriteria* criteria = [[ScheduleCriteria alloc] init];
    criteria.channelCallSigns = [NSArray arrayWithObject:@"BBC 1:ebsftp"];
    criteria.startTime = [transformer parseDateString:@"Wed, 16 May 2012 13:21:00 +0000"];
    criteria.endTime = [transformer parseDateString:@"Wed, 16 May 2012 18:30:00 +0000"];
    
    __block bool called = NO;
    
    [api getSchedule:criteria andCall:^(NSDictionary *data, NSError *error) {
        
        STAssertFalse(called,@"Should only be called once");
        STAssertNil(data,@"No result should be returned");
        STAssertNotNil(error,@"Should have an error");
        called = YES; 
    }];
    
    assertEventuallyWithBlock(^BOOL{
        return urlsLoaded == 3;
    });
}


-(void)testGetProgramExtraInfo
{
    NSString* url = @"EpgManagerService/epgmanagerservice/programme/123wwwee-667e-4ca2-aed4-3911d5d905e0/extrainfo";
 
    [self setExpectLoadsUrl:url 
                   withType:@"application/vnd.specificmedia.mws+json;type=epgextrainfo" 
                 andReturns:@"epg/extraInfo.json"];
    
    [[[mockTransformer expect] andReturn:[ProgramExtraInfo alloc]] transformExtraInfo:[OCMArg any]];
    
    __block BOOL called = NO;
    
    [api getExtraInfo:url andCall:^(ProgramExtraInfo *info, NSError *error) {
        
        STAssertNil(error,@"No Error");
        STAssertNotNil(info,@"Has result");
               
        called = YES;
    }];
    
    assertEventuallyWithBlock(^BOOL{
        return called==YES;
    });
}

-(void)testGetProgramExtraInfoFails
{
    
    NSString* url = @"EpgManagerService/epgmanagerservice/programme/123wwwee-667e-4ca2-aed4-3911d5d905e0/extrainfo";
    
    [self setExpectFailToLoadUrl:url];
    

    __block BOOL called = NO;
    
    [api getExtraInfo:url andCall:^(ProgramExtraInfo *info, NSError *error) {
        
        STAssertNil(info,@"No data");
        STAssertNotNil(error,@"Has error");
        
        called = YES;
    }];
    
    assertEventuallyWithBlock(^BOOL{
        return called==YES;
    });
    
}

-(void)testGetProgramExtraInfoSyntaxError
{
    
    NSString* url = @"EpgManagerService/epgmanagerservice/programme/123wwwee-667e-4ca2-aed4-3911d5d905e0/extrainfo";
    
    [self setExpectLoadsUrl:url 
                   withType:@"application/vnd.specificmedia.mws+json;type=epgextrainfo"
                 andReturns:@"epg/extraInfo_mangled.json"];
    
    __block BOOL called = NO;
    
    [api getExtraInfo:url andCall:^(ProgramExtraInfo *info, NSError *error) {
        
        STAssertNil(info,@"No data");
        STAssertNotNil(error,@"Has error");
        
        called = YES;
    }];
    
    assertEventuallyWithBlock(^BOOL{
        return called==YES;
    });
    
}

@end
