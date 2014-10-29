#import "../tuneup/tuneup.js"
/*
 library.js
 
 common functions that can be used in tests
 
 
 */

var sleepTime = 5;

function validateHomePageOpen(){
    debug("Validating the user is on the home screen");
    try{
        var HomeScreen = window.images()["HomeView"];
        assertNotNull(HomeScreen, "Home View is not being displayed when expected");
        assertNotNull(HomeScreen.buttons()["OnNow Option"], "OnNow Option is not being displayed when expected");
        assertNotNull(HomeScreen.elements()["PlanAhead Option"], "PlanAhead Option is not being displayed when expected");
    }catch(err){
        fail("Home screen is not being displayed as expected: "+err);
    }
}

function validateHomePageOpenWithProgramInfo(){
    debug("Validating the user is on the home screen with the program info panel being displayed");
    try{
        var HomeScreen = window.images()["HomeView"];
        assertNotNull(HomeScreen, "Home View is not being displayed when expected");
        assertNotNull(HomeScreen.buttons()["OnNow Option"], "OnNow Option is not being displayed when expected");
        assertNotNull(HomeScreen.elements()["PlanAhead Option"], "PlanAhead Option is not being displayed when expected");
        assertNotNull(HomeScreen.images()["InfoPanelView"], "Info Panel is not being displayed when expected");
    }catch(err){
        fail("Home screen with info panel is not being displayed as expected: "+err);
    }
}

function validatePlanAheadOpen(){
    debug("Validating the user is on the plan ahead screen");
    try{
        var EPGScreen = window.images()["PlanAheadEpgView"];
        assertNotNull(EPGScreen, "Plan Ahead EPG View is not being displayed when expected");
        assertNotNull(EPGScreen.images()["Action Ring View"].buttons()["Day Changer Button"], "Day Changer button is not being displayed when expected");
        assertNotNull(EPGScreen.images()["Action Ring View"].buttons()["PlanAhead Central Button"], "Plan Ahead Central button is not being displayed when expected");
    }catch(err){
        fail("Plan Ahead screen is not being displayed as expected: "+err);
    }
}

function validatePlanAheadOpenWithProgramInfo(){
    debug("Validating the user is on the plan ahead screen with the program info panel being displayed");
    try{
        var EPGScreen = window.images()["PlanAheadEpgView"];
        var InfoPanel = EPGScreen.images()["InfoPanelView"];
        assertNotNull(InfoPanel, "Info Panel view is not being displayed when expected");
        assertNotNull(InfoPanel.images()["info_panel.png"], "info_panel.png");
    }catch(err){
        fail("Plan Ahead screen with the info panel is not being displayed as expected: "+err);
    }
}   

function validateOnNowOpen(){
    debug("Validating the user is on the on now screen");
    try{
        var onNowScreen = window.images()["OnNowView"];
        assertNotNull(onNowScreen, "On Now View is not being displayed when expected");
        assertNotNull(onNowScreen.buttons()["on now centre"], "On Now Central button is not being displayed when expected");
        assertNotNull(onNowScreen.elements()["PlanAhead Button"], "Plan Ahead button is not being displayed when expected");
        assertNull(onNowScreen.elements()["Action Ring View"].elements()["Day Changer Button"], "Day Changer button being displayed when not expected");
    }catch(err){
        fail("On Now screen is not being displayed as expected: "+err);
    }
}

function validateOnNowOpenWithProgramInfo(){
    debug("Validating the user is on the on now screen with the program info panel being displayed");
    try{
        var onNowScreen = window.images()["OnNowView"];
        var InfoPanel = onNowScreen.images()["InfoPanelView"];
        assertNotNull(InfoPanel, "Info Panel view is not being displayed when expected");
        assertNotNull(InfoPanel.images()["info_panel.png"], "info_panel.png");
    }catch(err){
        fail("On Now screen with the info panel is not being displayed as expected: "+err);
    }
} 

function validateKnownUserLoginScreenOpen(username){
    debug("Validating the user is on the known user login screen");
    try{
        assertEquals(username,window.images()["LoginView"].images()["CenterLoginView"].staticTexts()["knownUser"].value());
    }catch(err){
        fail("Login screen is not being displayed: "+err);
    }
}

function validateProfileSelectionScreenOpen(){
    debug("Validating the user is on the profile selection screen");
    try{
        var profileView = window.images()["ProfileView"];
        assertNotNull(profileView, "Profile View is not being displayed when expected");
        assertNotNull(profileView.buttons()["Avatar_pos_0"], "Avatar position 0 is not being displayed when expected");
        assertNotNull(profileView.buttons()["Avatar_pos_1"], "Avatar position 1 is not being displayed when expected");
        assertNotNull(profileView.buttons()["Avatar_pos_2"], "Avatar position 2 is not being displayed when expected");
        assertNotNull(profileView.buttons()["Avatar_pos_3"], "Avatar position 3 is not being displayed when expected");
        assertNotNull(profileView.buttons()["Avatar_pos_4"], "Avatar position 4 is not being displayed when expected");
        assertNotNull(profileView.buttons()["Avatar_pos_5"], "Avatar position 5 is not being displayed when expected");
        assertNotNull(profileView.buttons()["Avatar_pos_6"], "Avatar position 6 is not being displayed when expected");
        assertNotNull(profileView.buttons()["Avatar_pos_7"], "Avatar position 7 is not being displayed when expected");
        assertNotNull(profileView.buttons()["ProfileBack"], "Profile Back Button is not being displayed when expected");
    }catch(err){
        fail("Profile Selection Screen is not being displayed as expected: "+err);
    }
}

