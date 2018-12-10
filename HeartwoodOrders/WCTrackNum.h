//
//  WCTrackNum.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 06/09/2014.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WayneOrderHeader.h"
#import "TrackingNumber.h"

@interface WCTrackNum : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * editDetailTableView;
    UITableViewCell *cellSelected;
}

@property (nonatomic, retain) NSMutableArray * tableArray;
@property (nonatomic, retain) WayneOrderHeader * orderHeaderInfo;
@property (retain, nonatomic) UITableViewCell *cellSelected;

- (IBAction)btnBack:(id)sender;
- (IBAction)btnSummary:(id)sender;

@end


