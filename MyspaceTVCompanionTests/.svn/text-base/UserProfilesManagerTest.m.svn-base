//
//  UserProfilesManagerTest.m
//  MyspaceTVCompanion
//
//  Created by Bann Al-Jelawi on 18/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <OCMock/OCMock.h>
#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "UserProfilesManager.h"
#import "UserProfile.h"


@interface UserProfilesManagerTest : SenTestCase
{
    UserProfilesManager *testProfileManger;
    UserProfile *uProf;
    id mockUserProfile;
}
@end


@implementation UserProfilesManagerTest

-(void)setUp
{
    [super setUp];
    testProfileManger = [[UserProfilesManager alloc] init];
    
    //using concrete instance of class as we can't use setters on mocks!
    uProf = [[UserProfile alloc] init];
}

-(void)tearDown
{
    testProfileManger = nil;
    uProf = nil;
}

-(void)testThatProfileGetsSavedThenLoadedSucessfully
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MSCOMPUserProfilesArray"];
    
    STAssertNil([[NSUserDefaults standardUserDefaults] objectForKey:@"MSCOMPUserProfilesArray"], @"our profiles object in user defaults should be nil as we've just removed them");
    
    uProf.name = @"Peter Parker";
    uProf.email = @"spidey@webmail.com";
    uProf.avatarURL = @"http://cache.io9.com/assets/images/8/2008/11/spidey.jpg";
    
    
    NSArray *arrayProfileToSave = [NSArray arrayWithObject:uProf];
    
    [testProfileManger saveUserProfiles:arrayProfileToSave];
    
    NSArray *arrayProfileToLoad = [testProfileManger loadUserProfiles];
    
    STAssertTrue([[[arrayProfileToSave objectAtIndex:0] name] isEqualToString: [[arrayProfileToLoad objectAtIndex:0] name]], @"Both strings should be the same");
    
}

-(void)testThatLoadingProfilesWhereNoKeyPreviouslySetReturnsNil
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MSCOMPUserProfilesArray"];
    
    STAssertNil([[NSUserDefaults standardUserDefaults] objectForKey:@"MSCOMPUserProfilesArray"], @"our profiles object in user defaults should be nil as we've just removed them");
    
    STAssertNil([testProfileManger loadUserProfiles], @"should return nil as nothing exists for key MSCOMPUserProfilesArray in user defaults");
}

-(void)testThatSavingNonExistingCurrentProfileIsSuccessful
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MSCOMPUserProfilesArray"];
    
    uProf.name = @"Clark Kent";
    uProf.email = @"super@man.com";
    uProf.avatarURL = @"http://www.chrisreevehomepage.com/images/superman/i-ck.jpg";
    
    [testProfileManger saveCurrentUserProfile:uProf];
    
    uProf.name = @"Peter Parker";
    uProf.email = @"spidey@webmail.com";
    uProf.avatarURL = @"http://cache.io9.com/assets/images/8/2008/11/spidey.jpg";
    
    [testProfileManger saveCurrentUserProfile:uProf];
    
    NSArray *loadedProfiles = [testProfileManger loadUserProfiles];
    
    NSString *name1 = [[loadedProfiles objectAtIndex:0] name];
    
    STAssertTrue([name1 isEqualToString:@"Clark Kent"], @"first profile name should be Clark Kent");
    
    NSString *name2 = [[loadedProfiles objectAtIndex:1] name];
    
    STAssertTrue([name2 isEqualToString:@"Peter Parker"], @"second profile name should be Peter Parker");

}

-(void)testThatSavingPreExistingCurrentProfileDoesNotSaveAsDuplicate
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MSCOMPUserProfilesArray"];
    
    uProf.name = @"Clark Kent";
    uProf.email = @"super@man.com";
    uProf.avatarURL = @"http://www.chrisreevehomepage.com/images/superman/i-ck.jpg";
    
    [testProfileManger saveCurrentUserProfile:uProf];
    
    uProf.name = @"Clark Kent";
    uProf.email = @"super@man.com";
    uProf.avatarURL = @"http://www.chrisreevehomepage.com/images/superman/i-ck.jpg";
    
    [testProfileManger saveCurrentUserProfile:uProf];
    
    NSArray *loadedProfiles = [testProfileManger loadUserProfiles];
    
    STAssertTrue([loadedProfiles count] == 1, @"the second profile should not have been added or it would be a duplication");
}

-(void)testThatSavingNewCurrentProfileSavesSuccessfully
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MSCOMPUserProfilesArray"];
    
    uProf.name = @"Kermit Frog";
    uProf.email = @"frogger@muppets.com";
    uProf.avatarURL = @"http://www.chrisreevehomepage.com/images/superman/i-ck.jpg";
    
    [testProfileManger saveCurrentUserProfile:uProf];
    
    uProf.name = @"Miss Piggy";
    uProf.email = @"diva@muppets.com";
    uProf.avatarURL = @"http://www.chrisreevehomepage.com/images/superman/i-ck.jpg";
    
    [testProfileManger saveCurrentUserProfile:uProf];
    
    NSArray *loadedProfiles = [testProfileManger loadUserProfiles];
    
    STAssertTrue([loadedProfiles count] == 2, @"both profiles should have saved because they are both different");
}

