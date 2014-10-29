#import "tuneup/tuneup.js"

/*
    exampleTest.js
 
    Just some tests to try out UIAutomation with tuneup
 
*/


test("Goto OnNow and back", function(target,app){
     target.delay(7);

     app.mainWindow().images()["HomeView"].buttons()["OnNow Option"].tap();
     
     target.delay(5);
     
     app.mainWindow().images()["Top Bar"].buttons()["Home Button"].tap();
});