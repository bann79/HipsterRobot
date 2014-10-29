//
//  LazyLoadImageViewTest.m
//  MyspaceTVCompanion
//
//  Created by Bann Al-Jelawi on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <OCMock/OCMock.h>
#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "LazyLoadImageView.h"


@interface LazyLoadImageViewTest : SenTestCase
{
    id mockLazyView;
    UIImage *mockDefaultImage;
    LazyLoadImageView *testLazyView;
    id mockril;
}
@end


@implementation LazyLoadImageViewTest

- (void) setUp
{
    [super setUp];
    
    testLazyView = [[LazyLoadImageView alloc] init];
    
    mockril = [OCMockObject niceMockForClass:[RemoteImageLoader class]];
    mockDefaultImage = [UIImage imageNamed:@"on-now-image-preloader.png"];    
    testLazyView.defaultImage = mockDefaultImage;
}

- (void) tearDown
{
    //clear cache manually
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *cacheFiles = [fileManager contentsOfDirectoryAtPath:cacheDirectory error:&error];
    
    for (NSString *file in cacheFiles)
    {
        error = nil;
        [fileManager removeItemAtPath:[cacheDirectory stringByAppendingPathComponent:file] error:&error];
    }
    
    mockril = nil;
    testLazyView = nil;

}

- (void) testThatImageViewIsNotNil
{
    STAssertNotNil(testLazyView, @"LazyLoadImageView does not exist");
}


- (void)testCheckThatURLIsWellFormed
{
    STAssertFalse([testLazyView checkThatURLIsWellFormed:@""], @"url should be well formed");
    
    STAssertFalse([testLazyView checkThatURLIsWellFormed:nil], @"url should be well formed");
    
    STAssertTrue([testLazyView checkThatURLIsWellFormed:@"http://www.google.com"], @"url should be well formed");
    
    STAssertTrue([testLazyView checkThatURLIsWellFormed:@"http://burt"], @"url should be well formed");
    
    STAssertFalse([testLazyView checkThatURLIsWellFormed:@"www.google.com"], @"url should be well formed");
    
    STAssertFalse([testLazyView checkThatURLIsWellFormed:@".google."], @"url should be well formed");
    
    STAssertTrue([testLazyView checkThatURLIsWellFormed:@"http://img1.ovp-cdn.xumo.com/middleware/bbc2.png"], @"url should be well formed");
}


- (void) testDoLazyLoadImagedDoesCallRemoteImageLoader
{
    NSString *imgURL = @"http://www.odcpl.com/web_images/logo_-_national_geographic_kids.jpg";
    
    /*
     testing getRemoteImage which is only called when image does not exist in cache
     */
    //replacing the real ril with our own mock ril for testing purposes
    //mockril = [OCMockObject niceMockForClass:[RemoteImageLoader class]];
    
    //hamcrest: sameInstance - matches the same instance of the object
    [[mockril expect] getRemoteImage:sameInstance(imgURL)];
    
    [testLazyView setRil:mockril];
    
    [testLazyView doLazyLoadImage:imgURL];
    
    [mockril verify];
     
}


- (void) testDoLazyLoadImagedDoesNotCallRemoteImageLoader
{
    NSString *imgURL = @"http://www.odcpl.com/web_images/logo_-_national_geographic_kids.jpg";
    
    //mockril = [OCMockObject niceMockForClass:[RemoteImageLoader class]];
    
    [testLazyView setRil:mockril];
    
    UIImage *img = [UIImage imageNamed:@"lost-connection"];
    
    //andreturn is an explicit return value we set
    [[[mockril stub] andReturn:img] getRemoteImage:sameInstance(imgURL)];
    
    [testLazyView doLazyLoadImage:imgURL];
    
    //test that mockril getRemoteImage is not called
    [[mockril reject] getRemoteImage:sameInstance(imgURL)];
    
    [testLazyView doLazyLoadImage:imgURL];
    
    [mockril verify];
}


- (void) testLazyLoadSetsContentMode
{
    NSString *imgURL = @"http://www.odcpl.com/web_images/logo_-_national_geographic_kids.jpg";
    
    [testLazyView lazyLoadImageFromURLString:imgURL contentMode:UIViewContentModeScaleAspectFill];
    
    STAssertEquals(testLazyView.contentMode, UIViewContentModeScaleAspectFill, @"contentMode should be set to UIViewContentModeScaleAspectFill");
}

- (void) testLazyLoadWithNilURLWillLoadDefaultImage
{
    
    //test that mockril getRemoteImage is not called
    [[mockril reject] getRemoteImage:[OCMArg any]];
    
    [testLazyView lazyLoadImageFromURLString:@"http://wwww.esample.com/image.png" contentMode:UIViewContentModeScaleAspectFill];
    
    [mockril verify];
    
    STAssertEquals(testLazyView.image,mockDefaultImage, @"image should not be nil");     
}

- (void) testLazyLoadWithNoURLWillLoadDefaultImage
{
    //test that mockril getRemoteImage is not called
    [[mockril reject] getRemoteImage:[OCMArg any]];
    
    [testLazyView lazyLoadImageFromURLString:@"http://wwww.esample.com/image.png"  contentMode:UIViewContentModeScaleAspectFill];
    
    [mockril verify];
    
    STAssertEquals(testLazyView.image,mockDefaultImage, @"image should not be nil");     
}

- (void) testLazyLoadWithInvalidURLWillLoadDefaultImage
{
    //test that mockril getRemoteImage is not called
    [[mockril reject] getRemoteImage:[OCMArg any]];
    
    [testLazyView lazyLoadImageFromURLString:@"90r309r80br2cnr8282nc74r89247" contentMode:UIViewContentModeScaleAspectFill];
    
    [mockril verify];
    
    STAssertEquals(testLazyView.image,mockDefaultImage, @"image should not be nil");     
}


@end
