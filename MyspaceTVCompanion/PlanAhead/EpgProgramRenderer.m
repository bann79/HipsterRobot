//
//  EpgProgramRenderer.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EpgProgramRenderer.h"
#import "EpgApi.h"
#import <QuartzCore/QuartzCore.h>

#import "UILabel+VerticleAlign.h"

#import "DDLog.h"
static const int ddLogLevel = LOG_LEVEL_INFO;


@implementation EpgProgramRenderer

static EpgProgramRenderer* instance = nil;  

- (id)init
{  
    _background          = [UIImage imageNamed:@"plan_ahead_bar_bkgd.png"];
    _background2         = [UIImage imageNamed:@"plan_ahead_bar_bkgd2.png"];
    _line                = [UIImage imageNamed:@"plan_ahead_bar_line.png"];
    _watch               = [UIImage imageNamed:@"plan_ahead_watching_icon.png"];
    _info                = [UIImage imageNamed:@"info-icon"];
    
    _watchFont           = [UIFont boldSystemFontOfSize:12];
    _titleFont           = [UIFont boldSystemFontOfSize:13];
    _synopsisFont        = [UIFont systemFontOfSize:13];
    
    
    _opQueue             = [[NSOperationQueue alloc] init];
    [_opQueue setName:@"EPG Renderer"];
    
    _urlLoader           = [[URLLoader alloc] init];
    _urlLoader.queue     = _opQueue;
    
    _watchApi            = [XMPPClient sharedInstance].watchingApi;
    
    return self;
}

+(EpgProgramRenderer*) sharedRenderer
{ 
    if(instance == nil){
        instance = [[EpgProgramRenderer alloc] init];
    }
    return instance;
}

+(void)setSharedRenderer:(EpgProgramRenderer*)renderer
{
    instance = renderer;
}


-(UIImage*)getLoadingImage
{
    if(_loadingImage == nil){
        
        UIGraphicsBeginImageContextWithOptions(EpgCellSize,NO, [[UIScreen mainScreen] scale]);
        
        Programme* fake = [Programme alloc];
        fake.startTime = [NSDate date];
        fake.endTime = [NSDate dateWithTimeIntervalSinceNow:60 * 60];
        fake.name = @"Loading...";
        fake.synopsis = @"Loading...";
        
        int w = EpgCellSize.width/3;
        
        [self renderProgram:fake inFrame:CGRectMake(0, 0, w, EpgCellSize.height) withProgramImage:nil];
        
        [self renderProgram:fake inFrame:CGRectMake(w, 0, w, EpgCellSize.height) withProgramImage:nil];
        
        [self renderProgram:fake inFrame:CGRectMake(w * 2, 0, w, EpgCellSize.height) withProgramImage:nil];
        
        _loadingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _loadingImage;
}


-(BOOL)shouldDisplaySynposisForProgram:(Programme *)program
{
    NSTimeInterval duration = [program.endTime timeIntervalSinceDate:program.startTime];
    return duration >= 15 * 60;
}

-(BOOL)shouldDisplayProgramImageForProgram:(Programme *)p
{
    NSTimeInterval duration = [p.endTime timeIntervalSinceDate:p.startTime];
    if( duration < 45 * 60)
       return NO;
    
    NSInteger w =  (EpgCellSize.width * duration) / (3 * 3600);
    w -= ProgramImageSize.width + 15;
    
    
    if(w < 0)
        return NO;

    CGSize size = [p.synopsis sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(w,500)];
    return size.height < 45;
}


-(void)renderProgram:(Programme *)p inFrame:(CGRect)rect withProgramImage:(UIImage*)programImage
{
    CGContextSaveGState(UIGraphicsGetCurrentContext());
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), rect.origin.x, rect.origin.y);
    
    int numOfWatching = [_watchApi numberOfFriendsWatchingProgram:p.programmeID];
    
    NSString* name       = [p.name length] != 0 ? p.name : @"Title unavailable";
    NSString* synopsis   = [p.synopsis length] != 0 ? p.synopsis : @"Synopsis unavailable";
        
    CGRect backgroundRect = {{0,0},{rect.size.width,_background.size.height}};
    
    CGRect synopsisTextArea = CGRectMake(7, 35, rect.size.width-15, 25);
    CGRect titleTextArea    = CGRectMake(7, 7,  rect.size.width-10, 15);
    
    if(numOfWatching == 0)
        synopsisTextArea.size.height = 45;

    if(programImage)
        synopsisTextArea.size.width -= ProgramImageSize.width;
    
    /*
        Lisa:
     
        I dont understand exactly why we need to sychronise this block of code but it 
        crashes if we dont, I think while it is safe to render from a background queue 
        it is not safe to use the same UIimages and UIfonts for rendering on multiple 
        threads simultaniously.
    */
    @synchronized(self)
    {
        if(![self shouldDisplaySynposisForProgram:p])
        {
            [_background2 drawAsPatternInRect:backgroundRect];
            
            [_info drawAtPoint:CGPointMake(7, 7)];
            
        }else{
            if (numOfWatching > 0) {
                
                [_background drawAsPatternInRect:backgroundRect];
                [_watch drawAtPoint:CGPointMake(15, 63)];
                
                
                NSString* numWatcherTxt = [NSString stringWithFormat: @"%d", numOfWatching];;
                
                [[UIColor whiteColor] setFill];
                [numWatcherTxt drawInRect:CGRectMake(41, 74, 15,20)
                                 withFont:_watchFont
                            lineBreakMode:UILineBreakModeClip
                                alignment:UITextAlignmentCenter];
                
            }else {
                [_background2 drawAsPatternInRect:backgroundRect];
            }
            
            [[UIColor whiteColor] setFill];
            [name drawInRect:titleTextArea withFont:_titleFont lineBreakMode:UILineBreakModeTailTruncation];
            [synopsis drawInRect:synopsisTextArea withFont:_synopsisFont lineBreakMode:UILineBreakModeTailTruncation];
            
            if(programImage)
            {
                [programImage drawInRect:(CGRect){
                    {(rect.size.width - ProgramImageSize.width) -1, 32},
                    ProgramImageSize
                }];
            }
        }
        
        [_line drawAtPoint:CGPointMake(-3,2)];
    }
    
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

