//
//  GMOrderOverviewVC.h
//  wayne mobile
//
//  Created by Delphi Dev Computer on 6/12/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quartzcore/QuartzCore.h>
#import "GMOrderHeader.h"

@interface GMOrderOverviewVC : UIViewController <UITextFieldDelegate, UIActionSheetDelegate>
{
    IBOutlet UITextView *txtNotes;
}

@property (nonatomic, retain) GMOrderHeader * orderHeader;
@property (nonatomic, strong) NSString *alertAction;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSMutableArray * orderLineArray;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UIButton *btnBillingShipping;
@property (retain, nonatomic) IBOutlet UIButton *btnPickItems;
@property (retain, nonatomic) IBOutlet UILabel *lblBillingShipping;
@property (retain, nonatomic) IBOutlet UILabel *lblPickItems;

- (IBAction)btnBillingShipping:(id)sender;
- (IBAction)btnPickItems:(id)sender;
- (IBAction)btnSave:(id)sender;
- (IBAction)btnDeleteOrder:(id)sender;
- (IBAction)btnCreatePDF:(id)sender;
- (IBAction)btnPostOrder:(id)sender;
- (IBAction)btnGMReminders:(id)sender;

@end
