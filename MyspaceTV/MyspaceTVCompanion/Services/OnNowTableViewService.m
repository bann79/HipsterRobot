//
//  OnNowTableViewService.m
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 13/06/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import "OnNowTableViewService.h"

@implementation OnNowTableViewService


- (void) initialise:(id<OnNowTableViewDelegate>) delegate
{
    NSString * chanListRequestId = [ChannelListRequestId channelListId];
    NSLog(@"MJL::chanListRequestId : %@",chanListRequestId);
    [[EpgApi sharedInstance] getChannelList:chanListRequestId andCall:^(NSArray *channels, NSError *error)
     {
         if (error == nil) 
         {
             [delegate onInitialised:channels];
             
         }else{
             //epg get channel list error. Need notify delegate about this error.
             [delegate onErrorOccurred:[NSString stringWithFormat:@"Epg api got channel list error: %@",error]];
         }
     }];
}

/**
 * Get schedule for each callsign.
 * -return dictionary key a channel callsign, value a Program instance.
 */
- (void) getSchedule:(NSArray *)channelCallSigns onNowTBVDelegate:(id<OnNowTableViewDelegate>) delegate;
{
    ScheduleCriteria *criteria = [[ScheduleCriteria alloc] init];
    
    criteria.channelCallSigns = channelCallSigns;
    criteria.startTime = [NSDate date];
    criteria.endTime = [NSDate dateWithTimeInterval:1 sinceDate:criteria.startTime];
    
    __block NSMutableDictionary *programs = [NSMutableDictionary dictionary];
    __block NSMutableDictionary *extraInfo = [NSMutableDictionary dictionary];
    
    [[EpgApi sharedInstance] getSchedule:criteria andCall:^(NSDictionary *data, NSError *error) {
        if(error){
            [delegate onErrorOccurred:[NSString stringWithFormat:@"Epg api met an error: %@",error]];
            
        }else{
            for (NSString *callSign in channelCallSigns) {
                NSArray *programes = [data objectForKey:callSign];
                Programme *prog = [programes objectAtIndex:0];
                
                [programs setValue:prog forKey:callSign];
                
                if(prog.extraInfoUrl != nil)
                {
                    [[EpgApi sharedInstance] getExtraInfo:prog.extraInfoUrl andCall:^(ProgramExtraInfo *info, NSError *error2){
                        if(error2){
                            [delegate onErrorOccurred:[NSString stringWithFormat:@"Epg api met an error: %@",error2]];
                        }else{
                            
                            [extraInfo setValue:info forKey:callSign];
                            
                            if([extraInfo count] == [channelCallSigns count])
                            {
                                [delegate onRecievedOnNowData:programs withExtraInfo:extraInfo];
                            }
                        }
                    }];
                    
                }else {
                    //set this program extra info object as NSNulll object.
                    [extraInfo setValue:[NSNull null] forKey:callSign];
                    if([extraInfo count] == [channelCallSigns count])
                    {
                        [delegate onRecievedOnNowData:programs withExtraInfo:extraInfo];
                    }
                }
            }
            
        }
    }]; 
}

@end
