//
//  ViewController.m
//  bee
//
//  Created by Bann Al-Jelawi on 27/10/2014.
//  Copyright (c) 2014 bann. All rights reserved.
//

#import "ViewController.h"
#import "Worker.h"
#import "Drone.h"
#import "Queen.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setupBees];
}

-(void)setupBees
{
    _beeArray = [[NSMutableArray alloc] init];
    
    //create array of 10 bees for each of the 3 bee types
    for(int i=0; i<10; i++)
    {
        Worker *wBee = [[Worker alloc] init];
        Drone *dBee = [[Drone alloc] init];
        Queen *qBee = [[Queen alloc] init];
        
        [_beeArray addObject:wBee];
        [_beeArray addObject:dBee];
        [_beeArray addObject:qBee];
    }
}

-(IBAction)doDamage:(id)sender
{
    //for each bee object in row call its damage method passing random damage value
    for(int i=0; i<_beeArray.count; i++)
    {
        NSUInteger r = arc4random_uniform(80);
        NSLog(@"hit + %i", r);
        [[_beeArray objectAtIndex:i] damage:r];
    }
    
    //now refresh tableview
    [_beeTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_beeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
    cell.textLabel.text = [NSString stringWithFormat:@"Type: %@ | Health: %.2f| Status: %@",  [[_beeArray objectAtIndex:indexPath.row] getType], [[_beeArray objectAtIndex:indexPath.row] getCurrentHealth], [[_beeArray objectAtIndex:indexPath.row] getCurrentStatus]];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
