#import "tuneup/tuneup.js"
#import "library/library.js"

var sleepTime=7;

test("PiG Mode - transport control displays", function(){
     try{
        sleep(sleepTime);
        window.images()["HomeView"].images()["OnNowPanel"].images()["onNowTopMenu"].buttons()["onNowTop"].tap(); //ET - step 2
        sleep(sleepTime);
        validateHomePageOpenWithProgramInfo();
        testTransportControls(window.images()["HomeView"].images()["InfoPanelView"]);
 
        //Repeating tests from on now screen
        window.images()["HomeView"].buttons()["OnNow Option"].tap();
        sleep(sleepTime);
        window.images()["OnNowView"].tableViews()["onNowTable"].cells()[0].tap(); //ET - step 2
        sleep(sleepTime);
        validateOnNowOpenWithProgramInfo();
        testTransportControls(window.images()["OnNowView"].images()["InfoPanelView"]);

        //Repeating tests from plan ahead screen
        window.images()["OnNowView"].buttons()["PlanAhead Button"].tap();
        sleep(sleepTime);
        sleep(sleepTime);
        sleep(sleepTime);
        target.tapWithOptions({x:460, y:300});//ET - step 2
        sleep(sleepTime);
        validatePlanAheadOpenWithProgramInfo();
        testTransportControls(window.images()["PlanAheadEpgView"].images()["InfoPanelView"]);
     
        window.images()["Top Bar"].buttons()["Home Button"].tap();

     }catch(err){
        customFail(err);
     }
});

function testTransportControls(InfoPanel){
     //TODO - check info panel data
     validatePigControlsNotVisible(InfoPanel, false);
     
     InfoPanel.buttons()["channel info play btn"].tap(); //ET - step 3
     while(InfoPanel.activityIndicators()["In progress"].isVisible()){
        debug("Video loading.....");
         sleep(1);
     }
     validatePigControlsVisible(InfoPanel);
     validatePigControlsNotVisible(InfoPanel, true); //ET - step 4
     
     isVideoBuffering(InfoPanel);
     target.tapWithOptions({x:120, y:280}); //ET - step 5
     validatePigControlsVisible(InfoPanel);
     target.tapWithOptions({x:120, y:280}); //ET - step 6
     validatePigControlsNotVisible(InfoPanel, false);
     
     sleep(sleepTime);
     target.tapWithOptions({x:150, y:150});
     sleep(sleepTime);
    
}

test("PiG Mode - Play/Pause", function(){
     try{
        sleep(sleepTime);
        window.images()["HomeView"].images()["OnNowPanel"].images()["onNowTopMenu"].buttons()["onNowTop"].tap(); //ET - step 2
        testPlayPause(window.images()["HomeView"].images()["InfoPanelView"]);

        //Repeating tests from on now screen
        window.images()["HomeView"].buttons()["OnNow Option"].tap();
        sleep(sleepTime);
        window.images()["OnNowView"].tableViews()["onNowTable"].cells()[0].tap(); //ET - step 2
        testPlayPause(window.images()["OnNowView"].images()["InfoPanelView"]);
     
        //Repeating tests from plan ahead screen
        window.images()["OnNowView"].buttons()["PlanAhead Button"].tap();
        sleep(sleepTime);
        sleep(sleepTime);
        sleep(sleepTime);
        target.tapWithOptions({x:460, y:300});//ET - step 2
        testPlayPause(window.images()["PlanAheadEpgView"].images()["InfoPanelView"]);
     
        window.images()["Top Bar"].buttons()["Home Button"].tap();

     
    }catch(err){
        customFail(err);
    }
});
 
function testPlayPause(InfoPanel){
    sleep(sleepTime);
    InfoPanel.buttons()["channel info play btn"].tap();
    waitForPiGVideoToLoad(InfoPanel);
    validatePigControlsVisible(InfoPanel);
    validatePiGVideoPlaying(InfoPanel);
 
    sleep(sleepTime);
    isVideoBuffering(InfoPanel);
    target.tapWithOptions({x:120, y:280});
    InfoPanel.images()["PlayerControls"].images()["PiGControls"].buttons()["play/pause"].tap(); //ET - step 3
    validatePiGVideoPaused(InfoPanel);
    sleep(sleepTime);
 
    isVideoBuffering(InfoPanel);
    target.tapWithOptions({x:120, y:280});
    InfoPanel.images()["PlayerControls"].images()["PiGControls"].buttons()["play/pause"].tap(); // ET - step 4
    validatePiGVideoPlaying(InfoPanel);
 
    sleep(sleepTime);
    target.tapWithOptions({x:150, y:150})
    sleep(sleepTime);
}

