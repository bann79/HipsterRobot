//
//  EpgDataTransformer.h
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 19/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EpgModel.h"

@interface EpgDataTransformer : NSObject


-(NSDate*)parseDateString:(NSString*)date;

-(NSTimeInterval)parseXMLDurationString:(NSString*)xmlDuration;

-(Channel*)transformChannel:(NSDictionary*)jsonObject;
-(Programme*)transformProgram:(NSDictionary*)jsonObject;

-(StaffMember*)transformStaffMember:(NSDictionary*)jsonObject;
-(ProgramImage*)transformThumbnail:(NSDictionary*)jsonObject;
-(Rating*)transformRating:(NSDictionary*)jsonObject;
-(Advisory*)transformAdvisory:(NSDictionary*)jsonObject;
-(QualityRating*)transformQualityRating:(NSDictionary*)jsonObject;
-(EpisodeInfo*)transformEpisodeInfo:(NSDictionary*)jsonObject;
-(ProgramExtraInfo*)transformExtraInfo:(NSDictionary*)jsonObject;

-(id)nilOrJSONValue:(id)jsonValue;
@end
