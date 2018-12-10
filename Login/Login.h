//
//  Login.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 8/31/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Login : UIViewController

@property(nonatomic, retain) NSString *message;


@property (retain, nonatomic) IBOutlet UILabel *lblLogin;
@property (retain, nonatomic) IBOutlet UITextField *txtLogin;
@property (retain, nonatomic) IBOutlet UIButton *btnLogin;
- (IBAction)btnLogin:(id)sender;
- (IBAction)btnLogout:(id)sender;
@end
