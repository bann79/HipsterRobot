//
//  Created by Elwyn Malethan on 06/12/12.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "SubMenuDataDelegate.h"
#import "HomeSubMenuView.h"

@interface SubMenuDataDelegateTest : SenTestCase

@end

@implementation SubMenuDataDelegateTest
{
    SubMenuDataDelegate *delegate;
    HomeSubMenuView *subMenu;
    id mockTopItem;
    id mockMiddleItem;
    id mockBottomItem;
}

- (void)setUp
{
    subMenu = [[HomeSubMenuView alloc] init];

    mockTopItem = [OCMockObject mockForClass:[HomeSubMenuItemView class]];
    subMenu.topItem = mockTopItem;

    mockMiddleItem = [OCMockObject mockForClass:[HomeSubMenuItemView class]];
    subMenu.middleItem = mockMiddleItem;

    mockBottomItem = [OCMockObject mockForClass:[HomeSubMenuItemView class]];
    subMenu.bottomItem = mockBottomItem;

    delegate = [[SubMenuDataDelegate alloc] init];
    delegate.subMenu = subMenu;
}

- (void)testThatWithoutInitialisationDataReadyIsFalse
{
    NSAssert(![delegate isDataReady], @"Data should not be ready");
}

- (void)testAfterInitialisationDataIsReady
{
    [delegate onInitialised];

    NSAssert([delegate isDataReady], @"Data should be ready");
}

- (void)testScheduleItemForSlotOneUpdatesTopItem
{
    ScheduleItem * item = [[ScheduleItem alloc] init];

    [[mockTopItem expect] populate:sameInstance(item)];

    [delegate onReceivedScheduleItem:item forSlot:@"slot1"];

    [mockTopItem verify];
}

- (void)testScheduleItemForSlotTwoUpdatesMiddleItem
{
    ScheduleItem * item = [[ScheduleItem alloc] init];

    [[mockMiddleItem expect] populate:sameInstance(item)];

    [delegate onReceivedScheduleItem:item forSlot:@"slot2"];

    [mockMiddleItem verify];
}

- (void)testScheduleItemForSlotThreeUpdatesBottomItem
{
    ScheduleItem * item = [[ScheduleItem alloc] init];

    [[mockBottomItem expect] populate:sameInstance(item)];

    [delegate onReceivedScheduleItem:item forSlot:@"slot3"];

    [mockBottomItem verify];
}
@end
