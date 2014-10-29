//
//  AuthStateTest.m
//  MyspaceTVCompanion
//
//  Copyright (c) 2012 Specific Media Ltd. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <MyspaceTVCompanion/Login/MyspaceApi.h>
#import <OCMock/OCMock.h>
// Allow use of Hamcrest shorthands
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <QuartzCore/QuartzCore.h>
#import "AuthState.h"
#import "AuthStateResponder.h"
#import "UserProfile.h"
#import "TestUtils.h"
#import "TimerFactory.h"
#import "XMPPClient.h"


@interface AuthState (Test)
- (void)_saveLoggedInAuthUser:(AuthUserInfo *)authUser;
- (void)_takeAuthUserInfo:(AuthUserInfo *)authUserInfo andConvertIntoUserProfile:(UserProfile *)userProfile;
- (void)_setStateToLoggedOut;
@end

@interface MyspaceApi (Test)
+(void)setSharedInstance:(id)inst;
@end

@interface XMPPClient (Test)
+(void)setSharedInstance:(id)inst;
@end

@interface AuthUserMatcher : HCBaseMatcher
+(id) theSameUserAs:(AuthUserInfo *) user;
- (id) initWithAuthUser:(AuthUserInfo *) user;
@end

@implementation AuthUserMatcher {
    AuthUserInfo *userToMatch;
}
+ (id)theSameUserAs:(AuthUserInfo *) user {
    return [[self alloc] initWithAuthUser:user];
}

- (id)initWithAuthUser:(AuthUserInfo *)user {
    self = [super init];
    if (self != nil) {
        userToMatch = [user copy];
    }
    return self;
}

- (BOOL)matches:(id)item {

    BOOL labelsMatch = [allOf(
        HC_hasProperty(@"name", userToMatch.name),
        HC_hasProperty(@"sessionId", userToMatch.sessionId),
        HC_hasProperty(@"xmppPassword", equalTo(userToMatch.xmppPassword)),
        nil
    ) matches:item];

    NSString *const urlString = ((ProfileImage *) [((AuthUserInfo *) item).profileImageUrls objectAtIndex:0]).url;

    return labelsMatch && [equalTo(@"http://microshaft.com/bill.jpg") matches:urlString];
}

- (void)describeTo:(id <HCDescription>)description {
    //TODO: For some reasons the appendText etc. methods don't compile
    NSLog(@"Expecting user with name %@", userToMatch.name);
    [super describeTo:description];
//    [description appendText:@"an AuthUserInfo with the same properties as {"];
//            appendDescriptionOf:userToMatch]
//            appendText:@"}"];
}

@end

id<HCMatcher> theSameUserAs(AuthUserInfo *user) {
    return [AuthUserMatcher theSameUserAs:user];
}

@interface AuthStateTest : SenTestCase
@end

@implementation AuthStateTest {
    Credential *credentials;
    AuthState *auth;

    id mockMyspaceAPI;
    id mockResponder;
    id mockLogoutResponder;
    id mockTimerFactory;
    id mockAuthState;
    id mockXMPPClient;
    id mockKeepAliveTimer;

    void(^authenticateServerBlock)(AuthUserInfo *, NSError *);
    void(^logoutServerBlock)(BOOL, int, NSError *);
    void(^keepaliveServerBlock)(BOOL, AuthUserInfo*, int, NSError *);
}

-(void) setUp
{
    [super setUp];
    mockMyspaceAPI = [OCMockObject mockForClass:[MyspaceApi class]];
    mockResponder = [OCMockObject niceMockForProtocol:@protocol(AuthStateResponder)];
    mockLogoutResponder = [OCMockObject mockForProtocol:@protocol(AuthStateResponder)];
    mockTimerFactory = [OCMockObject niceMockForClass:[TimerFactory class]];
    mockXMPPClient = [OCMockObject niceMockForClass:[XMPPClient class]];

    auth = [[AuthState alloc] init];

    auth._timerFactory = mockTimerFactory;

    credentials = [[Credential alloc] init];
    credentials.username = @"testuser";
    credentials.password = @"password";
    credentials.snName   = @"myspace";
    credentials.deviceId = @"d302703b-8e4e-4964-87cb-0f416556110e";
    credentials.rememberMe = YES;

    // create singleton
    [MyspaceApi setSharedInstance:mockMyspaceAPI];

    [XMPPClient setSharedInstance:mockXMPPClient];

    authenticateServerBlock = nil;
    logoutServerBlock = nil;
    keepaliveServerBlock = nil;
}

