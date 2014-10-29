//
// Created by rmacharg on 19/07/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "MyspaceApi.h"
static NSString *const AUTH_STATE_LOGGED_IN_USER = @"AuthState_LoggedInUser";

@class Credential;
@protocol AuthStateResponder;
@class TimerFactory;
@class UserProfilesManager;
@class UserProfile;
@class AuthUserInfo;

@interface AuthState : NSObject

@property(nonatomic, strong) TimerFactory *_timerFactory;
@property(nonatomic, strong) NSTimer *_keepAliveTimer;
@property(nonatomic, strong) NSString *sessionID;
@property(nonatomic, strong) UserProfile *currentUser;
@property(nonatomic, strong) AuthUserInfo *_authUser;
@property (nonatomic, assign, getter=isLoggedIn) BOOL loggedIn;

+(AuthState *)sharedInstance;

- (void)revivePreviousSession:(id <AuthStateResponder>)responder;
- (void)loginAndKeepSessionAliveWithResponder:(id <AuthStateResponder>)responder;
- (void)startKeepaliveTimer;
- (void)stopKeepaliveTimer;
- (void)authenticate:(Credential *)credential withResponder:(id <AuthStateResponder>)responder;
- (void)logoutWithResponder:(id <AuthStateResponder>)responder;


@end