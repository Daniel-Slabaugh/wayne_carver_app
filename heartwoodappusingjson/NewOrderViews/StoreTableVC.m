//
//  StoreTableVC.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/5/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "StoreTableVC.h"
#warning changed
#import "Store.h"

#import "ItemTableVC.h"

@interface StoreTableVC ()

@end

@implementation StoreTableVC
@synthesize storesArray;
@synthesize customerInfo;

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
    
    self.storesArray = [[NSMutableArray alloc] init];
    self.storesArray = [Store getStoresWhere:customerInfo.CustNum];
    if (self.storesArray.count == 0) {
        Store *temp = [[Store alloc] init];
        temp.StoreID = @"No Records";
        [self.storesArray addObject:temp];
            UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"No Stores" message:@"No stores with name programs for this customer..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    }
    [storeTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    return self.storesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"UserCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Store * store = nil;
    store = [self.storesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", store.StoreID];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iPhone 3.2 or later.
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:20]];
    }
    else
    {
        // The device is an iPhone or iPod touch.
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setNumberOfLines:2];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemTableVC *itemTableView = [self.storyboard instantiateViewControllerWithIdentifier:@"itemTable"];
    itemTableView.storeInfo = [storesArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:itemTableView animated:YES];
}


- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