-(void) tearDown
{
    [super tearDown];

    [MyspaceApi setSharedInstance:nil];
    [XMPPClient setSharedInstance:nil];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:AUTH_STATE_LOGGED_IN_USER];
}

#pragma mark Utility functions

- (AuthUserInfo *)createBobTestUser {
    AuthUserInfo *const info = [[AuthUserInfo alloc] init];
    info.name = @"Bob";
    ProfileImage *profileImage = [[ProfileImage alloc]init];
    profileImage.url = @"http://path/to/avatar/url.jpg";
    info.profileImageUrls = [[NSMutableArray alloc] initWithObjects:profileImage, nil];
    info.sessionId = @"4321";

    info.xmppJid = @"XMPPUser";
    info.xmppPassword = @"XMPPPassword";

    return info;
}

- (AuthUserInfo *)createBillTheTestUser {
    AuthUserInfo *const billUser = [[AuthUserInfo alloc] init];
    billUser.name = @"Bill Gates";
    billUser.sessionId = @"1234567890";
    billUser.xmppJid = @"billgates@microshaft.com";
    billUser.xmppPassword = @"I am richer than god";
    ProfileImage *const billsAvatar = [[ProfileImage alloc] init];
    billsAvatar.url = @"http://microshaft.com/bill.jpg";
    billUser.profileImageUrls = [[NSMutableArray alloc] initWithObjects:billsAvatar, nil];
    return billUser;
}

- (void)saveUserToPersistence:(AuthUserInfo *)user {
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:AUTH_STATE_LOGGED_IN_USER];
}

#pragma mark MSAPI stubs

-(void)stubOutMSAPIAuthenticateAndGrabServerCallbackBlock {
    [[[mockMyspaceAPI stub] andCaptureCallbackArgument:&authenticateServerBlock at:3]
               login:[OCMArg any]
            andCalls:[OCMArg any]
    ];
}

-(void)stubOutMSAPILogoutAndGrabServerCallbackBlock {
    [[[mockMyspaceAPI stub] andCaptureCallbackArgument:&logoutServerBlock at:3]
            logout:[OCMArg any]
          andCalls:[OCMArg any]
    ];
}

- (void)stubOutMSAPIKeepAliveAndGrabServerCallbackBlock {
    [[[mockMyspaceAPI stub] andCaptureCallbackArgument:&keepaliveServerBlock at:3]
            keepalive:[OCMArg any]
            andCalls:[OCMArg any]
    ];
}

#pragma mark Tests

-(void) testAuthStateIsASingleton
{
    AuthState *auth1 = [AuthState sharedInstance];
    AuthState *auth2 = [AuthState sharedInstance];
    assertThat(auth1, sameInstance(auth2));
}

-(void) testAuthenticateInvokesAuthAPI{
    [[mockMyspaceAPI expect] login:credentials
                          andCalls:[OCMArg any]];

    [auth authenticate:credentials withResponder:nil];

    [mockMyspaceAPI verify];
}

