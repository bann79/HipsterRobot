//
//  LoginViewController.h
//  MyspaceTVCompanion
//
//  Created by scott on 16/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppViewProtocol.h"
#import "ContentViewController.h"
#import "MyspaceApi.h"
#import "UserProfile.h"
#import "AuthStateResponder.h"
#import "Credential.h"
#import "AuthState.h"
#import "UserProfileAvatarViewController.h"


@class AppViewController;

@interface LoginViewController : ContentViewController <AuthStateResponder, UITextFieldDelegate>

@property (strong, nonatomic) NSString *sourceView;

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UILabel *knownUsernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *avatar;
@property (strong, nonatomic) IBOutlet UIView *elementsHolderView;

//Rings
@property (strong, nonatomic) IBOutlet UIImageView *centerRing;
@property (strong, nonatomic) IBOutlet UIImageView *middleRing;
@property (strong, nonatomic) IBOutlet UIImageView *outerRing;

//Other UI Elements
@property (strong, nonatomic) IBOutlet UIView *centerLoginView;
@property (strong, nonatomic) IBOutlet UIImageView *centreCircle;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundCentreCircle;


@property (strong, nonatomic) IBOutlet UIImageView *knownAvatar;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundGrad;
@property (strong, nonatomic) IBOutlet UIButton *cancelFailPromptBtn;

@property (strong, nonatomic) NSArray *rings;


@property (strong, nonatomic) Credential * userLoginCredentials;

@property (strong, nonatomic) UserProfile * knownUser;
@property (strong, nonatomic) UserProfileAvatarViewController * userAvatar;

-(IBAction)loginButtonTapped:(id)sender;
-(IBAction)cancelButtonTapped:(id)sender;
- (IBAction)onCancelFailPrompt:(id)sender;

-(void)doCancel;
-(void)authenticateUserLoginDetails;

-(void)loginSucceeded;
-(void)setUserProfile:(UserProfile *)userProfile;

-(void)checkLoginFieldsUsing:(NSString*) p_username AndPassword:(NSString *) p_password;
-(void)wrapUpLoginDetailsInCredentialObjectUsing:(NSString*) p_username And:(NSString*) p_password;;
-(void)displayCorrectLoginMessageAccordingToErrorCode:(int) errorCode OrSuccessfulLogin:(BOOL) loginWorked;

@property BOOL isKnownUser;
@property BOOL userDidPressReturnOnKeyboard;
-(void)clearLoginDetails;
@end



