//
//  GMEditingTableVC.h
//  wayne mobile
//
//  Created by Delphi Dev Computer on 7/24/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMEditingTableVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * orderTableView;
}

@property (nonatomic, retain) NSMutableArray * ordersArray;
@property (nonatomic, retain) NSString * status;
@property (nonatomic) BOOL NoOrders;

- (IBAction)btnBack:(id)sender;

@end