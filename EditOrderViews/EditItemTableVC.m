//
//  EditItemTableVC.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/26/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "EditItemTableVC.h"
#import "NewEditOrderScreen.h"

#import "Item.h"


@interface EditItemTableVC ()

@end

@implementation EditItemTableVC
@synthesize itemsArray;
@synthesize orderHeaderInfo;
@synthesize orderLines;

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

    NSMutableArray * unsortedNames = [Item getItemsWhere:orderHeaderInfo.CustNum];
    NSArray * sortedNames = [[NSArray alloc] initWithArray:[unsortedNames sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(Item*)a ItemNo];
        NSString *second = [(Item*)b ItemNo];
        return [first compare:second];
    }]];
    
    self.itemsArray = [NSMutableArray arrayWithArray:sortedNames];
    [itemTableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    return self.itemsArray.count;
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
    item = [self.itemsArray objectAtIndex:indexPath.row];
    
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
    Item *tmpItem = [itemsArray objectAtIndex:indexPath.row];
    BOOL new = YES;
    for (int i = 0; i < orderLines.count; i++) {
        OrderLine *tmpOrdLine = [orderLines objectAtIndex:i];
        if ([tmpOrdLine.ItemNo isEqual:tmpItem.ItemNo] && [tmpOrdLine.ProgName isEqual:tmpItem.ProgName]) {
            new = NO;
        }
    }
    
    if (new) {
// commented code was used to limit items to 2 or 3 in order to limit JSON sent back to heartwood. JSON limit has since been dealt with making this obsolete.
//        if (orderLines.count >= 3)
//        {
//            
//            NSString *message = @"Sorry, you can only pick 3 items per order at this time. If you would like to pick more, please start another order and indicate it is supposed to be the same order in the comments.";
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Item Limit Reached"
//                                                            message:message
//                                                           delegate:self
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert setAlertViewStyle:UIAlertViewStyleDefault];
//            [alert show];
//        }
//        else
        {
            
            NewEditOrderScreen *orderScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"newEditOrderScreen"];
            
            orderScreen.itemInfo = [itemsArray objectAtIndex:indexPath.row];
            orderScreen.orderHeaderInfo = orderHeaderInfo;
            [self.navigationController pushViewController:orderScreen animated:YES];
        }
    } else {
        NSString *message = [NSString stringWithFormat:@"You already have picked this item in this order. Please go back to the edit screen and select \"%@\" to Edit", [Item getItemDesc:tmpItem.ItemNo]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already Picked Item"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault]; 
        [alert show];
    }

}


- (IBAction)btnback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end