-(void) testAuthenticateInvokesResponderSuccessfullyWhenCalledWithABlock
{
    [self stubOutMSAPIAuthenticateAndGrabServerCallbackBlock];

    AuthUserInfo *info = [self createBobTestUser];

    NSString *email = @"bob@fictional.com";

    [[[mockResponder expect] andDo:^(NSInvocation *invocation){
        __unsafe_unretained UserProfile *profile = nil;
        [invocation getArgument:&profile atIndex:2];
        assertThat(profile.name, equalTo(@"Bob"));
        assertThat(profile.email, equalTo(@"bob@fictional.com"));
        assertThat(profile.avatarURL, equalTo(@"http://path/to/avatar/url.jpg"));
    }] onSuccess:[OCMArg any]];

    [[mockTimerFactory stub] scheduleWithInterval:180 withBlock:[OCMArg any] repeats:YES];

    credentials.username = email;

    [auth authenticate:credentials
          withResponder:mockResponder];

    authenticateServerBlock(info, nil);

    STAssertTrue(auth.isLoggedIn, @"");
    STAssertEquals(auth.sessionID, @"4321", @"");
    assertThat(auth._authUser, sameInstance(info));

    [mockResponder verify];
}

-(void) testAuthenticateInvokesTheFailureResponderSuccessfullyWhenCalledWithAnError
{
    [self stubOutMSAPIAuthenticateAndGrabServerCallbackBlock];

    NSError *authenticationError = [[NSError alloc] init];
    [[mockResponder expect] onFailure:[OCMArg any]];

    [auth authenticate:credentials
          withResponder:mockResponder];

    authenticateServerBlock(nil, authenticationError);

    [mockResponder verify];
}

-(void) testAuthenticateResponderHandlesBadCredentialsSuccessfully
{
    // populate serverBlock with
    [self stubOutMSAPIAuthenticateAndGrabServerCallbackBlock];

    // Faked MSAPI authentication failure error
    NSError *authenticationError = [[NSError alloc] initWithDomain:@"AuthState"
                                                              code:NSURLErrorUserCancelledAuthentication
                                                          userInfo:nil];

    // Set up OCMock expectation.  We expect onFailure to be called with an NSError argument
    // When it is we check that the NSError properties match what we expect
    [[[mockResponder expect]
        andDo:^(NSInvocation *invocation) {
            __unsafe_unretained NSError *receivedAuthenticationError = nil;
            [invocation getArgument:&receivedAuthenticationError atIndex:2];
            assertThat([NSNumber numberWithInteger:receivedAuthenticationError.code], equalToInt(401));
            assertThat(receivedAuthenticationError.domain, equalTo(@"AuthState"));
        }]
        onFailure:instanceOf([NSError class])
    ];

    // Make the authentication call.  serverBlock is instantiated at this point
    [auth authenticate:credentials
          withResponder:mockResponder];

    authenticateServerBlock(nil, authenticationError);

    [mockResponder verify];
}

-(void) testAuthenticateCreatesATimerToPokeKeepAliveEveryThreeMinutesUponSuccessfulLogin
{
    [self stubOutMSAPIAuthenticateAndGrabServerCallbackBlock];

    [[mockTimerFactory stub] scheduleWithInterval:180 withBlock:[OCMArg any] repeats:YES];

    AuthUserInfo *const info = [self createBobTestUser];

    NSString *email = @"bob@fictional.com";

    [[[mockResponder expect] andDo:^(NSInvocation *invocation){
        __unsafe_unretained UserProfile *profile = nil;
        [invocation getArgument:&profile atIndex:2];
        assertThat(profile.name, equalTo(@"Bob"));
        assertThat(profile.email, equalTo(@"bob@fictional.com"));
        assertThat(profile.avatarURL, equalTo(@"http://path/to/avatar/url.jpg"));
    }] onSuccess:[OCMArg any]];

    credentials.username = email;

    [auth authenticate:credentials
          withResponder:mockResponder];

    authenticateServerBlock(info, nil);

    // check that the timer is instantiated
    assertThat(auth._keepAliveTimer, isNot(nil));

    [mockResponder verify];
}

