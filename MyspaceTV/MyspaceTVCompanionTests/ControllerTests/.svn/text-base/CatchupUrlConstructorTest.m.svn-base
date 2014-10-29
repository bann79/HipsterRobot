//
//  CatchupUrlConstructorTest.m
//  MyspaceTVCompanion
//
//  Created by Dyfan Hughes on 09/07/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import "CatchupUrlGenerator.h"
#import "EpgApi.h"
#import <OCMock/OCMock.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface CatchupUrlConstructorTest : SenTestCase
{
    @private CatchupUrlGenerator * catchup ;
    @private Programme * program;
    @private Channel * channel;
    

}

@end


@implementation CatchupUrlConstructorTest


-(void)setUp
{
    [super setUp];
    
    catchup = [[CatchupUrlGenerator alloc]init];
    
    program = [[Programme alloc]init];
    program.programmeID = @"123456";
    program.name = @"catchupURL Test Program";
    program.synopsis = @" blah blah blah";
    program.startTime = [NSDate date];
    program.endTime = [NSDate date];
 
    
    channel = [[Channel alloc]init];
    channel.title = @"BBC1";
    channel.liveStreamUrls = [NSArray arrayWithObjects:@"http://betatv-cdn.xumo.com/live/BBC1/BBC1_multi.m3u8",nil];    
    
   
    
}

-(void)tearDown
{
    
}

-(BOOL) matchesCatchupPattern:(NSString*)str
{
    return [self matchesCatchupPattern:str 
                            withOffset:@"\\d+" 
                            withLength:@"\\d+" 
                         withChannelId:@"[\\w\\d-_]+"];
}

-(BOOL) matchesCatchupPattern:(NSString*)str withLength:(NSString*)length
{
    return [self matchesCatchupPattern:str withOffset:@"\\d+" withLength:length withChannelId:@"[\\w\\d-_]+"];
}

-(BOOL) matchesCatchupPattern:(NSString*)str withOffset:(NSString*)offset
{
    return [self matchesCatchupPattern:str withOffset:offset withLength:@"\\d+" withChannelId:@"[\\w\\d-_]+"];
}

-(BOOL) matchesCatchupPattern:(NSString*)str withChannel:(NSString*)channelId
{
    return [self matchesCatchupPattern:str withOffset:@"\\d+" withLength:@"\\d+" withChannelId:channelId];
}

-(BOOL) matchesCatchupPattern:(NSString*)str withOffset:(NSString*)offset withLength:(NSString*)length
{
    return [self matchesCatchupPattern:str withOffset:offset withLength:length withChannelId:@"[\\w\\d-_]+"];
}

-(BOOL) matchesCatchupPattern:(NSString*)str withOffset:(NSString*)offset withLength:(NSString*)length withChannelId:(NSString *) channelId
{
    NSString * catchupURLPattern = [NSString stringWithFormat:@"^.*/playlist/%@/%@_16x9_multirate.m3u8\\?offset=%@&length=%@$", channelId, channelId, offset, length];
    
    return [self stringMatches:str  pattern:catchupURLPattern];
}

-(BOOL) stringMatches:(NSString*)str pattern:(NSString*)pattern
{    
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [myTest evaluateWithObject:str];
}

-(void) testRegexMatchesCatchupUrl
{
    STAssertTrue([self matchesCatchupPattern:@"http://some.host.name/playlist/BBC1/BBC1_16x9_multirate.m3u8?offset=1341481385&length=130" ], @"");
}

-(void)testGenerstedCathupURLIsCorrectFormat
{
    
    NSString * catchupURL = [catchup generateURLWithChannel:channel andProgram:program];
    
    STAssertTrue([self matchesCatchupPattern:catchupURL], @"");

}

-(void)testCorrectStreamLengthIsCalculated
{
    program.startTime = [NSDate date];
    program.endTime = [NSDate dateWithTimeInterval:59 sinceDate:program.startTime];
    
    NSString * catchupURL = [catchup generateURLWithChannel:channel andProgram:program];
        
    STAssertTrue([self matchesCatchupPattern:catchupURL withLength:@"59"], @"");
}

-(void) testCorrectOffsetIsCalculated
{
    program.startTime = [NSDate date];
    program.endTime = [NSDate dateWithTimeInterval:59 sinceDate:program.startTime];
    
    NSTimeInterval secondsSinceEpoch = [program.startTime timeIntervalSince1970];
    
    NSString * catchupURL = [catchup generateURLWithChannel:channel andProgram:program];
    
    NSString *offsetStr = [NSString stringWithFormat:@"%.0f", secondsSinceEpoch];
    STAssertTrue([self matchesCatchupPattern:catchupURL withOffset:offsetStr], @"");
}

-(void) testChannelIdIsExtractedFromLiveUrl
{
    channel.liveStreamUrls = [NSArray arrayWithObjects:@"http://betatv-cdn.xumo.com/live/ChannelDyfan/ChannelDyfan_multi.m3u8",nil];    

    NSString * catchupURL = [catchup generateURLWithChannel:channel andProgram:program];
    
    STAssertTrue([self matchesCatchupPattern:catchupURL withChannel:@"ChannelDyfan"], @"");
}

-(void) testSameHostnameAsLiveIsUsed
{
    channel.liveStreamUrls = [NSArray arrayWithObjects:@"http://betatv-cdn.xumo.com/live/ChannelDyfan/ChannelDyfan_multi.m3u8",nil];

    NSString * catchupURL = [catchup generateURLWithChannel:channel andProgram:program];

    assertThat(catchupURL, startsWith(@"http://betatv-cdn.xumo.com"));
}

@end