-(void)testThatAMatchingCurrentProfileIsSuccessfullyRemovedFromUserDefaults
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MSCOMPUserProfilesArray"];
    
    uProf.name = @"Kermit Frog";
    uProf.email = @"frogger@muppets.com";
    uProf.avatarURL = @"http://www.chrisreevehomepage.com/images/superman/i-ck.jpg";
    
    [testProfileManger saveCurrentUserProfile:uProf];
    
    uProf.name = @"Miss Piggy";
    uProf.email = @"diva@muppets.com";
    uProf.avatarURL = @"http://www.chrisreevehomepage.com/images/superman/i-ck.jpg";
    
    [testProfileManger saveCurrentUserProfile:uProf];
    
    uProf.name = @"Rodger Rabbit";
    uProf.email = @"bugsy@carrots.com";
    uProf.avatarURL = @"http://www.chrisreevehomepage.com/images/superman/i-ck.jpg";
    
    [testProfileManger saveCurrentUserProfile:uProf];
    
    NSArray *loadedProfiles = [testProfileManger loadUserProfiles];
    
    STAssertTrue([loadedProfiles count] == 3, @"all 3 profiles should have saved");
    
    UserProfile *profileToDelete = [[UserProfile alloc] init];
    profileToDelete.name = @"Miss Piggy";
    profileToDelete.email = @"diva@muppets.com";
    profileToDelete.avatarURL = @"http://www.chrisreevehomepage.com/images/superman/i-ck.jpg";
    
    [testProfileManger removeCurrentUserFromUserDefaultsThenSave:profileToDelete];
    
    NSArray *loadedProfilesRecheck = [testProfileManger loadUserProfiles];
    
    STAssertTrue([loadedProfilesRecheck count] == 2, @"only 2 profiles should remain");
    
    STAssertTrue([[[loadedProfilesRecheck objectAtIndex:0]name] isEqualToString:@"Kermit Frog"], @"First in array should be Kermit Frog");
    
    STAssertTrue([[[loadedProfilesRecheck objectAtIndex:1]name] isEqualToString:@"Rodger Rabbit"], @"First in array should be Rodger Rabbit");
}


-(void)testThatANONMatchingCurrentProfileIsSuccessfullyRemovedFromUserDefaults
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MSCOMPUserProfilesArray"];
    
    uProf.name = @"Kermit Frog";
    uProf.email = @"frogger@muppets.com";
    uProf.avatarURL = @"http://www.chrisreevehomepage.com/images/superman/i-ck.jpg";
    
    [testProfileManger saveCurrentUserProfile:uProf];
    
    uProf.name = @"Miss Piggy";
    uProf.email = @"diva@muppets.com";
    uProf.avatarURL = @"http://www.chrisreevehomepage.com/images/superman/i-ck.jpg";
    
    [testProfileManger saveCurrentUserProfile:uProf];
    
    uProf.name = @"Rodger Rabbit";
    uProf.email = @"bugsy@carrots.com";
    uProf.avatarURL = @"http://www.chrisreevehomepage.com/images/superman/i-ck.jpg";
    
    [testProfileManger saveCurrentUserProfile:uProf];
    
    NSArray *loadedProfiles = [testProfileManger loadUserProfiles];
    
    STAssertTrue([loadedProfiles count] == 3, @"all 3 profiles should have saved");
    
    UserProfile *profileToDelete = [[UserProfile alloc] init];
    profileToDelete.name = @"Bob McBoberson";
    profileToDelete.email = @"bob@people.com";
    profileToDelete.avatarURL = @"http://www.chrisreevehomepage.com/images/superman/i-ck.jpg";
    
    [testProfileManger removeCurrentUserFromUserDefaultsThenSave:profileToDelete];
    
    NSArray *loadedProfilesRecheck = [testProfileManger loadUserProfiles];
    
    STAssertTrue([loadedProfilesRecheck count] == 3, @"all 3 profiles should remain intact as no matching profile was found");
    
}

-(void)testThatNilUserProfileCannotBeSaved
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MSCOMPUserProfilesArray"];
    
    uProf.name = @"Miss Piggy";
    uProf.email = @"diva@muppets.com";
    uProf.avatarURL = @"http://www.chrisreevehomepage.com/images/superman/i-ck.jpg";
    
    [testProfileManger saveCurrentUserProfile:uProf];
    
    uProf.name = nil;
    uProf.email = nil;
    uProf.avatarURL = nil;
    
    [testProfileManger saveCurrentUserProfile:uProf];
    
    NSArray *loadedProfiles = [testProfileManger loadUserProfiles];
    
    NSLog(@"loadedProfiles = %@", loadedProfiles);
    
    STAssertTrue([loadedProfiles count] == 1, @"no profile should be added as is nil");
}

-(void)testThatEmptyUserProfileCannotBeSaved
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MSCOMPUserProfilesArray"];
    
    uProf.name = @"Miss Piggy";
    uProf.email = @"diva@muppets.com";
    uProf.avatarURL = @"http://www.chrisreevehomepage.com/images/superman/i-ck.jpg";
    
    [testProfileManger saveCurrentUserProfile:uProf];
    
    uProf.name = @"";
    uProf.email = @"";
    uProf.avatarURL = @"";
    
    [testProfileManger saveCurrentUserProfile:uProf];
    
    NSArray *loadedProfiles = [testProfileManger loadUserProfiles];
    
    NSLog(@"loadedProfiles = %@", loadedProfiles);
    
    STAssertTrue([loadedProfiles count] == 1, @"no profile should be added as is nil");
}


@end
