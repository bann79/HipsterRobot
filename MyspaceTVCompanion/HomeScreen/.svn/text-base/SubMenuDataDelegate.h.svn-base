//
//  Created by Elwyn Malethan on 12/06/2012.
//
//  Copyright (c) 2012 Specific Media. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DataIterator.h"

@class HomeSubMenuView;
@class TimerFactory;
@class PlanAheadDataIterator;


@interface SubMenuDataDelegate : NSObject <DataIteratorDelegate>
- (void)prepare:(HomeSubMenuView *)subMenu;
@property(nonatomic, assign) BOOL isDataReady;
@property(nonatomic, strong) HomeSubMenuView *subMenu;

@property(nonatomic, assign) BOOL isRunOutOfChannels;
@end
