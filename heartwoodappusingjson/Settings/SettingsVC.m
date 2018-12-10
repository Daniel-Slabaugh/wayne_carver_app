//
//  SettingsVC.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/1/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "SettingsVC.h"
#import "GlobalVariables.h"
#import "IPSettingsViewController.h"
#import "Sync.h"
#import "SVProgressHUD.h"

#import "User.h"
#import "Customer.h"
#import "Address.h"
#import "Item.h"
#import "Name.h"

#import "OrderHeader.h"
#import "OrderLine.h"
#import "OrderDetail.h"

#import "WayneOrderHeader.h"
#import "WayneOrderLine.h"

#import "GMItem.h"
#import "GMOrderHeader.h"
#import "GMOrderLine.h"

#import "AttemptedOrdersVC.h"
#import "TrackingNumber.h"

#define RESYNC      @"Resync"
#define LOGOUT      @"Logout"
#define CLEAR       @"ClearData"
#define ATTEMPT     @"AttemptedOrders"


@interface SettingsVC ()

@end

@implementation SettingsVC
@synthesize action;

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
    
    
    // notification for post working
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"ResyncDone"
                                               object:nil];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnResync:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Re-sync"
                                                    message:@"Enter Username and Password"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Re-sync", nil];
    action = RESYNC;
    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput]; // Gives us the username and password password field
    [alert show];
}

- (IBAction)btnLogout:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout?"
                                                    message:@"Are you sure you want to log out"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Logout", nil];
    action = LOGOUT;
    [alert setAlertViewStyle:UIAlertViewStyleDefault]; // Gives us the username and password password field
    [alert show];
}

- (IBAction)btnAttemptedOrders:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Acess Ateempted Orders:"
                                                    message:@"This is only in case of a porgram bug, only acess this after you have talked to a waynecarver employee, they will give you the password"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"View", nil];
    [alert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    action = ATTEMPT;
    [alert show];
}

- (IBAction)btnClearData:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear All Data?"
                                                    message:@"Are you sure you want to clear all data? You will lose everything including saved orders."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Clear", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    action = CLEAR;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        
        if ([action isEqual:ATTEMPT])
        {
#warning here is the password for the attempted orders
            
            if([[[alertView textFieldAtIndex:0] text] isEqualToString: @"test"])
            {
                AttemptedOrdersVC *AOView = [self.storyboard instantiateViewControllerWithIdentifier:@"attemptedOrders"];
                [self.navigationController pushViewController:AOView animated:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong Password"
                                                                message:@"You entered a wrong password, have you checked with a wayne carver employee?"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
            }
        } else if ([action isEqual:RESYNC])
        {
            [self resync:[[alertView textFieldAtIndex:0] text] withPassword:[[alertView textFieldAtIndex:1] text]];
        } else if([action isEqual:CLEAR]) {
            NSLog(@"Clearing...");
            [User deleteAllUsers];
            [Customer deleteAllCustomers];
            [Address deleteAllAddresses];
            [Item deleteAllItems];
            [Name deleteAllNames];
            [OrderHeader deleteAllOrderHeaders];
            [OrderLine deleteAllOrderLines];
            [OrderDetail deleteAllOrderDetails];
            [WayneOrderHeader deleteAllOrderHeaders];
            [WayneOrderLine deleteAllOrderLines];
            [GMItem deleteAllItems];
            [GMOrderHeader deleteAllOrderHeaders];
            [GMOrderLine deleteAllOrderLines];
            [TrackingNumber deleteAllTrackingNumbers];
            editSubmitAsk = @"YES";
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"Logging out...");
            [User deleteAllUsers];
            [Customer deleteAllCustomers];
            [Address deleteAllAddresses];
            [Item deleteAllItems];
            [Name deleteAllNames];
//            No longer deleting order info. Instead, this info is still stored and only displayed when the correct user is signed in.
//            [OrderHeader deleteAllOrder
//            [OrderLine deleteAllOrderLines];
//            [OrderDetail deleteAllOrderDetails];
//            [GMOrderHeader deleteAllOrderHeaders];
//            [GMOrderLine deleteAllOrderLines];
            [WayneOrderHeader deleteAllOrderHeaders];
            [WayneOrderLine deleteAllOrderLines];
            [GMItem deleteAllItems];
            editSubmitAsk = @"YES";
            NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
            [self.navigationController popToViewController:[allViewControllers objectAtIndex:0] animated:YES];
        }
    }
}

- (IBAction)btnEditIP:(id)sender {
    [self performSegueWithIdentifier:@"ip" sender:self];    
}

- (void)resync:(NSString *)user withPassword:(NSString *)pass {
    Sync *sync = [Sync alloc];
    [sync syncAll:user withPassword:pass reSync:YES];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)receiveTestNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"ResyncDone"]) {
        [SVProgressHUD showSuccessWithStatus:@"Sucessfully Resynced"];
        [SVProgressHUD dismiss];
    }
}


@end
