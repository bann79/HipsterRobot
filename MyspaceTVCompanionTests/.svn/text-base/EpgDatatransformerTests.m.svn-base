//
//  EpgDataTransformerTests.m
//
//  Created by Lisa Croxford on 29/05/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//
#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "AssertEventually/AssertEventually.h"

#import "TestUtils.h"

#import "EpgModel.h"
#import "EpgDataTransformer.h"

@interface EpgDataTransformerTests : SenTestCase{
    EpgDataTransformer* transformer;
}
@end


@implementation EpgDataTransformerTests

-(void)setUp{
    transformer = [[EpgDataTransformer alloc] init];
}

-(void)testTransformChannel
{
    NSData* data =[TestUtils loadTestData:@"epg/bbc1Channel.json"];
    NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    Channel *newChan = [transformer transformChannel:[jsonData objectForKey:@"item"]];
    
    [self validateChannel:newChan];
}


-(void)validateChannel:(Channel*)channel
{
    STAssertNotNil(channel.channelNumber,@"Channel number not nil");
    STAssertNotNil(channel.title,@"title not nil");
    STAssertNotNil(channel.description,@"Description not nil");
    STAssertNotNil(channel.callSign,@"Callsign not nil");
    STAssertNotNil(channel.thumbnail,@"thumbnail not nil");
    STAssertNotNil(channel.thumbnail.url,@"thumbnail url not nil");
    STAssertTrue( channel.thumbnail.width > 0, @"thumbnail width bigger than 0");
    STAssertTrue( channel.thumbnail.height> 0, @"thumbnail height bigger than 0");
    STAssertTrue( channel.liveStreamUrls.count> 0, @"live stream urls more than 0");
    STAssertTrue( [[channel.liveStreamUrls objectAtIndex:0] isEqualToString:@"http://betatv-cdn.xumo.com/live/BBC1/BBC1_multi.m3u8"], @"bbc 1 live stream.");
    STAssertNotNil(channel.liveStreamUrls, @"live stream url should not be nil.");
    
}

-(void)checkDateString: (NSString*) date isUnixTime: (time_t)unixTime
{
    NSDate* d = [transformer parseDateString:date];
    STAssertNotNil(d,@"parseDateString returned a result");
    
    time_t calculatedUnixTime = [d timeIntervalSince1970];
    STAssertEquals(calculatedUnixTime, unixTime,date);
}

-(void)testParseDate
{
    //Unix timestamps calculated by http://www.epochconverter.com/
    
    
    [self checkDateString:@"Wed, 16 May 2012 01:15:00 +0000" isUnixTime:1337130900];
    
    [self checkDateString:@"Wed, 16 May 2012 02:15:00 +0100" isUnixTime:1337130900];
    
    [self checkDateString:@"Fri, 01 Jun 2012 13:32:23 +0000" isUnixTime:1338557543];
    
    [self checkDateString:@"Thu, 01 Jun 2000 13:32:23 +0000" isUnixTime:959866343];
    
}

-(void)verifyXMLDateString:(NSString*)xml isEqualTo:(NSTimeInterval)expected
{
    NSTimeInterval result = [transformer parseXMLDurationString:xml];
    STAssertEquals(result, expected,xml);
}

-(void)testParseXMLDate
{
    [self verifyXMLDateString:@"P01H35M" isEqualTo:95 * 60];
    [self verifyXMLDateString:@"PT15H"   isEqualTo:15 * 60 * 60];
    [self verifyXMLDateString:@"-PT10H" isEqualTo:-10 * 60 * 60];
    
}

-(void)validateScheduleData:(NSDictionary*)data forChannels:(NSArray*) channels
{
    
    for(NSString* channelCallSign in channels){
        
        NSArray* schedule = [data objectForKey:channelCallSign];
        
        STAssertNotNil(schedule, @"Got schedule data");
        STAssertTrue(schedule.count > 0, @"Got some programs");
        
        
        for(Programme* prog in schedule)
        {
            STAssertNotNil(prog,@"Program not nil");
            STAssertNotNil(prog.programmeID,@"programmeID not nil");
            STAssertNotNil(prog.name,@"");
            STAssertNotNil(prog.synopsis,@"");
            STAssertNotNil(prog.description,@"");
            //STAssertNotNil(prog.extraInfoUrl,@"Has extra info URL");
        }
    }
    
}


