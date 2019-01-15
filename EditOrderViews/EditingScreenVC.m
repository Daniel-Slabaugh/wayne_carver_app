//
//  EditingScreenVC.m
//  wayne mobile
//
//  Created by Daniel Slabaugh on 7/24/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "EditingScreenVC.h"
#import "AppDelegate.h"
#import "UserVC.h"
#import "GlobalVariables.h"
#import <QuartzCore/QuartzCore.h>
#import "Sync.h"
#import "SVProgressHUD.h"

#import "EditItemTableVC.h"
#import "EditOrderScreenVC.h"
#import "EditDetailScreenVC.h"
#import "EditDateScreenVC.h"
#import "WCPDFViewController.h"
#import "User.h"
#import "Item.h"
#import "Ship.h"
#import "Customer.h"
#import "OrderLine.h"
#import "OrderDetail.h"
#import "AttemptedOrderHeader.h"
#import "AttemptedOrderLine.h"
#import "AttemptedOrderDetail.h"

#define ASAP                @"ASAP"
#define DELETE              @"deleteOrders"
#define BACK                @"goBack"
#define PDF                 @"goToPDF"
#define DEFAULTDELIVERY     @"UPS Ground"
#define BOY                 @"BOYNAME"
#define GIRL                @"GIRLNAME"
#define INITIAL             @"INITIAL"
#define UNISEX              @"UNISEX"
#define SAYING              @"SAYING"
#define POST                @"Posted"
#define BACKUP              @"Backup"
#define EDIT                @"Edited"

@interface EditingScreenVC ()

@end

@implementation EditingScreenVC
@synthesize orderLineArray;
@synthesize orderHeaderInfo;
@synthesize lblCustomer;
@synthesize lblDateStarted;
@synthesize lblSalesman;
@synthesize dateFormatter;
@synthesize txtPONumber;
@synthesize pickerShipTypeArray;
@synthesize alertAction;
@synthesize btnSetShipDate;
@synthesize btnShipMethod;
@synthesize btnSetStore;
@synthesize btnChangeShipDate;
@synthesize btnChangeShipMethod;
@synthesize btnChangeStore;
@synthesize lblShipDate;
@synthesize lblShipMethod;
@synthesize lblSetStore;
@synthesize changed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {

    //setup lbl and btns
    [btnSetStore.titleLabel setTextColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]];
    [btnSetShipDate.titleLabel setTextColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]];
    [btnShipMethod.titleLabel setTextColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]];
    [lblSetStore setTextColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]];
    [lblShipMethod setTextColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]];
    [lblShipDate setTextColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]];
    changed = @"NO";

    [super viewDidLoad];
    // initialize scroll view
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iPhone 3.2 or later.
        [self->scrollView setContentSize:CGSizeMake(768, 2350)];
        self->scrollView.frame = CGRectMake(0, 0, 768, 1700);
    }
    else
    {
        // The device is an iPhone or iPod touch.
        [self->scrollView setContentSize:CGSizeMake(320, 1950)];
        self->scrollView.frame = CGRectMake(0, 0, 320, 1200);
    }
    [self.view addSubview:self->scrollView];

    // So that keyboard will hide.
    txtPONumber.delegate = self;

    // to hide keyboard when outside is tapped
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    tapScroll.cancelsTouchesInView = NO;
    [scrollView addGestureRecognizer:tapScroll];

    // notification for post working
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"PostWorked"
                                               object:nil];
    // notification for changing data
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"UpdateData"
                                               object:nil];

    //adding borders to uitableview and notes view
    txtNotes.layer.borderWidth = 2.5f;
    txtNotes.layer.borderColor =[[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]CGColor];
    orderLineView.layer.borderWidth = 2.5f;
    orderLineView.layer.borderColor =[[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]CGColor];

    //set labels for order header information
    NSMutableArray *tmpUser = [User getAllUsers];
    User *user = [tmpUser objectAtIndex:0];
    lblSalesman.text = [NSString stringWithFormat:@"Salesman: %@ %@", user.FirstName, user.LastName];
    Customer *cust = [Customer getCustomerWhereCustomerNumber:orderHeaderInfo.CustNum];
    lblCustomer.text = [NSString stringWithFormat:@"Customer: %@", cust.CustName];
    lblDateStarted.text = [NSString stringWithFormat:@"Started: %@",orderHeaderInfo.DateCreated];
}

