//
//  ViewFactory.m
//  MyspaceTVCompanion
//
//  Created by scott on 06/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewFactory.h"

@implementation ViewFactory

-(UIViewController<AppViewProtocol> *)getViewControllerFromString:(NSString *)viewName
{
    return [[NSClassFromString(viewName) alloc] initWithNibName:viewName bundle:[NSBundle mainBundle]];
}


@end
