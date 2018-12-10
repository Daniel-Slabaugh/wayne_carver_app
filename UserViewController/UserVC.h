//
//  HeartwoodAppUserViewController.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/3/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface UserVC : UIViewController
{
    Reachability *internetReachableFoo;
}


@property (nonatomic, retain) NSMutableArray *usersArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (retain, nonatomic) IBOutlet UILabel *lblWelcome;
@property (retain, nonatomic) IBOutlet UIButton *btnNeedAttention;
@property (retain, nonatomic) IBOutlet UIButton *btnNeedAttnSub;
@property (retain, nonatomic) IBOutlet UILabel *lblRepID;


@property (nonatomic, retain) NSString *action;


- (IBAction)btnNewOrder:(id)sender;
- (IBAction)btnEditOrders:(id)sender;
- (IBAction)btniPadOrders:(id)sender;
- (IBAction)btnSubmittedOrders:(id)sender;
- (IBAction)btnWebsite:(id)sender;
- (IBAction)btnContactInfo:(id)sender;
- (IBAction)btnShippingInfo:(id)sender;
- (IBAction)btnTutorialVideo:(id)sender;
- (IBAction)btnViewUnshippedOrders:(id)sender;
- (IBAction)btnNeedAttention:(id)sender;




@end
