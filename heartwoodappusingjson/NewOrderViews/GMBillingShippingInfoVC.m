//
//  GMBillingShippingInfoVC.m
//  wayne mobile
//
//  Created by Delphi Dev Computer on 6/12/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import "GMBillingShippingInfoVC.h"
#import "GMOrderOverviewVC.h"
#import "CustomerTableVC.h"

#import "EditDetailScreenVC.h"
#import "EditDateScreenVC.h"
#import "GMOrderLine.h"

#define ASAP                @"ASAP"
#define DEFAULTDELIVERY     @"UPS Ground"
#define GM                  @"GeneralMerchandise"
#define CLEAR               @"CLEARFIELDS"


@interface GMBillingShippingInfoVC ()

@end

@implementation GMBillingShippingInfoVC
@synthesize gmorderHeaderInfo;
@synthesize txtBillTo;
@synthesize txtBAddress;
@synthesize txtBCity;
@synthesize txtBState;
@synthesize txtBZip;
@synthesize txtBPhone;
@synthesize txtShipTo;
@synthesize txtSAddress;
@synthesize txtSCity;
@synthesize txtSState;
@synthesize txtSZip;
@synthesize customer;
@synthesize customerInfo;
@synthesize lblEnterCustomer;
@synthesize lblEnterShip;
@synthesize btnSetShipDate;
@synthesize btnShipMethod;
@synthesize btnSetCustomer;
@synthesize btnSetStore;
@synthesize btnSetCancelDate;
@synthesize btnChangeCustomer;
@synthesize btnChangeShipDate;
@synthesize btnChangeShipMethod;
@synthesize btnChangeCancelDate;
@synthesize btnChangeStore;
@synthesize lblShipDate;
@synthesize lblShipMethod;
@synthesize lblSetStore;
@synthesize alertAction;
@synthesize changed;
@synthesize cancel;
@synthesize dateFormatter;
@synthesize addressInfo;
@synthesize address;
@synthesize lblCancelDate;
@synthesize lblSetCustomer;
@synthesize txtShipDate;
@synthesize txtCancelDate;
@synthesize txtPurchaseOrder;



- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
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
    cancel = @"NO";
    
    // initialize scroll view
    [self->scrollView setContentSize:CGSizeMake(768, 2350)];
    self->scrollView.frame = CGRectMake(0, 0, 768, 1700);

    [self.view addSubview:self->scrollView];
    
    
    //configure txtfields for tabbing through them
    [txtBillTo setDelegate:self];
    [txtBAddress setDelegate:self];
    [txtBCity setDelegate:self];
    [txtBState setDelegate:self];
    [txtBZip setDelegate:self];
    [txtBPhone setDelegate:self];
    [txtShipTo setDelegate:self];
    [txtSAddress setDelegate:self];
    [txtSCity setDelegate:self];
    [txtSState setDelegate:self];
    [txtSZip setDelegate:self];
    [txtShipDate setDelegate:self];
    [txtCancelDate setDelegate:self];
    [txtPurchaseOrder setDelegate:self];
    txtBillTo.tag = 0;
    txtBAddress.tag = 1;
    txtBCity.tag = 2;
    txtBState.tag = 3;
    txtBZip.tag = 4;
    txtBPhone.tag = 5;
    txtShipTo.tag = 6;
    txtSAddress.tag = 7;
    txtSCity.tag = 8;
    txtSState.tag = 9;
    txtSZip.tag = 10;
    txtShipDate.tag = 11;
    txtCancelDate.tag = 12;
    txtPurchaseOrder.tag = 13;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // to hide keyboard when outside is tapped
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    tapScroll.cancelsTouchesInView = NO;
    [scrollView addGestureRecognizer:tapScroll];
    
    // notification for changing data
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"GMUpdateData"
                                               object:nil];
    
//    //set labels for order header information
//    NSMutableArray *tmpUser = [User getAllUsers];
//    User *user = [tmpUser objectAtIndex:0];
//    lblCustomer.text = [NSString stringWithFormat:@"Customer: %@", cust.CustName];
//    lblDateStarted.text = [NSString stringWithFormat:@"Started: %@",orderHeaderInfo.DateCreated];
}

