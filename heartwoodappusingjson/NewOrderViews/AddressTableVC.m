//
//  AddressTableVC.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 12/14/18.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "AddressTableVC.h"
#import "Item.h"

#import "OrderScreenVC.h"

@interface AddressTableVC ()

@end

@implementation AddressTableVC
@synthesize addressArray;
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
    
    NSMutableArray * unsortedStores = [Address getAddressesWhere:customerInfo.CustNum];
    NSArray * sortedStores = [[NSArray alloc] initWithArray:[unsortedStores sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(Address*)a StoreID];
        NSString *second = [(Address*)b StoreID];
        return [first compare:second];
    }]];
    self.addressArray = [NSMutableArray arrayWithArray:sortedStores];
    [itemTableView reloadData];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    return self.addressArray.count;
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
    
    
    Item * item = nil;
    item = [self.addressArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", item.ItemNo, item.Description];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", item.MAD];
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
    OrderScreenVC *orderScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"orderScreen"];
    orderScreen.itemInfo = [addressArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:orderScreen animated:YES];
    
}


- (IBAction)btnback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