-(void) testAuthenticateKeepAliveTimerCallsMyspaceAPIKeepAlive
{
    [self stubOutMSAPIAuthenticateAndGrabServerCallbackBlock];

    __block void(^startEvent)() = nil;
    [[[mockTimerFactory expect]
            andDo:^(NSInvocation *invocation) {
                void(^tmpBlock)() = nil;
                [invocation getArgument:&tmpBlock atIndex:3];

                startEvent = [tmpBlock copy];
            }]
            scheduleWithInterval:180 withBlock:[OCMArg any] repeats:YES];

    AuthUserInfo *info = [self createBobTestUser];

    NSString *email = @"bob@fictional.com";

    [[[mockResponder expect] andDo:^(NSInvocation *invocation){
        __unsafe_unretained UserProfile *profile = nil;
        [invocation getArgument:&profile atIndex:2];
        assertThat(profile.name, equalTo(@"Bob"));
        assertThat(profile.email, equalTo(@"bob@fictional.com"));
        assertThat(profile.avatarURL, equalTo(@"http://path/to/avatar/url.jpg"));
    }] onSuccess:[OCMArg any]];

    credentials.username = email;

    [auth authenticate:credentials
          withResponder:mockResponder];

    authenticateServerBlock(info, nil);
    [mockMyspaceAPI verify];

    [[mockMyspaceAPI expect] keepalive:[OCMArg any]
            andCalls:[OCMArg any]];

    startEvent();

    [mockResponder verify];
    [mockMyspaceAPI verify];
    [mockTimerFactory verify];
}

-(void) testAuthenticateLogsInToXMPPServerWithProvidedCredentialsUponSuccessfulLogin
{
    [self stubOutMSAPIAuthenticateAndGrabServerCallbackBlock];

    [[mockXMPPClient expect] connectWithJID:instanceOf([NSString class])
                                andPassword:instanceOf([NSString class])];

    AuthUserInfo *const info = [self createBobTestUser];

    NSString *email = @"bob@fictional.com";

    [[[mockResponder expect] andDo:^(NSInvocation *invocation){
        __unsafe_unretained UserProfile *profile = nil;
        [invocation getArgument:&profile atIndex:2];
        assertThat(profile.name, equalTo(@"Bob"));
        assertThat(profile.email, equalTo(@"bob@fictional.com"));
        assertThat(profile.avatarURL, equalTo(@"http://path/to/avatar/url.jpg"));
    }] onSuccess:[OCMArg any]];

    [[mockTimerFactory stub] scheduleWithInterval:180 withBlock:[OCMArg any] repeats:YES];

    credentials.username = email;

    [auth authenticate:credentials
          withResponder:mockResponder];

    authenticateServerBlock(info, nil);

    [mockResponder verify];
    [mockXMPPClient verify];
}

-(void)testAuthenticateSetsCurrentUserCorrectly
{
    [self stubOutMSAPIAuthenticateAndGrabServerCallbackBlock];

    AuthUserInfo *const info = [self createBobTestUser];

    [[mockResponder stub] onSuccess:[OCMArg any]];

    [[mockTimerFactory stub] scheduleWithInterval:180 withBlock:[OCMArg any] repeats:YES];

    credentials.username = @"bob@fictional.com";

    [auth authenticate:credentials
         withResponder:mockResponder];

    authenticateServerBlock(info, nil);

    STAssertNotNil(auth.currentUser, @"");
    assertThat(auth.currentUser.name, equalTo(info.name));
    assertThat(auth.currentUser.email, equalTo(credentials.username));
    assertThat(auth.currentUser.avatarURL, equalTo(((ProfileImage *)[info.profileImageUrls objectAtIndex:0]).url));
}

-(void) testLogoutCallsMyspaceLogoutRegardless
{
    [self stubOutMSAPIAuthenticateAndGrabServerCallbackBlock];

    [[mockMyspaceAPI expect] logout:[OCMArg any]
                           andCalls:[OCMArg any]];

    [auth logoutWithResponder:nil];

    [mockMyspaceAPI verify];
}

