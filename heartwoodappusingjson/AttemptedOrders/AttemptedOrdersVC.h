//
//  ItemTableVC.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/16/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttemptedOrdersVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * AttOrdTableView;
}

- (IBAction)btnback:(id)sender;



@end
