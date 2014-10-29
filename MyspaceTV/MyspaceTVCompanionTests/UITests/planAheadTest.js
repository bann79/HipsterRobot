#import "tuneup/tuneup.js"

/**
	UI Testing for MSCOMP-807 Plan Ahead - EPG
 
	Story: 
        As a user 
        I want an EPG 
        So that I can easily see what is on both now and in the future in a familiar way 
*/
var sleepTime=7;

function dateString(d)
{
	var day = d.getDate();
	if(day < 10){
		day = "0" + day;
	}
	
	var month = d.getMonth() + 1;
	if(month < 10){
		month = "0" + month;
	}
	
	return day + "-" + month + "-" + d.getFullYear();
}

function dayName(d)
{
	switch(d.getDay())
	{
		case 0: return "Sun";
		case 1: return "Mon";
		case 2: return "Tue";
		case 3: return "Wed";
		case 4: return "Thu";
		case 5: return "Fri";
		case 6: return "Sat";
	}	   
}


/**
Given I have pressed a sub-category from the Plan Ahead summary page
When the EPG loads
Then the EPG should be presented with the heatmap reflecting the sub-category selected
And should show:
Day/Time I'm viewing
*/ 

test("On the home screen I can goto the EPG",function(){
     sleep(sleepTime);
	 window.images()["HomeView"].buttons()["PlanAhead Option"].tap();
});

test("I am viewing the EPG",function(){
     sleep(sleepTime);
     assertNotNull(window.images()["PlanAheadEpgView"].scrollViews()["EPG Grid"], "Epg Grid present");
     
     var actionRingView = window.images()["PlanAheadEpgView"].elements()["Action Ring View"];
     
     assertNotNull(actionRingView, "Action Ring present");
     
     assertNotNull(actionRingView.staticTexts()["Day Label"], "Day label present");
	 assertNotNull(actionRingView.staticTexts()["Date Label"], "Date label present");
	 
	 assertNotNull(window.images()["PlanAheadEpgView"].scrollViews()["Top Timeline"], "Top Timeline present");
	 assertNotNull(window.images()["PlanAheadEpgView"].scrollViews()["Bottom Timeline"], "Bottom Timeline present");
	 
	 var epgCells = window.images()["PlanAheadEpgView"].scrollViews()["EPG Grid"].images();
	 if(epgCells.length == 0){
	 	fail("No EPG cells");
	 }
});

					
/*					
	Given The EPG is open
	When I hold down and drag on the EPG
	Then the EPG should move in line with the movements
	And I can navigate back and forwards 1week
	And I can navigate up and down to the start and end of the channels
*/


test("I Can navigate back 5 days",function(){
     sleep(sleepTime);
     var weekInPastDateString = dateString(new Date(new Date().valueOf() - (5 * 24 * 60 * 60 * 1000)));
     var swipes = 0;
     
     while(window.images()["PlanAheadEpgView"].elements()["Action Ring View"].staticTexts()["Date Label"].value() != weekInPastDateString)
     {
        window.images()["PlanAheadEpgView"].scrollViews()["EPG Grid"].scrollLeft();
        sleep(0.2);
        if(swipes++ > 1000) fail("Timeout trying to reach date");
     }
     
     sleep(2);
});

test("I Can navigate forwards 5 days",function(){
     sleep(sleepTime);
     var weekInFutureDateString = dateString(new Date(new Date().valueOf() + (5 * 24 * 60 * 60 * 1000)));
     var swipes = 0;
     
     while(window.images()["PlanAheadEpgView"].elements()["Action Ring View"].staticTexts()["Date Label"].value() != weekInFutureDateString)
     {
        window.images()["PlanAheadEpgView"].scrollViews()["EPG Grid"].scrollRight();
        sleep(0.2);
        if(swipes++ > 1000) fail("Timeout trying to reach date");
     }
     
     sleep(2);
});

test("I can use the EPG Day Changer to choose a day", function(){
    sleep(sleepTime);
    var actionRingView = window.images()["PlanAheadEpgView"].images()["Action Ring View"];
	for(var i = -5; i < 5; i++)
	{
		actionRingView.buttons()["Day Changer Button"].tap();
	 
	 	var targetDay = new Date(new Date().valueOf() + (i * 24 * 60 * 60 * 1000));
	 
        var wheel = window.images()["PlanAheadEpgView"].pickers()[0].wheels()[0];
        var value = wheel.values()[i+5];
     
        debug("Selecting day picker value: " + value);
        screenshot("Selecting day picker value: " + value);
     
        wheel.selectValue(value);
        wheel.tap();
	 
	 	sleep(2);
	 
		assertEquals(dateString(targetDay),  actionRingView.staticTexts()["Date Label"].value());
		assertEquals(dayName(targetDay), actionRingView.staticTexts()["Day Label"].value());
     
        screenshot("Viewing: " + value);
	} 
});

/*
Scenario 3: Selecting a show
	Given The EPG is open
	When I press on a show
	Then this will take me to the info page for that show
*/
test("I can view program information by selecting an EPG program",function(){
	 
     sleep(sleepTime);
	 window.images()["PlanAheadEpgView"].scrollViews()["EPG Grid"].images()[3].tap();
     
     target.delay(5);
});
