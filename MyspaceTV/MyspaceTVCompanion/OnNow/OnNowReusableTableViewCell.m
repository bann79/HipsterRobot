//
//  OnNowReusableTableViewCell.m
//  MyspaceTVCompanion
//
//  Created by Bann Al-Jelawi on 06/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OnNowReusableTableViewCell.h"
#import "UserProfile.h"

#import "EpgModel.h"
#import "CircularImageButton.h"

#import <QuartzCore/QuartzCore.h>

@implementation OnNowReusableTableViewCell {
    NSArray *friendsWatching;
}
@synthesize programDescription;
@synthesize watchButton;
@synthesize watchingView;
@synthesize watchingViewFriends;
@synthesize watchCount;
@synthesize selectionView;
@synthesize progressIndicator;
@synthesize title, image;
@synthesize programStartAndEndTimes,timeRemaining;
@synthesize timeConverter;
@synthesize progressPointer;


+(OnNowReusableTableViewCell*)cellView
{
    OnNowReusableTableViewCell* cell = [[[NSBundle mainBundle] 
                                                loadNibNamed:@"OnNowReusableTableViewCell" 
                                            owner:nil 
                                        options:nil] objectAtIndex:0];
    
    //Position watchingView so that only the watchButton is visible on the left hand side
    CGRect frame = cell.watchingView.frame;
    
    frame.origin.x = cell.frame.size.width - cell.watchButton.frame.size.width;
    cell.watchingView.frame = frame;
        
    [cell addSubview:cell.watchingView];
    
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setHighlighted:(BOOL)highlighted
{
    
    selectionView.alpha  = highlighted ? 1.0f : 0.0f;
    
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if(animated){
        [UIView animateWithDuration:0.5 animations:^{
            selectionView.alpha  = highlighted ? 1.0f : 0.0f;
        }];
    }else{
        selectionView.alpha  = highlighted ? 1.0f : 0.0f;
    }
}
-(void)setProgram:(Programme*)program
{
    _program = program;
    
    timeConverter = [[ProgramTimeConverter alloc]init];
    
    [image lazyLoadImageFromURLString:[program getBestImageForSize:image.bounds.size] contentMode:UIViewContentModeScaleAspectFill];
       
    [title setText: program.name ? program.name : @"Title unavalible"];
    
    [programDescription setText:(program.synopsis && program.synopsis.length>0) ? [self displayProgramDescriptionAndTimes] :[self programUnavailable]];
    
    //[programDescription setL]
    
    [self updateProgramTimeDetails];
}

-(NSString*)programUnavailable
{
    [programStartAndEndTimes setHidden:YES];
    return @"Synopsis unavalible";
}

-(NSString*)displayProgramDescriptionAndTimes
{
    [programStartAndEndTimes setHidden:NO];
    NSString * startTime = [timeConverter convertStartTimeToString:_program.startTime];
    NSString * endTime = [timeConverter convertEndTimeToString:_program.endTime];
    
    NSString * appendedSynposis;
    NSString * startAndEndTimes =  [startTime stringByAppendingString:@" - "];
    startAndEndTimes = [startAndEndTimes stringByAppendingString:endTime];
    NSString * space;
    NSLog(@"legnth %u",[startAndEndTimes length]);
    
    if([startAndEndTimes length] == 17)
    {
        space = @"                                  ";
    }
    else
    {
        space = @"                                 ";
    }
    
    appendedSynposis = [space stringByAppendingString:_program.synopsis];
    
    programStartAndEndTimes.text = startAndEndTimes;
    
    return appendedSynposis;
}



-(void)updateProgramTimeDetails
{
    timeRemaining.text = [timeConverter setTimeRemaining:[NSDate date] andEndTime:_program.endTime];
    
    [self updateProgressIndicator:[NSDate date]];
}

-(void)updateProgressIndicator:(NSDate*)nowTime
{
    NSTimeInterval programLength = [_program.endTime timeIntervalSinceDate:_program.startTime];
    NSTimeInterval elapsed = [nowTime timeIntervalSinceDate:_program.startTime];
    
    NSInteger width = (elapsed * 129) / programLength;
    
    NSLog(@"program: %@ width:%i ",_program.name,width);
    
    if(width < 0)
        //width = 5;
        [progressPointer setHidden:NO];
    
    if (width >= 129) {
        width = 131;
        [progressPointer setHidden:YES];
        progressIndicator.contentMode = UIViewContentModeLeft;
    }else{
        [progressPointer setHidden:YES];
        progressIndicator.contentMode = UIViewContentModeRight;
    }
    progressIndicator.frame = CGRectMake(progressIndicator.frame.origin.x,progressIndicator.frame.origin.y, width,progressIndicator.frame.size.height);
}

-(void)showWatchingAvatars
{
    //NSLog(@"showWatchingAvatars");
    if(friendsWatching.count != watchingViewFriends.subviews.count){
        [self createFriendsWatchingViews];
    }
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:
     ^{
         
         watchingView.transform = CGAffineTransformMakeTranslation(-(watchingView.frame.size.width-watchButton.frame.size.width), 0);
         
         watchingViewFriends.alpha = 1.0f;
         watchingViewFriends.contentOffset = CGPointMake(-25, 0);
         
     } completion:nil];
}

