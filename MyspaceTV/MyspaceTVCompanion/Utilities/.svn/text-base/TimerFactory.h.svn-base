//
// Created by emalethan on 07/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface _BlockRunner : NSObject
- (void)setBlock:(void(^)())block;
-(void) invokeBlock;
@end

@interface TimerFactory : NSObject
-(NSTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;
-(NSTimer *) scheduleWithInterval:(double)interval withBlock:(void (^)())block repeats:(BOOL)yesOrNo;
@end