//
//  LostConnectionIndicatorViewController.h
//  MyspaceTVCompanion
//
//  Created by Bann Al-Jelawi on 03/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LostConnectionIndicatorViewController : UIViewController {
}

@property (strong, nonatomic) IBOutlet UIImageView *failImage;
//@property (strong, nonatomic) IBOutlet UILabel *failMessage;
@property (strong, nonatomic) IBOutlet UIButton *okBtn;

-(IBAction)didClickOK:(id)sender;

@end
