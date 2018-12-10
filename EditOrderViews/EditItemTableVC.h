//
//  EditItemTableVC.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/26/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderHeader.h"
#import "OrderLine.h"

@interface EditItemTableVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * itemTableView;
}
- (IBAction)btnback:(id)sender;

@property (nonatomic, retain) OrderHeader * orderHeaderInfo;
@property (nonatomic, retain) NSMutableArray * orderLines;
@property (nonatomic, retain) NSMutableArray * itemsArray;

@end