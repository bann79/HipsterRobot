//
//  TestUtils.h
//  LisasTestApp
//
//  Created by Lisa Croxford on 01/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OCMock/OCMock.h>
#import <SenTestingKit/SenTestingKit.h>

@interface OCMockRecorder(CaptureCallback) 
-(id)andCaptureCallbackArgument:(void*)callback at:(NSUInteger)index;
@end



@interface TestUtils : NSObject

+(NSData*)loadTestData:(NSString*)name;

+(NSString*)reportDir;
+(void)saveImage:(UIImage*)img forTestCase:(SenTestCase*)testCase named:(NSString*)name;
@end
