//
//  EpgProgramRenderer.h
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "XMPPClient.h"
#import "URLLoader.h"
#import "EpgModel.h"

static const CGSize EpgCellSize = {900,104};
static const CGSize ProgramImageSize = {88,66};



@interface EpgProgramRenderer : NSObject

@property WatchingApi *watchApi;

@property UIImage *loadingImage;
@property UIImage *line;
@property UIImage *info;
@property UIImage *background;
@property UIImage *background2;
@property UIImage *watch;

@property UIFont *watchFont;
@property UIFont *titleFont;
@property UIFont *synopsisFont;

@property URLLoader *urlLoader;

@property NSOperationQueue *opQueue;

+(EpgProgramRenderer*) sharedRenderer;

-(BOOL)shouldDisplaySynposisForProgram:(Programme*)program;
-(BOOL)shouldDisplayProgramImageForProgram:(Programme*)program;

-(UIImage*)getLoadingImage;

-(UIImage*)renderPrograms:(NSArray*)programData              
               beginingAt:(NSDate *)startTime 
                 endingAt:(NSDate *)endTime
            programImages:(NSDictionary*)programImages;

-(NSOperation*)renderPrograms:(NSArray*)programData
                   beginingAt:(NSDate*)startTime 
                     endingAt:(NSDate*)endTime 
                    andCall:(void (^)(UIImage*))cb;
@end
