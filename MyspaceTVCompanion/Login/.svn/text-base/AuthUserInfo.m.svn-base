//
//  AuthUserInfo.m
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 16/07/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import "AuthUserInfo.h"

//Disable warning about leak when using performSelector
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation ProfileImage {
    NSArray* properties;
}
@synthesize name, url;
@synthesize width, height;

- (id)init {
    self = [super init];
    if (self) {
        properties = [NSArray
                arrayWithObjects:@"name", @"url", nil];
        //TODO: Add width and height, they are primitives.
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    for (NSString * prop in properties) {
        SEL propSelector = NSSelectorFromString(prop);
        [aCoder encodeObject:[self performSelector:propSelector] forKey:prop];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [self init])) {
        for (NSString * prop in properties) {
            id value = [aDecoder decodeObjectForKey:prop];
            [self setValue:value forKey:prop];
        }
    }
    return self;
}


@end

@implementation DapPayload{
    NSArray* properties;
}

@synthesize uri, rel, accepts, produces;

- (id)init {
    self = [super init];
    if (self) {
        properties = [NSArray
                      arrayWithObjects:@"uri",@"rel",@"accepts",@"produces",nil];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    for (NSString * prop in properties) {
        SEL propSelector = NSSelectorFromString(prop);
        [aCoder encodeObject:[self performSelector:propSelector] forKey:prop];
    }
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [self init])) {
        for (NSString * prop in properties) {
            id value = [aDecoder decodeObjectForKey:prop];
            [self setValue:value forKey:prop];
        }
    }
    return self;
}
@end

@implementation AuthUserInfo {
    NSArray* properties;
}
@synthesize xmppJid = _xmppJid;
@synthesize xmppPassword = _xmppPassword;
@synthesize name = _name;
@synthesize sessionId = _sessionId;
@synthesize accountId = _accountId;
@synthesize authenticationToken = _authenticationToken;
@synthesize objectIDString = _objectIDString;
@synthesize profileImageUrls = _profileImageUrls;
@synthesize dapPayload = _dapPayload;
@synthesize cookie = _cookie;
@synthesize channelListId = _channelListId;

- (id)init {
    self = [super init];
    if (self) {
        properties = [NSArray
                arrayWithObjects:@"xmppJid", @"xmppPassword", @"name",
                                 @"sessionId", @"accountId", @"authenticationToken", @"objectIDString",
                                 @"profileImageUrls", @"cookie", @"dapPayload", @"channelListId", nil];
    }

    return self;
}


-(id)copyWithZone:(NSZone*)zone
{
    AuthUserInfo *copy = [[AuthUserInfo alloc] init];
    copy.xmppJid = [self.xmppJid copyWithZone:zone];
    copy.xmppPassword = [self.xmppPassword copyWithZone:zone];
    copy.name = [self.name copyWithZone:zone];
    copy.sessionId = [self.sessionId copyWithZone:zone];
    copy.accountId = [self.accountId copyWithZone:zone];
    copy.authenticationToken = [self.authenticationToken copyWithZone:zone];
    copy.objectIDString = [self.objectIDString copyWithZone:zone];
    copy.profileImageUrls = [self.profileImageUrls copyWithZone:zone];
    copy.dapPayload = [self.dapPayload copyWithZone:zone];
    copy.cookie = [self.cookie copyWithZone:zone];
    copy.channelListId = [self.channelListId copyWithZone:zone];
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {

    for (NSString * prop in properties) {
        SEL propSelector = NSSelectorFromString(prop);
        [aCoder encodeObject:[self performSelector:propSelector] forKey:prop];
    }

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [self init])) {
        for (NSString * prop in properties) {
            id value = [aDecoder decodeObjectForKey:prop];
            [self setValue:value forKey:prop];
        }
    }
    return self;
}


@end
