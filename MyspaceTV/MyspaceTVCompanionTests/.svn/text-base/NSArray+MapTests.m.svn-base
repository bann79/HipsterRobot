
//
//  NSArrayUtilsTests.m
//  MyspaceTVCompanion
//
//  Created by Dyfan Hughes on 17/06/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <SenTestingKit/SenTestingKit.h>

#import "NSArray+Map.h"

@interface NSArrayMapTests : SenTestCase
@end




@implementation NSArrayMapTests


-(void)testStringTransformsWithBlock
{
    
    NSArray* colours = [NSArray arrayWithObjects:@"red",@"green",@"blue", nil];
    
    __block int timesExecuted = 0;
    
    NSArray* uppercaseColors = [colours mapWithBlock:^id(id c) {
       
        timesExecuted ++;
        return [c uppercaseString];
        
    }];
    
    STAssertEquals(timesExecuted, 3, @"Executed block 3 times");
    
    
    STAssertEquals((int)[uppercaseColors count], (int)3,@"3 Elements in returned array");
    STAssertTrue([[uppercaseColors objectAtIndex:0] isEqual:@"RED"], @"RED");
    STAssertTrue([[uppercaseColors objectAtIndex:1] isEqual:@"GREEN"], @"GREEN");
    STAssertTrue([[uppercaseColors objectAtIndex:2] isEqual:@"BLUE"], @"BLUE");
    
}

-(void)testDoesNoIterateOnNilWithBlock
{
    
    NSArray* emptyArray = [NSArray array];
    
    NSArray* result = [emptyArray mapWithBlock:^id(id obj) {
        STFail(@"Should not be called");
        return nil;
    }];
    
    STAssertEquals((int)[result count],0,@"result emopty array");
}

-(NSString*)transform:(NSString*)c
{
    return [c uppercaseString];
}

-(void)testStringTransformsWithSelector
{
    
    NSArray* colours = [NSArray arrayWithObjects:@"red",@"green",@"blue", nil];
    
    
    NSArray* uppercaseColors = [colours mapWithSelector:@selector(transform:) target:self];        
    
    STAssertEquals((int)[uppercaseColors count], (int)3,@"3 Elements in returned array");
    STAssertTrue([[uppercaseColors objectAtIndex:0] isEqual:@"RED"], @"RED");
    STAssertTrue([[uppercaseColors objectAtIndex:1] isEqual:@"GREEN"], @"GREEN");
    STAssertTrue([[uppercaseColors objectAtIndex:2] isEqual:@"BLUE"], @"BLUE");
    
}

-(NSString*)shouldnotBeCalled:(NSString*)s
{
    STFail(@"Should not be called");
    return nil;
}

-(void)testDoesNoIterateOneptyArrayWithSelector
{
    
    NSArray* emptyArray = [NSArray array];
    NSArray* result = [emptyArray mapWithSelector:@selector(shouldnotBeCalled:) target:self];    
    STAssertEquals((int)[result count], 0,@"Result is empty array");
}




@end