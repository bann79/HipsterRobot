//
//  CatchupUrlConstructor.h
//  MyspaceTVCompanion
//
//  Created by Dyfan Hughes on 09/07/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EpgApi.h"

@interface CatchupUrlGenerator : NSObject

-(NSString*)generateURLWithChannel:(Channel*) channel andProgram:(Programme*) program;

@end
