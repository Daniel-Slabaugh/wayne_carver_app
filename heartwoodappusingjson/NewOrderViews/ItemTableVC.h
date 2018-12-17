//
//  ItemTableVC.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/16/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Customer.h"
#import "Address.h"

@interface ItemTableVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * itemTableView;
}

- (IBAction)btnback:(id)sender;

@property (nonatomic, retain) Customer * customerInfo;
@property (nonatomic, retain) Address * addressInfo;
@property (nonatomic, retain) NSMutableArray * itemsArray;


@end
