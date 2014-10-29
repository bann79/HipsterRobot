
//  EpgApi.m
//  LisasTestApp
//
//  Created by Lisa Croxford on 29/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EpgApi.h"
#import "Foundation/Foundation.h"

#import "NSArray+Map.h"

#import "DDLog.H"
#include <libkern/OSAtomic.h>

static const int ddLogLevel = LOG_LEVEL_ERROR;

NSString *EPG_URL           = @"http://%@/EpgManagerService/epgmanagerservice/%@/%@/%d";
NSString *CHANNEL_LIST_URL  = @"http://%@/ChannelAssetManagerService/channelassetmanagerclient/channellist/%@";


@implementation ScheduleCriteria
@synthesize channelCallSigns;
@synthesize startTime;
@synthesize endTime;
@end


@implementation EpgApi{
    NSOperationQueue *sharedOperationQueue;
    NSCalendar *gregorianCalendar;
    NSDateFormatter *dateFormatter;

}
static EpgApi* instance = nil;

@synthesize urlLoader;
@synthesize transformer;
@synthesize serverHost;

-(EpgApi*)init
{
    transformer = [[EpgDataTransformer alloc] init];
    
    NSTimeZone* utc = [NSTimeZone timeZoneForSecondsFromGMT:0]; //Use UTC when constructing dates 
    
    gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];    
    [gregorianCalendar setTimeZone:utc];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    [dateFormatter setTimeZone:utc];
        
    sharedOperationQueue = [[NSOperationQueue alloc] init];
    
    urlLoader = [[URLLoader alloc] init];
    urlLoader.queue = sharedOperationQueue;
         
    serverHost = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MiddlewareServerHost"];
    
    _channelListCache = [NSMutableDictionary dictionary];
    
    return [super init];
}

+(EpgApi*)sharedInstance
{
    
    if(instance == nil){
        instance = [[EpgApi alloc]init];
    }
    return instance;
}

+(void)setSharedInstance:(EpgApi*)api
{
    instance = api;
}

+(NSString*)channelListId
{
    NSString * channelListId = [ChannelListRequestId channelListId];
    return channelListId;
}

-(void)getChannelList:(NSString*)listId andCall:(void (^)(NSArray *, NSError *))handler
{
    NSLog(@"Getting channel list: %@", listId);
    
    @synchronized(_channelListCache){
        NSArray* channelList = [_channelListCache objectForKey:listId];
        if(channelList){
            
            //Dont call syncronously
            [[NSOperationQueue currentQueue] addOperationWithBlock:^{
                handler(channelList,nil);
            }];
            return;
        }
    }
    
    NSOperationQueue *callingQueue = [NSOperationQueue currentQueue];
        
    [urlLoader loadUrl:[NSString stringWithFormat:CHANNEL_LIST_URL,serverHost,listId]
        withAcceptType:nil //@"application/json"
              andCalls:^(NSURLResponse *response, NSData *data, NSError *error) 
     {
         NSMutableDictionary *json = nil;
         NSArray *result = nil;
         
         if(error == nil){
             json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
             
             DDLogVerbose(@"Channel list data: %@", json);
         }
         
         if(error == nil){
             result = [[[json 
                          valueForKey:@"channel"] 
                          valueForKey: @"items"] 
                       mapWithSelector:@selector(transformChannel:) target:transformer];
         }
         
         if(error){
             DDLogError(@"Error getting channel list: %@",error);
             if(data) DDLogError(@"Data is: \n %@", [[NSString alloc] initWithData:data encoding:0]);
         }
         
         if(result)
         {
             @synchronized(_channelListCache){
                 [_channelListCache setObject:result forKey:listId];
             }
         }
         
         [callingQueue addOperationWithBlock:^{
             handler(result,error);
         }];
     }];
}


-(bool)program:(Programme*) program matchesRangeStartingAt:(NSDate*)start andEndingAt:(NSDate*)end
{
    NSTimeInterval startTime = [start timeIntervalSince1970];
    NSTimeInterval endTime   = [end timeIntervalSince1970];
    
    NSTimeInterval programStart = [program.startTime timeIntervalSince1970];
    NSTimeInterval programEnd = [program.endTime timeIntervalSince1970];
    
    if(programStart >= startTime && programEnd   <= endTime) //Fully inside range
        return true; 
    
    if(programStart <= startTime && programEnd   >= endTime) //Full overlaps range
        return true; 
    
    if(programStart <= startTime && programEnd   >  startTime) //Overlaps begining of range
        return true; 
    
    if(programStart < endTime    && programEnd >=  endTime) //Overlaps end of range
        return true; 
    
    //NSLog(@"Program %@ not within %@-%@ start:%@ end:%@", program.name, start, end, program.startTime, program.endTime);
    return false;
}


