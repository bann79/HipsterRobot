//
//  EpgModel.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EpgModel.h"

@implementation Thumbnail
@synthesize url;
@synthesize width;
@synthesize height;

- (id)initWithUrl:(NSString *)_url andWidth:(int) _width andHeight:(int) _height
{
    self = [super init];
    if (self) {
        self.url    = _url;
        self.height = _height;
        self.width  = _width;
    }

    return self;
}

@end

@implementation Channel
@synthesize channelNumber;
@synthesize title;
@synthesize description;
@synthesize callSign;
@synthesize thumbnail;
@synthesize liveStreamUrls;


-(NSString *)description
{
    return [NSString stringWithFormat:@"Channel. channelNumber:%@, title:%@, description:%@", channelNumber, title, description];
}

-(BOOL)isEqual:(Channel*)other {
    return [callSign isEqual:other.callSign];
}

@end

@implementation Programme
@synthesize programmeID;
@synthesize name;
@synthesize synopsis;
@synthesize extraInfoUrl;
@synthesize startTime;
@synthesize endTime;
@synthesize images;

-(BOOL)isEqual:(Programme *)other
{
    return [programmeID isEqual:other.programmeID];
}

-(NSString*)getBestImageForSize:(CGSize)size
{
    //Exactly one image
    if([images count] == 1){
        return [(Thumbnail*)[images objectAtIndex:0] url];
    }
    
    if([images count] > 1){
        
        //Try and find one that matches exactly
        for(Thumbnail* thumb in images){
            
            if(thumb.width == size.width && thumb.height == size.height)
                return thumb.url;
        }
        
        //Fall back to the first one
        return [(Thumbnail*)[images objectAtIndex:0] url];
    }
    
    
    
    
    //Mock data
    static NSArray *mockImages = nil;
    if(!mockImages)
    {
        /*mockImages = @[:
                      @"http://static.skynetblogs.be/media/32278/colin_farrell_horrible_bosses_pic.jpg",
                      @"http://static.skynetblogs.be/media/32278/jason_bateman_horrible_bosses_pic.jpg",
                      @"http://forum.divxplanet.com/uploads/imgs_gecici_dizin/393fe4f002d2ecb78279dbf6cf02918c.jpg",
                      @"http://junior.chosun.com/section/img/20120702132707711_1.jpg",
                      @"http://images.wikia.com/paradisa/images/b/b9/New_X-Men_Vol_2_29_Textless-1.jpg",
                      @"http://tour2siam.com/menu_thailand/Ratchaburi_menu.jpg",
                      @"http://www.jasneek.com/images/jasneek_top_bar_final_01.gif",
                      @"http://www.teluguboxoffice.com/Audio/images/veera.jpg",
                      @"http://music.bangaliaana.com/images/header_01.jpg",
                      @"http://www.odcpl.com/web_images/logo_-_national_geographic_kids.jpg"
        ];*/
        
        mockImages = @[
                      @"on-now-temp-alcartaz.png",
                      @"on-now-temp-crub-you-enthusiasm.png",
                      @"on-now-temp-dexter.png",
                      @"on-now-temp-eureka.png",
                      @"on-now-temp-game-of-throne.png",
                      @"on-now-temp-hawaii-5-0.png",
                      @"on-now-temp-how-i-meet-your-mother.png",
                      @"on-now-temp-kim.png",
                      @"on-now-temp-mike-molly.png",
                      @"on-now-temp-samcro.png",
                      @"on-now-temp-sherlock.png",
                      @"on-now-temp-spartacus.png",
                      @"on-now-temp-the-event.png",
                      @"on-now-temp-two-half-men.png",
                      @"on-now-temp-walking-dead.png",
                      @"on-now-temp-wilfred.png",
                      @"on-now-tempbig-bang.png"
        ];
    } 
    
    NSString* image = [mockImages objectAtIndex: rand() % mockImages.count];
    
    images = [NSArray arrayWithObject:[[Thumbnail alloc] initWithUrl:image andWidth:size.width andHeight:size.height]];
     
    return image;
    
}

-(BOOL)isLive
{
    NSDate * currentTime =  [NSDate date];
    return [currentTime compare:startTime] == NSOrderedDescending && 
            [currentTime compare:endTime] == NSOrderedAscending;
}

-(BOOL)isCatchup
{
    NSDate *currentTime =  [NSDate date];
    return [currentTime compare:endTime] == NSOrderedDescending;
}

-(BOOL)isFuture
{
    NSDate *currentTime =  [NSDate date];
    return [currentTime compare:startTime] == NSOrderedAscending;
}

@end
