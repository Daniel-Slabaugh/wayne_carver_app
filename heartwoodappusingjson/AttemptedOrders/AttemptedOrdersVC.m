//
//  ItemTableVC.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/16/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "AttemptedOrdersVC.h"

#import "EditingTableVC.h"

#define ATTEMPT     @"Attempted"
#define GMATTEMPT   @"GMAttempted"

@interface AttemptedOrdersVC ()

@end

@implementation AttemptedOrdersVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    return 2;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"ItemCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        else
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    if(indexPath.row == 0)
    {
        cell.textLabel.text = @"NAME PROGRAM ORDERS";
    } else if(indexPath.row == 1) {
        cell.textLabel.text = @"GENERAL MERCHANDISE ORDERS";
    }
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iPhone 3.2 or later.
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [cell.detailTextLabel setMinimumScaleFactor:.5];
        [cell.detailTextLabel setAdjustsFontSizeToFitWidth:YES];
    }
    else
    {
        // The device is an iPhone or iPod touch.
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0)
    {
        EditingTableVC *editView = [self.storyboard instantiateViewControllerWithIdentifier:@"editingTable"];
        editView.status = ATTEMPT;
        [self.navigationController pushViewController:editView animated:YES];
    
    } else if(indexPath.row == 1) {
        EditingTableVC *editView = [self.storyboard instantiateViewControllerWithIdentifier:@"editingTable"];
        editView.status = GMATTEMPT;
        [self.navigationController pushViewController:editView animated:YES];    }
    
}


- (IBAction)btnback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
