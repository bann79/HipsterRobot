//
//  AuthUserInfoTransformer.h
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 18/07/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthUserInfo.h"

@interface AuthUserInfoTransformer : NSObject
-(AuthUserInfo*)transformAuthUserInfo:(NSDictionary*)json;
-(ProfileImage*) transformProfileImages:(NSDictionary*)json;
-(DapPayload*)transformPayload:(NSDictionary*)json;

-(id)nilOrJSONValue:(id)jsonValue;

@end
