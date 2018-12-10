//
//  PostedScreenVC.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 11/26/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderHeader.h"

@interface PostedScreenVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextViewDelegate, UIActionSheetDelegate, UITextFieldDelegate>
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
@property (retain, nonatomic) IBOutlet UILabel *lblMessage;

//Store
@property (retain, nonatomic) IBOutlet UILabel *lblSetStore;

//Ship method
@property (retain, nonatomic) IBOutlet UILabel *lblShipMethod;

//Ship Date
@property (retain, nonatomic) IBOutlet UILabel *lblShipDate;

@property (retain, nonatomic) IBOutlet UITextField *txtPONumber;

- (IBAction)btnBack:(id)sender;
- (IBAction)btnPostOrder:(id)sender;
- (IBAction)btnDeleteOrder:(id)sender;
- (IBAction)btnCreatePDF:(id)sender;

@end