-(void) testLogoutCallsOnFailureResponderOnFailure
{
    [self stubOutMSAPILogoutAndGrabServerCallbackBlock];

    [[[mockLogoutResponder expect] andDo:^(NSInvocation *invocation){
        __unsafe_unretained NSError *error = nil;
        [invocation getArgument:&error atIndex:2];
        assertThatInteger(error.code, equalTo([NSNumber numberWithInt:NSURLErrorUserCancelledAuthentication]));
        assertThat(error.domain, equalTo(@"AuthState"));
        STAssertNil(error.userInfo, @"");
    }] onFailure:[OCMArg any]];

    NSError *logoutError = [[NSError alloc] initWithDomain:@"AuthState"
                                                              code:NSURLErrorUserCancelledAuthentication
                                                          userInfo:nil];
    [auth logoutWithResponder:mockLogoutResponder];

    logoutServerBlock(NO, 500, logoutError);

    [mockLogoutResponder verify];
}

-(void) testLogoutCallsResponderOnSuccessfulLogoutOnSuccess
{
    [self stubOutMSAPILogoutAndGrabServerCallbackBlock];

    [[mockLogoutResponder expect] onSuccessfulLogout];

    [auth logoutWithResponder:mockLogoutResponder];

    logoutServerBlock(YES, 200, nil);

    [mockLogoutResponder verify];
}

-(void) testLogoutCallsXMPPLogoutRegardless
{
    [self stubOutMSAPILogoutAndGrabServerCallbackBlock];

    [[mockXMPPClient expect] logout];

    [auth logoutWithResponder:nil];

    [mockXMPPClient verify];
}

-(void)testUserProfileIsPersistedOnSuccessfulLogin
{
    mockAuthState = [OCMockObject partialMockForObject:auth];

    AuthUserInfo *const bobUser = [self createBobTestUser];

    [self stubOutMSAPIAuthenticateAndGrabServerCallbackBlock];

    [[mockTimerFactory stub] scheduleWithInterval:180 withBlock:[OCMArg any] repeats:YES];

    [[mockAuthState expect] _saveLoggedInAuthUser:sameInstance(bobUser)];

    [mockAuthState authenticate:credentials withResponder:mockResponder];

    authenticateServerBlock(bobUser, nil);

    [mockAuthState verify];
}

-(void)testUserProfileIsDeletedOnLogoutRegardless
{
    [self stubOutMSAPILogoutAndGrabServerCallbackBlock];

    mockAuthState = [OCMockObject partialMockForObject:auth];

    [[[mockAuthState expect] andForwardToRealObject] _setStateToLoggedOut];

    // populate with some data, test it's there
    AuthUserInfo *const testUser = [self createBobTestUser];
    NSData *userData1 = [NSKeyedArchiver archivedDataWithRootObject:testUser];
    [[NSUserDefaults standardUserDefaults] setObject:userData1 forKey:AUTH_STATE_LOGGED_IN_USER];
    NSData *userData2 = [[NSUserDefaults standardUserDefaults] objectForKey:AUTH_STATE_LOGGED_IN_USER];
    AuthUserInfo *userProfile1 = [NSKeyedUnarchiver unarchiveObjectWithData:userData2];
    STAssertNotNil(userProfile1, @"Error saving user profile to persistence prior to test.");

    [mockAuthState logoutWithResponder:mockLogoutResponder];

    NSData *userData3 = [[NSUserDefaults standardUserDefaults] objectForKey:AUTH_STATE_LOGGED_IN_USER];
    AuthUserInfo *userProfile2 = [NSKeyedUnarchiver unarchiveObjectWithData:userData3];

    [mockAuthState verify];

    STAssertNil(userProfile2, @"Logout does not remove AuthUserInfo from persistence.");
}

-(void) testLogoutStopsTheKeepAliveTimerOnSuccessRegardless
{
    [self stubOutMSAPILogoutAndGrabServerCallbackBlock];

    mockKeepAliveTimer = [OCMockObject mockForClass:[NSTimer class]];

    [[mockKeepAliveTimer expect] invalidate];

    auth._keepAliveTimer = mockKeepAliveTimer;

    [auth logoutWithResponder:mockResponder];

    [mockKeepAliveTimer verify];

}

