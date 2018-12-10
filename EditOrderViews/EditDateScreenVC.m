//
//  EditDateScreenVC.m
//  wayne mobile
//
//  Created by Daniel Slabaugh on 10/26/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "EditDateScreenVC.h"

#define ASAP @"ASAP"
#define kPickerAnimationDuration 0.40


@interface EditDateScreenVC ()

@end

@implementation EditDateScreenVC
@synthesize switchAsap;
@synthesize switchNotBefore;
@synthesize txtDate;
@synthesize dateFormatter;
@synthesize orderHeaderInfo;
@synthesize gmorderHeaderInfo;
@synthesize type;
@synthesize lblAsap;
@synthesize lblBadItemCount;
@synthesize lblHeader;
@synthesize lblNotBefore;
@synthesize lblOptions;


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
    
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]])
            [view resignFirstResponder];
    }
    
//    if ([type isEqualToString:@"NPShipDate"]) {
    
        [switchAsap setHidden:NO];
        [switchAsap setEnabled:YES];
        [switchNotBefore setHidden:NO];
        [switchNotBefore setEnabled:YES];
        [lblOptions setHidden:NO];
        [lblAsap setHidden:NO];
        [lblNotBefore setHidden:NO];
        lblHeader.text = @"Request Ship Date";
        
        // Do any additional setup after loading the view.
        txtDate.text = orderHeaderInfo.DateToShip;
        
        // set asap switch
        if ([orderHeaderInfo.DateToShip isEqualToString:ASAP]) {
            [switchAsap setOn:YES animated:YES];
            [switchNotBefore setOn:NO animated:YES];
            [switchNotBefore setEnabled:NO];
            [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
            txtDate.text = ASAP;
        } else {
            // initialize and design nsdateformatter and set txtdate to right date and format
            self.dateFormatter = [[NSDateFormatter alloc] init];
            [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
            [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            NSDate *tmpDate = [self.dateFormatter  dateFromString:orderHeaderInfo.DateToShip];
            txtDate.text = [self.dateFormatter stringFromDate:tmpDate];
            self.pickerView.date = [self.dateFormatter dateFromString:txtDate.text];
            [switchAsap setOn:NO animated:YES];
            if ([orderHeaderInfo.NotBefore isEqual:@"true"]) {
                [switchNotBefore setOn:YES animated:YES];
            }
        }
//    } else if([type isEqualToString:@"GMShipDate"]) {
//        
//        [switchAsap setHidden:NO];
//        [switchAsap setEnabled:YES];
//        [switchNotBefore setHidden:NO];
//        [switchNotBefore setEnabled:YES];
//        [lblOptions setHidden:NO];
//        [lblAsap setHidden:NO];
//        [lblNotBefore setHidden:NO];
//        lblHeader.text = @"Request Ship Date";
//        
//        txtDate.text = gmorderHeaderInfo.DateToShip;
//        
//        // set asap switch
//        if ([gmorderHeaderInfo.DateToShip isEqualToString:ASAP]) {
//            [switchAsap setOn:YES animated:YES];
//            [switchNotBefore setOn:NO animated:YES];
//            [switchNotBefore setEnabled:NO];
//            [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//            [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
//            [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
//            txtDate.text = ASAP;
//        } else {
//            // initialize and design nsdateformatter and set txtdate to right date and format
//            self.dateFormatter = [[NSDateFormatter alloc] init];
//            [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
//            [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
//            [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//            NSDate *tmpDate = [self.dateFormatter  dateFromString:orderHeaderInfo.DateToShip];
//            txtDate.text = [self.dateFormatter stringFromDate:tmpDate];
//            self.pickerView.date = [self.dateFormatter dateFromString:txtDate.text];
//            [switchAsap setOn:NO animated:YES];
//            if ([orderHeaderInfo.NotBefore isEqual:@"true"]) {
//                [switchNotBefore setOn:YES animated:YES];
//            }
//        }
//    } else if([type isEqualToString:@"GMCancelDate"]) {
//        txtDate.text = gmorderHeaderInfo.DateToCancel;
//        
//        // set asap switch
//        [switchAsap setHidden:YES];
//        [switchAsap setEnabled:NO];
//        [switchNotBefore setHidden:YES];
//        [switchNotBefore setEnabled:NO];
//        [lblOptions setHidden:YES];
//        [lblAsap setHidden:YES];
//        [lblNotBefore setHidden:YES];
//        lblHeader.text = @"Request Cancel Date";
//
//        
//        // initialize and design nsdateformatter and set txtdate to right date and format
//        self.dateFormatter = [[NSDateFormatter alloc] init];
//        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
//        [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
//        [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//        NSDate *tmpDate = [self.dateFormatter  dateFromString:orderHeaderInfo.DateToShip];
//        txtDate.text = [self.dateFormatter stringFromDate:tmpDate];
//        self.pickerView.date = [self.dateFormatter dateFromString:txtDate.text];
//    }

}

- (void)viewDidAppear:(BOOL)animated {
    [self ShowPicker];
}

- (void)ShowPicker {
    // the date picker might already be showing, so don't add it to our view
    if (self.pickerView.superview == nil)
    {
        CGRect startFrame = self.pickerView.frame;
        CGRect endFrame = self.pickerView.frame;
        
        // the start position is below the bottom of the visible frame
        startFrame.origin.y = self.view.frame.size.height;
        
        // the end position is slid up by the height of the view
        endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
        
        self.pickerView.frame = startFrame;
        self.pickerView.datePickerMode = UIDatePickerModeDate;
        
        [self.view addSubview:self.pickerView];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kPickerAnimationDuration];
        self.pickerView.frame = endFrame;
        [UIView commitAnimations];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma uipickerview

- (void)slideDownDidStop {
	// the date picker has finished sliding downwards, so remove it from the view hierarchy
	[self.pickerView removeFromSuperview];
}

- (void)hideDatePicker {
    CGRect pickerFrame = self.pickerView.frame;
    pickerFrame.origin.y = self.view.frame.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kPickerAnimationDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
    self.pickerView.frame = pickerFrame;
    [UIView commitAnimations];
}

- (IBAction)dateAction:(id)sender {
	txtDate.text = [self.dateFormatter stringFromDate:self.pickerView.date];
}


- (IBAction)btnDone:(id)sender {
    [self hideDatePicker];
    
    
//    if ([type isEqualToString:@"NPShipDate"]) {
        //send notification to main edit screen
        orderHeaderInfo.DateToShip = txtDate.text;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:self];
//    } else if([type isEqualToString:@"GMShipDate"]) {
//        //send notification to main edit screen
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"GMUpdateData" object:self];
//        gmorderHeaderInfo.DateToShip = txtDate.text;
//    } else if([type isEqualToString:@"GMCancelDate"]) {
//        //send notification to main edit screen
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"GMUpdateData" object:self];
//        gmorderHeaderInfo.DateToCancel = txtDate.text;
//    }
//    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnShipDateInfo:(id)sender {
    NSString *message = [NSString stringWithFormat:@"Wayne orders usually ship within three to five business days."];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Requested Ship Date:"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

- (IBAction)switchAsap:(id)sender {
    if ([sender isOn]) {
        [self hideDatePicker];
        txtDate.text = ASAP;
        [switchNotBefore setOn:NO animated:YES];
        [switchNotBefore setEnabled:NO];
        orderHeaderInfo.NotBefore = @"false";
    } else {
        // initialize and design nsdateformatter and set txtdate to right date and format
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        NSDate *tmpDate = [[NSDate alloc] init];
//        if ([type isEqualToString:@"NPShipDate"]) {
            tmpDate = [self.dateFormatter  dateFromString:orderHeaderInfo.DateEdited];
//        } else {
//            tmpDate = [self.dateFormatter  dateFromString:gmorderHeaderInfo.DateEdited];
//        }
        [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        txtDate.text = [self.dateFormatter stringFromDate:tmpDate];
        self.pickerView.date = [self.dateFormatter dateFromString:txtDate.text];
        [switchNotBefore setEnabled:YES];
        [self ShowPicker];
    }
}

- (IBAction)switchNotBefore:(id)sender {
    if ([sender isOn]) {
        orderHeaderInfo.NotBefore = @"true";
    } else {
        orderHeaderInfo.NotBefore = @"false";
    }
}

@end



//#import "EditingScreenVC.h"
//#import "HeartwoodAppAppDelegate.h"
//#import "HeartwoodAppUserViewController.h"
//#import "HeartwoodAppIntroViewController.h"
//#import <QuartzCore/QuartzCore.h>
//#import "Sync.h"
//#import "SVProgressHUD.h"
//
//
//#import "EditItemTableVC.h"
//#import "EditOrderScreenVC.h"
//#import "EditDetailScreenVC.h"
//#import "User.h"
//#import "Item.h"
//#import "Ship.h"
//#import "Customer.h"
//#import "OrderLine.h"
//#import "OrderDetail.h"
//
//#define DELETE @"deleteOrders"
//#define DEFAULTDELIVERY @"UPS Ground"
//#define kPickerAnimationDuration 0.40
//
//@interface EditingScreenVC ()
//
//@end
//
//@implementation EditingScreenVC
//@synthesize orderLineArray;
//@synthesize orderHeaderInfo;
//@synthesize lblCustomer;
//@synthesize lblDateStarted;
//@synthesize lblSalesman;
//@synthesize txtPONumber;
//@synthesize pickerShipTypeArray;
//@synthesize deleteAlert;
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // initialize scroll view for iphone
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        // The device is an iPad running iPhone 3.2 or later.
//        [self->scrollView setContentSize:CGSizeMake(768, 2450)];
//        self->scrollView.frame = CGRectMake(0, 0, 768, 1700);
//        
//    }
//    else
//    {
//        // The device is an iPhone or iPod touch.
//        [self->scrollView setContentSize:CGSizeMake(320, 1950)];
//        self->scrollView.frame = CGRectMake(0, 0, 320, 1200);
//    }
//    [self.view addSubview:self->scrollView];
//    
//    // So that keyboard will hide.
//    txtPONumber.delegate = self;
//    
//    // to hide keyboard when outside is tapped
//    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
//    tapScroll.cancelsTouchesInView = NO;
//    [scrollView addGestureRecognizer:tapScroll];
//    
//    // notification for post working
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(receiveTestNotification:)
//                                                 name:@"PostWorked"
//                                               object:nil];
//
//    // ship Type Array
//    self.pickerShipTypeArray = [[NSMutableArray alloc] init];
//    self.pickerShipTypeArray = [Ship getAllShipTypes];
//    
//    //adding borders to uitableview and notes view
//    txtNotes.layer.borderWidth = 2.5f;
//    txtNotes.layer.borderColor =[[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]CGColor];
//    orderLineView.layer.borderWidth = 2.5f;
//    orderLineView.layer.borderColor =[[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]CGColor];
//    
//    // make the "Done" button invisible;
//    [btnSetDate setEnabled:YES];
//    
//    //set labels for order header information
//    NSMutableArray *tmpUser = [User getAllUsers];
//    User *user = [tmpUser objectAtIndex:0];
//    lblSalesman.text = [NSString stringWithFormat:@"Salesman: %@ %@", user.FirstName, user.LastName];
//    Customer *cust = [Customer getCustomerWhereCustomerNumber:orderHeaderInfo.CustNum];
//    lblCustomer.text = [NSString stringWithFormat:@"Customer: %@", cust.CustName];
//    lblDateStarted.text = [NSString stringWithFormat:@"Started: %@",orderHeaderInfo.DateCreated];
//}
//
//- (void) viewWillAppear:(BOOL) animated {
//    [super viewWillAppear:animated];
//    
//    // set asap switch
//    if ([orderHeaderInfo.DateToShip isEqualToString:ASAP]) {
//        [switchAsap setOn:YES animated:YES];
//        [switchNotBefore setOn:NO animated:YES];
//        [switchNotBefore setEnabled:NO];
//        [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
//        [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
//        txtDate.text = ASAP;
//        btnSetDate.hidden = YES;
//        btnSetDate.enabled = NO;
//        btnDoneSettingDate.hidden = YES;
//        btnDoneSettingDate.enabled = NO;
//    } else {
//        // initialize and design nsdateformatter and set txtdate to right date and format
//        self.dateFormatter = [[NSDateFormatter alloc] init];
//        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
//        [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
//        [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//        NSDate *tmpDate = [self.dateFormatter  dateFromString:orderHeaderInfo.DateToShip];
//        txtDate.text = [self.dateFormatter stringFromDate:tmpDate];
//        [switchAsap setOn:NO animated:YES];
//        if ([orderHeaderInfo.NotBefore isEqual:@"true"]) {
//            [switchNotBefore setOn:YES animated:YES];
//        }
//        btnDoneSettingDate.hidden = YES;
//        btnDoneSettingDate.enabled = NO;
//        btnSetDate.hidden = NO;
//        btnSetDate.enabled = YES;
//    }
//
//    //initialize text fields
//    [txtShipMethod setEnabled:NO];
//    [txtDate setEnabled:NO];
//    if ([orderHeaderInfo.Notes isEqual:@"(null)"]) {
//        txtNotes.text = @"";
//    } else {
//        txtNotes.text = orderHeaderInfo.Notes;
//    }
//    if ([orderHeaderInfo.ShipMethod isEqual:@"(null)"]) {
//        txtShipMethod.text = DEFAULTDELIVERY;
//        lblDefaultShip.hidden = NO;
//    } else {
//        txtShipMethod.text = orderHeaderInfo.ShipMethod;
//        lblDefaultShip.hidden = YES;
//    }
//    // hide done shipping btn
//    btnDoneShip.hidden = YES;
//    btnDoneShip.enabled = NO;
//    
//    if ([orderHeaderInfo.PONum isEqual:@"(null)"]) {
//        txtPONumber.text = @"";
//    } else {
//        txtPONumber.text = orderHeaderInfo.PONum;
//    }
//    
//    // set up ItemOrderlist for tableview
//    self.orderLineArray = [[NSMutableArray alloc] init];
//    self.orderLineArray = [OrderLine getOrderLinesWhere:orderHeaderInfo.OrderNum];
//    if (self.orderLineArray.count == 0) {
//        OrderLine *temp = [[OrderLine alloc] init];
//        temp.ItemNo = @"No Records";
//        temp.Quantity = 0;
//        [self.orderLineArray addObject:temp];
//        UIAlertView *alert =
//        [[UIAlertView alloc] initWithTitle:@"Something Wrong" message:@"There seems to be an error with this order." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//    }
//    deleteAlert = @"";
//    [orderLineView reloadData];
//}
//
//- (IBAction)btnPostOrder:(id)sender {
//    [self saveData];
//    NSString *message = [NSString stringWithFormat:@"Are you sure you want to send this order? Please Validate order information before you submit."];
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:message delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Send Order" otherButtonTitles:@"Cancel", nil];
//    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
//    [actionSheet showInView:self.view];
//    [actionSheet release];
//}
//
////sending order
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//	
//	//SMS
//	if(buttonIndex == 0){
//        // save data
//        [self saveData];
//        // order header
//        NSMutableArray *tmpOrderHeaderArray = [[NSMutableArray alloc] init];
//        NSMutableArray *tmpOrderLineArray = [[NSMutableArray alloc] init];
//        NSMutableArray *tmpOrderDetailArray = [[NSMutableArray alloc] init];
//        NSInteger *countPcs = 0;
//        for (int i = 0; i < orderLineArray.count; i++) {
//            OrderLine *tmpOrderLineTest = [self.orderLineArray objectAtIndex:i];
//            countPcs += tmpOrderLineTest.Quantity;
//        }
//        if (countPcs > 0) {
//            [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
//            [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//            [self.dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//            NSDate *tmpDateCreated = [dateFormatter dateFromString:orderHeaderInfo.DateCreated];
//            NSDate *tmpDateEdited = [dateFormatter dateFromString:orderHeaderInfo.DateCreated];
//            NSLog(@"%@, %@", tmpDateEdited, [NSTimeZone systemTimeZone]);
//            [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//            
//            NSDictionary *orderHeader = [NSDictionary dictionaryWithObjectsAndKeys:
//                                         [NSString stringWithFormat:@"%d", orderHeaderInfo.OrderNum], @"OrderNum",
//                                         [NSString stringWithFormat:@"%@", orderHeaderInfo.UserID], @"UserID",
//                                         [NSString stringWithFormat:@"%@", orderHeaderInfo.CustNum], @"CustNum",
//                                         [NSString stringWithFormat:@"%@", orderHeaderInfo.StoreID], @"StoreID",
//                                         [NSString stringWithFormat:@"%@", orderHeaderInfo.PONum], @"PONum",
//                                         [NSString stringWithFormat:@"%@", orderHeaderInfo.LocalStatus], @"LocalStatus",
//                                         [NSString stringWithFormat:@"%@", orderHeaderInfo.HeartwoodStatus], @"HeartwoodStatus",
//                                         [NSString stringWithFormat:@"%@", orderHeaderInfo.ShipMethod], @"ShipMethod",
//                                         [NSString stringWithFormat:@"%@", orderHeaderInfo.Notes], @"Notes",
//                                         [NSString stringWithFormat:@"%@", orderHeaderInfo.DateToShip], @"DateToShip",
//                                         [NSString stringWithFormat:@"%@", orderHeaderInfo.NotBefore], @"NotBefore",
//                                         [NSString stringWithFormat:@"%@", tmpDateCreated], @"DateCreated",
//                                         [NSString stringWithFormat:@"%@", tmpDateEdited], @"DateEdited",
//                                         nil];
//            [tmpOrderHeaderArray addObject:orderHeader];
//            
//            // order lines
//            for (int i = 0; i < orderLineArray.count; i++) {
//                OrderLine *tmpOrderLine = [self.orderLineArray objectAtIndex:i];
//                if (tmpOrderLine.Quantity > 0) {
//                    NSDictionary *orderLine = [NSDictionary dictionaryWithObjectsAndKeys:
//                                               [NSString stringWithFormat:@"%d", tmpOrderLine.OrderNum], @"OrderNum",
//                                               [NSString stringWithFormat:@"%@", tmpOrderLine.ItemNo], @"ItemNO",
//                                               [NSString stringWithFormat:@"%@", tmpOrderLine.Nameset], @"Nameset",
//                                               [NSString stringWithFormat:@"%d", tmpOrderLine.Quantity], @"Quantity",
//                                               [NSString stringWithFormat:@"%d", tmpOrderLine.BadItems], @"BadItems",
//                                               nil];
//                    [tmpOrderLineArray addObject:orderLine];
//                    
//                    // order details per orderline
//                    NSMutableArray *tmpOrderDetailInfoArray = [OrderDetail getOrderDetailsWhereOrder:tmpOrderLine];
//                    for (int i = 0; i < tmpOrderDetailInfoArray.count; i++) {
//                        OrderDetail *tmpOrderDetail = [tmpOrderDetailInfoArray objectAtIndex:i];
//                        NSDictionary *orderDetail = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                     [NSString stringWithFormat:@"%d", tmpOrderDetail.OrderNum], @"OrderNum",
//                                                     [NSString stringWithFormat:@"%@", tmpOrderDetail.ItemNo], @"ItemNO",
//                                                     [NSString stringWithFormat:@"%@", tmpOrderDetail.Nameset], @"Nameset",
//                                                     [NSString stringWithFormat:@"%@", tmpOrderDetail.Name], @"Name",
//                                                     [NSString stringWithFormat:@"%@", tmpOrderDetail.NameType], @"NameType",
//                                                     [NSString stringWithFormat:@"%d", tmpOrderDetail.QtyOrdered], @"QtyOrdered",
//                                                     nil];
//                        [tmpOrderDetailArray addObject:orderDetail];
//                    }
//                }
//            }
//            
//            NSDictionary *tmpWholeOrder = [NSDictionary dictionaryWithObjectsAndKeys:
//                                           tmpOrderHeaderArray, @"OrderHeader",
//                                           tmpOrderLineArray, @"OrderLines",
//                                           tmpOrderDetailArray, @"OrderDetails",
//                                           nil];
//            
//            NSMutableArray *usersArray = [User getAllUsers];
//            User *tmpUser = [usersArray objectAtIndex:0];
//            Sync *postSync = [[Sync alloc] init];
//            [postSync postOrder:orderHeaderInfo.UserID withPassword:tmpUser.Password withOrderheader:tmpWholeOrder];
//            
//        } else {
//            
//            NSString *message = [NSString stringWithFormat:@"No Parts in this order. You need to order something..."];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Parts"
//                                                            message:message
//                                                           delegate:self
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert setAlertViewStyle:UIAlertViewStyleDefault];
//            [alert show];
//            [alert release];
//            
//        }
//	} else {
//        NSLog(@"Cancelled");
//        
//	}
//    
//}
//
//- (IBAction)btnSetDate:(id)sender {
//    btnSetShip.hidden = YES;
//    btnSetShip.enabled = NO;
//    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        // The device is an iPad running iPhone 3.2 or later.
//        [scrollView setContentOffset:CGPointMake(0, 60) animated:YES];
//    }
//    else
//    {
//        // The device is an iPhone or iPod touch.
//        [scrollView setContentOffset:CGPointMake(0, 275) animated:YES];
//    }
//    
//	for (UIView* view in self.view.subviews) {
//		if ([view isKindOfClass:[UITextField class]])
//			[view resignFirstResponder];
//	}
//	self.pickerView.date = [self.dateFormatter dateFromString:txtDate.text];
//	
//    // the date picker might already be showing, so don't add it to our view
//    if (self.pickerView.superview == nil)
//    {
//        CGRect startFrame = self.pickerView.frame;
//        CGRect endFrame = self.pickerView.frame;
//        
//        // the start position is below the bottom of the visible frame
//        startFrame.origin.y = self.view.frame.size.height;
//        
//        // the end position is slid up by the height of the view
//        endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
//        
//        self.pickerView.frame = startFrame;
//        self.pickerView.datePickerMode = UIDatePickerModeDate;
//        
//        [self.view addSubview:self.pickerView];
//        
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:kPickerAnimationDuration];
//        self.pickerView.frame = endFrame;
//        [UIView commitAnimations];
//    }
//    
//    // make setdate btn invisible
//    [btnSetDate setEnabled:NO];
//    [btnSetDate setHidden:YES];
//    
//    // make the "Done" button visible;
//    [btnDoneSettingDate setEnabled:YES];
//    [btnDoneSettingDate setHidden:NO];
//}
//
//- (IBAction)btnDoneSettingDate:(id)sender {
//    
//    [self hideDatePicker];
//    
//	// remove the "Done" button and replace with setdate btn
//    [btnDoneSettingDate setEnabled:NO];
//    [btnDoneSettingDate setHidden:YES];
//    [btnSetDate setEnabled:YES];
//    [btnSetDate setHidden:NO];
//    btnSetShip.hidden = NO;
//    btnSetShip.enabled = YES;
//    
//}
//
//- (IBAction)btnSetShip:(id)sender {
//    [btnSetDate setEnabled:NO];
//    [btnSetDate setHidden:YES];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        // The device is an iPad running iPhone 3.2 or later.
//        [scrollView setContentOffset:CGPointMake(0,-75) animated:YES];
//    }
//    else
//    {
//        // The device is an iPhone or iPod touch.
//        [scrollView setContentOffset:CGPointMake(0,180) animated:YES];
//    }
//    
//    for (UIView* view in self.view.subviews) {
//		if ([view isKindOfClass:[UITextField class]])
//			[view resignFirstResponder];
//	}
//    // the date picker might already be showing, so don't add it to our view
//    if (self->pickerShipType.superview == nil)
//    {
//        CGRect startFrame = self->pickerShipType.frame;
//        CGRect endFrame = self->pickerShipType.frame;
//        
//        // the start position is below the bottom of the visible frame
//        startFrame.origin.y = self.view.frame.size.height;
//        
//        // the end position is slid up by the height of the view
//        endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
//        
//        self->pickerShipType.frame = startFrame;
//        
//        [self.view addSubview:self->pickerShipType];
//        
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:kPickerAnimationDuration];
//        self->pickerShipType.frame = endFrame;
//        [UIView commitAnimations];
//    }
//    
//    [btnSetShip setEnabled:NO];
//    [btnSetShip setHidden:YES];
//    [btnDoneShip setEnabled:YES];
//    [btnDoneShip setHidden:NO];
//    [btnSetDate setEnabled:NO];
//    [btnDoneSettingDate setEnabled:NO];
//    [btnDoneSettingDate setHidden:YES];
//    
//    lblDefaultShip.hidden = YES;
//    for (int row = 0; row < pickerShipTypeArray.count; row++) {
//        if ([txtShipMethod.text isEqual:[pickerShipTypeArray objectAtIndex:row]])
//            [pickerShipType selectRow:row inComponent:0 animated:YES];
//    }
//    
//    
//    
//}
//
//- (IBAction)btnDoneShip:(id)sender {
//    [self hideShipPicker];
//	// remove the "Done" button and replace with setdate btn
//    [btnSetShip setEnabled:YES];
//    [btnSetShip setHidden:NO];
//    [btnDoneShip setEnabled:NO];
//    [btnDoneShip setHidden:YES];
//    [btnDoneSettingDate setEnabled:NO];
//    [btnDoneSettingDate setHidden:YES];
//    if (![self.switchAsap isOn]) {
//        [btnSetDate setEnabled:YES];
//        [btnSetDate setHidden:NO];
//    }
//}
//
//- (IBAction)btnDeleteOrder:(id)sender {
//    
//    OrderLine *temp = [[OrderLine alloc] init];
//    temp.ItemNo = @"No Records";
//    temp.Quantity = 0;
//    [self.orderLineArray addObject:temp];
//    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Delete Order"
//                                                   message:@"Are you sure you want to delete this order? You will never get it back..."
//                                                  delegate:self
//                                         cancelButtonTitle:@"Cancel"
//                                         otherButtonTitles:@"Delete", nil];
//    deleteAlert = DELETE;
//    [alert show];
//    [alert release];
//}
//
//- (void)slideDownDidStop {
//    [self->pickerShipType removeFromSuperview];
//	// the date picker has finished sliding downwards, so remove it from the view hierarchy
//	[self.pickerView removeFromSuperview];
//}
//
//- (void)hideShipPicker {
//    CGRect pickerShipFrame = self->pickerShipType.frame;
//    pickerShipFrame.origin.y = self.view.frame.size.height;
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:kPickerAnimationDuration];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
//    self->pickerShipType.frame = pickerShipFrame;
//    [UIView commitAnimations];
//}
//
//- (void)hideDatePicker {
//    CGRect pickerFrame = self.pickerView.frame;
//    pickerFrame.origin.y = self.view.frame.size.height;
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:kPickerAnimationDuration];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
//    self.pickerView.frame = pickerFrame;
//    [UIView commitAnimations];
//}
//
//-(void)saveData {
//    orderHeaderInfo.PONum = txtPONumber.text;
//    orderHeaderInfo.LocalStatus = @"Edited";
//    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
//    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//    [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//    orderHeaderInfo.LocalStatus = @"Edited";
//    orderHeaderInfo.ShipMethod = txtShipMethod.text;
//    if ([switchNotBefore isOn]) {
//        orderHeaderInfo.NotBefore = @"true";
//    } else {
//        orderHeaderInfo.NotBefore = @"false";
//    }
//    orderHeaderInfo.Notes = txtNotes.text;
//    orderHeaderInfo.DateToShip = txtDate.text;
//    self.dateFormatter = [[NSDateFormatter alloc] init];
//    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
//    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//    orderHeaderInfo.DateEdited = [self.dateFormatter stringFromDate:[NSDate date]];
//    [OrderHeader updateOrderHeader:orderHeaderInfo];
//}
//
//- (IBAction)dateAction:(id)sender {
//	txtDate.text = [self.dateFormatter stringFromDate:self.pickerView.date];
//}
//
//- (IBAction)txtPONumEditBegin:(id)sender {
//    [self hideDatePicker];
//    [self hideShipPicker];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        // The device is an iPad running iPhone 3.2 or later.
//        [scrollView setContentOffset:CGPointMake(0,-100) animated:YES];
//    }
//    else
//    {
//        // The device is an iPhone or iPod touch.
//        [scrollView setContentOffset:CGPointMake(0,91) animated:YES];
//    }
//}
//
//-(void)textViewDidBeginEditing:(UITextView *)sender {
//    [self hideDatePicker];
//    [self hideShipPicker];
//    if ([sender isEqual:txtNotes])
//    {
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//        {
//            // The device is an iPad running iPhone 3.2 or later.
//            [scrollView setContentOffset:CGPointMake(0,645) animated:YES];
//        }
//        else
//        {
//            // The device is an iPhone or iPod touch.
//            [scrollView setContentOffset:CGPointMake(0,726) animated:YES];
//        }
//    }
//}
//
//#pragma mark - UIPickerViewDataSource
//
//- (NSString *)pickerView:(UIPickerView *)pickerViewShip titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//	NSString *returnStr = @"";
//	
//	// note: for the custom picker we use custom views instead of titles
//	if (pickerViewShip == self->pickerShipType)
//	{
//        returnStr = [self.pickerShipTypeArray objectAtIndex:row];
//	}
//	
//	return returnStr;
//}
//
//- (void)pickerView:(UIPickerView *)pickerViewShip didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//	if (pickerViewShip == pickerShipType)	// don't show selection for the custom picker
//	{
//		// report the selection to the UI label
//		txtShipMethod.text = [NSString stringWithFormat:@"%@",
//                              [self.pickerShipTypeArray objectAtIndex:[pickerViewShip selectedRowInComponent:0]]];
//	}
//}
//
//- (CGFloat)pickerView:(UIPickerView *)pickerViewShip widthForComponent:(NSInteger)component {
//	return 240.0;
//}
//
//- (CGFloat)pickerView:(UIPickerView *)pickerViewShip rowHeightForComponent:(NSInteger)component {
//	return 40.0;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerViewShip numberOfRowsInComponent:(NSInteger)component {
//    return self.pickerShipTypeArray.count;
//}
//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//	return 1;
//}
//
//
//#pragma Item Tableview
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
//    return (self.orderLineArray.count +1);
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString * cellID = @"OrderLineCellID";
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (cell == nil) {
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID] autorelease];
//        else
//            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID] autorelease];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    
//    if (indexPath.row < self.orderLineArray.count) {
//        OrderLine * tmpOrderLine = nil;
//        tmpOrderLine = [self.orderLineArray objectAtIndex:indexPath.row];
//        cell.textLabel.text = [NSString stringWithFormat:@"%@", [Item getItemDesc:tmpOrderLine.ItemNo]];
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Pieces", tmpOrderLine.Quantity];
//    } else {
//        cell.textLabel.text = @"Add another Name Program";
//        cell.detailTextLabel.text = @"New Item";
//    }
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//        cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
//    else
//        cell.textLabel.font = [UIFont systemFontOfSize:14];
//    
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self saveData];
//    if (indexPath.row < self.orderLineArray.count) {
//        OrderLine *tmpOrderLine = [self.orderLineArray objectAtIndex:indexPath.row];
//        EditOrderScreenVC *editOrderScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"editOrderScreen"];
//        editOrderScreen.orderHeaderInfo = orderHeaderInfo;
//        editOrderScreen.orderLineInfo = tmpOrderLine;
//        [self.navigationController pushViewController:editOrderScreen animated:YES];
//    } else {
//        EditItemTableVC *itemTableView = [self.storyboard instantiateViewControllerWithIdentifier:@"editItemTable"];
//        itemTableView.orderHeaderInfo = orderHeaderInfo;
//        itemTableView.orderLines = orderLineArray;
//        [self.navigationController pushViewController:itemTableView animated:YES];
//    }
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"Items In Order";
//}
//
//#pragma mark - Other methods
//
//-(BOOL) textFieldShouldReturn:(UITextField *)textField {
//    [txtPONumber resignFirstResponder];
//    [txtDate resignFirstResponder];
//    [txtNotes resignFirstResponder];
//    return YES;
//}
//
//- (void) receiveTestNotification:(NSNotification *) notification {
//    if ([[notification name] isEqualToString:@"PostWorked"]) {
//        
//        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
//        [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//        [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//        orderHeaderInfo.DatePosted = [self.dateFormatter stringFromDate:[NSDate date]];
//        
//        orderHeaderInfo.LocalStatus = @"Posted";
//        
//        [OrderHeader updateOrderHeader:orderHeaderInfo];
//        
//        [OrderHeader deleteWhere:orderHeaderInfo.OrderNum];
//        
//        orderSent = @"orderSent";
//        
//        
//        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
//        [self.navigationController popToViewController:[allViewControllers objectAtIndex:1] animated:YES];
//        NSLog(@"data posted!");
//    }
//    
//}
//
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 1) {
//        if ([deleteAlert isEqualToString:DELETE]) {
//            [OrderHeader deleteWhere:orderHeaderInfo.OrderNum];
//            [OrderLine deleteWhere:orderHeaderInfo.OrderNum];
//            [OrderDetail deleteWhere:orderHeaderInfo.OrderNum];
//        }
//        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
//        [self.navigationController popToViewController:[allViewControllers objectAtIndex:1] animated:YES];
//    }
//}
//
//- (IBAction)btnSaveOrder:(id)sender {
//    [self saveData];
//    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
//    [self.navigationController popToViewController:[allViewControllers objectAtIndex:1] animated:YES];
//    NSLog(@"data saved!");
//}
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)dealloc {
//    [lblSalesman release];
//    [lblCustomer release];
//    [lblDateStarted release];
//    //[lblStore release];
//    [UIPickerView release];
//    [txtDate release];
//    [btnSetDate release];
//    [btnDoneSettingDate release];
//    [txtNotes release];
//    [switchAsap release];
//    [txtPONumber release];
//    [pickerShipType release];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [btnSetShip release];
//    [btnDoneShip release];
//    [txtShipMethod release];
//    [scrollView release];
//    [scrollView release];
//    [lblDefaultShip release];
//    [switchNotBefore release];
//    [_btnStore release];
//    [_btnSetShipDate release];
//    [_btnShipMethod release];
//    [super dealloc];
//}
//
//- (IBAction)btnBack:(id)sender {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Exit"
//                                                    message:@"Are you sure you want to exit? You will lose all unsaved data"
//                                                   delegate:self
//                                          cancelButtonTitle:@"Cancel"
//                                          otherButtonTitles:@"Yes", nil];
//    [alert setAlertViewStyle:UIAlertViewStyleDefault];
//    [alert show];
//    [alert release];
//}
//
//- (void) tapped {
//    [self.view endEditing:YES];
//}
//
//
//
//- (IBAction)btnStore:(id)sender {
//    EditDetailScreenVC *editDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDetailScreen"];
//    editDetailView.orderHeaderInfo = orderHeaderInfo;
//    editDetailView.type = @"Store";
//    editDetailView.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self.navigationController presentViewController:editDetailView animated:YES completion:nil];
//}
//
//- (IBAction)btnSetShipDate:(id)sender {
//    EditDetailScreenVC *editDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDateScreen"];
//    //    editDetailView.orderHeaderInfo = orderHeaderInfo;
//    editDetailView.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self.navigationController presentViewController:editDetailView animated:YES completion:nil];
//}
//- (IBAction)btnShipMethod:(id)sender {
//}
//@end


