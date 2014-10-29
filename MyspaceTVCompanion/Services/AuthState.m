//
// Encapsulate the Myspace authentication state.
//

#import "AuthState.h"
#import "AuthStateResponder.h"
#import "UserProfile.h"
#import "TimerFactory.h"
#import "XMPPClient.h"

double const KEEPALIVE_INTERVAL_IN_SECONDS = 180;

@implementation AuthState {

}
@synthesize _timerFactory;
@synthesize _keepAliveTimer;
@synthesize sessionID;
@synthesize _authUser;
@synthesize loggedIn;
@synthesize currentUser;


#pragma mark Singleton boilerplate

static AuthState *sharedSingleton;

+(AuthState *)sharedInstance
{
    @synchronized(self)
    {
        if (!sharedSingleton)
        {
            sharedSingleton = [[AuthState alloc] init];
            sharedSingleton._timerFactory = [[TimerFactory alloc] init];
        }
        return sharedSingleton;
    }
}

+(void)setSharedInstance:(AuthState*)instance
{
    sharedSingleton = instance;
}

#pragma mark Public entry points

- (void)authenticate:(Credential *)credential withResponder:(id <AuthStateResponder>)responder
{
    void (^const apiCallback)(AuthUserInfo *, NSError *) = ^(AuthUserInfo *authUserInfo, NSError *error) {
        if (!error) {
            [self _successfulLogin:credential withResponder:responder forAuthUser:authUserInfo];
        } else {
            [self _translateError:error andPassToResponder:responder];
        }
    };

    [[MyspaceApi sharedInstance]
            login:credential
         andCalls:apiCallback
    ];
}

-(void)revivePreviousSession:(id <AuthStateResponder>) responder
{
    NSData * saved = [[NSUserDefaults standardUserDefaults] objectForKey:AUTH_STATE_LOGGED_IN_USER];
    AuthUserInfo * savedUser = [NSKeyedUnarchiver unarchiveObjectWithData:saved];

    if(!saved){
        [responder onSuccess:nil];
    }else{
        self._authUser = savedUser;
        [self loginAndKeepSessionAliveWithResponder:responder];
    }
}

-(void)logoutWithResponder:(id <AuthStateResponder>)responder {

    [[MyspaceApi sharedInstance]
            logout:self._authUser
          andCalls:^(BOOL isSuccessfulLogout, int httpStatus, NSError *error) {
              if (!isSuccessfulLogout) {
                  [responder onFailure:error];
              }
              else {
                  [responder onSuccessfulLogout];
              }

          }];

    [self stopKeepaliveTimer];
    [self _setStateToLoggedOut];
}

#pragma mark Internal methods

- (void)loginAndKeepSessionAliveWithResponder:(id <AuthStateResponder>)responder {
    [[MyspaceApi sharedInstance]
            keepalive:self._authUser
             andCalls:^(BOOL success, AuthUserInfo *info, int httpStatus, NSError *error) {
                 if (success) {

                     [self setSessionID:[info sessionId]];

                     self._authUser = info;
                     [self setLoggedIn:YES];

                     if (![[[XMPPClient sharedInstance] xmppStream] isConnected]) {
                         [[XMPPClient sharedInstance]
                                 connectWithJID:info.xmppJid
                                    andPassword:info.xmppPassword];
                     }
                     
                     UserProfile *const profile = [[UserProfile alloc] init];
                     [self _takeAuthUserInfo:info andConvertIntoUserProfile:profile];
                     [self startKeepaliveTimer];

                     self.currentUser = profile;

                     [responder onSuccess:profile];
                 } else {
                     [self _setStateToLoggedOut];
                     [self stopKeepaliveTimer];
                     [self _translateError:error andPassToResponder:responder];
                 }
             }];
}

-(void)startKeepaliveTimer {
    self._keepAliveTimer = [self._timerFactory scheduleWithInterval:KEEPALIVE_INTERVAL_IN_SECONDS withBlock:^{
        [self loginAndKeepSessionAliveWithResponder:nil];
    } repeats:YES];
}

-(void)stopKeepaliveTimer {
    if (self._keepAliveTimer) {
        [self._keepAliveTimer invalidate];
        self._keepAliveTimer = nil;
    }
}

- (void)_takeAuthUserInfo:(AuthUserInfo *)authUserInfo andConvertIntoUserProfile:(UserProfile *)userProfile {

    [userProfile setName:[authUserInfo name]];

    if ([[authUserInfo profileImageUrls] count] > 0) {
        ProfileImage *const image = [[authUserInfo profileImageUrls] objectAtIndex:0];
        [userProfile setAvatarURL:image.url];
    }
}

- (void)_successfulLogin:(Credential *)credential withResponder:(id <AuthStateResponder>)responder forAuthUser:(AuthUserInfo *) authUserInfo {
    self._authUser = authUserInfo;

    [self startKeepaliveTimer];

    [[XMPPClient sharedInstance]
                    connectWithJID:authUserInfo.xmppJid
                       andPassword:authUserInfo.xmppPassword];

    [self _saveLoggedInAuthUser:authUserInfo];

    UserProfile *profile = [[UserProfile alloc] init];
    [self _takeAuthUserInfo:authUserInfo andConvertIntoUserProfile:profile];
    profile.email = [credential.username copy];

    self.currentUser = profile;

    [responder onSuccess:profile];

    self.sessionID = authUserInfo.sessionId;
    self.loggedIn = YES;
}

// Translate Cocoa error codes to more standard HTTP ones
- (void)_translateError:(NSError *)error andPassToResponder:(id <AuthStateResponder>)responder {

    NSError *authError;
    if (error.code == NSURLErrorUserCancelledAuthentication) {
                // derive an error
                authError = [[NSError alloc] initWithDomain:@"AuthState"
                        code:401 // we use a standard HTTP error code
                    userInfo:nil];
                self.loggedIn = NO;
            } else {
                authError = [[NSError alloc] initWithDomain:@"AuthState"
                        code:500
                    userInfo:nil];
                self.loggedIn = NO;
            }

    [responder onFailure:authError];
}

- (void)_setStateToLoggedOut {
    [self stopKeepaliveTimer];

    [[XMPPClient sharedInstance] logout];

    // Remove from persistence
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:AUTH_STATE_LOGGED_IN_USER];

    self._authUser = nil;
    self.currentUser = nil;
    self.sessionID = nil;
    self.loggedIn = NO;

    [self stopKeepaliveTimer];
}

-(void) _saveLoggedInAuthUser: (AuthUserInfo *) authUser
{
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:authUser];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:AUTH_STATE_LOGGED_IN_USER];
}

@end