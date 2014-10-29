#import "tuneup/tuneup.js"
#import "library/library.js"
/*
 profileSelection.js
 
Tests to cover the profile selection screen
 */

/*
Scenario - access profile selection screen and click cancel/exit and ensure the user is returned to the screen they were previously on
*/

var sleepTime=7;

/*test("profile selection screen - initial view", function(){
     //Setup - 2 known users, no one logged in
     //createKnownUser(0, "testuser_1@ronk.com", "password");
     //createKnownUser(1, "testuser_2@ronk.com", "password");
     sleep(sleepTime);
     createKnownUser(0, "testuser1@xumo-test.com", "testuser1");
     createKnownUser(1, "testuser2@xumo-test.com", "testuser2");
     sleep(sleepTime);
     window.images()["Top Bar"].buttons()["top bar login"].tap();
     sleep(sleepTime);
     validateProfileSelectionScreenOpen();
     sleep(sleepTime);
     
     target.captureRectWithName(window.images()["ProfileView"].buttons()["Avatar_pos_0"].rect(), "profile_user0_avatar");
     sleep(sleepTime);
     //imageComparison("profileSelectionTest", "profile_user0_avatar", "profile_user0_avatar");
     sleep(sleepTime);
     target.captureRectWithName(window.images()["ProfileView"].buttons()["Avatar_pos_1"].rect(), "profile_user1_avatar");
     sleep(sleepTime);
     //imageComparison("profileSelectionTest", "profile_user1_avatar", "profile_user1_avatar");
     window.images()["ProfileView"].buttons()["ProfileBack"].tap();
     sleep(sleepTime);
     //teardown - delete known users
     deleteKnownUsers();
});*/

test("profile selection screen - cancel/exit", function(){
     sleep(sleepTime);
     window.images()["Top Bar"].buttons()["top bar login"].tap();
     sleep(5);
     validateProfileSelectionScreenOpen();
     window.images()["ProfileView"].buttons()["ProfileBack"].tap();
     
     validateHomePageOpen();
     sleep(sleepTime);
     window.images()["HomeView"].buttons()["PlanAhead Option"].tap();
     sleep(sleepTime);
     window.images()["Top Bar"].buttons()["top bar login"].tap();
     sleep(sleepTime)
     window.images()["ProfileView"].buttons()["ProfileBack"].tap();
     validatePlanAheadOpen();
     
     window.images()["PlanAheadEpgView"].scrollViews()["EPG Grid"].images()[1].tap();
     sleep(sleepTime);
     validatePlanAheadOpenWithProgramInfo();
     sleep(sleepTime);
     window.images()["Top Bar"].buttons()["top bar login"].tap();
     sleep(sleepTime);
     window.images()["ProfileView"].buttons()["ProfileBack"].tap();
     //validatePlanAheadOpenWithProgramInfo(); - This is currently disabled due to MSCOMP-1293

     sleep(sleepTime); 
     window.images()["PlanAheadEpgView"].scrollViews()["EPG Grid"].scrollLeft();
     sleep(sleepTime);
     var ProgramName =  window.images()["PlanAheadEpgView"].scrollViews()["EPG Grid"].images()[1].label();
     debug(ProgramName);
     window.images()["PlanAheadEpgView"].scrollViews()["EPG Grid"].images()[1].tap();
     sleep(sleepTime);
     window.images()["Top Bar"].buttons()["top bar login"].tap();
     sleep(sleepTime);
     window.images()["ProfileView"].buttons()["ProfileBack"].tap();
     validatePlanAheadOpen();
     //assertEquals(ProgramName,window.images()["PlanAheadEpgView"].scrollViews()["EPG Grid"].images()[1].label()); - This is currently disabled due to MSCOMP-1293

     sleep(sleepTime);
     window.images()["PlanAheadEpgView"].images()["Action Ring View"].buttons()["Day Changer Button"].tap();
     sleep(sleepTime);
     var wheel = window.images()["PlanAheadEpgView"].pickers()[0].wheels()[0];
     wheel.selectValue(wheel.values()[2]);
     wheel.tap();
     var selectedDay = window.images()["PlanAheadEpgView"].pickers()[0].wheels()[0].value();
     debug(selectedDay);
     sleep(sleepTime);
     window.images()["Top Bar"].buttons()["top bar login"].tap();
     sleep(sleepTime);
     window.images()["ProfileView"].buttons()["ProfileBack"].tap();
     //assertEquals(selectedDay,window.images()["PlanAheadEpgView"].pickers()[0].wheels()[0].value()); - This is currently disabled due to MSCOMP-1293

     sleep(sleepTime);
     window.images()["PlanAheadEpgView"].images()["Action Ring View"].buttons()["No Now Button"].tap();
     sleep(sleepTime);
     window.images()["Top Bar"].buttons()["top bar login"].tap();
     sleep(sleepTime);
     window.images()["ProfileView"].buttons()["ProfileBack"].tap();
     validateOnNowOpen();
     sleep(sleepTime);
     window.images()["OnNowView"].tableViews()[0].cells()[0].tap();
     sleep(sleepTime);
     validateOnNowOpenWithProgramInfo();
     sleep(sleepTime);
     window.images()["Top Bar"].buttons()["top bar login"].tap();
     sleep(sleepTime);
     window.images()["ProfileView"].buttons()["ProfileBack"].tap();
     //validateOnNowOpenWithProgramInfo(); - This is currently disabled due to MSCOMP-1293
     });


/*test("profile selection screen - remove users", function(){
     sleep(sleepTime);
     createKnownUser(0, "testuser_1@ronk.com", "password");
     createKnownUser(1, "testuser_2@ronk.com", "password");
     createKnownUser(2, "testuser_3@ronk.com", "password");
     createKnownUser(3, "testuser_4@ronk.com", "password");
     createKnownUser(4, "testuser_5@ronk.com", "password");
     createKnownUser(5, "testuser_6@ronk.com", "password");
     createKnownUser(6, "testuser_7@ronk.com", "password");
     createKnownUser(7, "testuser_8@ronk.com", "password");
     sleep(sleepTime);
     
     //delete the user in position 0 and ensure that the avatars move round to fill the space
     window.images()["Top Bar"].buttons()["top bar login"].tap();
     sleep(sleepTime);
     window.images()["ProfileView"].buttons()["Avatar_pos_0"].touchAndHold(3);
     window.images()["ProfileView"].buttons()["Delete_avatar_pos_0"].tap();
     window.images()["ProfileView"].buttons()["Delete_avatar_pos_0"].tap();
     window.images()["ProfileView"].buttons()["Delete_avatar_pos_0"].tap();
     window.images()["ProfileView"].buttons()["Delete_avatar_pos_0"].tap();
     window.images()["ProfileView"].buttons()["Delete_avatar_pos_0"].tap();
     window.images()["ProfileView"].buttons()["Delete_avatar_pos_0"].tap();
     window.images()["ProfileView"].buttons()["Delete_avatar_pos_0"].tap();
     window.images()["ProfileView"].buttons()["Delete_avatar_pos_0"].tap();
     
     //check that all the known users have been deleted successfully
     sleep(sleepTime);
     for (i=0; i<7; i++) {
        sleep(sleepTime);
        avatar = "Avatar_pos_"+i;
        expected_avatar = "profile_user_"+i+"blank_avatar";
        target.captureRectWithName(window.images()["ProfileView"].buttons()[avatar].rect(), expected_avatar);
        imageComparison("profileSelectionTest", expected_avatar, expected_avatar);
     }
     
     });*/

 