//
//  EpgDataTransformer.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 19/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EpgDataTransformer.h"
#import "NSArray+Map.h"

@implementation EpgDataTransformer

-(NSDate*)parseDateString:(NSString *)date
{
    
    static NSDateFormatter *rfc2822DateParser = nil;
    
    if(rfc2822DateParser == nil){
       rfc2822DateParser = [[NSDateFormatter alloc] init];
       [rfc2822DateParser setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
        
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [rfc2822DateParser setLocale:usLocale];
    }
    
    @synchronized(rfc2822DateParser)
    {
        return [rfc2822DateParser dateFromString:date];
    }
}

//http://www.w3schools.com/Schema/schema_dtypes_date.asp
-(NSTimeInterval)parseXMLDurationString:(NSString*)xmlDuration
{
    if(xmlDuration == nil)
        return 0;
    
    __block NSTimeInterval result = 0;
    int sign = [xmlDuration characterAtIndex:0] == '-' ? -1 : 1;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+[DHMS]" options:0 error:nil];
    
    [regex enumerateMatchesInString:xmlDuration 
                            options:0 
                              range:NSMakeRange(0,[xmlDuration length]) 
                         usingBlock:
     ^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
         
         NSRange matchRange = match.range;
         
         int val = sign * [[xmlDuration substringWithRange:NSMakeRange(matchRange.location, matchRange.length-1)] intValue];
         char specifier = [xmlDuration characterAtIndex:matchRange.location + matchRange.length-1];
         
         switch (specifier) {
             case 'D':
                 result += val * 24 * 60 * 60;
                 break;
             case 'H':
                 result += val * 60 * 60;
                 break;
             case 'M':
                 result += val * 60;
                 break;
             case 'S':
                 result += val;
                 break;
         }
     }];
    
    return result;
}


-(Channel*)transformChannel:(NSDictionary*)chan
{
    if(chan == nil)
        return nil;
    
    Channel *newChan = [Channel alloc];
    
    newChan.channelNumber = [self nilOrJSONValue:[chan valueForKey:@"identifier"]]; 
    newChan.title         = [self nilOrJSONValue:[chan valueForKey:@"title"]];
    newChan.description   = [self nilOrJSONValue:[chan valueForKey:@"description"]];
    newChan.callSign      = [self nilOrJSONValue:[chan valueForKeyPath:@"guid.value"]];
    
    Thumbnail *newThumbnail = [Thumbnail alloc];
    newThumbnail.url = [self nilOrJSONValue:[chan valueForKeyPath:@"thumbnail.url"]];
    newThumbnail.width = [[self nilOrJSONValue:[chan valueForKeyPath:@"thumbnail.width"]] intValue];
    newThumbnail.height = [[self nilOrJSONValue:[chan valueForKeyPath:@"thumbnail.height"]] intValue];
    
    newChan.thumbnail = newThumbnail;
    
    newChan.liveStreamUrls = [self nilOrJSONValue:[chan valueForKeyPath:@"group.content.url"]];
    return newChan;
    
}

-(Programme*)transformProgram:(NSDictionary*)jsonObject
{
    if(jsonObject == nil)
        return nil;
    
    Programme* newProgram = [[Programme alloc] init];
    
    newProgram.programmeID     = [self nilOrJSONValue:[jsonObject valueForKey:@"programmeID"]];
    newProgram.name         = [self nilOrJSONValue:[jsonObject valueForKey:@"name"]];
    newProgram.synopsis     = [self nilOrJSONValue:[jsonObject valueForKey:@"synopsis"]];
    
 
    newProgram.startTime    = [self parseDateString:[self nilOrJSONValue:[jsonObject valueForKey:@"start"]]];
    
    
    newProgram.endTime      = [self parseDateString:[self nilOrJSONValue:[jsonObject valueForKey:@"end"]]];
    
    
    newProgram.images       = [self transformImages:[jsonObject valueForKey:@"images" ]];
    newProgram.extraInfoUrl = [self nilOrJSONValue:[jsonObject valueForKeyPath:@"extraInfo.link.uri"]];
        
    return newProgram;
}

