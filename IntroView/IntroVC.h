//
//  HeartwoodAppIntroViewController.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 6/25/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroVC : UIViewController <UITextFieldDelegate>



@property (retain, nonatomic) IBOutlet UITextField *txtUsername;
@property (retain, nonatomic) IBOutlet UITextField *txtPassword;
@property (retain, nonatomic) IBOutlet UIButton *btnIP;
@property (retain, nonatomic) IBOutlet UILabel *lblVersion;
@property (retain, nonatomic) IBOutlet UIButton *btnLogout;
@property (retain, nonatomic) IBOutlet UIButton *btnLogin;

@property (nonatomic, retain) NSMutableArray *usersArray;

- (IBAction)btnTry:(id)sender;
- (IBAction)btnLogout:(id)sender;


-(void)recievedData:(NSString*)theUser withPassword:(NSString*)thePassword;



@end
