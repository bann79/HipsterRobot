//
//  Drone.m
//  bee
//
//  Created by Bann Al-Jelawi on 28/10/2014.
//  Copyright (c) 2014 bann. All rights reserved.
//

#import "Drone.h"

@implementation Drone

-(id)init
{
    if (self = [super init])
    {
        [self setInitialValsOfMaxDamage:50.0 andType:@"Drone"];
    }
    return self;
}

@end
