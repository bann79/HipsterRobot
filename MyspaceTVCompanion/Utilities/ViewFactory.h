//
//  ViewFactory.h
//  MyspaceTVCompanion
//
//  Created by scott on 06/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppViewProtocol.h"

@interface ViewFactory : NSObject

-(UIViewController<AppViewProtocol> *)getViewControllerFromString:(NSString *)viewName;

@end
