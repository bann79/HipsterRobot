//
//  AuthUserInfoTransformer.m
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 18/07/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import "AuthUserInfoTransformer.h"

@implementation AuthUserInfoTransformer

-(AuthUserInfo*)transformAuthUserInfo:(NSDictionary*)json
{
    
    NSDictionary *soJson = [self nilOrJSONValue:[json valueForKey:@"serverObject"]];
    
    AuthUserInfo *authUser = [[AuthUserInfo alloc] init];
    //parse general info
    authUser.xmppJid = [self nilOrJSONValue:[soJson valueForKey:@"xmppJid"]];
    authUser.xmppPassword = [self nilOrJSONValue:[soJson valueForKey:@"xmppPassword"]];
    authUser.name = [self nilOrJSONValue:[soJson valueForKey:@"name"]];
    authUser.sessionId = [self nilOrJSONValue:[soJson valueForKey:@"sessionId"]];
    authUser.accountId = [self nilOrJSONValue:[soJson valueForKey:@"accountId"]];
    authUser.authenticationToken = [self nilOrJSONValue:[soJson valueForKey:@"authenticationToken"]];
    authUser.objectIDString = [self nilOrJSONValue:[soJson valueForKey:@"objectIDString"]];
    authUser.channelListId = [self nilOrJSONValue:[soJson valueForKey:@"channelListId"]];
    
    //parse profile images.
    ProfileImage *img = [[ProfileImage alloc] init];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    NSMutableArray* images = [self nilOrJSONValue:[soJson valueForKey:@"profileImageUrls"]];
    for(NSDictionary* jsonObject in images)
    {
        img = [self transformProfileImages:jsonObject];
        [temp addObject:img];
    }
    authUser.profileImageUrls = temp;
    
    //parse dap payload;
    DapPayload *payload = [[DapPayload alloc] init];
    NSMutableDictionary *dapPaylaods = [[NSMutableDictionary alloc]init];
    NSMutableArray *payloads = [self nilOrJSONValue:[json valueForKey:@"dapPayload"]];
    for (NSDictionary *payJson in payloads) 
    {
        payload = [self transformPayload:payJson];
        
        [dapPaylaods setValue:payload forKey:payload.rel];
    }
    authUser.dapPayload = dapPaylaods;
    
    return authUser;
}

-(ProfileImage*) transformProfileImages:(NSDictionary*)json
{
    if (json == nil) {
        return nil;
    }
    
    ProfileImage *image = [[ProfileImage alloc] init];
    image.url = [self nilOrJSONValue:[json valueForKey:@"url"]];
    image.name = [self nilOrJSONValue:[json valueForKey:@"name"]];
    image.width = [[self nilOrJSONValue:[json valueForKey:@"width"]] intValue];
    image.height =[[self nilOrJSONValue:[json valueForKey:@"height"]] intValue];
    
    return image;
}


-(DapPayload*)transformPayload:(NSDictionary*)json
{
    if (json == nil) {
        return nil;
    }
    
    DapPayload *payload = [[DapPayload alloc] init];
    payload.uri = [self nilOrJSONValue:[json valueForKey:@"uri"]];
    payload.rel = [self nilOrJSONValue:[json valueForKey:@"rel"]];
    payload.accepts = [self nilOrJSONValue:[json valueForKey:@"accepts"]];
    payload.produces = [self nilOrJSONValue:[json valueForKey:@"produces"]];
    
    return payload;
}


-(id)nilOrJSONValue:(id)jsonValue
{
    if(jsonValue == [NSNull null])
    {
        return nil;
    }else {
        return jsonValue;
    }
}
@end
