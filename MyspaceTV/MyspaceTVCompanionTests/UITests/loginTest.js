#import "tuneup/tuneup.js"
#import "library/library.js"
/*
 loginTest.js
 
 Tests to cover the login/logout
 */
//Users with valid credentials
/*var user1_username = "testuser_1@ronk.com";
var user1_name = "testuser_1";
var user1_password = "password";*/
var user1_username = "testuser1@xumo-test.com";
var user1_name = "TestUser 1";
var user1_password = "testuser1";

/*var user2_username = "testuser_2@ronk.com";
var user2_name = "testuser_2";
var user2_password = "password";*/
var user2_username = "testuser2@xumo-test.com";
var user2_name = "TestUser 2";
var user2_password = "testuser2";

/*var user3_username = "testuser_3@ronk.com";
var user3_name = "testuser_3";
var user3_password = "password";*/
var user3_username = "testuser4@xumo-test.com";
var user3_name = "TestUser 4";
var user3_password = "testuser4new";

//users with invalid credentials
/*var invalid_username = "testuser_99@ronk.com";
var invalid_password = "pass";*/
var invalid_username = "testuser3@xumo-test.com";
var invalid_password = "pass";

var sleepTime = 3;

function validateSuccessfulLogin(){
    while(window.images()["LoginView"].images()["CenterLoginView"].activityIndicators()["In progress"].isVisible()){
        debug("Login - In Progress.....");
    }
    sleep(2);
    if(window.images()["LoginView"].images()["CenterLoginView"].images()["login_failed"].checkIsValid()){
        screenshot("failedLogin");
        fail("failed login but expected successful login (failed logo was displayed)");
    }
    sleep(sleepTime);
    validateHomePageOpen();
}

function validateFailedLogin(username){
    while(window.images()["LoginView"].images()["CenterLoginView"].activityIndicators()["In progress"].isVisible()){
        debug("Login - In Progress.....");
    }
    sleep(2);
    if(window.images()["LoginView"].images()["CenterLoginView"].images()["login_successful"].checkIsValid()){
        screenshot("successfulLogin");
        fail("login successful but expected login failure (successful logo was displayed)");
    }
    sleep(sleepTime);
    assertEquals(username,window.images()["LoginView"].images()["CenterLoginView"].textFields()["Username"].value());
}

test("New User Login - failed login", function(){
     try{
        sleep(sleepTime);
        validateHomePageOpen();
        window.images()["Top Bar"].buttons()["top bar login"].tap();
        sleep(sleepTime);
        validateProfileSelectionScreenOpen();
        
        var UserProfiles = window.images()["ProfileView"].buttons()["Avatar_pos_0"];
     
        UserProfiles.tap();
        sleep(sleepTime);
        window.images()["LoginView"].images()["CenterLoginView"].textFields()["Username"].setValue(invalid_username);
        window.images()["LoginView"].images()["CenterLoginView"].secureTextFields()["Password"].setValue(invalid_password);
        sleep(sleepTime);
        
        window.images()["LoginView"].buttons()["login go btn"].tap();
        validateFailedLogin(invalid_username);
        sleep(sleepTime);
        window.images()["LoginView"].buttons()["login back"].tap();
        sleep(sleepTime);
        window.images()["ProfileView"].buttons()["ProfileBack"].tap();
        sleep(sleepTime);
        target.captureRectWithName(window.images()["Top Bar"].buttons()["top bar login"].rect(), "logIn");
        sleep(sleepTime);
        imageComparison("loginTest", "logIn", "logIn");
     }catch(err){
        customFail(err);
     }
});

/*test("New User Login - successful login", function(){
     try{
        sleep(sleepTime);
        validateHomePageOpen();
        window.images()["Top Bar"].buttons()["top bar login"].tap();
        sleep(sleepTime);
        validateProfileSelectionScreenOpen();
     
        window.images()["ProfileView"].buttons()["Avatar_pos_0"].tap();
        sleep(sleepTime);
        window.images()["LoginView"].images()["CenterLoginView"].textFields()["Username"].setValue(user1_username);
        window.images()["LoginView"].images()["CenterLoginView"].secureTextFields()["Password"].setValue(user1_password);
        window.images()["LoginView"].buttons()["login go btn"].tap();
        validateSuccessfulLogin();
     
        sleep(sleepTime);
        target.captureRectWithName(window.images()["Top Bar"].buttons()["top bar login"].rect(), "user1_avatar");
        //imageComparison("loginTest", "user1_avatar", "user1_avatar");
     
        //tidy up - logout
        window.images()["Top Bar"].buttons()["top bar login"].tap();
        sleep(sleepTime);
        window.images()["UserMenu"].buttons()["user menu logout"].tap();
        window.images()["ProfileView"].buttons()["ProfileBack"].tap();
     
     }catch(err){
        customFail(err);
     }
});

test("Known User Login", function(){
     try{
        sleep(sleepTime);
        validateHomePageOpen();
        window.images()["Top Bar"].buttons()["top bar login"].tap();
        sleep(sleepTime);
        validateProfileSelectionScreenOpen();
     
        window.images()["ProfileView"].buttons()["Avatar_pos_0"].tap();
        sleep(sleepTime);
        //Need to double check about this
        validateKnownUserLoginScreenOpen(user1_name);
        window.images()["LoginView"].images()["CenterLoginView"].secureTextFields()["Password"].setValue(user1_password);
        window.images()["LoginView"].buttons()["login go btn"].tap();
        validateSuccessfulLogin();

        //tidy up - delete known user
        window.images()["Top Bar"].buttons()["top bar login"].tap();
        sleep(sleepTime);
        window.images()["UserMenu"].buttons()["user menu logout"].tap();
        sleep(sleepTime);
        window.images()["ProfileView"].buttons()["Avatar_pos_0"].touchAndHold(2);
        sleep(sleepTime);
        window.images()["ProfileView"].buttons()["Delete_avatar_pos_0"].tap();
        sleep(sleepTime);
        window.images()["ProfileView"].buttons()["ProfileBack"].tap();
     }catch(err){
        customFail(err);
     }
});*/