//
//  EditingTableVC.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/24/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "EditingTableVC.h"
#import "User.h"
#import "OrderHeader.h"
#import "Customer.h"
#import "EditingScreenVC.h"
#import "PostedScreenVC.h"
#import "WCPDFViewController.h"

#import "AttemptedOrderHeader.h"
#import "AttemptedGMOrderHeader.h"

#define POST        @"Posted"
#define EDIT        @"Edited"
#define START       @"Started"
#define ATTEMPT     @"Attempted"
#define GMATTEMPT   @"GMAttempted"

@interface EditingTableVC ()
@end

@implementation EditingTableVC
@synthesize ordersArray;
@synthesize NoOrders;
@synthesize status;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ordersArray = [[NSMutableArray alloc] init];

    if ([status isEqual:START] || [status isEqual:EDIT]) {


        NSMutableArray *orders = [OrderHeader getAllOrderHeaders];

        for (OrderHeader *order in orders) {
            // stored orders that haven't been submitted
            if ([order.LocalStatus isEqualToString:START] || [order.LocalStatus isEqualToString:EDIT])
            {
                // only include the order in the list if the correct user is signed in
                NSMutableArray * usersArray = [User getAllUsers];
                if ([usersArray count] != 0) {
                    User *user = [usersArray objectAtIndex:0];

                    if ([order.UserID isEqual:user.UserID])
                        [self.ordersArray addObject:order];
                    else
                        NSLog(@"ERROR IN THE EDITING TABLE");
                }
            }
        }

    } else if ([status isEqual:ATTEMPT]) {
//        NSMutableArray *attemptedOrders = [AttemptedOrderHeader getAllOrderHeaders];

        self.ordersArray = [AttemptedOrderHeader getAllOrderHeaders];

    } else if ([status isEqual:GMATTEMPT]) {



    } else if ([status isEqual:POST]) {
        //status = post means it's in iPad order history not editing
        NSMutableArray *orders = [OrderHeader getAllOrderHeaders];

        for (OrderHeader *order in orders) {
            if ([order.LocalStatus isEqual:POST])
                [self.ordersArray addObject:order];
        }
        
    }
    
    if (self.ordersArray.count == 0) {
        OrderHeader *temp = [[OrderHeader alloc] init];
        [self.ordersArray addObject:temp];
        //iOS 8 code
//        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"No orders"
//                                                                       message:@"There are no orders to see. Please create a new order."
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
//                                                              handler:^(UIAlertAction * action) {
//                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
//                                                              }];
//        [alert addAction:defaultAction];
//        [self presentViewController:alert animated:YES completion:nil];
//        [alert release];

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
    
    OrderHeader * tmpOrder = nil;
    tmpOrder = [self.ordersArray objectAtIndex:indexPath.row];
    Customer *tmpCust = [[Customer alloc] init];
    NSString *tmpStoreID = tmpOrder.StoreID;
    if ([tmpStoreID isEqual:@"(null)"]) {
        tmpStoreID = @"Not Selected";
    }
    tmpCust = [Customer getCustomerWhereCustomerNumber:tmpOrder.CustNum];
    if ((indexPath.row == 0) && NoOrders) {
        tmpCust.CustName = @"NONE";
        tmpStoreID = @"NONE";
        cell.detailTextLabel.text = @"";
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ on %@", tmpOrder.LocalStatus, tmpOrder.DateEdited];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        cell.textLabel.text = [NSString stringWithFormat:@"Cust: %@", tmpCust.CustName];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"Cust: %@", tmpCust.CustName];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }



    // Text field
    UILabel *lblStore = [[UILabel alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iOS 3.2 or later.
        lblStore.frame = CGRectMake(50, 10, 300, 40);
        [lblStore setFont:[UIFont boldSystemFontOfSize:16]];
    }
    else
    {
        // The device is an iPhone or iPod touch.
        lblStore.frame = CGRectMake(0, 10, 40, 30);
        [lblStore setFont:[UIFont boldSystemFontOfSize:22]];
    }
    
    [lblStore setTextColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]];
//    [txtField setBackgroundColor:[[UIColor alloc] initWithRed:194.0 / 255 green:213.0 / 255 blue:221.0 / 255 alpha:1.0]];

    cell.accessoryView = lblStore;
    lblStore.text = [NSString stringWithFormat:@"Store: %@", tmpStoreID];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([status isEqual:POST]) {
        WCPDFViewController *pdfView = [self.storyboard instantiateViewControllerWithIdentifier:@"WCPDFViewController"];
        pdfView.orderHeaderInfo = [ordersArray objectAtIndex:indexPath.row];
        pdfView.orderHeaderInfo.PDFType = POST;
        [self.navigationController pushViewController:pdfView animated:YES];
        
//        PostedScreenVC *postScreenView = [self.storyboard instantiateViewControllerWithIdentifier:@"postScreen"];
//        postScreenView.orderHeaderInfo = [ordersArray objectAtIndex:indexPath.row];
//        [self.navigationController pushViewController:postScreenView animated:YES];
    } else {
        EditingScreenVC *editingScreenView = [self.storyboard instantiateViewControllerWithIdentifier:@"editScreen"];
        editingScreenView.orderHeaderInfo = [ordersArray objectAtIndex:indexPath.row];
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

