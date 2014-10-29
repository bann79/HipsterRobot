//
//  Created by Elwyn Malethan on 12/06/2012.
//
//  Copyright (c) 2012 Specific Media. All rights reserved.
//


#import "SubMenuDataDelegate.h"
#import "HomeSubMenuView.h"
#import "TimerFactory.h"
#import "PlanAheadDataIterator.h"


@implementation SubMenuDataDelegate
{

@private
    BOOL _isDataReady;
    HomeSubMenuView *_subMenu;
    BOOL _isRunOutOfChannels;
}
@synthesize isDataReady = _isDataReady;
@synthesize subMenu = _subMenu;
@synthesize isRunOutOfChannels = _isRunOutOfChannels;


- (void)prepare:(HomeSubMenuView *)subMenu
{
    _subMenu = subMenu;
}


- (void)onInitialised
{
    _isDataReady = YES;
}

- (void)onErrorOccurred:(NSString *)errorInfo
{
    //TODO: Somehow report this error
    NSLog(@"Error:  %@", errorInfo);
}

- (void)onErrorOccurred:(NSString *)errorInfo forSlot:(NSString *)slotId
{
    NSLog(@"Error:  %@ for slot %@", errorInfo, slotId);
    self.isRunOutOfChannels = YES;
}


- (void)onRequestingScheduleItemForSlot:(NSString *)slotId
{
    //NSLog(@"About to fetch new data for %@", slotId);

    if ([slotId isEqualToString:@"slot1"]) {
        [_subMenu.topItem setWaiting];
    } else if ([slotId isEqualToString:@"slot2"]) {
        [_subMenu.middleItem setWaiting];
    } else if ([slotId isEqualToString:@"slot3"]) {
        [_subMenu.bottomItem setWaiting];
    }
}


- (void)onReceivedScheduleItem:(ScheduleItem *)scheduleItem forSlot:(NSString *)slotId
{
    self.isRunOutOfChannels = NO;

    if ([slotId isEqualToString:@"slot1"]) {
        [_subMenu.topItem populate:scheduleItem];
    } else if ([slotId isEqualToString:@"slot2"]) {
        [_subMenu.middleItem populate:scheduleItem];
    } else if ([slotId isEqualToString:@"slot3"]) {
        [_subMenu.bottomItem populate:scheduleItem];
    }
}


@end
