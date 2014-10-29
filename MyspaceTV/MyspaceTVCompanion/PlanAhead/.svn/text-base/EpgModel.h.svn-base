//
//  EpgModel.h
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 13/06/2012.
//  Copyright (c) 2012 Xumo. All rights reserved.
//

#import "ProgramExtraInfo.h"

@interface Thumbnail : NSObject

@property(nonatomic, copy) NSString *url;
@property int width;
@property int height;

- (id)initWithUrl:(NSString *)url andWidth:(int)width andHeight:(int)height;

@end

@interface  Channel : NSObject 
@property(nonatomic, copy) NSString *callSign;
@property(nonatomic, copy) NSNumber *channelNumber;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, strong) Thumbnail *thumbnail;
@property(nonatomic, copy) NSArray *liveStreamUrls;

-(BOOL)isEqual:(Channel*)other;
@end

@interface Programme : NSObject
@property(nonatomic, copy) NSString *programmeID;         // GUID
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *synopsis;
@property(nonatomic, copy) NSString *extraInfoUrl;

@property(nonatomic, copy) NSDate *startTime;
@property(nonatomic, copy) NSDate *endTime;

@property(nonatomic,strong) NSArray *images;

-(NSString*)getBestImageForSize:(CGSize)size;

-(BOOL)isEqual:(Programme*)other;

-(BOOL)isLive;    //Its on now
-(BOOL)isCatchup; //Its in the past
-(BOOL)isFuture;  //Not on yet
@end