-(void)textFieldDidBeginEditing:(UITextField *)txtField {
    [self->scrollView setContentOffset:CGPointMake(0, (txtField.frame.origin.y + - 500))];
    
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (void)viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%@", gmorderHeaderInfo.CustNum);
    if ([gmorderHeaderInfo.CustNum isEqual:@"(null)"] || [gmorderHeaderInfo.CustNum isEqual:@""]) {
        lblSetCustomer.text = @"";
        [btnSetCustomer setEnabled:YES];
        [btnSetCustomer setHidden:NO];
        [btnChangeCustomer setEnabled:NO];
        [btnChangeCustomer setHidden:YES];
        lblSetStore.text = @"";
        [btnSetStore setEnabled:NO];
        [btnSetStore setHidden:YES];
        [btnChangeStore setEnabled:NO];
        [btnChangeStore setHidden:YES];
        [lblEnterCustomer setHidden:NO];
        [lblEnterShip setHidden:YES];

        [self populateBillToFields];
        [self populateShipToFields];
    } else {
        customerInfo = [[Customer alloc] init];
        customerInfo = [Customer getCustomerWhereCustomerNumber:gmorderHeaderInfo.CustNum];
        customerInfo.CustName = [self checkNull:customerInfo.CustName];
        customerInfo.ADDR1 = [self checkNull:customerInfo.ADDR1];
        customerInfo.ADDR2 = [self checkNull:customerInfo.ADDR2];
        customerInfo.City = [self checkNull:customerInfo.City];
        customerInfo.State = [self checkNull:customerInfo.State];
        customerInfo.Zip = [self checkNull:customerInfo.Zip];
        customerInfo.Phone1 = [self checkNull:customerInfo.Phone1];
        customerInfo.Phone2 = [self checkNull:customerInfo.Phone2];

        lblSetCustomer.text = [NSString stringWithFormat:@"Customer: %@", customerInfo.CustName];
        [btnSetCustomer setEnabled:NO];
        [btnSetCustomer setHidden:YES];
        [btnChangeCustomer setEnabled:YES];
        [btnChangeCustomer setHidden:NO];
        txtBillTo.text = customerInfo.CustName;
        txtBAddress.text = [NSString stringWithFormat:@"%@  %@", customerInfo.ADDR1, customerInfo.ADDR2];
        txtBCity.text = customerInfo.City;
        txtBState.text = customerInfo.State;
        txtBZip.text = customerInfo.Zip;
        txtBPhone.text = [NSString stringWithFormat:@"%@  %@", customerInfo.Phone1, customerInfo.Phone2];
        [lblEnterCustomer setHidden:YES];
        
        if ([gmorderHeaderInfo.StoreID isEqual:@"(null)"] || [gmorderHeaderInfo.StoreID isEqual:@""]) {
            lblSetStore.text = @"";
            [btnSetStore setEnabled:YES];
            [btnSetStore setHidden:NO];
            [btnChangeStore setEnabled:NO];
            [btnChangeStore setHidden:YES];
            [lblEnterShip setHidden:NO];
            [self populateShipToFields];
        } else {
            addressInfo = [[Address alloc] init];
            addressInfo = [Address getAddressWhereStore:gmorderHeaderInfo.StoreID];
            
            addressInfo.Addr1 = [self checkNull:addressInfo.Addr1];
            addressInfo.Addr2 = [self checkNull:addressInfo.Addr2];
            addressInfo.City = [self checkNull:addressInfo.City];
            addressInfo.State = [self checkNull:addressInfo.State];
            addressInfo.Zip = [self checkNull:addressInfo.Zip];
            lblSetStore.text = [NSString stringWithFormat:@"Store: %@", gmorderHeaderInfo.StoreID];
            txtShipTo.text = addressInfo.StoreID;
            txtSAddress.text = [NSString stringWithFormat:@"%@  %@", addressInfo.Addr1, addressInfo.Addr2];
            txtSCity.text = addressInfo.City;
            txtSState.text = addressInfo.State;
            txtSZip.text = addressInfo.Zip;
            [btnSetStore setEnabled:NO];
            [btnSetStore setHidden:YES];
            [btnChangeStore setEnabled:YES];
            [btnChangeStore setHidden:NO];
            [lblEnterShip setHidden:YES];
        }
    }

    if ([gmorderHeaderInfo.ShipMethod isEqual:@"(null)"]) {
        lblShipMethod.text = @"Ship by: UPS Ground";
        gmorderHeaderInfo.ShipMethod = DEFAULTDELIVERY;
        [btnShipMethod setEnabled:NO];
        [btnShipMethod setHidden:YES];
        [btnChangeShipMethod setEnabled:YES];
        [btnChangeShipMethod setHidden:NO];
    } else {
        lblShipMethod.text = [NSString stringWithFormat:@"Ship by: %@", gmorderHeaderInfo.ShipMethod];
        [btnShipMethod setEnabled:NO];
        [btnShipMethod setHidden:YES];
        [btnChangeShipMethod setEnabled:YES];
        [btnChangeShipMethod setHidden:NO];
    }
    
//    // set asap
//    if ([gmorderHeaderInfo.DateToShip isEqualToString:ASAP]) {
//        [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
//        [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
//        lblShipDate.text = [NSString stringWithFormat:@"Requested Ship Date: %@", ASAP];
//        [btnSetShipDate setEnabled:NO];
//        [btnSetShipDate setHidden:YES];
//        [btnChangeShipDate setEnabled:YES];
//        [btnChangeShipDate setHidden:NO];
//    } else {
//        // initialize and design nsdateformatter and set txtdate to right date and format
//        if ([gmorderHeaderInfo.LocalStatus isEqualToString:@"Started"] && [changed isEqualToString:@"NO"]) {
//            lblShipDate.text = @"";
//            [btnSetShipDate setEnabled:YES];
//            [btnSetShipDate setHidden:NO];
//            [btnChangeShipDate setEnabled:NO];
//            [btnChangeShipDate setHidden:YES];
//        } else {
//            self.dateFormatter = [[NSDateFormatter alloc] init];
//            [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
//            [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
//            [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//            NSDate *tmpDate = [self.dateFormatter  dateFromString:gmorderHeaderInfo.DateToShip];
//            if ([gmorderHeaderInfo.NotBefore isEqual: @"true"]) {
//                lblShipDate.text = [NSString stringWithFormat:@"Requested Ship Date: Not before %@", [self.dateFormatter stringFromDate:tmpDate]];
//            } else {
//                lblShipDate.text = [NSString stringWithFormat:@"Requested Ship Date: %@", [self.dateFormatter stringFromDate:tmpDate]];
//            }
//            [btnSetShipDate setEnabled:NO];
//            [btnSetShipDate setHidden:YES];
//            [btnChangeShipDate setEnabled:YES];
//            [btnChangeShipDate setHidden:NO];
//        }
//    }
//    
//    //set cancel date
//    // initialize and design nsdateformatter and set txtdate to right date and format
//    if ([gmorderHeaderInfo.LocalStatus isEqualToString:@"Started"] && [cancel isEqualToString:@"NO"]) {
//        lblCancelDate.text = @"";
//        [btnSetCancelDate setEnabled:YES];
//        [btnSetCancelDate setHidden:NO];
//        [btnChangeCancelDate setEnabled:NO];
//        [btnChangeCancelDate setHidden:YES];
//    } else {
//        self.dateFormatter = [[NSDateFormatter alloc] init];
//        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
//        [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
//        [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//        NSDate *tmpDate = [self.dateFormatter  dateFromString:gmorderHeaderInfo.DateToCancel];
//        lblCancelDate.text = [NSString stringWithFormat:@"Requested Ship Date: %@", [self.dateFormatter stringFromDate:tmpDate]];
//        [btnSetCancelDate setEnabled:NO];
//        [btnSetCancelDate setHidden:YES];
//        [btnChangeCancelDate setEnabled:YES];
//        [btnChangeCancelDate setHidden:NO];
//    }
    
    if ([gmorderHeaderInfo.DateToShip isEqual:@"(null)"]) {
        txtShipDate.text = @"";
    } else {
        txtShipDate.text = gmorderHeaderInfo.DateToShip;
    }
    
    if ([gmorderHeaderInfo.DateToCancel isEqual:@"(null)"]) {
        txtCancelDate.text = @"";
    } else {
        txtCancelDate.text = gmorderHeaderInfo.DateToCancel;
    }
    
    if ([gmorderHeaderInfo.PONum isEqual:@"(null)"]) {
        txtPurchaseOrder.text = @"";
    } else {
        txtPurchaseOrder.text = gmorderHeaderInfo.PONum;
    }
}

