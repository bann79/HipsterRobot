//
//  DataIterator.m
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 11/06/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import "DataIterator.h"

@implementation DataIterator
@synthesize _channels;
@synthesize _index;

-(id) init
{
    self = [super init];
    if(self){
        _index = 0;
        _channels = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) initialise:(id<DataIteratorDelegate>) delegate
{
    [[EpgApi sharedInstance] getChannelList:[EpgApi channelListId] andCall:^(NSArray *channels, NSError *error)
     {
         if (error == nil) 
         {
             _channels = channels;
             
             [delegate onInitialised];
             
         }else{
             //epg get channel list error. Need notify delegate about this error.
             [delegate onErrorOccurred:[NSString stringWithFormat:@"DataIteraror: Epg api got channel list error: %@", error]];
         }
     }];
}

- (void) reset
{
    _index = 0;
}

- (void)next:(id <DataIteratorDelegate>)delegate forSlot:(NSString* )rowId
{
    if(self._channels != nil && self._index < self._channels.count)
    {   
        Channel *targetChannel = [self._channels objectAtIndex:self._index];
        
        //Update iterator index, when view controller call next method. 
        self._index++;
        
        //notify view controller going to fentch epg data for it.
        [delegate onRequestingScheduleItemForSlot:rowId];
        
        [self getScheduleForChannel:targetChannel startingAt:[NSDate date] dIDelegate:delegate forSlot:rowId];

    }else {
        //tell delegate that there is no channel available.
        [delegate onErrorOccurred:@"There are no more channels" forSlot:rowId];
    }
}

- (void)getScheduleForChannel:(Channel*)channel startingAt:(NSDate*)startTime dIDelegate:(id<DataIteratorDelegate>)delegate forSlot:(NSString* )rowId
{
    //NSAssert(NO, @"This is an abstract method and should be overridden");
    NSException* myException = [NSException
                                exceptionWithName:@"MethodNeedBeOverridden"
                                reason:@"Method need be overridden by sub class."
                                userInfo:nil];
    @throw myException;
}
@end