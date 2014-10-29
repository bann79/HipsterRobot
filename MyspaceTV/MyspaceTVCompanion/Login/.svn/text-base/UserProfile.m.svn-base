//
//  UserProfile.m
//  MyspaceTVCompanion
//
//  Created by Bann Al-Jelawi on 17/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile

@synthesize name;
@synthesize email;
@synthesize avatarURL;
@synthesize isKnownUser;
@synthesize profileSelectionPositionIndex;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.avatarURL = [aDecoder decodeObjectForKey:@"avatarURL"];
        self.isKnownUser = [aDecoder decodeBoolForKey:@"isKnownUser"];
        self.profileSelectionPositionIndex = [aDecoder decodeIntForKey:@"profileSelectionPositionIndex"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.avatarURL forKey:@"avatarURL"];
    [aCoder encodeBool:self.isKnownUser forKey:@"isKnownUser"];
    [aCoder encodeInt:self.profileSelectionPositionIndex forKey:@"profileSelectionPositionIndex"];
    
}

@end