-(void) testLogoutRemovesUserStatePropertiesFromTheAuthStateObjectRegardlessOfLogoutSuccess
{
    [[mockMyspaceAPI expect] logout:[OCMArg any]
            andCalls:[OCMArg any]];

    auth.currentUser = [[UserProfile  alloc] init];
    auth._authUser = [[AuthUserInfo  alloc] init];
    auth.loggedIn = YES;
    auth.sessionID = @"1234";

    [auth logoutWithResponder:nil];

    assertThat(auth.currentUser, equalTo(nil));
    assertThat(auth._authUser, equalTo(nil));
    STAssertFalse(auth.isLoggedIn, @"");
    assertThat(auth.sessionID, equalTo(nil));
}

-(void)testInitialStateHasPropertiesSetAsIfLoggedOut
{
    assertThat(auth.currentUser, equalTo(nil));
    assertThat(auth._authUser, equalTo(nil));
    STAssertFalse(auth.isLoggedIn, @"");
    assertThat(auth.sessionID, equalTo(nil));
}

-(void)testUserConversionIsTolerantOfEmptyAvatarURLArray
{
    AuthUserInfo *const bob = [self createBobTestUser];
    bob.profileImageUrls = [[NSMutableArray alloc] init];
    UserProfile *const profile = [[UserProfile alloc] init];

    [auth _takeAuthUserInfo:bob andConvertIntoUserProfile:profile];

    STAssertNil(profile.avatarURL, @"Avatar URL should be nil");
}

-(void)testUserIsSavedAndToPersistentStorage
{
    // Representative sample of fields for a user
    AuthUserInfo *billUser = [self createBillTheTestUser];

    [auth _saveLoggedInAuthUser:billUser];

    NSData * saved = [[NSUserDefaults standardUserDefaults] objectForKey:AUTH_STATE_LOGGED_IN_USER];
    AuthUserInfo * savedUser = [NSKeyedUnarchiver unarchiveObjectWithData:saved];

    assertThat(savedUser, theSameUserAs(billUser));

}

-(void)testUserIsRetrievedFromPersistenceOnAutoLogin
{
    AuthUserInfo *billUser = [self createBillTheTestUser];

    [self saveUserToPersistence:billUser];

    [[mockMyspaceAPI expect] keepalive:[OCMArg any] andCalls:[OCMArg any]];

    [auth revivePreviousSession:mockResponder];

    assertThat([auth _authUser], theSameUserAs(billUser));
}

-(void)testCurrentUserIsSetOnAutoLogin
{
    AuthUserInfo *billUser = [self createBillTheTestUser];

    [self saveUserToPersistence:billUser];

    [self stubOutMSAPIKeepAliveAndGrabServerCallbackBlock];

    [auth revivePreviousSession:mockResponder];

    keepaliveServerBlock(YES, billUser, 200, nil);

    assertThat([auth _authUser], theSameUserAs(billUser));

    STAssertNotNil(auth.currentUser, @"");
    assertThat(auth.currentUser.name, equalTo(billUser.name));
//    assertThat(auth.currentUser.email, equalTo(???)); //TODO: We don't have the email at this point
    assertThat(auth.currentUser.avatarURL, equalTo(((ProfileImage *)[billUser.profileImageUrls objectAtIndex:0]).url));
}

-(void)testAutomaticLoginTriesTheKeepAliveEndpointWithTheStoredUser
{
    AuthUserInfo *billUser = [self createBillTheTestUser];

    [self saveUserToPersistence:billUser];

    [[mockMyspaceAPI expect] keepalive:(id)theSameUserAs(billUser) andCalls:[OCMArg any]];

    [auth revivePreviousSession:mockResponder];

    [mockMyspaceAPI verify];
}

