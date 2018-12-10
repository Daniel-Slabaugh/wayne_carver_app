//
//  EditingScreenVC.h
//  wayne mobile
//
//  Created by Daniel Slabaugh on 7/24/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderHeader.h"

@interface EditingScreenVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate, UITextFieldDelegate>
{
    IBOutlet UITableView * orderLineView;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextView *txtNotes;
}

@property (nonatomic, retain) OrderHeader * orderHeaderInfo;
@property (nonatomic, retain) NSMutableArray * orderLineArray;
@property (nonatomic, retain) NSMutableArray * pickerShipTypeArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSString *alertAction;

@property (retain, nonatomic) IBOutlet UILabel *lblDateStarted;
@property (retain, nonatomic) IBOutlet UILabel *lblSalesman;
@property (retain, nonatomic) IBOutlet UILabel *lblCustomer;

//Store
@property (retain, nonatomic) IBOutlet UIButton *btnSetStore;
- (IBAction)btnSetStore:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnChangeStore;
- (IBAction)btnChangeStore:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lblSetStore;

//Ship method
@property (retain, nonatomic) IBOutlet UIButton *btnShipMethod;
- (IBAction)btnShipMethod:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnChangeShipMethod;
- (IBAction)btnChangeShipMethod:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lblShipMethod;

//Ship Date
@property (retain, nonatomic) IBOutlet UIButton *btnSetShipDate;
- (IBAction)btnSetShipDate:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnChangeShipDate;
- (IBAction)btnChangeShipDate:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lblShipDate;
@property (retain, nonatomic) NSString *changed;

@property (retain, nonatomic) IBOutlet UITextField *txtPONumber;
- (IBAction)txtPONumEditBegin:(id)sender;

- (IBAction)btnBack:(id)sender;
- (IBAction)btnPostOrder:(id)sender;
- (IBAction)btnSaveOrder:(id)sender;
- (IBAction)btnDeleteOrder:(id)sender;
- (IBAction)btnCreatePDF:(id)sender;

-(void)saveData;

@end