- (void)viewWillAppear:(BOOL) animated {


    //initialize text fields
    if ([orderHeaderInfo.Notes isEqual:@"(null)"]) {
        txtNotes.text = @"";
    } else {
        txtNotes.text = [orderHeaderInfo.Notes stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    }
    if ([orderHeaderInfo.PONum isEqual:@"(null)"]) {
        txtPONumber.text = @"";
    } else {
        txtPONumber.text = orderHeaderInfo.PONum;
    }


    if ([orderHeaderInfo.StoreID isEqual:@"(null)"]) {
        lblSetStore.text = @"";
        [btnSetStore setEnabled:YES];
        [btnSetStore setHidden:NO];
        [btnChangeStore setEnabled:NO];
        [btnChangeStore setHidden:YES];
    } else {
        lblSetStore.text = [NSString stringWithFormat:@"Store: %@", orderHeaderInfo.StoreID];
        [btnSetStore setEnabled:NO];
        [btnSetStore setHidden:YES];
        [btnChangeStore setEnabled:YES];
        [btnChangeStore setHidden:NO];
    }

    if ([orderHeaderInfo.ShipMethod isEqual:@"(null)"]) {
        lblShipMethod.text = @"Ship by: UPS Ground";
        orderHeaderInfo.ShipMethod = DEFAULTDELIVERY;
        [btnShipMethod setEnabled:NO];
        [btnShipMethod setHidden:YES];
        [btnChangeShipMethod setEnabled:YES];
        [btnChangeShipMethod setHidden:NO];
    } else {
        lblShipMethod.text = [NSString stringWithFormat:@"Ship by: %@", orderHeaderInfo.ShipMethod];
        [btnShipMethod setEnabled:NO];
        [btnShipMethod setHidden:YES];
        [btnChangeShipMethod setEnabled:YES];
        [btnChangeShipMethod setHidden:NO];
    }

    // set asap
    if ([orderHeaderInfo.DateToShip isEqualToString:ASAP]) {
        [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        lblShipDate.text = [NSString stringWithFormat:@"Requested Ship Date: %@", ASAP];
        [btnSetShipDate setEnabled:NO];
        [btnSetShipDate setHidden:YES];
        [btnChangeShipDate setEnabled:YES];
        [btnChangeShipDate setHidden:NO];
    } else {
        // initialize and design nsdateformatter and set txtdate to right date and format
        if ([orderHeaderInfo.LocalStatus isEqualToString:@"Started"] && [changed isEqualToString:@"NO"]) {
            lblShipDate.text = @"";
            [btnSetShipDate setEnabled:YES];
            [btnSetShipDate setHidden:NO];
            [btnChangeShipDate setEnabled:NO];
            [btnChangeShipDate setHidden:YES];
        } else {
            self.dateFormatter = [[NSDateFormatter alloc] init];
            [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
            [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            NSDate *tmpDate = [self.dateFormatter  dateFromString:orderHeaderInfo.DateToShip];
            if ([orderHeaderInfo.NotBefore isEqual: @"true"]) {
                lblShipDate.text = [NSString stringWithFormat:@"Requested Ship Date: Not before %@", [self.dateFormatter stringFromDate:tmpDate]];
            } else {
                lblShipDate.text = [NSString stringWithFormat:@"Requested Ship Date: %@", [self.dateFormatter stringFromDate:tmpDate]];
            }
            [btnSetShipDate setEnabled:NO];
            [btnSetShipDate setHidden:YES];
            [btnChangeShipDate setEnabled:YES];
            [btnChangeShipDate setHidden:NO];
        }
        [super viewWillAppear:animated];

    }

    // set up ItemOrderlist for tableview
    self.orderLineArray = [[NSMutableArray alloc] init];
    self.orderLineArray = [OrderLine getOrderLinesWhere:orderHeaderInfo.OrderNum];
    if (self.orderLineArray.count == 0) {
        OrderLine *temp = [[OrderLine alloc] init];
        temp.ItemNo = @"No Records";
        temp.Quantity = 0;
        [self.orderLineArray addObject:temp];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"Something Wrong" message:@"There seems to be an error with this order." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    alertAction = @"";
    [orderLineView reloadData];
}

#pragma posting order

- (IBAction)btnPostOrder:(id)sender {
    [self saveData];
#warning ios8 data commented out
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        //Load resources for iOS 7.1 or earlier
        NSString *message = [NSString stringWithFormat:@"Are you sure you want to send this order? Please Validate order information before you submit."];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:message delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Send Order" otherButtonTitles:@"Cancel", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    } else {
        // Load resources for iOS 8 or later
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Send Order?"
                                                                       message:@"Are you sure you want to send this order? Please Validate order information before you submit."
                                                                preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {
                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                                              }];
        UIAlertAction* defaultAction2 = [UIAlertAction actionWithTitle:@"Send Order" style:UIAlertActionStyleDestructive
                                                               handler:^(UIAlertAction * action) {
                                                                   [self postOrder];
                                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                               }];
        [alert addAction:defaultAction];
        [alert addAction:defaultAction2];
        [self presentViewController:alert animated:YES completion:nil];

    }
}

//sending order
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self postOrder];
    } else {
        NSLog(@"Cancelled");
    }
}

