//
//  NameProgramVC.h
//  wayne mobile
//
//  Created by Delphi Dev Computer on 6/11/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Reachability.h"

@interface NameProgramVC : UIViewController <MFMailComposeViewControllerDelegate>
{
    Reachability *internetReachableFoo;
}


@property (nonatomic, retain) NSMutableArray *usersArray;
@property (retain, nonatomic) IBOutlet UILabel *lblWelcome;
@property (retain, nonatomic) IBOutlet UILabel *lblRepID;
@property (retain, nonatomic) NSString  *feedbackMsg;


- (IBAction)btnNewOrder:(id)sender;
- (IBAction)btnEditOrders:(id)sender;
- (IBAction)btniPadOrders:(id)sender;
- (IBAction)btnSubmittedOrders:(id)sender;
- (IBAction)btnWebsite:(id)sender;
- (IBAction)btnContactInfo:(id)sender;
- (IBAction)btnShippingInfo:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lblEdtOrd;



@end
