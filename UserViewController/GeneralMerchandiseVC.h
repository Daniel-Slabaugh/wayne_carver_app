//
//  GeneralMerchandiseVC.h
//  wayne mobile
//
//  Created by Delphi Dev Computer on 6/11/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "Reachability.h"


@interface GeneralMerchandiseVC : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) NSMutableArray *usersArray;



- (IBAction)btniPadOrders:(id)sender;
- (IBAction)btnEdiGMOrd:(id)sender;
- (IBAction)btnNewGMOrd:(id)sender;
- (IBAction)btnGMReminders:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *lblEdtOrd;
@property (retain, nonatomic) NSString  *feedbackMsg;



@end