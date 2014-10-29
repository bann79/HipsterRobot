//
//  InfoObject.h
//  MyspaceTVCompanion
//
//  Created by Bann Al-Jelawi on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoObject : NSObject

/* channel */
@property (strong, nonatomic) NSString *channelTitle;
@property (strong, nonatomic) NSNumber *channelNumber;
@property (strong, nonatomic) NSString *channelIdentURL;

/* programme */
@property (strong, nonatomic) NSString *programTitle;
@property (strong, nonatomic) NSString *programEpisodeSeason;
@property (strong, nonatomic) NSString *programSynopsis;
@property (strong, nonatomic) NSDate *programStart;
@property (strong, nonatomic) NSDate *programEnd;
@property (strong, nonatomic) NSString *programThumbURL;

@end