function goHome()
{
    //TODO - add check to see if in full screen 
	debug("Go to Home Page");
    if(window.images()["LoginView"].buttons()["login back"].checkIsValid()){
        window.images()["LoginView"].buttons()["login back"].tap();
    }
    sleep(5);
    if(window.images()["ProfileView"].buttons()["ProfileBack"].checkIsValid()){
        window.images()["ProfileView"].buttons()["ProfileBack"].tap();
    }
    if(window.images()["HomeView"].buttons()["Home Button"].checkIsValid()){
        window.images()["HomeView"].buttons()["Home Button"].tap();
    }
    validateHomePageOpen();
}

function customFail(message)
{
    debug("--------------An Error occured - tidying up state--------------");
    try{
        target.tapWithOptions({x:150, y:150});//required to get rid of the info panel if being displayed
        goHome();
        deleteKnownUsers();
        fail(message);
    }catch(err){
        fail(message);
    }
    debug("--------------Finished tidying up the state--------------");
}

function deleteKnownUsers()
{
    debug("deleteKnownUsers");
    //Open Profile Selection screen
    window.images()["Top Bar"].buttons()["top bar login"].tap();
    //log user out if they are logged in
    if(window.images()["Top Bar"].buttons()["user menu logout"].isVisible()){
        window.images()["Top Bar"].buttons()["user menu logout"].tap();
    }
    sleep(2);
    //this has to be done in reverse otherwise the avatars move and the numbering changes
    for (i=7; i>=0; i--) {
        window.tap();
        avatar = "Avatar_pos_"+i;
        delete_avatar = "Delete_avatar_pos_"+i;
        window.images()["ProfileView"].buttons()[avatar].touchAndHold(3);
        try{
            window.images()["ProfileView"].buttons()[delete_avatar].tap();
        }catch(err){
            //there was no known user to delete
            continue
        }
    }
    window.images()["ProfileView"].buttons()["ProfileBack"].tap();
}


function waitForElementToBeEnabled(element)
{
	//Note: this may not be needed , woudl vtap() work for this?
	var count = 0;
	while(count<=5){
		if(element.isEnabled()){
			UIALogger.logMessage("Element became enabled");
			return true
		}else{
			count = count + 1;
			sleep(1);
		}
	}
	UIALogger.logFail("Element did not become enabled");
	return false
}

/*function waitForVideoToLoad()
{
    UIALogger.logMessage("Wait for video to load");
	var count = 0;
	while(count<=20){
		if(window.buttons()["channel info play btn"].isVisible() || window.buttons()["channel info catchup btn"].isVisible()){
            UIALogger.logMessage("Play is visible");
			return true;
		}else{
			count++;
			sleep(1);
		}
	}
    fail("Video took too long to load");
	return false    
}

function validateInfoPanelData(){
    UIALogger.logMessage("Validate info panel data");
    //TODO - once there is static data add tests for data
    assertNotNull(window.images()["channel-blobby-bg.png"], "channel-blobby-bg.png");
}*/

function imageComparison(testName, actualScreenshotName, expectedScreenshotName){
    var target = UIATarget.localTarget();
    var host = target.host();
    var UITestsDirectory = host.performTaskWithPathArgumentsTimeout("/usr/bin/printenv", ["UITESTS_DIR"],5).stdout.replace(/(\r\n|\n|\r)/gm,"");
    var imageComparisonScript = UITestsDirectory+"/imageComparison.sh";
    
    sleep(sleepTime);
    
    var result = host.performTaskWithPathArgumentsTimeout(imageComparisonScript, [testName, expectedScreenshotName, actualScreenshotName],5);
    
    if(result.exitCode==0){
        debug("Image Comparison script ran successfully");
        //TODO: work out if a failure tolerance produces the correct success/failues?
        if(result.stderr>3000){
            fail("Images do not match: diff amount="+result.stderr);
        }else{
            debug("diff amount: "+result.stderr);
        }
    }else{
        fail("Image Comparison script did NOT run successfully: "+result.stderr);
    }    
}