-(NSArray*)transformImages:(NSArray*)images
{
    if([images count] == 0)
        return nil;
    
    return [images mapWithBlock:^id(NSDictionary* jsonImage) {
        
        return [[Thumbnail alloc]
                initWithUrl:[jsonImage valueForKey:@"uri"]
                andWidth:[[jsonImage valueForKey:@"width"] integerValue]
                andHeight:[[jsonImage valueForKey:@"height"] integerValue]
                ];
        
    }];
}

-(StaffMember*)transformStaffMember:(NSDictionary*)json
{
    if(json == nil)
        return nil;
    
    StaffMember *member = [StaffMember alloc];
    member.role =       [self nilOrJSONValue:[json valueForKey:@"role"]];
    member.firstname =  [self nilOrJSONValue:[json valueForKey:@"firstname"]];
    member.lastname =   [self nilOrJSONValue:[json valueForKey:@"lastname"]];
    return member;
}

-(ProgramImage*)transformThumbnail:(NSDictionary*)jsonObject
{
    if(jsonObject == nil)
        return nil;
    
    ProgramImage *thumbnail = [ProgramImage alloc];
    
    thumbnail.link          = [self nilOrJSONValue:[jsonObject valueForKey:@"link"]];
    thumbnail.type          = [self nilOrJSONValue:[jsonObject valueForKey:@"type"]];
    thumbnail.width         = [[self nilOrJSONValue:[jsonObject valueForKey:@"width"]] intValue];
    thumbnail.height        = [[self nilOrJSONValue:[jsonObject valueForKey:@"height"]] intValue];
    thumbnail.primary       = [[self nilOrJSONValue:[jsonObject valueForKey:@"primary"]] boolValue];
    thumbnail.category      = [self nilOrJSONValue:[jsonObject valueForKey:@"category"]];
    thumbnail.uri           = [self nilOrJSONValue:[jsonObject valueForKey:@"uri"]];
    thumbnail.caption       = [self nilOrJSONValue:[jsonObject valueForKey:@"caption"]];
    thumbnail.provider      = [self nilOrJSONValue:[jsonObject valueForKey:@"provider"]];
    thumbnail.crediLine     = [self nilOrJSONValue:[jsonObject valueForKey:@"crediLine"]];
    thumbnail.objectIDString= [self nilOrJSONValue:[jsonObject valueForKey:@"objectIDString"]];
    
    return thumbnail;
}

-(Rating*)transformRating:(NSDictionary*)ratingJson
{
    if(ratingJson == nil)
        return nil;
    
    Rating* rating = [Rating alloc];
    
    rating.warning =        [self nilOrJSONValue:[ratingJson valueForKey:@"warning"]];
    rating.area =           [self nilOrJSONValue:[ratingJson valueForKey:@"area"]];
    rating.code =           [self nilOrJSONValue:[ratingJson valueForKey:@"code"]];
    rating.description =    [self nilOrJSONValue:[ratingJson valueForKey:@"description"]];
    rating.ratingsBody =    [self nilOrJSONValue:[ratingJson valueForKey:@"ratingsBody"]];
    
    return rating;
}

-(Advisory*)transformAdvisory:(NSDictionary*)json
{
    if(json == nil)
        return nil;
    
    Advisory* advisory = [Advisory alloc];
    advisory.value = [self nilOrJSONValue:[json valueForKey:@"value"]];
    advisory.ratingsBody = [self nilOrJSONValue:[json valueForKey:@"ratingsBody"]];
    return  advisory;
}

-(QualityRating*)transformQualityRating:(NSDictionary*)json
{
    if(json == nil)
        return nil;
    
    QualityRating* quality = [QualityRating alloc];
    quality.value = [[self nilOrJSONValue:[json valueForKey:@"quality"]] floatValue];
    quality.numVotes = [[self nilOrJSONValue:[json valueForKey:@"numVotes"]] intValue];
    quality.ratingsBody = [self nilOrJSONValue:[json valueForKey:@"ratingsBody"]];    
    return  quality;
}