- (void)postOrder {
    // save data
    [self saveData];
#warning backup data commented out
//    [self backupData];
    // order header
    NSMutableArray *tmpOrderHeaderArray = [[NSMutableArray alloc] init];
    NSMutableArray *tmpOrderLineArray = [[NSMutableArray alloc] init];
    NSMutableArray *tmpOrderDetailArray = [[NSMutableArray alloc] init];
    NSInteger *countPcs = 0;
    for (int i = 0; i < orderLineArray.count; i++) {
        OrderLine *tmpOrderLineTest = [self.orderLineArray objectAtIndex:i];
        countPcs += tmpOrderLineTest.Quantity;
    }


    if (countPcs > 0) {
        if (![orderHeaderInfo.LocalStatus  isEqual: POST]) {

            if ([orderHeaderInfo.StoreID isEqual:@"(null)"] ||[orderHeaderInfo.ShipMethod isEqual:@"(null)"]) {
                NSString *message = [NSString stringWithFormat:@"You need to select a shipping location and method before you submit this order."];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select Shipping Location/Method"
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
            } else {
                [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
                [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
                [self.dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                NSDate *tmpDateCreated = [dateFormatter dateFromString:orderHeaderInfo.DateCreated];
                NSDate *tmpDateEdited = [dateFormatter dateFromString:orderHeaderInfo.DateCreated];
                NSLog(@"%@, %@", tmpDateEdited, [NSTimeZone systemTimeZone]);
                [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];

                NSDictionary *orderHeader = [NSDictionary dictionaryWithObjectsAndKeys:
                                             [NSString stringWithFormat:@"%ld", (long)orderHeaderInfo.OrderNum], @"OrderNum",
                                             [NSString stringWithFormat:@"%@", orderHeaderInfo.UserID], @"UserID",
                                             [NSString stringWithFormat:@"%@", orderHeaderInfo.CustNum], @"CustNum",
                                             [NSString stringWithFormat:@"%@", orderHeaderInfo.StoreID], @"StoreID",
                                             [NSString stringWithFormat:@"%@", orderHeaderInfo.PONum], @"PONum",
                                             [NSString stringWithFormat:@"%@", orderHeaderInfo.LocalStatus], @"LocalStatus",
                                             [NSString stringWithFormat:@"%@", orderHeaderInfo.HeartwoodStatus], @"HeartwoodStatus",
                                             [NSString stringWithFormat:@"%@", orderHeaderInfo.ShipMethod], @"ShipMethod",
                                             [NSString stringWithFormat:@"%@", orderHeaderInfo.Notes], @"Notes",
                                             [NSString stringWithFormat:@"%@", orderHeaderInfo.DateToShip], @"DateToShip",
                                             [NSString stringWithFormat:@"%@", orderHeaderInfo.NotBefore], @"NotBefore",
                                             [NSString stringWithFormat:@"%@", tmpDateCreated], @"DateCreated",
                                             [NSString stringWithFormat:@"%@", tmpDateEdited], @"DateEdited",
                                             nil];
                [tmpOrderHeaderArray addObject:orderHeader];

#warning here is where we start
                // order lines
                for (int i = 0; i < orderLineArray.count; i++) {
                    OrderLine *tmpOrderLine = [self.orderLineArray objectAtIndex:i];
                    if (tmpOrderLine.Quantity > 0) {
                        NSDictionary *orderLine = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [NSString stringWithFormat:@"%ld", (long)tmpOrderLine.OrderNum], @"OrderNum",
                                                   [NSString stringWithFormat:@"%@", tmpOrderLine.ItemNo], @"ItemNO",
                                                   [NSString stringWithFormat:@"%@", tmpOrderLine.Nameset], @"Nameset",
                                                   [NSString stringWithFormat:@"%ld", (long)tmpOrderLine.Quantity], @"Quantity",
                                                   [NSString stringWithFormat:@"%ld", (long)tmpOrderLine.BadItems], @"BadItems",
                                                   [NSString stringWithFormat:@"%@", tmpOrderLine.ProgName], @"ProgName",
                                                   nil];
                        [tmpOrderLineArray addObject:orderLine];

                        // order details per orderline
                        NSMutableArray *tmpOrderDetailInfoArray = [OrderDetail getOrderDetailsWhereOrder:tmpOrderLine];
                        for (int i = 0; i < tmpOrderDetailInfoArray.count; i++) {
                            OrderDetail *tmpOrderDetail = [tmpOrderDetailInfoArray objectAtIndex:i];
                            if (tmpOrderDetail.QtyOrdered > 0)
                            {
                                // 'O' = ordernum, 'N' = nameset, 'A' = Name, 'T' = Nametype, Q = Qtyordered
                                NSString *tmpNameType;
                                if ([tmpOrderDetail.NameType isEqual:BOY]) {
                                    tmpNameType = @"B";
                                } else if ([tmpOrderDetail.NameType isEqual:GIRL]) {
                                    tmpNameType = @"G";
                                } else if ([tmpOrderDetail.NameType isEqual:UNISEX]) {
                                    tmpNameType = @"U";
                                } else if ([tmpOrderDetail.NameType isEqual:INITIAL]) {
                                    tmpNameType = @"I";
                                } else if ([tmpOrderDetail.NameType isEqual:SAYING]) {
                                    tmpNameType = @"S";
                                } else {
                                    tmpNameType = tmpOrderDetail.NameType;
                                }

                                NSDictionary *orderDetail = [NSDictionary dictionaryWithObjectsAndKeys:
                                                             [NSString stringWithFormat:@"%ld", (long)tmpOrderDetail.OrderNum], @"O",
                                                             [NSString stringWithFormat:@"%@", tmpOrderDetail.ItemNo], @"I",
                                                             [NSString stringWithFormat:@"%@", tmpOrderDetail.Nameset], @"N",
                                                             [NSString stringWithFormat:@"%@", tmpOrderDetail.Name], @"A",
                                                             [NSString stringWithFormat:@"%@", tmpNameType], @"T",
                                                             [NSString stringWithFormat:@"%ld", (long)tmpOrderDetail.QtyOrdered], @"Q",
                                                             nil];
                                [tmpOrderDetailArray addObject:orderDetail];
                            }
                        }
                    }
                    //                    NSDictionary *tmpWholeOrder = [NSDictionary dictionaryWithObjectsAndKeys:
                    //                                                   tmpOrderHeaderArray, @"OrderHeader",
                    //                                                   tmpOrderLineArray, @"OrderLines",
                    //                                                   tmpOrderDetailArray, @"OrderDetails",
                    //                                                   nil];
                    //#warning this is where it ends.
                    //                    NSMutableArray *usersArray = [User getAllUsers];
                    //                    User *tmpUser = [usersArray objectAtIndex:0];
                    //                    Sync *postSync = [[Sync alloc] init];
                    //                    [postSync postOrderLine:orderHeaderInfo.UserID withPassword:tmpUser.Password withOrderData:tmpWholeOrder withOrderHeader:orderHeaderInfo number:[NSString stringWithFormat:@"%d", i] of:[NSString stringWithFormat:@"%lu", (unsigned long)orderLineArray.count]]; // test this ....
                }

                NSDictionary *tmpWholeOrder = [NSDictionary dictionaryWithObjectsAndKeys:
                                               tmpOrderHeaderArray, @"OrderHeader",
                                               tmpOrderLineArray, @"OrderLines",
                                               tmpOrderDetailArray, @"OrderDetails",
                                               nil];

                //                 try this...
                // NSLog(@"String: %@", tmpWholeOrder);

                NSMutableArray *usersArray = [User getAllUsers];
                User *tmpUser = [usersArray objectAtIndex:0];
                Sync *postSync = [[Sync alloc] init];
                [postSync postOrder:orderHeaderInfo.UserID withPassword:tmpUser.Password withOrderData:tmpWholeOrder withOrderHeader:orderHeaderInfo];
            }
        } else {
            // order already posted. exiting out to main screen
            orderSent = @"orderSent";

            NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
            [self.navigationController popToViewController:[allViewControllers objectAtIndex:1] animated:YES];
            NSLog(@"data posted!");
        }

    } else {

        NSString *message = [NSString stringWithFormat:@"No Parts in this order. You need to order something..."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Parts"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];

    }
}


-(void)saveData {
    orderHeaderInfo.PONum = txtPONumber.text;
    orderHeaderInfo.LocalStatus = @"Edited";
    orderHeaderInfo.Notes = txtNotes.text;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    orderHeaderInfo.DateEdited = [self.dateFormatter stringFromDate:[NSDate date]];
    [OrderHeader updateOrderHeader:orderHeaderInfo];
}

-(void)backupData {
    orderHeaderInfo.PONum = txtPONumber.text;
//    orderHeaderInfo.LocalStatus = @"Backup";
    orderHeaderInfo.Notes = txtNotes.text;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];

    orderHeaderInfo.DateEdited = [self.dateFormatter stringFromDate:[NSDate date]];

    [OrderHeader updateOrderHeader:orderHeaderInfo];


    // order header
    NSMutableArray *tmpArray = [User getAllUsers];
    User *user = [tmpArray objectAtIndex:0];

    AttemptedOrderHeader *tmpOrderHdr = [[AttemptedOrderHeader alloc] init];
    tmpOrderHdr.UserID = user.UserID;
    tmpOrderHdr.CustNum = orderHeaderInfo.CustNum;
    tmpOrderHdr.LocalStatus = @"Attempted";
    [AttemptedOrderHeader insertInto:tmpOrderHdr];
#warning this method not working
    AttemptedOrderHeader *createdOrderHdr = [AttemptedOrderHeader getLastOrderHeaderEntered];

    // order lines
    for (int i = 0; i < orderLineArray.count; i++) {
        // order line
        AttemptedOrderLine *tmpAttemptedOrderLine = [[AttemptedOrderLine alloc] init];
        OrderLine *tmpOrderLine = [self.orderLineArray objectAtIndex:i];


        tmpAttemptedOrderLine.OrderNum = createdOrderHdr.OrderNum;
        tmpAttemptedOrderLine.ItemNo = tmpOrderLine.ItemNo;
        tmpAttemptedOrderLine.Nameset = tmpOrderLine.Nameset;
        tmpAttemptedOrderLine.Quantity = tmpOrderLine.Quantity;
        tmpAttemptedOrderLine.BadItems = tmpOrderLine.BadItems;
        tmpAttemptedOrderLine.ProgName = tmpOrderLine.ProgName;

        [AttemptedOrderLine insertInto:tmpAttemptedOrderLine];

        // order details per orderline
        NSMutableArray *tmpOrderDetailInfoArray = [OrderDetail getOrderDetailsWhereOrder:tmpOrderLine];
        [AttemptedOrderDetail beginOrderDetailInsert];
        for (int i = 0; i < tmpOrderDetailInfoArray.count; i++) {
#warning not sure if this will work
            AttemptedOrderDetail *tmpAttemptedOrderDetail = [tmpOrderDetailInfoArray objectAtIndex:i];
            [AttemptedOrderDetail insertInto:tmpAttemptedOrderDetail];
            //                    AttemptedOrderDetail *tmpAttemptedOrderDetail = [[AttemptedOrderDetail alloc] init];
            //
            //                    orderDetail.OrderNum = createdOrderHdr.OrderNum;
            //                    [OrderDetail insertInto:orderDetail];

        }
        [AttemptedOrderDetail endOrderDetailInsert];
    }

    //    orderHeaderInfo.PONum = txtPONumber.text;
    //    orderHeaderInfo.LocalStatus = @"Backup";
    //    orderHeaderInfo.Notes = txtNotes.text;
    //    self.dateFormatter = [[NSDateFormatter alloc] init];
    //    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    //    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    //    orderHeaderInfo.DateEdited = [self.dateFormatter stringFromDate:[NSDate date]];
    //#warning change
    //    [OrderHeader updateOrderHeader:orderHeaderInfo];
}

- (IBAction)txtPONumEditBegin:(id)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iPhone 3.2 or later.
        [scrollView setContentOffset:CGPointMake(0,500) animated:YES];
    }
    else
    {
        // The device is an iPhone or iPod touch.
        [scrollView setContentOffset:CGPointMake(0,91) animated:YES];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)sender {
    if ([sender isEqual:txtNotes])
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // The device is an iPad running iPhone 3.2 or later.
            [scrollView setContentOffset:CGPointMake(0,645) animated:YES];
        }
        else
        {
            // The device is an iPhone or iPod touch.
            [scrollView setContentOffset:CGPointMake(0,726) animated:YES];
        }
    }
}

