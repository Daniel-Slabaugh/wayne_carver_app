//
//  EditDateScreenVC.h
//  wayne mobile
//
//  Created by Daniel Slabaugh on 10/26/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderHeader.h"
#import "GMOrderHeader.h"

@interface EditDateScreenVC : UIViewController

@property (nonatomic, retain) NSString * type;

//Setting Date
- (IBAction)switchAsap:(id)sender;
- (IBAction)btnShipDateInfo:(id)sender;
- (IBAction)switchNotBefore:(id)sender;

@property (retain, nonatomic) IBOutlet UILabel *lblHeader;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) OrderHeader * orderHeaderInfo;
@property (nonatomic, retain) GMOrderHeader * gmorderHeaderInfo;
@property (retain, nonatomic) IBOutlet UILabel *lblBadItemCount;


@property (retain, nonatomic) IBOutlet UILabel *lblAsap;
@property (retain, nonatomic) IBOutlet UILabel *lblNotBefore;
@property (retain, nonatomic) IBOutlet UILabel *lblOptions;
@property (retain, nonatomic) IBOutlet UISwitch *switchAsap;
@property (retain, nonatomic) IBOutlet UISwitch *switchNotBefore;
@property (retain, nonatomic) IBOutlet UIDatePicker *pickerView;
@property (retain, nonatomic) IBOutlet UILabel *txtDate;
- (IBAction)btnDone:(id)sender;

@end
