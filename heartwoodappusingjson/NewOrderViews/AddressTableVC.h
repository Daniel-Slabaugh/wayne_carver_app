//
//  AddressTableVC
//  wayne mobile
//
//  Created by Daniel Slabaugh on 12/14/18.
//  Copyright (c) 2018 Daniel Slabaugh. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "Customer.h"
#import "Address.h"

@interface AddressTableVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * itemTableView;
}

- (IBAction)btnback:(id)sender;

@property (nonatomic, retain) Customer * customerInfo;
@property (nonatomic, retain) NSMutableArray * addressArray;


@end