#pragma Item Tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    return (self.orderLineArray.count +1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"OrderLineCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        else
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    if (indexPath.row > 0) {
        OrderLine * tmpOrderLine = nil;
        tmpOrderLine = [self.orderLineArray objectAtIndex:(indexPath.row - 1)];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [Item getItemDesc:tmpOrderLine.ItemNo]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld Pieces", (long)tmpOrderLine.Quantity];
    } else {
        cell.textLabel.text = @"Add another Name Program";
        cell.detailTextLabel.text = @"New Item";
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    else
        cell.textLabel.font = [UIFont systemFontOfSize:14];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self saveData];
    if (indexPath.row > 0) {
        OrderLine *tmpOrderLine = [self.orderLineArray objectAtIndex:(indexPath.row - 1)];
        EditOrderScreenVC *editOrderScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"editOrderScreen"];
        editOrderScreen.orderHeaderInfo = orderHeaderInfo;
        editOrderScreen.orderLineInfo = tmpOrderLine;
        [self.navigationController pushViewController:editOrderScreen animated:YES];
    } else {
        EditItemTableVC *itemTableView = [self.storyboard instantiateViewControllerWithIdentifier:@"editItemTable"];
        itemTableView.orderHeaderInfo = orderHeaderInfo;
        itemTableView.orderLines = orderLineArray;
        [self.navigationController pushViewController:itemTableView animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Items In Order";
}

#pragma mark - Other methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [txtPONumber resignFirstResponder];
    [txtNotes resignFirstResponder];
    return YES;
}

