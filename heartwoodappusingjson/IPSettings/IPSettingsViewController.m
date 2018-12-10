//
//  IPSettingsViewController.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/2/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "IPSettingsViewController.h"
#import "User.h"
#import "IP.h"

@interface IPSettingsViewController ()



@end

@implementation IPSettingsViewController
@synthesize txtIPAddress;
@synthesize txtPort;
@synthesize usersArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    txtIPAddress.delegate = self;
    txtPort.delegate = self;
    
	// Do any additional setup after loading the view.
    txtIPAddress.text = [IP getIP];
    txtPort.text = [IP getPort];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
	for (UIView* view in self.view.subviews) {
		if ([view isKindOfClass:[UITextField class]])
			[view resignFirstResponder];
	}
}




- (IBAction)ipChanged:(id)sender {
    [IP setIP:txtIPAddress.text];
}

- (IBAction)portChanged:(id)sender {
    [IP setPort:txtPort.text];
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}
@end