-(void)getScheduleForChannel:(NSString*)callSign startingAt:(NSDate*)startTime endingAt:(NSDate*)endTime andCall:(void (^)(NSArray*, NSError*)) handler
{
    DDLogInfo(@"GetScheduleForChannel: %@ start:%@ end:%@",callSign,startTime,endTime);
    
    NSOperationQueue *callingQueue = [NSOperationQueue currentQueue];
    
    const NSTimeInterval pageLength = 3 * 3600;
    
    NSDateComponents* components = [gregorianCalendar components:0xffffff fromDate:startTime];
    
    [components setHour:(components.hour / 3) * 3];
    [components setMinute:0];
    [components setSecond:0];
    
    NSMutableArray *pagesToFetch = [NSMutableArray array];
    
    NSDate* startingPageTime = [gregorianCalendar dateFromComponents:components];
    for(NSDate* time = startingPageTime; 
        ([time earlierDate:endTime] == time);
        time = [time dateByAddingTimeInterval:pageLength])
    {
        
        NSInteger pageNumber = [gregorianCalendar components:NSHourCalendarUnit fromDate:time].hour;
        NSString* dateString = [dateFormatter stringFromDate:time];
        NSString* pageUrl = [NSString stringWithFormat:EPG_URL, serverHost, callSign, dateString, pageNumber];
        
        [pagesToFetch addObject:pageUrl];
    }
     
    
    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
    __block volatile int pagesFetched = 0;
    __block volatile BOOL aborted = NO;
        
    for(NSString* pageUrl in pagesToFetch){
        
        [urlLoader loadUrl:pageUrl withAcceptType:@"application/vnd.specificmedia.mws+json;type=epgschedule" andCalls:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if(aborted)
                return;
            
            NSMutableDictionary *json;
            if(!error){
                json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                DDLogVerbose(@"Schedule data: %@", json);
            }
            
            if(error != nil){
                aborted = YES;
                [callingQueue addOperationWithBlock:^{
                    handler(nil,error);
                }];
                return;
            }
            
            NSArray* programmes = [[json valueForKey:@"serverObject"] valueForKey:@"programmes"];
            for(NSDictionary* jsonObject in programmes)
            {
                Programme* program = [transformer transformProgram:jsonObject];      
                if([self program:program matchesRangeStartingAt:startTime andEndingAt:endTime])   
                {
                    //Store in a dictionary of object ids to ensure uniqueness
                    @synchronized(temp)
                    {
                        [temp setValue:program forKey:program.programmeID];
                    }
                }
            }
            
            OSAtomicIncrement32(&pagesFetched);
            
            if(pagesFetched == [pagesToFetch count]) {
                
                //Pull out a sorted array of the programs, ensures they are in the right order when server responses can return out of order
                NSArray* result = [[temp allValues] sortedArrayUsingComparator:^NSComparisonResult(Programme* a, Programme* b){
                    
                    return [a.startTime compare:b.startTime];
                }];
                
                [callingQueue addOperationWithBlock:^{
                    handler(result,nil);
                }];
                
            }
        }];
    }
}

-(void)getSchedule:(ScheduleCriteria*)criteria andCall:(void (^)(NSDictionary*, NSError*))handler
{
    const NSOperationQueue *callingQueue = [NSOperationQueue currentQueue];
    
    NSMutableDictionary* result = [NSMutableDictionary dictionaryWithCapacity:criteria.channelCallSigns.count];
    
    const NSUInteger channelsToGet = [criteria.channelCallSigns count];
    __block volatile BOOL abortFlag = NO;
    
    for(NSString* callSign in criteria.channelCallSigns)
    {
        [self getScheduleForChannel:callSign startingAt:criteria.startTime endingAt:criteria.endTime andCall:^(NSArray *data, NSError *error) {
            
            if(abortFlag)
                return;
            
            if(error){
                
                DDLogError(@"Failed to get schedule: %@", error);
                
                abortFlag = YES;
                [callingQueue addOperationWithBlock:^{
                    handler(nil,error);
                }];
                return;
            }
            
            @synchronized(result)
            {
                [result setValue:data forKey:callSign];
                
                if([result count] == channelsToGet){
                    [callingQueue addOperationWithBlock:^{
                        handler(result ,nil);
                    }];
                }
            }
        }];
    }
}


-(void)getExtraInfo:(NSString*)extraInfoUrl andCall:(void (^)(ProgramExtraInfo*, NSError *))handler
{
    NSOperationQueue *callingQueue = [NSOperationQueue currentQueue];
    
    DDLogInfo(@"Loading extra info: %@", extraInfoUrl);
    
    [urlLoader loadUrl:extraInfoUrl
        withAcceptType:@"application/vnd.specificmedia.mws+json;type=epgextrainfo" 
              andCalls:^(NSURLResponse *response, NSData *data, NSError *error) 
     {
         NSDictionary *json = nil;
         ProgramExtraInfo *programExtraInfo = nil;
         
         if(error == nil){
             json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
             DDLogVerbose(@"Program extra info data: %@",json);
         }
         
         if(error == nil ){
             programExtraInfo = [transformer transformExtraInfo:[json objectForKey:@"serverObject"]];
         }
         
         if(error){
             DDLogError(@"Failed to load program extra info: %@",error);
             if(data) DDLogError(@"Data is \n %@", [[NSString alloc] initWithData:data encoding:0]);
         }
         
         [callingQueue addOperationWithBlock:^{
             handler(programExtraInfo, error);
         }];
     }];
}

@end
