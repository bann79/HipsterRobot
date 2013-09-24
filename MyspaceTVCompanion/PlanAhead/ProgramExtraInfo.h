//
//  ProgramExtraInfo.h
//  MyspaceTVCompanion
//
//  Created by Jason Zong on 12/06/2012.
//  Copyright (c) 2012 Specific Media. All rights reserved.
//

#import <Foundation/Foundation.h>

//extra information.
@interface StaffMember : NSObject
@property(strong) NSString *role,
                           *firstname,
                           *lastname;
@end

@interface EpisodeInfo : NSObject
@property int season, number;

@property(strong) NSString *episodes,
                           *episodeTitle;
@end

@interface ProgramImage : NSObject
@property int width;
@property int height;
@property bool primary;
@property(strong) NSString *link,
                           *type,
                           *category,
                           *uri,
                           *caption,
                           *provider,
                           *crediLine,
                           *objectIDString;
@end

@interface Rating : NSObject
@property(strong) NSString *warning,
                           *area,
                           *code,
                           *description,
                           *ratingsBody;
@end

@interface Advisory : NSObject
@property(strong) NSString *value,
                           *ratingsBody;
@end

@interface QualityRating : NSObject
@property(strong) NSString *ratingsBody;
@property float value;
@property int   numVotes;
@end

@interface ProgramRatings :  NSObject 
@property(strong) NSArray *ratings,
                           *advisories,
                           *qualityRatings;
@end

@interface ProgramExtraInfo : NSObject
@property(strong) EpisodeInfo *episodeInfo;
@property(strong) ProgramRatings *ratings;
@property NSTimeInterval runtime;
@property(strong) NSArray *cast, 
                          *crew,
                          *countries,
                          *genres,
                          *images;
@property(strong) NSString *extendedSynopsis,
                           *programmeType,
                           *origAudioLang;
@property(strong) NSDate  *origAirDate;
@end

