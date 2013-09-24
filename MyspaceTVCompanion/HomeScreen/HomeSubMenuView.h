//
//  UISubView.h
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 01/06/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeSubMenuItemView.h"

@class ScheduleItem;

@interface HomeSubMenuView : UIView
@property(strong,nonatomic) IBOutlet HomeSubMenuItemView *topItem;
@property(strong,nonatomic) IBOutlet HomeSubMenuItemView *middleItem;
@property(strong,nonatomic) IBOutlet HomeSubMenuItemView *bottomItem;

@property BOOL isInsideTextAlignLeft;

@end
