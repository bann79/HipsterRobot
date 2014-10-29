//
//  NSArray+Map.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 18/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSArray+Map.h"

//Disable warning about leak when using performSelector
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation NSArray(Map)

-(NSArray*)mapWithBlock:(ArrayMapperBlock)block
{
    NSMutableArray* newArray = [[NSMutableArray alloc] initWithCapacity:self.count];
    for(id obj in self)
    {
        [newArray addObject:block(obj)];
    }
    return newArray;
}

-(NSArray*)mapWithSelector:(SEL)selector target:(id)object
{
    
    NSMutableArray* newArray = [[NSMutableArray alloc] initWithCapacity:self.count];
    for(id obj in self)
    {
        id obj2 = [object performSelector:selector withObject:obj];
        [newArray addObject: obj2];
    }
    return newArray;
}



@end