-(EpisodeInfo*)transformEpisodeInfo:(NSDictionary*)json
{
    if(json == nil)
        return nil;
    
    EpisodeInfo* episode = [EpisodeInfo alloc];
    episode.episodeTitle = [self nilOrJSONValue:[json valueForKeyPath:@"title.value"]];
    episode.season = [[self nilOrJSONValue:[json valueForKey:@"season"]] intValue];
    episode.number = [[self nilOrJSONValue:[json valueForKey:@"number"]] intValue];
    episode.episodes= [self nilOrJSONValue:[json valueForKey:@"episodes"]];
    return episode;
}


static NSComparisonResult compareByOrderKey(NSDictionary *a, NSDictionary *b, void *context)
{
    int orderA = [[a valueForKey:@"order"] intValue];
    int orderB = [[b valueForKey:@"order"] intValue];
    
    if ( orderA < orderB ) {
        return (NSComparisonResult)NSOrderedAscending;
    } else if ( orderA > orderB ) {
        return (NSComparisonResult)NSOrderedDescending;
    } else {
        return (NSComparisonResult)NSOrderedSame;
    };
}

-(ProgramExtraInfo*)transformExtraInfo:(NSDictionary*)json
{
   ProgramExtraInfo* programExtraInfo = [[ProgramExtraInfo alloc] init];
    
    programExtraInfo.cast = [[[self nilOrJSONValue:[json valueForKey: @"cast"]] 
                              sortedArrayUsingFunction:compareByOrderKey context:nil] 
                             mapWithSelector:@selector(transformStaffMember:) 
                             target:self];
    
    programExtraInfo.crew = [[[self nilOrJSONValue:[json valueForKey: @"crew"]]
                              sortedArrayUsingFunction:compareByOrderKey context:nil] 
                             mapWithSelector:@selector(transformStaffMember:) target:self];
    
    programExtraInfo.countries = [self nilOrJSONValue:[json valueForKey:@"countries"]];
    
    programExtraInfo.genres = [self nilOrJSONValue:[json valueForKey:@"genres"]];
    
    programExtraInfo.images = [[self nilOrJSONValue:[json valueForKey:@"images"]] 
                               mapWithSelector:@selector(transformThumbnail:) target:self];
    
    NSDictionary* ratings = [self nilOrJSONValue:[json valueForKey:@"ratings"]];
    if(ratings){
        
        programExtraInfo.ratings = [ProgramRatings alloc];
        programExtraInfo.ratings.ratings = [[self nilOrJSONValue:[ratings valueForKey:@"ratings"]]
                                            mapWithSelector:@selector(transformRating:) target:self];
        
        programExtraInfo.ratings.advisories = [[self nilOrJSONValue:[ratings valueForKey:@"advisories"]] 
                                               mapWithSelector:@selector(transformAdvisory:) target:self];
        
        programExtraInfo.ratings.qualityRatings = [[self nilOrJSONValue:[ratings valueForKey:@"qualityRatings"]] 
                                                   mapWithSelector:@selector(transformQualityRating:) target:self];
    }
    
    programExtraInfo.episodeInfo = [self transformEpisodeInfo:[self nilOrJSONValue:[json valueForKey:@"episodeInfo"]]];
    
    programExtraInfo.runtime =         [self parseXMLDurationString:[self nilOrJSONValue:[json valueForKey:@"runtime"]]];
    programExtraInfo.programmeType =   [self nilOrJSONValue:[json valueForKey:@"programmeType"]];
    programExtraInfo.origAudioLang =   [self nilOrJSONValue:[json valueForKey:@"origAudioLang"]];
    programExtraInfo.origAirDate =     [self nilOrJSONValue:[json valueForKey:@"origAirDate"]];
    
    programExtraInfo.extendedSynopsis = [self nilOrJSONValue:[json valueForKey:@"extendedSynopsis"]];
    return programExtraInfo;
}

-(id)nilOrJSONValue:(id)jsonValue
{
    if(jsonValue == [NSNull null])
    {
        return nil;
    }else {
        return jsonValue;
    }
}

@end
