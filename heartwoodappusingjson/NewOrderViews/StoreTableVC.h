//
//  StoreTableVC.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/5/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Customer.h"

@interface StoreTableVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * storeTableView;
}

@property (nonatomic, retain) Customer * customerInfo;
@property (nonatomic, retain) NSMutableArray * storesArray;

- (IBAction)btnBack:(id)sender;

@end

