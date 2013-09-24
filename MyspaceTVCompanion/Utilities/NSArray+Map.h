//
//  NSArray+Map.h
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 18/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef id (^ArrayMapperBlock)(id);

@interface NSArray(Map)
-(NSArray*)mapWithBlock:(ArrayMapperBlock)block;
-(NSArray*)mapWithSelector:(SEL)selector target:(id)object;
@end
