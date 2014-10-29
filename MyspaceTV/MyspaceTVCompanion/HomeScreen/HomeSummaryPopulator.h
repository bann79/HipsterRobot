//
//  Created by Elwyn Malethan on 13/06/2012.
//
//  Copyright (c) 2012 Specific Media. All rights reserved.
//
#import <Foundation/Foundation.h>

@class TimerFactory;
@class DataIterator;
@protocol DataIteratorDelegate;


@interface HomeSummaryPopulator : NSObject
@property(nonatomic, strong) TimerFactory * timerFactory;

- (HomeSummaryPopulator *) init;

- (void)prepareWithIterator:(DataIterator*)dataIt andDelegate:(id<DataIteratorDelegate>)dataDel;

- (void)start;

- (void)stop;
@end