-(void)verifiyStaffMember:(StaffMember*) member firstName:(NSString*) firstname lastName:(NSString*) lastname role:(NSString*) role
{    
    STAssertTrue([member.firstname isEqual:firstname], @"Firstname is correct");
    STAssertTrue([member.lastname isEqual:lastname], @"LastName is correct");
    STAssertTrue([member.role isEqual:role], @"Role is correct");
}


-(void)testTransformExtraInfo
{
    
    NSData* data =[TestUtils loadTestData:@"epg/extraInfo.json"];
    
    NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    ProgramExtraInfo *info = [transformer transformExtraInfo:[jsonData objectForKey:@"serverObject"]];
    
    STAssertEquals((int)[info.cast count], 5, @"has 5 cast members");
    
    [self verifiyStaffMember:[info.cast objectAtIndex:0] firstName:@"Peter" lastName:@"Falk"    role:@"ACTOR"];
    [self verifiyStaffMember:[info.cast objectAtIndex:1] firstName:@"Ross"  lastName:@"Martin"  role:@"Guest Star"];
    [self verifiyStaffMember:[info.cast objectAtIndex:2] firstName:@"Don"   lastName:@"Ameche"  role:@"Guest Star"];
    [self verifiyStaffMember:[info.cast objectAtIndex:3] firstName:@"Kim"   lastName:@"Hunter"  role:@"Guest Star"];
    [self verifiyStaffMember:[info.cast objectAtIndex:4] firstName:@"Vic"   lastName:@"Tayback" role:@"Guest Star"];
    
    STAssertEquals((int)[info.crew count], 1, @"has 1 crew members");
    [self verifiyStaffMember:[info.crew objectAtIndex:0] firstName:@"Paul" lastName:@"Schrader" role:@"DIRECTOR"];
    
    STAssertEquals((int)info.runtime, 95 * 60, @"Runtime is 1 hour 35 minutes, or 95 minutes");
    
    STAssertTrue([info.programmeType isEqual:@"Network Series"], @"programmeType is Network series");
    
    //Countries
    STAssertNotNil(info.countries,@"Countries not nil");
    STAssertTrue([info.countries containsObject:@"USA"], @"Contains USA as country");
    STAssertTrue([info.countries containsObject:@"italy"], @"Contains italy as country");
    
    //Genres
    STAssertNotNil(info.genres,@"Genres not nil");
    STAssertTrue([info.genres containsObject:@"Mystery"],@"Contains mystery genre");
    STAssertTrue([info.genres containsObject:@"Crime Drama"],@"Contains crime drama genre");
    
    //Images
    STAssertNotNil(info.images,@"Has images");
    STAssertEquals((int)[info.images count], 1, @"Has 1 image");
    
    ProgramImage* image = [info.images objectAtIndex:0];
    STAssertTrue([image.uri isEqual:@"http://www.colombo.com/banner"],@"Image url correct");
    
    //Ratings
    STAssertNotNil(info.ratings, @"Has ratings");
    STAssertNotNil(info.ratings.ratings,@"Has ratings");
    STAssertNotNil(info.ratings.advisories,@"Has advisories");
    STAssertNotNil(info.ratings.qualityRatings,@"Has quality ratings");

    //extended synopsis
    // LISA C: Fix this
    //STAssertNotNil(info.extendedSynopsis, @"extendedSynopsis not nil");
}

-(void)testNilOrJSONValue
{
    STAssertNil([transformer nilOrJSONValue:[NSNull null]], @"return nil when json value is NSNull null object.");
    
    STAssertEquals([transformer nilOrJSONValue:@"mock json value"], @"mock json value", @"transformer class return same non-null value.");
}
@end