-(NSString*)checkNull: (NSString*)string {
    if ([string isEqualToString:@"(null)"] || [string isEqualToString:@"<null>"]) {
        string = @"";
    }
    return string;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)populateBillToFields {
    if ([gmorderHeaderInfo.BillTo isEqual:@"(null)"]) {
        txtBillTo.text = @"";
    } else {
        txtBillTo.text = gmorderHeaderInfo.BillTo;
    }
    
    if ([gmorderHeaderInfo.BAddress isEqual:@"(null)"]) {
        txtBAddress.text = @"";
    } else {
        txtBAddress.text = gmorderHeaderInfo.BAddress;
    }
    
    if ([gmorderHeaderInfo.BCity isEqual:@"(null)"]) {
        txtBCity.text = @"";
    } else {
        txtBCity.text = gmorderHeaderInfo.BCity;
    }
    
    if ([gmorderHeaderInfo.BState isEqual:@"(null)"]) {
        txtBState.text = @"";
    } else {
        txtBState.text = gmorderHeaderInfo.BState;
    }
    
    if ([gmorderHeaderInfo.BZip isEqual:@"(null)"]) {
        txtBZip.text = @"";
    } else {
        txtBZip.text = gmorderHeaderInfo.BZip;
    }
    
    if ([gmorderHeaderInfo.BPhoneFax isEqual:@"(null)"]) {
        txtBPhone.text = @"";
    } else {
        txtBPhone.text = gmorderHeaderInfo.BPhoneFax;
    }
}

