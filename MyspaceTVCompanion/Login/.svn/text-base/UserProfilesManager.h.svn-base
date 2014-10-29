//
//  UserProfilesManager.h
//  MyspaceTVCompanion
//
//  Created by Bann Al-Jelawi on 17/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfile.h"

@interface UserProfilesManager : NSObject

+(UserProfilesManager *)sharedSingleton;
-(NSArray *)loadUserProfiles;
-(void)saveUserProfiles:(NSArray *)arrayOfProfilesToSave;
-(void)saveCurrentUserProfile:(UserProfile *)currentUserProfile;
-(void)removeCurrentUserFromUserDefaultsThenSave:(UserProfile *)userProfileToRemove;

@end
