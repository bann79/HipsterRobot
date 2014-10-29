//
//  InfoPageViewControllerTest.m
//  MyspaceTVCompanion
//
//  Created by Dyfan Hughes on 26/06/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <SenTestingKit/SenTestingKit.h>
#import "InfoPageViewController.h"
#import "MyspaceApi.h"

#import "TestUtils.h"
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface InfoPageViewControllerTest : SenTestCase
{
    @private InfoPageViewController * infoPageController;
   }
@end

@implementation InfoPageViewControllerTest
{
    id mockApi;
    
    void (^callback)(ProgramExtraInfo *, NSError *error);
}

-(void)setUp
{
    infoPageController = [[InfoPageViewController alloc] init];
    mockApi = [OCMockObject niceMockForClass:[EpgApi class]];
    
    callback = nil;
}

-(void)tearDown
{
    infoPageController = nil;
}

-(void)stubGetExtroInfoCallback:(NSString *)requestPath
{
    [[[mockApi expect] andCaptureCallbackArgument:&callback at:3]
                                   getExtraInfo:(NSString *)endsWith(requestPath)
                                       andCall:[OCMArg any]
                                 ];
}
@end
