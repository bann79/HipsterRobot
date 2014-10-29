//
//  Created by Elwyn Malethan on 13/06/2012.
//
//  Copyright (c) 2012 Specific Media. All rights reserved.
//
#import "HomeSummaryPopulator.h"
#import "PlanAheadDataIterator.h"
#import "SubMenuDataDelegate.h"
#import "TimerFactory.h"
#import "DataIterator.h"


@implementation HomeSummaryPopulator
{
    PlanAheadDataIterator *iterator;
    SubMenuDataDelegate *delegate;
@private
    TimerFactory * _timerFactory;
    NSTimer *startTimer;
    NSTimer *populationTimer;
}
@synthesize timerFactory = _timerFactory;


- (HomeSummaryPopulator *)init
{
    self = [super init];

    self.timerFactory = [[TimerFactory alloc] init];

    return self;
}

- (void)prepareWithIterator:(PlanAheadDataIterator*)dataIt andDelegate:(SubMenuDataDelegate *)dataDel
{
    iterator = dataIt;
    delegate = dataDel;

    [iterator initialise:delegate];
}

- (void)requestNewDataForSlots
{
    [iterator next:delegate forSlot:@"slot1"];
    [iterator next:delegate forSlot:@"slot2"];
    [iterator next:delegate forSlot:@"slot3"];
}

- (void)start
{
    const BOOL dataReady = [delegate isDataReady];
    if (dataReady) {
        [self __start];
    } else {
        startTimer = [self.timerFactory scheduleWithInterval:0.1 withBlock:^{
            const BOOL dataNowReady = [delegate isDataReady];
            if (dataNowReady) {
                [self __start];
                [startTimer invalidate];
                startTimer = nil;
            }
        } repeats:YES];
    }
}

- (void)__start
{
    [self requestNewDataForSlots];

    populationTimer = [self.timerFactory scheduleWithInterval:10 withBlock:^{
        if ([delegate isRunOutOfChannels]) {
            [iterator reset];
        }
        [self requestNewDataForSlots];
    } repeats:YES];
}

- (void)stop
{
    if (startTimer) {
        [startTimer invalidate];
        startTimer = nil;
    }
    if (populationTimer) {
        [populationTimer invalidate];
        populationTimer = nil;
    }
}
@end
