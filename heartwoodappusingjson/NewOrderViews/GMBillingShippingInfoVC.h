//
//  GMBillingShippingInfoVC.h
//  wayne mobile
//
//  Created by Delphi Dev Computer on 6/12/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Customer.h"
#import "Address.h"
#import "GMOrderHeader.h"
#import "GMOrderLine.h"


@interface GMBillingShippingInfoVC : UIViewController <UIScrollViewDelegate, UITextFieldDelegate>
{
    IBOutlet UIScrollView *scrollView;
}

@property (retain, nonatomic) GMOrderHeader * gmorderHeaderInfo;
@property (nonatomic, retain) NSMutableArray * pickerShipTypeArray;
@property (retain, nonatomic) Customer * customerInfo;
@property (retain, nonatomic) Address * addressInfo;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSString *alertAction;
@property (nonatomic) BOOL customer;
@property (nonatomic) BOOL address;

//Bill to
@property (retain, nonatomic) IBOutlet UITextField *txtBillTo;
@property (retain, nonatomic) IBOutlet UITextField *txtBAddress;
@property (retain, nonatomic) IBOutlet UITextField *txtBCity;
@property (retain, nonatomic) IBOutlet UITextField *txtBState;
@property (retain, nonatomic) IBOutlet UITextField *txtBZip;
@property (retain, nonatomic) IBOutlet UITextField *txtBPhone;

//Ship to
@property (retain, nonatomic) IBOutlet UITextField *txtShipTo;
@property (retain, nonatomic) IBOutlet UITextField *txtSAddress;
@property (retain, nonatomic) IBOutlet UITextField *txtSCity;
@property (retain, nonatomic) IBOutlet UITextField *txtSState;
@property (retain, nonatomic) IBOutlet UITextField *txtSZip;

//Customer
@property (retain, nonatomic) IBOutlet UIButton *btnSetCustomer;
- (IBAction)btnSetCustomer:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnChangeCustomer;
- (IBAction)btnChangeCustomer:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lblSetCustomer;
@property (retain, nonatomic) IBOutlet UILabel *lblEnterCustomer;

//Store
@property (retain, nonatomic) IBOutlet UIButton *btnSetStore;
- (IBAction)btnSetStore:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnChangeStore;
- (IBAction)btnChangeStore:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lblSetStore;
@property (retain, nonatomic) IBOutlet UILabel *lblEnterShip;

//Ship method
@property (retain, nonatomic) IBOutlet UIButton *btnShipMethod;
- (IBAction)btnShipMethod:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnChangeShipMethod;
- (IBAction)btnChangeShipMethod:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lblShipMethod;

- (IBAction)btnSave:(id)sender;
- (IBAction)btnClear:(id)sender;

@property (retain, nonatomic) IBOutlet UITextField *txtShipDate;
@property (retain, nonatomic) IBOutlet UITextField *txtCancelDate;
@property (retain, nonatomic) IBOutlet UITextField *txtPurchaseOrder;


//Not using these methods at this time

//Ship Date
@property (retain, nonatomic) IBOutlet UIButton *btnSetShipDate;
- (IBAction)btnSetShipDate:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnChangeShipDate;
- (IBAction)btnChangeShipDate:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lblShipDate;
@property (retain, nonatomic) NSString *changed;


//Cancel Date
@property (retain, nonatomic) IBOutlet UIButton *btnSetCancelDate;
- (IBAction)btnSetCancelDate:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnChangeCancelDate;
- (IBAction)btnChangeCancelDate:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lblCancelDate;
@property (retain, nonatomic) NSString *cancel;


@end
