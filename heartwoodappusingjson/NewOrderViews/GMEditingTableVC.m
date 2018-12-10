//
//  GMEditingTableVC.m
//  wayne mobile
//
//  Created by Delphi Dev Computer on 7/24/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import "GMEditingTableVC.h"
#import "User.h"
#import "GMOrderHeader.h"
#import "Customer.h"
#import "GMOrderOverviewVC.h"
#import "WCPDFViewController.h"

#define START  @"Started"
#define EDIT  @"Edited"
#define GMPOST  @"GMPosted"

@interface GMEditingTableVC ()

@end

@implementation GMEditingTableVC
@synthesize ordersArray;
@synthesize NoOrders;
@synthesize status;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ordersArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *orders = [GMOrderHeader getAllOrderHeaders];
    
    //status = post means it's in iPad order history not editing
    if ([status isEqual:GMPOST]) {
        for (GMOrderHeader *order in orders) {
            if ([order.LocalStatus isEqual:GMPOST])
                [self.ordersArray addObject:order];
        }
        
    } else {
        
        for (GMOrderHeader *order in orders) {
            // stored orders that haven't been submitted
            if ([order.LocalStatus isEqualToString:EDIT] || [order.LocalStatus isEqualToString:START])
            {
                // only include the order in the list if the correct user is signed in
                NSMutableArray * usersArray = [User getAllUsers];
                if ([usersArray count] != 0) {
                    User *user = [usersArray objectAtIndex:0];
                    
                    NSLog(@"USER: %@, ORDER: %@", user.UserID, order.UserID);
                    if ([order.UserID isEqual:user.UserID])
                        [self.ordersArray addObject:order];
                    else
                        NSLog(@"ERROR IN THE EDITING TABLE");
                }
            }
        }
    }
    
    if (self.ordersArray.count == 0) {
        GMOrderHeader *temp = [[GMOrderHeader alloc] init];
        temp.DateCreated = @"NONE";
        temp.PONum = @"NONE";
        [self.ordersArray addObject:temp];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"No orders"
                                   message:@"There are no orders to see. Please create a new order."
                                  delegate:self
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [alert show];
        NoOrders = YES;
    } else {
        NoOrders = NO;
    }
    [orderTableView reloadData];
}

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    [orderTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ordersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"OrderHeaderCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        else
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    GMOrderHeader * tmpOrder = nil;
    tmpOrder = [self.ordersArray objectAtIndex:indexPath.row];
    
    if ((indexPath.row == 0) && NoOrders) {
        cell.detailTextLabel.text = @"";
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ on %@", tmpOrder.LocalStatus, tmpOrder.DateEdited];
    }


    cell.textLabel.text = [NSString stringWithFormat:@"Started: %@", tmpOrder.DateCreated];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];

    // Text field
    UILabel *lblPO = [[UILabel alloc] init];
    lblPO.frame = CGRectMake(50, 10, 300, 40);
    [lblPO setFont:[UIFont boldSystemFontOfSize:16]];

    [lblPO setTextColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]];
    
    cell.accessoryView = lblPO;
    if ([tmpOrder.PONum isEqualToString:@"(null)"]) {
        lblPO.text = @"";
    } else {
        lblPO.text = [NSString stringWithFormat:@"P.O. #: %@", tmpOrder.PONum];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([status isEqual:GMPOST]) {
        WCPDFViewController *pdfView = [self.storyboard instantiateViewControllerWithIdentifier:@"WCPDFViewController"];
        pdfView.gmOrderHeaderInfo.PDFType= GMPOST;
        pdfView.gmOrderHeaderInfo = [ordersArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:pdfView animated:YES];
    } else {
        GMOrderOverviewVC *editingScreenView = [self.storyboard instantiateViewControllerWithIdentifier:@"GMOrderOverviewVC"];
        editingScreenView.orderHeader = [ordersArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:editingScreenView animated:YES];
    }
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}
@end


