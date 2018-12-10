//
//  GMOrderOverviewVC.m
//  wayne mobile
//
//  Created by Delphi Dev Computer on 6/12/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import "GlobalVariables.h"
#import "Sync.h"

#import "WCPDFViewController.h"
#import "User.h"
#import "GMOrderOverviewVC.h"
#import "GMOrderScreenVC.h"
#import "GMBillingShippingInfoVC.h"
#import "GMOrderHeader.h"
#import "Customer.h"
#import "GMInfoVC.h"

#define DELETE              @"deleteOrders"
#define BACK                @"goBack"
#define GMPOST              @"GMPosted"
#define PDF                 @"goToPDF"


@interface GMOrderOverviewVC ()

@end

@implementation GMOrderOverviewVC
@synthesize orderHeader;
@synthesize alertAction;
@synthesize dateFormatter;
@synthesize orderLineArray;
@synthesize lblTitle;
@synthesize btnBillingShipping;
@synthesize btnPickItems;
@synthesize lblBillingShipping;
@synthesize lblPickItems;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // notification for post working
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"GMPostWorked"
                                               object:nil];
    
    
    // to hide keyboard when outside is tapped
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    tapScroll.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapScroll];
    
    //adding borders to uitableview and notes view
    txtNotes.layer.borderWidth = 2.5f;
    txtNotes.layer.borderColor =[[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]CGColor];
    

}

