//
// Created by rmacharg on 19/07/2012.
//
// Encapsulate success and failure actions for a callback


#import <Foundation/Foundation.h>

@class UserProfile;

@protocol AuthStateResponder
-(void) onSuccess:(UserProfile *) userProfile;
-(void) onFailure:(NSError *) authError;
-(void) onSuccessfulLogout;
@end