-(void)hideWatchingAvatars
{
    //NSLog(@"hideWatchingAvatars");
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:
     ^{
         watchingView.transform = CGAffineTransformIdentity;
         
         watchingViewFriends.alpha = 0.0f;
         watchingViewFriends.contentOffset = CGPointMake(0, 0);
         
     } completion:nil];
}

-(void)reset
{
    for(UIView *v in watchingViewFriends.subviews)
    {
        [v removeFromSuperview];
    }
    
    watchButton.selected = NO;
    watchingView.transform = CGAffineTransformIdentity;
    watchingViewFriends.alpha = 0.0f;
}

-(void)setWatchingFriends:(NSArray *)friends
{
    
    //Number of friend watchoing changed
    if([friendsWatching count] != [friends count])
    {
        
        //If Watching view is show update views
        if(watchButton.selected){
            [self hideWatchingAvatars];
        }
        
        //Remove existing watching views
        for(UIView *v in watchingViewFriends.subviews){
            [v removeFromSuperview];
        }
    }
    
    [watchButton setEnabled:friends.count != 0];
    
    watchCount.text = [NSString stringWithFormat:@"%u", friends.count];
    friendsWatching = friends;
}

-(void)createFriendsWatchingViews
{
    UIImage *holderImage = [UIImage imageNamed:@"on_now_bar_watch_out_holder.png"];
        
    
    CGPoint avatarPosition = { holderImage.size.width / 2 , holderImage.size.height/2 };
    
    for(UserProfile *friend in friendsWatching)
    {
        
        UIImageView *holder = [[UIImageView alloc] initWithImage:holderImage];
        
        holder.center = avatarPosition;
        [watchingViewFriends addSubview:holder];
        
        CircularImageButton *avatar = [CircularImageButton avatarFrameForUrl:friend.avatarURL];
        
        avatar.center = avatarPosition;
    
        [watchingViewFriends addSubview:avatar];
        
        avatarPosition.x += holderImage.size.width;
    }
    
    NSInteger emptyAvatarsToAdd = 7 - friendsWatching.count;
    while (emptyAvatarsToAdd-- > 0) {
        UIImageView *holder = [[UIImageView alloc] initWithImage:holderImage];
       
        holder.center = avatarPosition;
        
        [watchingViewFriends addSubview:holder];
        
        avatarPosition.x += holderImage.size.width;
    }
    

    watchingViewFriends.contentSize = CGSizeMake(holderImage.size.width * friendsWatching.count, holderImage.size.height);
}
@end
