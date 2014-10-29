//
//  AuthUserInfo.h
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 16/07/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileImage : NSObject <NSCoding>
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *url;
@property int width;
@property int height;
@end

@interface DapPayload : NSObject<NSCoding>
@property(strong, nonatomic) NSString *uri;
@property(strong, nonatomic) NSString *rel;
@property(strong, nonatomic) NSString *accepts;
@property(strong, nonatomic) NSString *produces;
@end

@interface AuthUserInfo : NSObject <NSCoding>
@property(strong, nonatomic) NSString *xmppJid;
@property(strong, nonatomic) NSString *xmppPassword;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *sessionId;
@property(strong, nonatomic) NSString *accountId;
@property(strong, nonatomic) NSString *authenticationToken;
@property(strong, nonatomic) NSString *objectIDString;
@property(strong, nonatomic) NSMutableArray *profileImageUrls;
@property(strong, nonatomic) NSMutableDictionary *dapPayload;
@property(strong, nonatomic) NSString *cookie;
@property(strong, nonatomic) NSString *channelListId;

@end
