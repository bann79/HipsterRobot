//
// Created by emalethan on 07/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TimerFactory.h"

@implementation _BlockRunner
{
@private
    void (^_block)();

}
- (void)setBlock:(void(^)())block
{
    _block = block;
}

- (void)invokeBlock
{
    _block();
}

@end

@implementation TimerFactory
{

}
-(NSTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo
{
    return [NSTimer scheduledTimerWithTimeInterval:interval
                                            target:aTarget
                                          selector:aSelector
                                          userInfo:userInfo
                                           repeats:yesOrNo];
}

-(NSTimer *) scheduleWithInterval:(double)interval withBlock:(void (^)())block repeats:(BOOL)yesOrNo
{
    _BlockRunner *blockRunner = [[_BlockRunner alloc] init];

    [blockRunner setBlock:[block copy]];

    return [NSTimer scheduledTimerWithTimeInterval:interval
                                            target:blockRunner
                                          selector:@selector(invokeBlock)
                                          userInfo:nil
                                           repeats:yesOrNo];

}


@end