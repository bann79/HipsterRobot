//
//  Bee.m
//  bee
//
//  Created by Bann Al-Jelawi on 27/10/2014.
//  Copyright (c) 2014 bann. All rights reserved.
//

#import "Bee.h"

@interface Bee()
@property double health;
@property double maxDamage;
@property(strong,nonatomic) NSString *status;
@property(strong,nonatomic) NSString *type;
@property double lastHitValue;
@end

@implementation Bee


-(void)setInitialValsOfMaxDamage:(int)maxDamage andType:(NSString*)type
{
    self.health = 100;
    self.maxDamage = maxDamage;
    self.type = type;
    self.status = @"alive";
}


-(NSString*)damage:(int)percentage
{
    //sanity check that int is between 0 and 100
    //and that bee is still alive
    
    if([[self status] isEqualToString:@"alive"])
    {
        if(percentage>=0 && percentage<=100)
        {
            //reduce current health by int percentage
            //convert int to a % (*0.01)
            float percentageDamage = percentage * 0.01;
            float healthDeduction = self.health * percentageDamage;
            [self setHealth:self.health - healthDeduction];
            
            //ask status to update itself given current health
            [self updateStatus];
        }
    }
    
    return [self status];
}

-(NSString*)getCurrentStatus
{
    return [self status];
}

-(double)getCurrentHealth
{
    return [self health];
}

-(NSString*)getType
{
    return [self type];
}

-(void)updateStatus
{
    //determine status from health and type of bee
    if(self.health < self.maxDamage)
    {
        [self setStatus:@"dead"];
    }
    else
    {
        [self setStatus:@"alive"];
    }
}

@end
