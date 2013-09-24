//
//  OnNowReusableTableViewCellTest.m
//  MyspaceTVCompanion
//
//  Created by Bann Al-Jelawi on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <SenTestingKit/SenTestingKit.h>
#import "AssertEventually.h"

#import "EpgApi.h"
#import "OnNowReusableTableViewCell.h"


@interface OnNowReusableTableViewCellTest : SenTestCase
{
    NSArray* mockChannelData;
    OnNowReusableTableViewCell* cell;
}
@end


@implementation OnNowReusableTableViewCellTest

- (void) setUp
{
    cell = [OnNowReusableTableViewCell cellView];
}

- (void) tearDown
{
    cell = nil;
}


- (void) testOutletsCreated
{
    STAssertNotNil(cell, @"Cell does not exist");

    STAssertNotNil(cell.title, @"Title should exist");
    STAssertNotNil(cell.description , @"Description should exist");
    STAssertNotNil(cell.image, @"Image should exist - if not available from server should be replaced with default but should never be nil");
}


-(void)testSetProgramUpdatesFeilds
{
    Programme *p = [[Programme alloc] init];
    
    p.name = @"name";
    p.synopsis = @"                     description";
    
    [cell setProgram:p];

    STAssertEqualObjects(cell.title.text, p.name,@"title feild set correctly");
   // STAssertEqualObjects(cell.programDescription.text, p.synopsis,@"Synposis feild set correctly");
}


- (void) testThatIfNoImageAvailableReplaceWithDefault
{
    //this is possibly something for the view controller/model to worry about - before we get to populating the cell - if so
    //this test should be in the viewcontroller or model
    
    /*
     - use mockobject to simulate channel array where no image is specified to download
     - in the case the test shouldn't fail but switch to using a default image available locally
     **/
}

@end
