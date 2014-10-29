//
//  ViewController.h
//  bee
//
//  Created by Bann Al-Jelawi on 27/10/2014.
//  Copyright (c) 2014 bann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(strong,nonatomic) IBOutlet UITableView *beeTableView;
@property(strong,nonatomic) IBOutlet UIButton *dealDamageBtn;

@property(strong,nonatomic) NSMutableArray *beeArray;

-(IBAction)doDamage:(id)sender;

@end