- (void)viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    
    //initialize text fields
    if ([orderHeader.Notes isEqual:@"(null)"]) {
        txtNotes.text = @"";
    } else {
        txtNotes.text = [orderHeader.Notes stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    }
    
    alertAction = @"";
    
    if ([orderHeader.LocalStatus isEqualToString:@"Started"]) {
        lblTitle.text = @"New General Merchandise Order:";
    } else if ([orderHeader.LocalStatus isEqualToString:@"Edited"]) {
        lblTitle.text = @"Editing General Merchandise Order:";
    }
    
    if ([orderHeader.BillTo isEqual:@"(null)"]) {
        btnBillingShipping.titleLabel.text = @"Enter Billing and Shipping Info";
    } else {
        btnBillingShipping.titleLabel.text = @"Edit Billing and Shipping Info";
    }
    
    if ([orderHeader.PONum isEqual:@"(null)"]) {
        lblBillingShipping.text = @"";
    } else {
        lblBillingShipping.text = [NSString stringWithFormat:@"P.O. Num: %@", orderHeader.PONum];
    }
    
    NSMutableArray *tmpOrderLineArray = [GMOrderLine getOrderLinesWhere:orderHeader.OrderNum];
    if (tmpOrderLineArray.count > 1) {
        lblPickItems.text = [NSString stringWithFormat:@"%ld Items Picked", (long)tmpOrderLineArray.count];
    } else if (tmpOrderLineArray.count > 0) {
        lblPickItems.text = [NSString stringWithFormat:@"%ld Item Picked", (long)tmpOrderLineArray.count];
    } else {
        lblPickItems.text = @"No Items Picked Yet";
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnBillingShipping:(id)sender {
    [self saveData];
    GMBillingShippingInfoVC *shippingView = [self.storyboard instantiateViewControllerWithIdentifier:@"GMBillingShippingInfo"];
    shippingView.gmorderHeaderInfo = orderHeader;
    [self.navigationController pushViewController:shippingView animated:YES];
}

- (IBAction)btnPickItems:(id)sender {
    [self saveData];
    GMOrderScreenVC *orderView = [self.storyboard instantiateViewControllerWithIdentifier:@"GMOrderScreenVC"];
    orderView.orderHeaderInfo = orderHeader;
    [self.navigationController pushViewController:orderView animated:YES];
}

- (IBAction)btnDeleteOrder:(id)sender {
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Delete Order"
                                                   message:@"Are you sure you want to delete this order? You will never get it back..."
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Delete", nil];
    alertAction = DELETE;
    [alert show];
}

- (IBAction)btnSave:(id)sender {
    [self saveData];
    orderHeader.Notes = txtNotes.text;
    orderHeader.LocalStatus = @"Edited";
    
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [NSDate date];
    
    orderHeader.DateEdited = [dateFormatter stringFromDate:date];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSLog(@"%@", orderHeader.UserID);
    [GMOrderHeader updateOrderHeader:orderHeader];
    
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    [self.navigationController popToViewController:[allViewControllers objectAtIndex:1] animated:YES];
}

- (IBAction)btnCreatePDF:(id)sender {
    [self saveData];
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
                [GMOrderHeader deleteWhere:orderHeader.OrderNum];
                [GMOrderLine deleteWhere:orderHeader.OrderNum];
            }
            NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
            [self.navigationController popToViewController:[allViewControllers objectAtIndex:1] animated:YES];
        } else if ([alertAction isEqualToString:PDF])
        {
            orderHeader.Notes = txtNotes.text;
            WCPDFViewController *pdfView = [self.storyboard instantiateViewControllerWithIdentifier:@"WCPDFViewController"];
            pdfView.gmOrderHeaderInfo = orderHeader;
            pdfView.gmOrderHeaderInfo.PDFType = @"GMORDER";
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


-(void)saveData {
    orderHeader.Notes = txtNotes.text;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    orderHeader.DateEdited = [self.dateFormatter stringFromDate:[NSDate date]];
    [GMOrderHeader updateOrderHeader:orderHeader];
}


#pragma posting order

- (IBAction)btnPostOrder:(id)sender {
    [self saveData];
//#warning ios8 data commented out
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

- (IBAction)btnGMReminders:(id)sender {
    orderHeader.Notes = txtNotes.text;
    GMInfoVC *infoView = [self.storyboard instantiateViewControllerWithIdentifier:@"GMInfoVC"];
    [self.navigationController pushViewController:infoView animated:YES];
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
    // order header
    NSMutableArray *tmpOrderHeaderArray = [[NSMutableArray alloc] init];
    NSMutableArray *tmpOrderLineArray = [[NSMutableArray alloc] init];
    NSInteger *countPcs = 0;
    self.orderLineArray = [GMOrderLine getOrderLinesWhere:orderHeader.OrderNum];
    for (int i = 0; i < orderLineArray.count; i++) {
        GMOrderLine *tmpOrderLineTest = [self.orderLineArray objectAtIndex:i];
        countPcs += tmpOrderLineTest.Quantity;
    }
    if (countPcs > 0) {
        if ([orderHeader.BillTo isEqual:@"(null)"] ||[orderHeader.ShipTo isEqual:@"(null)"]) {
            NSString *message = [NSString stringWithFormat:@"You need to select a billing and shipping location before you submit this order."];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select Billing/Shipping Location"
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
            NSDate *tmpDateCreated = [dateFormatter dateFromString:orderHeader.DateCreated];
            NSDate *tmpDateEdited = [dateFormatter dateFromString:orderHeader.DateCreated];
            NSLog(@"%@, %@", tmpDateEdited, [NSTimeZone systemTimeZone]);
            [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            
            NSDictionary *orderHeaderInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                             [NSString stringWithFormat:@"%ld", (long)orderHeader.OrderNum], @"OrderNum",
                                             [NSString stringWithFormat:@"%@", orderHeader.UserID], @"UserID",
                                             [NSString stringWithFormat:@"%@", orderHeader.CustNum], @"CustNum",
                                             [NSString stringWithFormat:@"%@", orderHeader.StoreID], @"StoreID",
                                             [NSString stringWithFormat:@"%@", orderHeader.PONum], @"PONum",
                                             [NSString stringWithFormat:@"%@", orderHeader.LocalStatus], @"LocalStatus",
                                             [NSString stringWithFormat:@"%@", orderHeader.HeartwoodStatus], @"HeartwoodStatus",
                                             [NSString stringWithFormat:@"%@", orderHeader.ShipMethod], @"ShipMethod",
                                             [NSString stringWithFormat:@"%@", orderHeader.Notes], @"Notes",
                                             [NSString stringWithFormat:@"%@", orderHeader.BillTo], @"BillTo",
                                             [NSString stringWithFormat:@"%@", orderHeader.BAddress], @"BAddress",
                                             [NSString stringWithFormat:@"%@", orderHeader.BCity], @"BCity",
                                             [NSString stringWithFormat:@"%@", orderHeader.BState], @"BState",
                                             [NSString stringWithFormat:@"%@", orderHeader.BZip], @"BZip",
                                             [NSString stringWithFormat:@"%@", orderHeader.BPhoneFax], @"BPhoneFax",
                                             [NSString stringWithFormat:@"%@", orderHeader.ShipTo], @"ShipTo",
                                             [NSString stringWithFormat:@"%@", orderHeader.SAddress], @"SAddress",
                                             [NSString stringWithFormat:@"%@", orderHeader.SCity], @"SCity",
                                             [NSString stringWithFormat:@"%@", orderHeader.SState], @"SState",
                                             [NSString stringWithFormat:@"%@", orderHeader.SZip], @"SZip",
                                             [NSString stringWithFormat:@"%@", orderHeader.DateToShip], @"DateToShip",
                                             [NSString stringWithFormat:@"%@", orderHeader.NotBefore], @"NotBefore",
                                             [NSString stringWithFormat:@"%@", tmpDateCreated], @"DateCreated",
                                             [NSString stringWithFormat:@"%@", tmpDateEdited], @"DateEdited",
                                             nil];
            [tmpOrderHeaderArray addObject:orderHeaderInfo];
            
            // order lines
            for (int i = 0; i < self.orderLineArray.count; i++) {
                GMOrderLine *tmpOrderLine = [self.orderLineArray objectAtIndex:i];
                if (tmpOrderLine.Quantity > 0) {
                    NSDictionary *orderLine = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [NSString stringWithFormat:@"%ld", (long)tmpOrderLine.OrderNum], @"OrderNum",
                                               [NSString stringWithFormat:@"%@", tmpOrderLine.ItemNum], @"ItemNO",
                                               [NSString stringWithFormat:@"%ld", (long)tmpOrderLine.Quantity], @"Quantity",
                                               [NSString stringWithFormat:@"%ld", (long)tmpOrderLine.BadItems], @"BadItems",
                                               [NSString stringWithFormat:@"%@", tmpOrderLine.ArtNum], @"ArtNum",
                                               [NSString stringWithFormat:@"%@", tmpOrderLine.NameDrop], @"NameDrop",
                                               nil];
                    [tmpOrderLineArray addObject:orderLine];
                }
            }
            
            NSDictionary *tmpWholeOrder = [NSDictionary dictionaryWithObjectsAndKeys:
                                           tmpOrderHeaderArray, @"GMOrderHeader",
                                           tmpOrderLineArray, @"GMOrderLines",
                                           nil];
            
            NSMutableArray *usersArray = [User getAllUsers];
            User *tmpUser = [usersArray objectAtIndex:0];
            Sync *postSync = [[Sync alloc] init];
            [postSync gmpostOrder:orderHeader.UserID withPassword:tmpUser.Password withOrderheader:tmpWholeOrder];
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

- (void)receiveTestNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"GMPostWorked"]) {
        
        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        orderHeader.DatePosted = [self.dateFormatter stringFromDate:[NSDate date]];
        
        orderSent = @"orderSent";
        orderHeader.LocalStatus = GMPOST;
        
        [GMOrderHeader updateOrderHeader:orderHeader];
        
        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        [self.navigationController popToViewController:[allViewControllers objectAtIndex:1] animated:YES];
        NSLog(@"data posted!");
    }
}

#pragma txtNotes

//-(void)textViewDidBeginEditing:(UITextView *)sender {
//    if ([sender isEqual:txtNotes])
//    {
//        [self.view setContentOffset:CGPointMake(0,645) animated:YES];
//    }
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [txtNotes resignFirstResponder];
    return YES;
}

- (void)tapped {
    [self.view endEditing:YES];
}


@end
