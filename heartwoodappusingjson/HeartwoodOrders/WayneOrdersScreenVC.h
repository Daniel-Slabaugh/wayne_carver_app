//
//  WayneOrdersScreenVC.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 8/6/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WayneOrderHeader.h"

@interface WayneOrdersScreenVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * orderLineView;
}

@property (nonatomic, retain) WayneOrderHeader * orderHeaderInfo;
@property (nonatomic, retain) NSMutableArray * orderLineArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

- (IBAction)btnBack:(id)sender;
- (IBAction)btnExit:(id)sender;
- (IBAction)btnCreatePdf:(id)sender;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UILabel *lblStatus;
@property (retain, nonatomic) IBOutlet UILabel *lblWayneRep;
@property (retain, nonatomic) IBOutlet UILabel *lblMessage;
@property (retain, nonatomic) IBOutlet UILabel *lblCustomer;
@property (retain, nonatomic) IBOutlet UILabel *lblPONum;
@property (retain, nonatomic) IBOutlet UILabel *lblTerms;
@property (retain, nonatomic) IBOutlet UILabel *lblAccepted;
@property (retain, nonatomic) IBOutlet UILabel *lblShipDate;
- (IBAction)btnShowDetails:(id)sender;
- (IBAction)btnTrackingNumbers:(id)sender;

//money
@property (retain, nonatomic) IBOutlet UILabel *lblTotal;

@end
