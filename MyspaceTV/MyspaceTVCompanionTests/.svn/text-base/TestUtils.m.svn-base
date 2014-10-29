//
//  TestUtils.m
//  LisasTestApp
//
//  Created by Lisa Croxford on 01/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "TestUtils.h"



@implementation OCMockRecorder(CaptureCallback)
-(id)andCaptureCallbackArgument:(void*)callback at:(NSUInteger)index
{
    return [self andDo:^(NSInvocation *i) {
        void* cb = NULL;
        [i getArgument:&cb atIndex:index];
        *((void**)callback) = Block_copy(cb);
    }];
}
@end

@implementation TestUtils


+(NSData*)loadTestData:(NSString*)name {
    NSString* fileName = [NSString stringWithFormat:@"%@/testdata/%@",
                          [[NSBundle bundleForClass:[TestUtils class]] bundlePath],
                          name];
    
    NSLog(@"Loading test data file %@", fileName);
    
    NSData* data = [NSData dataWithContentsOfFile:fileName];
    
    if(!data){
        NSLog(@"Could not load data for %@",name);
        assert(false);
    }
    return data; 
}

+(NSString*)reportDir
{
    //Change this line if we move this file or the test-reports dir
    NSString* reportDir = [[@__FILE__ stringByAppendingString:@"/../../test-reports"] stringByStandardizingPath];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:reportDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    return reportDir;
}

+(void)saveImage:(UIImage*)img forTestCase:(SenTestCase*)testCase named:(NSString*)name
{
    
    NSString *testName = [testCase.name substringFromIndex:2];
    testName = [testName substringToIndex:testName.length - 1];
    
    NSString *resultDir = [TestUtils reportDir];
    NSString *filename = [NSString stringWithFormat:@"%@/%@_%@.png",resultDir, testName, name];

    [UIImagePNGRepresentation(img) writeToFile:filename atomically:NO];
    
    NSLog(@"Saved image object %@ as %@",name,filename);
}

@end