function createKnownUser(position, username, password){
    sleep(sleepTime);
    window.images()["Top Bar"].buttons()["top bar login"].tap();
    sleep(sleepTime);
    window.images()["ProfileView"].buttons()["Avatar_pos_"+position].tap();
    sleep(sleepTime);
    window.images()["LoginView"].images()["CenterLoginView"].textFields()["Username"].setValue(username);
    window.images()["LoginView"].images()["CenterLoginView"].secureTextFields()["Password"].setValue(password);
    sleep(sleepTime);
    window.images()["LoginView"].buttons()["login go btn"].tap();
    sleep(sleepTime);
    window.images()["Top Bar"].buttons()["top bar login"].tap();
    sleep(sleepTime);
    window.images()["UserMenu"].buttons()["user menu logout"].tap();
    sleep(sleepTime);
    window.images()["ProfileView"].buttons()["ProfileBack"].tap();
    sleep(sleepTime);
}

function validatePigControlsVisible(InfoPanel){
    debug("Validating the PiG controls are being displayed");
    if(!InfoPanel.images()["PlayerControls"].images()["PiGControls"].buttons()["play/pause"].isVisible()){
        fail("Controls are not visible when expected to be visible")
    }else{
        debug("-----Controls Visible------");
    }
    
}

function validatePigControlsNotVisible(InfoPanel, waitForBuffer){
    debug("Validating the PiG controls are not being displayed");
    if(waitForBuffer){
        debug("wait again if video starts buffering..");
        isVideoBuffering(InfoPanel); //This is required to reset if stream buffers
    }
    if(InfoPanel.images()["PlayerControls"].images()["PiGControls"].buttons()["play/pause"].isVisible()){
        fail("Controls are visible when not expected");
    }
    
}

function validatePiGVideoPlaying(InfoPanel){
    debug("Validating the video is playing");
    //TODO - validate pause button is displayed
    var eclipsedTime1 = InfoPanel.images()["PlayerControls"].images()["PiGControls"].images()["PigControlsProgressBar"].staticTexts()["eclipsed"].value();
    debug(eclipsedTime1);
    sleep(5);
    var eclipsedTime2 = InfoPanel.images()["PlayerControls"].images()["PiGControls"].images()["PigControlsProgressBar"].staticTexts()["eclipsed"].value();
    debug(eclipsedTime2);
    if(eclipsedTime1 >= eclipsedTime2){
        fail("video is not playing as expected");
    }
}

function validatePiGVideoPaused(InfoPanel){
    debug("Validating the video is paused");
    sleep(1);
    //TODO - validate the play button is displayed
    var eclipsedTime1 = InfoPanel.images()["PlayerControls"].images()["PiGControls"].images()["PigControlsProgressBar"].staticTexts()["eclipsed"].value();
    debug(eclipsedTime1);
    sleep(5);
    var eclipsedTime2 = InfoPanel.images()["PlayerControls"].images()["PiGControls"].images()["PigControlsProgressBar"].staticTexts()["eclipsed"].value();
    debug(eclipsedTime2);
    assertEquals(eclipsedTime1, eclipsedTime2, "Video is not paused as expected");
}

function validateFullscreenVideoPlaying(){
    debug("Validating the video is playing in full screen");
    sleep(1);
    //TOOD - validate the pause button is displayed
    var eclipsedTime1 = window.images()["FullScreenView"].images()["TopPlayerControls"].images()["progressBar"].staticTexts()["eclipsed"].value();
    debug(eclipsedTime1);
    sleep(5);
    var eclipsedTime2 = window.images()["FullScreenView"].images()["TopPlayerControls"].images()["progressBar"].staticTexts()["eclipsed"].value();
    debug(eclipsedTime2);
    if(eclipsedTime1 >= eclipsedTime2){
        fail("Video is not playing in full screen as expected");
    }
}

function validateFullscreenVideoPaused(InfoPanel){
    debug("Validating the video is paused in full screen");
    sleep(1);
    //TOOD - validate the pause button is displayed
    var eclipsedTime1 = window.images()["FullScreenView"].images()["TopPlayerControls"].images()["progressBar"].staticTexts()["eclipsed"].value();
    debug(eclipsedTime1);
    sleep(5);
    var eclipsedTime2 = window.images()["FullScreenView"].images()["TopPlayerControls"].images()["progressBar"].staticTexts()["eclipsed"].value();
    debug(eclipsedTime2);
    assertEquals(eclipsedTime1, eclipsedTime2, "Video is not paused in full screen as expected");
    
}

function waitForPiGVideoToLoad(InfoPanel){
    while(InfoPanel.activityIndicators()["In progress"].isVisible()){
        debug("Video loading.....");
        sleep(1);
    }
}

function Buffering(InfoPanel, count){
    var bufferingOccured = false;
    //while(InfoPanel.images()["PlayerControls"].staticTexts()["Buffering..."].isVisible()){
    while(InfoPanel.activityIndicators()["In progress"].isVisible()){
        debug("Video buffering .."+count);
        sleep(1);
        bufferingOccured = true;
    }
    return bufferingOccured;
}

function isVideoBuffering(InfoPanel){
    debug("isVideoBuffering?");
    var transportControlStayTime = 7;
    for (i=transportControlStayTime; i>=0; i--) {
        sleep(1);
        if(Buffering(InfoPanel, i)){
            debug("bufferingOccurred");
            i = transportControlStayTime;
        }
    }
}