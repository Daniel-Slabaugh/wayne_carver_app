//
//  EditingTableVC.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/24/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditingTableVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * orderTableView;
}

@property (nonatomic, retain) NSMutableArray * ordersArray;
@property (nonatomic, retain) NSString * status;
@property (nonatomic) BOOL NoOrders;

- (IBAction)btnBack:(id)sender;

@end