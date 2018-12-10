//
//  WCDateScreenVC.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 11/27/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderHeader.h"

@interface WCDateScreenVC : UIViewController

//Setting Date


@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) OrderHeader * orderHeaderInfo;


@property (retain, nonatomic) IBOutlet UIDatePicker *pickerView;
@property (retain, nonatomic) IBOutlet UILabel *txtDate;
@property (retain, nonatomic) IBOutlet UILabel *txtShown;
- (IBAction)btnDone:(id)sender;

@end
