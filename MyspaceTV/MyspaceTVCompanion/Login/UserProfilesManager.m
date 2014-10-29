//
//  UserProfilesManager.m
//  MyspaceTVCompanion
//
//  Created by Bann Al-Jelawi on 17/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserProfilesManager.h"

@implementation UserProfilesManager

+ (UserProfilesManager *)sharedSingleton
{
    static UserProfilesManager *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
        {
            sharedSingleton = [[UserProfilesManager alloc] init];
        }
        return sharedSingleton;
    }
}


-(NSArray *)loadUserProfiles
{
    NSData *profilesAsData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MSCOMPUserProfilesArray"];
    NSArray *userProfilesArray = [NSKeyedUnarchiver unarchiveObjectWithData:profilesAsData];
    return userProfilesArray;
}


-(void)saveUserProfiles:(NSArray *)arrayOfProfilesToSave
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arrayOfProfilesToSave];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"MSCOMPUserProfilesArray"]; 
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)saveCurrentUserProfile:(UserProfile *)currentUserProfile
{
    BOOL isUserProfileNilOrEmpty = [self doCheckForNilOrEmptyProfile:currentUserProfile];
    BOOL isDuplicateProfile = [self doCheckForDuplicateProfile:currentUserProfile];
    
    if(isUserProfileNilOrEmpty == false){
    
        if(isDuplicateProfile == true)
        {
            NSLog(@"User Profile already exists in user defaults!");
        }
        else
        {
            NSLog(@"Adding user to user defaults");
            [self addCurrentUserToUserDefaultsThenSave: currentUserProfile];
        }
    }
}

-(BOOL)doCheckForNilOrEmptyProfile:(UserProfile *)currentUserProfile
{
    if([currentUserProfile.name length] == 0 || [currentUserProfile.email length] == 0 || [currentUserProfile.avatarURL length] == 0)
    {
        return true;
    }
    else
    {
        return false;
    }
}

-(BOOL)doCheckForDuplicateProfile:(UserProfile *)currentUserProfile
{
    NSArray *loadedProfiles = [self loadUserProfiles];
    NSString *currentUserEmail = [currentUserProfile email];
    
    if(loadedProfiles != nil)
    {
        for (int i=0; i < [loadedProfiles count]; i++)
        {
            if([[[loadedProfiles objectAtIndex:i] email] isEqualToString: currentUserEmail])
            {
                return true;
            }
        } 
        
    }
    return false;
    
    loadedProfiles = nil;
    currentUserEmail = nil;
}

-(void)addCurrentUserToUserDefaultsThenSave:(UserProfile *)currentUserProfile
{
    NSArray *loadedProfilesToConcat = [self loadUserProfiles];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    [tempArray addObjectsFromArray:loadedProfilesToConcat];
    
    [tempArray addObject:currentUserProfile];
    
    NSArray *finalArrayToSave= [NSArray arrayWithArray:tempArray];
    
    [self saveUserProfiles:finalArrayToSave]; 
    
    loadedProfilesToConcat = nil;
    tempArray = nil;
    finalArrayToSave = nil;
}

-(void)removeCurrentUserFromUserDefaultsThenSave:(UserProfile *)userProfileToRemove
{
    NSString *currentUserEmail = [userProfileToRemove email];
    
    NSArray *loadedProfilesArray = [self loadUserProfiles];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    [tempArray addObjectsFromArray:loadedProfilesArray];
    
    
    if(loadedProfilesArray != nil)
    {
        for (int i=0; i < [loadedProfilesArray count]; i++)
        {
            if([[[loadedProfilesArray objectAtIndex:i] email] isEqualToString: currentUserEmail])
            {
                [tempArray removeObjectAtIndex:i];
                
                NSArray *finalArrayToSave= [NSArray arrayWithArray:tempArray];
                
                [self saveUserProfiles:finalArrayToSave]; 

                break;
            }
        } 
        
    }
         
    currentUserEmail = nil;
    loadedProfilesArray = nil;
    tempArray = nil;
}



@end
