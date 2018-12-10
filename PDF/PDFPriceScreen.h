//
//  PDFPriceScreen.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 11/26/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderHeader.h"
#import "GMOrderHeader.h"

@interface PDFPriceScreen : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * editDetailTableView;
    UITableViewCell *cellSelected;
}

@property (nonatomic, retain) NSMutableArray * tableArray;
@property (nonatomic, retain) OrderHeader * orderHeaderInfo;
@property (nonatomic, retain) GMOrderHeader * gmorderHeaderInfo;
@property (retain, nonatomic) UITableViewCell * cellSelected;
@property (nonatomic, retain) NSString * type;

- (IBAction)btnBack:(id)sender;
- (IBAction)btnSummary:(id)sender;

@end


