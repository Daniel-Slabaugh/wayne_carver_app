//
//  AddressInfoVC.m
//  wayne mobile
//
//  Created by Daniel Slabaugh on 7/27/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "AddressInfoVC.h"
#import "User.h"

@interface AddressInfoVC ()

@end

@implementation AddressInfoVC
@synthesize lblMADDR1;
@synthesize lblSADDR1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    NSMutableArray *userArray = [User getAllUsers];
    User *user = [userArray objectAtIndex:0];

    //set label info
    // mail
    
    lblMADDR1.text = user.MailADDR1;
    if (![user.MailADDR2 isEqual:@"<null>"]) {
        lblMADDR1.text = [NSString stringWithFormat:@"%@\n%@", lblMADDR1.text, user.MailADDR2];
    }
    lblMADDR1.text = [NSString stringWithFormat:@"%@\n%@, %@\n%@\n%@", lblMADDR1.text, user.MailCity, user.MailState, user.MailZip, user.MailCountry];

    // ship
    lblSADDR1.text = user.ShipADDR1;
    if (![user.ShipADDR2 isEqual:@"<null>"]) {
        lblSADDR1.text = [NSString stringWithFormat:@"%@\n%@", lblSADDR1.text, user.ShipADDR1];
    }
    
    lblSADDR1.text = [NSString stringWithFormat:@"%@\n%@, %@\n%@\n%@", lblSADDR1.text, user.ShipCity, user.ShipState, user.ShipZip, user.ShipCountry];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end