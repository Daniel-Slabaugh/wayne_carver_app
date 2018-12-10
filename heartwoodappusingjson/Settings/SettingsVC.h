//
//  SettingsVC.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/1/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsVC : UIViewController 


- (IBAction)btnClearData:(id)sender;
- (IBAction)btnResync:(id)sender;
- (IBAction)btnEditIP:(id)sender;
- (IBAction)btnLogout:(id)sender;
- (IBAction)btnAttemptedOrders:(id)sender;

- (void)resync:(NSString *)username withPassword:(NSString *)password;

@property (nonatomic, retain) NSString *action;

@end
