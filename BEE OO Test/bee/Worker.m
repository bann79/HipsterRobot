//
//  Worker.m
//  bee
//
//  Created by Bann Al-Jelawi on 28/10/2014.
//  Copyright (c) 2014 bann. All rights reserved.
//

#import "Worker.h"

@implementation Worker

-(id)init
{
    if (self = [super init])
    {
        [self setInitialValsOfMaxDamage:70.0 andType:@"Worker"];
    }
    return self;
}

@end