- (void)receiveTestNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"PostWorked"]) {

        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        orderHeaderInfo.DatePosted = [self.dateFormatter stringFromDate:[NSDate date]];


        orderSent = @"orderSent";
        orderHeaderInfo.LocalStatus = POST;
        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        [self.navigationController popToViewController:[allViewControllers objectAtIndex:1] animated:YES];
        NSLog(@"data posted!");
    } else if ([[notification name] isEqualToString:@"UpdateData"]) {
        [self viewWillAppear:YES];
    }
}

- (IBAction)btnDeleteOrder:(id)sender {

    OrderLine *temp = [[OrderLine alloc] init];
    temp.ItemNo = @"No Records";
    temp.Quantity = 0;
    [self.orderLineArray addObject:temp];
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Delete Order"
                                                   message:@"Are you sure you want to delete this order? You will never get it back..."
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Delete", nil];
    alertAction = DELETE;
    [alert show];
}

- (IBAction)btnBack:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Exit"
                                                    message:@"Are you sure you want to exit? You will lose all unsaved data"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Yes", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    alertAction = BACK;
    [alert show];
}

- (IBAction)btnCreatePDF:(id)sender {
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Generate PDF?"
                                                   message:@"This enables you to send a copy of the order to other people."
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Create PDF", nil];
    alertAction = PDF;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([alertAction isEqualToString:DELETE] || [alertAction isEqualToString:BACK]) {
            if ([alertAction isEqualToString:DELETE]) {
                [OrderHeader deleteWhere:orderHeaderInfo.OrderNum];
                [OrderLine deleteWhere:orderHeaderInfo.OrderNum];
                [OrderDetail deleteWhere:orderHeaderInfo.OrderNum];
            }
            NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
            [self.navigationController popToViewController:[allViewControllers objectAtIndex:1] animated:YES];
        } else if ([alertAction isEqualToString:PDF])
        {
            orderHeaderInfo.PONum = txtPONumber.text;
            orderHeaderInfo.Notes = txtNotes.text;
            orderHeaderInfo.PDFType = @"FULL";
            WCPDFViewController *pdfView = [self.storyboard instantiateViewControllerWithIdentifier:@"WCPDFViewController"];
            //            pdfView.PDFType = @"SUMMARY";
            //            NSLog(@"PDFType: %@", pdfView.PDFType);
            pdfView.orderHeaderInfo = orderHeaderInfo;
            [self.navigationController pushViewController:pdfView animated:YES];
        }
    }
}