test("PiG Mode - Full Screen", function(){
     try{
        sleep(sleepTime);
        window.images()["HomeView"].images()["OnNowPanel"].images()["onNowTopMenu"].buttons()["onNowTop"].tap();
        testFullscreen(window.images()["HomeView"].images()["InfoPanelView"]);
     
        //Repeating tests from on now screen
        window.images()["HomeView"].buttons()["OnNow Option"].tap();
        sleep(sleepTime);
        window.images()["OnNowView"].tableViews()["onNowTable"].cells()[0].tap(); //ET - step 2
        testFullscreen(window.images()["OnNowView"].images()["InfoPanelView"]);
 
        //Repeating tests from plan ahead screen
        window.images()["OnNowView"].buttons()["PlanAhead Button"].tap();
        sleep(sleepTime);
        sleep(sleepTime);
        sleep(sleepTime);
        target.tapWithOptions({x:460, y:300});//ET - step 2
        testFullscreen(window.images()["PlanAheadEpgView"].images()["InfoPanelView"]);
     
        window.images()["Top Bar"].buttons()["Home Button"].tap();
     
     }catch(err){
        customFail(err);
     }
});
 
function testFullscreen(InfoPanel){
    sleep(sleepTime);
    InfoPanel.buttons()["channel info play btn"].tap();
    while(InfoPanel.activityIndicators()["In progress"].isVisible()){
        debug("Video loading.....");
        sleep(1);
    }
    validatePigControlsVisible(InfoPanel);
 
    InfoPanel.images()["PlayerControls"].images()["PiGControls"].buttons()["fullscreen"].tap();
 
    window.images()["FullScreenView"].images()["TopPlayerControls"].buttons()["Done"].tap();
 
    sleep(sleepTime);
    target.tapWithOptions({x:150, y:150});
    sleep(sleepTime);
}

/*test("PiG Mode - Gestures", function(){
     try{
        sleep(sleepTime);
        window.images()["HomeView"].images()["OnNowPanel"].images()["onNowTopMenu"].buttons()["onNowTop"].tap();
        testGestures(window.images()["HomeView"].images()["InfoPanelView"]);
     
        //Repeating tests from on now screen
        window.images()["HomeView"].buttons()["OnNow Option"].tap();
        sleep(sleepTime);
        window.images()["OnNowView"].tableViews()["onNowTable"].cells()[0].tap(); //ET - step 2
        testGestures(window.images()["OnNowView"].images()["InfoPanelView"]);
     
        //Repeating tests from plan ahead screen
        window.images()["OnNowView"].buttons()["PlanAhead Button"].tap();
        sleep(sleepTime);
        target.tapWithOptions({x:460, y:300});//ET - step 2
        testGestures(window.images()["PlanAheadEpgView"].images()["InfoPanelView"]);
     
        window.images()["Top Bar"].buttons()["Home Button"].tap();
     
    }catch(err){
        customFail(err);
    }
});

function testGestures(InfoPanel){
    sleep(sleepTime);
    InfoPanel.buttons()["channel info play btn"].tap();
    while(InfoPanel.activityIndicators()["In progress"].isVisible()){
        debug("Video loading.....");
        sleep(1);
    }
    sleep(sleepTime);
    target.pinchOpenFromToForDuration({x:150,y:300},{x:170, y:320}, 1);
    validateFullscreenVideoPlaying();
    window.images()["FullScreenView"].images()["TopPlayerControls"].buttons()["Done"].tap();
    sleep(sleepTime);
    isVideoBuffering(InfoPanel);
    target.tapWithOptions({x:120, y:280});
    InfoPanel.images()["PlayerControls"].images()["PiGControls"].buttons()["play/pause"].tap();
    target.pinchOpenFromToForDuration({x:150,y:300},{x:170, y:320}, 1);
    validateFullscreenVideoPaused();
    window.images()["FullScreenView"].images()["TopPlayerControls"].buttons()["Done"].tap();
    
    sleep(sleepTime);
    target.tapWithOptions({x:150, y:150})
    
}*/

/*test("PiG Mode - End of catchup show????", function(){
 sleep(sleepTime);
 });
 
 test("PiG Mode - End of live stream????", function(){
 sleep(sleepTime);
 });
 
 test("PiG Mode - End of time-shifted live stream???", function(){
 sleep(sleepTime);
 });*/

/*test("Full Screen Video - Video Overlay displays", function(){
     sleep(sleepTime);
     });

test("Full Screen Video - Done", function(){
     sleep(sleepTime);
     });

test("Full Screen Video - Done when show has changed", function(){
     sleep(sleepTime);
     });

test("Full Screen Video - Play/Pause", function(){
     sleep(sleepTime);
     });

test("Full Screen Video - Rewind", function(){
     sleep(sleepTime);
     });

test("Full Screen Video - Scrub Bar", function(){
     sleep(sleepTime);
     });

test("Full Screen Video - Scrubbing", function(){
     sleep(sleepTime);
     });

test("Full Screen Video - Volume Control", function(){
     sleep(sleepTime);
     });

test("Full Screen Video - Default Volume", function(){
     sleep(sleepTime);
     });

test("Full Screen Video - Gestures", function(){
     sleep(sleepTime);
     });*/
