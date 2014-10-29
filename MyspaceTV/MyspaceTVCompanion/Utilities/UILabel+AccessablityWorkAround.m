//
//  UILabel+AccessablityWorkAround.m
//  MyspaceTVCompanion
//
//  Created by Lisa Croxford on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UILabel+AccessablityWorkAround.h"

@implementation UILabel (AccessibilityFix)
-(NSString *)accessibilityValue {
    // Here we force UIKit to return Label value, not the accessibility label 
    return self.text;
}
@end