- (IBAction)btnSaveOrder:(id)sender {
    [self saveData];
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    [self.navigationController popToViewController:[allViewControllers objectAtIndex:1] animated:YES];
    NSLog(@"data saved!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)tapped {
    [self.view endEditing:YES];
}

//- (IBAction)btnSetStore:(id)sender {
//    EditDetailScreenVC *editDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDetailScreen"];
//    editDetailView.orderHeaderInfo = orderHeaderInfo;
//    editDetailView.type = @"Store";
//    editDetailView.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self.navigationController presentViewController:editDetailView animated:YES completion:nil];
//}

//- (IBAction)btnChangeStore:(id)sender {
//    EditDetailScreenVC *editDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDetailScreen"];
//    editDetailView.orderHeaderInfo = orderHeaderInfo;
//    editDetailView.type = @"Store";
//    editDetailView.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self.navigationController presentViewController:editDetailView animated:YES completion:nil];
//}

- (IBAction)btnShipMethod:(id)sender {
    EditDetailScreenVC *editDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDetailScreen"];
    editDetailView.orderHeaderInfo = orderHeaderInfo;
    editDetailView.type = @"ShipMethod";
    editDetailView.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentViewController:editDetailView animated:YES completion:nil];
}
- (IBAction)btnChangeShipMethod:(id)sender {
    EditDetailScreenVC *editDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDetailScreen"];
    editDetailView.orderHeaderInfo = orderHeaderInfo;
    editDetailView.type = @"ShipMethod";
    editDetailView.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentViewController:editDetailView animated:YES completion:nil];
}

- (IBAction)btnSetShipDate:(id)sender {
    [self SetShipDate];
}
- (IBAction)btnChangeShipDate:(id)sender {
    [self SetShipDate];
}
- (void)SetShipDate {
    EditDateScreenVC *editDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDateScreen"];
    editDetailView.type = @"NPShipDate";
    editDetailView.orderHeaderInfo = orderHeaderInfo;
    changed = @"YES";
    editDetailView.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentViewController:editDetailView animated:YES completion:nil];
}


#pragma mark email

@end

