//
//  Bee.h
//  bee
//
//  Created by Bann Al-Jelawi on 27/10/2014.
//  Copyright (c) 2014 bann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bee : NSObject

-(void)setInitialValsOfMaxDamage:(int)maxDamage andType:(NSString*)type;
-(NSString*)damage:(int)percentage;
-(NSString*)getCurrentStatus;
-(double)getCurrentHealth;
-(NSString*)getType;

@end
