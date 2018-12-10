//
//  IPSettingsViewController.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/2/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPSettingsViewController : UIViewController <UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *txtIPAddress;
@property (retain, nonatomic) IBOutlet UITextField *txtPort;

- (IBAction)ipChanged:(id)sender;
- (IBAction)portChanged:(id)sender;
- (IBAction)btnBack:(id)sender;

@property (nonatomic, retain) NSMutableArray *usersArray;


@end