-(void)testAutomaticLoginStartsKeepAliveTimer
{
    AuthUserInfo *billUser = [self createBillTheTestUser];

    [self saveUserToPersistence:billUser];

    [self stubOutMSAPIKeepAliveAndGrabServerCallbackBlock];

    [auth set_keepAliveTimer:nil];

    [auth revivePreviousSession:mockResponder];

    [[mockXMPPClient expect] connectWithJID:(id)equalTo(billUser.xmppJid)
                                andPassword:(id)equalTo(billUser.xmppPassword)];

    [[mockResponder expect] onSuccess:(id)HC_hasProperty(@"name", equalTo(@"Bill Gates"))];

    id mockTimer = [OCMockObject mockForClass:[NSTimer class]];

    [[[mockTimerFactory stub] andReturn:mockTimer ] scheduleWithInterval:180.0f withBlock:[OCMArg any] repeats:YES];

    keepaliveServerBlock(YES, billUser, 200, nil);

    assertThat(auth.sessionID, equalTo(@"1234567890"));
    STAssertNotNil([auth _keepAliveTimer], @"Expected auth._keepAliveTimer to be instantiated");

    [mockXMPPClient verify];
    [mockResponder verify];

}

-(void)testAutomaticLoginSetsStateAndLogsInToXMPPOnSuccessAndCallsResponder
{
    AuthUserInfo *billUser = [self createBillTheTestUser];

    [self saveUserToPersistence:billUser];

    [self stubOutMSAPIKeepAliveAndGrabServerCallbackBlock];

    [[mockTimerFactory expect] scheduleWithInterval:180.0f withBlock:[OCMArg any] repeats:YES];

    [auth revivePreviousSession:mockResponder];



    [[mockXMPPClient expect] connectWithJID:(id)equalTo(billUser.xmppJid)
                                andPassword:(id)equalTo(billUser.xmppPassword)];

    [[mockResponder expect] onSuccess:(id)HC_hasProperty(@"name", equalTo(@"Bill Gates"))];

    keepaliveServerBlock(YES, billUser, 200, nil);

    assertThat(auth.sessionID, equalTo(@"1234567890"));

    [mockXMPPClient verify];
    [mockResponder verify];
}

-(void)testAutomaticLoginCallsOnFailureWhenKeepaliveFails
{
    AuthUserInfo *billUser = [self createBillTheTestUser];

    [self saveUserToPersistence:billUser];

    [self stubOutMSAPIKeepAliveAndGrabServerCallbackBlock];

    [auth revivePreviousSession:mockResponder];

    [[mockResponder expect]
            onFailure:(id)allOf(
                instanceOf([NSError class]),
                HC_hasProperty(@"domain", equalTo(@"AuthState")),
                nil)
    ];

    keepaliveServerBlock(NO, billUser, 500, nil);

    [mockResponder verify];
}

-(void)testAutomaticLoginSetsStateToLoggedOutOnFailure
{
    AuthUserInfo *billUser = [self createBillTheTestUser];

    [self saveUserToPersistence:billUser];

    [self stubOutMSAPIKeepAliveAndGrabServerCallbackBlock];

    [auth revivePreviousSession:mockResponder];

    keepaliveServerBlock(NO, billUser, 500, nil);

    STAssertNil(auth.currentUser, @"");
    STAssertNil(auth._authUser, @"");
    STAssertNil(auth.sessionID, @"");
    STAssertFalse(auth.isLoggedIn, @"");

}

-(void)testAutomaticLoginStopsKeepAliveTimerOnFailure
{
    AuthUserInfo *billUser = [self createBillTheTestUser];

    [self saveUserToPersistence:billUser];

    [self stubOutMSAPIKeepAliveAndGrabServerCallbackBlock];

    id mockTimer = [OCMockObject mockForClass:[NSTimer class]];

    [[mockTimer expect] invalidate];

    [auth set_keepAliveTimer:mockTimer];

    [auth revivePreviousSession:mockResponder];

    // fake login failure
    keepaliveServerBlock(NO, billUser, 403, Nil);

    STAssertNil([auth _keepAliveTimer], @"Expected auth._keepAliveTimer to be cleared");
}

-(void)testAutomaticLoginDoesNothingWithNoStoredUser
{
    [[mockMyspaceAPI reject] keepalive:[OCMArg any] andCalls:[OCMArg any]];
    
    [[mockResponder expect] onSuccess:nil];
    
    [auth revivePreviousSession:mockResponder];
}

@end
