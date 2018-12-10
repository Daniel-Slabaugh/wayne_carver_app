//
//  WayneOrdersCustomerTableVC.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 8/12/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WayneOrderHeader.h"

@interface WayneOrdersCustomerTableVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * customerTableView;
}

- (IBAction)btnback:(id)sender;

@property (nonatomic, retain) WayneOrderHeader * orderInfo;
@property (nonatomic, strong) NSArray* allTableData;
@property (nonatomic, retain) NSString * sortType;


@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *dateRec;
@property (nonatomic, strong) NSDate *dateAcc;

@end