- (void)populateShipToFields {
    if ([gmorderHeaderInfo.ShipTo isEqual:@"(null)"]) {
        txtShipTo.text = @"";
    } else {
        txtShipTo.text = gmorderHeaderInfo.ShipTo;
    }
    
    if ([gmorderHeaderInfo.SAddress isEqual:@"(null)"]) {
        txtSAddress.text = @"";
    } else {
        txtSAddress.text = gmorderHeaderInfo.SAddress;
    }
    
    if ([gmorderHeaderInfo.SCity isEqual:@"(null)"]) {
        txtSCity.text = @"";
    } else {
        txtSCity.text = gmorderHeaderInfo.SCity;
    }
    
    if ([gmorderHeaderInfo.SState isEqual:@"(null)"]) {
        txtSState.text = @"";
    } else {
        txtSState.text = gmorderHeaderInfo.SState;
    }
    
    if ([gmorderHeaderInfo.SZip isEqual:@"(null)"]) {
        txtSZip.text = @"";
    } else {
        txtSZip.text = gmorderHeaderInfo.SZip;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)btnSave:(id)sender {
    [self saveData];
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[GMOrderOverviewVC class]]) {
            [self.navigationController popToViewController:aViewController animated:YES];
        }
    }
}

- (IBAction)btnClear:(id)sender {
    NSString *message = [NSString stringWithFormat:@"This will delete all data you have entered on this screen. This cannot be undone."];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear All Fields"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
    alertAction = CLEAR;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([alertAction isEqualToString:CLEAR]) {
            gmorderHeaderInfo.CustNum = @"";
            gmorderHeaderInfo.StoreID = @"";
            txtBillTo.text = @"";
            txtBAddress.text = @"";
            txtBCity.text = @"";
            txtBState.text = @"";
            txtBZip.text = @"";
            txtBPhone.text = @"";
            txtShipTo.text = @"";
            txtSAddress.text = @"";
            txtSCity.text = @"";
            txtSState.text = @"";
            txtSZip.text = @"";
            txtShipDate.text = @"";
            txtCancelDate.text = @"";
            txtPurchaseOrder.text = @"";
            [self saveData];
            [self viewWillAppear:YES];
        }
    }
    alertAction = @"";
}