-(NSInteger) getXForDate:(NSDate*)d startingAt:(NSDate*)startTime endingAt:(NSDate*)endTime
{   
    return  (EpgCellSize.width * [d timeIntervalSinceDate: startTime]) / 
    [endTime timeIntervalSinceDate: startTime];
}


-(UIImage*)renderPrograms:(NSArray*)programData              
                   beginingAt:(NSDate *)startTime 
                     endingAt:(NSDate *)endTime                programImages:(NSDictionary *)programImages
{
    UIGraphicsBeginImageContextWithOptions(EpgCellSize,NO,[[UIScreen mainScreen] scale]);
    
    
    [[UIColor whiteColor] setFill];

    for(Programme *p in programData){
        NSInteger x1 = [self getXForDate:p.startTime startingAt:startTime endingAt:endTime];
        NSInteger x2 = [self getXForDate:p.endTime startingAt:startTime endingAt:endTime];
        
        CGRect frame = CGRectMake(x1, 0, x2-x1, EpgCellSize.height);
        
        UIImage* image = [programImages objectForKey:p.programmeID];
        [self renderProgram:p inFrame:frame withProgramImage:image];
    }
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(NSOperation*)renderPrograms:(NSArray*)programData
                   beginingAt:(NSDate *)startTime
                     endingAt:(NSDate *)endTime
                      andCall:(void (^)(UIImage*))cb
{
    //Maintain a map of program images to program ids
    __block NSMutableDictionary* programImages = [[NSMutableDictionary alloc] init];
    
    void (^renderBlock)(void) = ^{
        UIImage* image = [self renderPrograms:programData beginingAt:startTime endingAt:endTime programImages:programImages];
        
        [[NSOperationQueue mainQueue]
            addOperationWithBlock:^{cb(image);}];
    };
    
    __block int imagesWillFetch = 0;
    __block int imagesFetched   = 0;
    
    // See if we need to load any images for these programs and then load them asycronously
    for(Programme* p in programData)
    {
        if([self shouldDisplayProgramImageForProgram:p])
        {
            imagesWillFetch++;
            
            
            NSString* url = [p getBestImageForSize:ProgramImageSize];
            
            UIImage* placeHolder = [UIImage imageNamed:@"epg-image-preloader"];
            
            if(![[url substringToIndex:4] isEqualToString:@"http"])
            {
                placeHolder = [UIImage imageNamed:url];
            }else{
            [_urlLoader loadUrl:url withAcceptType:nil andCalls:
             ^(NSURLResponse *response, NSData *data, NSError *error) {
                 
                 imagesFetched++;
                 
                 if(error){
                     DDLogError(@"Error loading program image for %@", p.name);
                     return;
                 }
                 
                 UIImage* programImage = [UIImage imageWithData:data];
                 if(programImage)
                     [programImages setObject:programImage forKey:p.programmeID];
                 
                 // We fetched all the program images we need to redraw
                 if(imagesFetched == imagesWillFetch)
                     [_opQueue addOperationWithBlock:renderBlock];
             }];
            }
            
            
            [programImages setObject:placeHolder forKey:p.programmeID];
            
        }
    }
    
    NSBlockOperation* op = [NSBlockOperation blockOperationWithBlock:renderBlock];
    [_opQueue addOperation:op];
    return op;
}


@end
