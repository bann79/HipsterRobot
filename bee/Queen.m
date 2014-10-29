//
//  Queen.m
//  bee
//
//  Created by Bann Al-Jelawi on 28/10/2014.
//  Copyright (c) 2014 bann. All rights reserved.
//

#import "Queen.h"

@implementation Queen

-(id)init
{
    if (self = [super init])
    {
        [self setInitialValsOfMaxDamage:20.0 andType:@"Queen"];
    }
    return self;
}

@end