- (void)saveData {
//    self.dateFormatter = [[NSDateFormatter alloc] init];
//    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
//    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//    gmorderHeaderInfo.DateEdited = [self.dateFormatter stringFromDate:[NSDate date]];
    gmorderHeaderInfo.BillTo = txtBillTo.text;
    gmorderHeaderInfo.BAddress = txtBAddress.text;
    gmorderHeaderInfo.BCity = txtBCity.text;
    gmorderHeaderInfo.BState = txtBState.text;
    gmorderHeaderInfo.BZip = txtBZip.text;
    gmorderHeaderInfo.BPhoneFax = txtBPhone.text;
    gmorderHeaderInfo.ShipTo = txtShipTo.text;
    gmorderHeaderInfo.SAddress = txtSAddress.text;
    gmorderHeaderInfo.SCity = txtSCity.text;
    gmorderHeaderInfo.SState = txtSState.text;
    gmorderHeaderInfo.SZip = txtSZip.text;
    gmorderHeaderInfo.DateToShip = txtShipDate.text;
    gmorderHeaderInfo.DateToCancel = txtCancelDate.text;
    gmorderHeaderInfo.PONum = txtPurchaseOrder.text;
    
    [GMOrderHeader updateOrderHeader:gmorderHeaderInfo];
}

#pragma mark - Other methods

- (void)receiveTestNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"GMUpdateData"]) {
        [self viewWillAppear:YES];
    }
}

- (IBAction)btnSaveOrder:(id)sender {
    [self saveData];
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    [self.navigationController popToViewController:[allViewControllers objectAtIndex:1] animated:YES];
    NSLog(@"data saved!");
}

- (void)tapped {
    [self.view endEditing:YES];
}

- (IBAction)btnSetCustomer:(id)sender {
    CustomerTableVC *customerView = [self.storyboard instantiateViewControllerWithIdentifier:@"customerTable"];
    customerView.status = GM;
    customerView.gmorderHeaderInfo = gmorderHeaderInfo;
    [self.navigationController pushViewController:customerView animated:YES];
}

- (IBAction)btnChangeCustomer:(id)sender {
    CustomerTableVC *customerView = [self.storyboard instantiateViewControllerWithIdentifier:@"customerTable"];
    customerView.status = GM;
    customerView.gmorderHeaderInfo = gmorderHeaderInfo;
    [self.navigationController pushViewController:customerView animated:YES];
}

- (IBAction)btnSetStore:(id)sender {
    EditDetailScreenVC *editDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDetailScreen"];
    editDetailView.gmorderHeaderInfo = gmorderHeaderInfo;
    editDetailView.type = @"GMStore";
    editDetailView.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentViewController:editDetailView animated:YES completion:nil];
}

- (IBAction)btnChangeStore:(id)sender {
    EditDetailScreenVC *editDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDetailScreen"];
    editDetailView.gmorderHeaderInfo = gmorderHeaderInfo;
    editDetailView.type = @"GMStore";
    editDetailView.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentViewController:editDetailView animated:YES completion:nil];
}

- (IBAction)btnShipMethod:(id)sender {
    EditDetailScreenVC *editDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDetailScreen"];
    editDetailView.gmorderHeaderInfo = gmorderHeaderInfo;
    editDetailView.type = @"GMShipMethod";
    editDetailView.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentViewController:editDetailView animated:YES completion:nil];
}

- (IBAction)btnChangeShipMethod:(id)sender {
    EditDetailScreenVC *editDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDetailScreen"];
    editDetailView.gmorderHeaderInfo = gmorderHeaderInfo;
    editDetailView.type = @"GMShipMethod";
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
    editDetailView.type = @"GMShipDate";
    editDetailView.gmorderHeaderInfo = gmorderHeaderInfo;
    changed = @"YES";
    editDetailView.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentViewController:editDetailView animated:YES completion:nil];
}

- (IBAction)btnSetCancelDate:(id)sender {
    [self SetCancelDate];
}
- (IBAction)btnChangeCancelDate:(id)sender {
    [self SetCancelDate];
}

- (void)SetCancelDate {
    EditDateScreenVC *editDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDateScreen"];
    editDetailView.type = @"GMCancelDate";
    editDetailView.gmorderHeaderInfo = gmorderHeaderInfo;
    cancel = @"YES";
    editDetailView.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentViewController:editDetailView animated:YES completion:nil];
}

@end

