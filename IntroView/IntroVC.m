//
//  HeartwoodAppIntroViewController.m
//  HeartwoodAppUsingJson
//
//  Created by Daniel Slabaugh on 6/25/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "IntroVC.h"
#import "GlobalVariables.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "DeviceIdentifiers.h"
#import "Sync.h"
#import "IP.h"

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


@interface IntroVC ()

@end

@implementation IntroVC
@synthesize txtPassword;
@synthesize txtUsername;
@synthesize usersArray;
@synthesize btnIP;
@synthesize lblVersion;
@synthesize btnLogin;
@synthesize btnLogout;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"SyncDone"
                                               object:nil];
    // Do any additional setup after loading the view.
    needsSync = false;
    txtUsername.delegate = self;
    txtPassword.delegate = self;
    lblVersion.text = [NSString stringWithFormat:@"Ver %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

- (void) viewWillAppear:(BOOL) animated {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.dontShow = YES;
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    //get user from database if there is a user
    self.usersArray = [User getAllUsers];
    //disable ip access there is a user
    if ([usersArray count] != 0) {
        User *user = [self.usersArray objectAtIndex:0];
        txtUsername.text = user.UserID;
        [txtUsername setEnabled:NO];
        [btnIP setEnabled:NO];
        [btnIP setHidden:YES];
        [btnLogout setEnabled:YES];
        [btnLogout setHidden:NO];
        [btnLogin setTitle:@"Sign in" forState:UIControlStateNormal];
        [btnLogin setTitle:@"Sign in" forState:UIControlStateHighlighted];
    } else {
        txtUsername.text = @"";
        [txtUsername setEnabled:YES];
        [btnIP setEnabled:YES];
        [btnIP setHidden:NO];
        [btnLogout setEnabled:NO];
        [btnLogout setHidden:YES];
        [btnLogin setTitle:@"Login" forState:UIControlStateNormal];
        [btnLogin setTitle:@"Login" forState:UIControlStateHighlighted];
    }
}

- (IBAction)btnTry:(id)sender {
    self.usersArray = [User getAllUsers];
    if ([usersArray count] != 0) {
        User *user = [self.usersArray objectAtIndex:0];
        
        if ([txtPassword.text isEqual: user.Password] && [[txtUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqual: user.UserID]) {
            [self performSegueWithIdentifier:@"mainView" sender:self];
            txtPassword.text = @"";
        }
        else if ([[txtUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqual: user.UserID]) {
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"Wrong Password" message:@"Please Try Again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            NSLog(@"username is %@, and is supposed to be %@. Password is %@, and is supposed to be %@", txtUsername.text, user.UserID, txtPassword.text, user.Password);
            txtPassword.text = @"";
            txtUsername.text = user.UserID;
        } else {
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"Wrong UserName and/or Password" message:@"Please Try Again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            NSLog(@"username is %@, and is supposed to be %@. Password is %@, and is supposed to be %@", txtUsername.text, user.UserID, txtPassword.text, user.Password);
            txtPassword.text = @"";
            txtUsername.text = @"";
        }
    } else {
        Sync *sync = [Sync alloc];
        [sync syncAll:[txtUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] withPassword:txtPassword.text reSync:NO];
    }
}

- (IBAction)btnLogout:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout?"
                                                    message:@"Are you sure you want to log out"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Logout", nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault]; // Gives us the username and password password field
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.dontShow = NO;
}

-(void)recievedData:(NSString*)theUser withPassword:(NSString*)thePassword {
    self.usersArray = [User getAllUsers];
    if ([usersArray count] != 0) {
        User *user = [self.usersArray objectAtIndex:0];
        if ([thePassword isEqual:user.Password] && [theUser isEqual:user.UserID]) {
            [self performSegueWithIdentifier:@"mainView" sender:self];
        }
        else if ([theUser isEqual:user.UserID]) {
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"Wrong Password" message:@"Please Try Again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            NSLog(@"After Sync: username is %@, and is supposed to be %@. Password is %@, and is supposed to be %@", theUser, user.UserID, thePassword, user.Password);
            txtPassword.text = @"";
        } else {
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"Wrong UserName" message:@"Please Try Again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            NSLog(@"After Sync: username is %@, and is supposed to be %@. Password is %@, and is supposed to be %@", theUser, user.UserID, thePassword, user.Password);
            txtUsername.text = @"";
        }
    }
    txtPassword.text = @"";
}

- (void) receiveTestNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"SyncDone"])
    {
        [self recievedData:[txtUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] withPassword:[txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        NSLog (@"SyncDone!");
    }
}

#pragma methods for keyboard

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]])
            [view resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if(theTextField == txtUsername){
        [txtPassword becomeFirstResponder];
    } else {
        [theTextField resignFirstResponder];
    }
    return YES;
}

#pragma alertview

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"Logging out...");
        [User deleteAllUsers];
        [Customer deleteAllCustomers];
        [Address deleteAllAddresses];
        [Item deleteAllItems];
        [Name deleteAllNames];
//      No longer deleting order info. Instead, this info is still stored and only displayed when the correct user is signed in.
//      [OrderHeader deleteAllOrder
//      [OrderLine deleteAllOrderLines];
//      [OrderDetail deleteAllOrderDetails];
        [WayneOrderHeader deleteAllOrderHeaders];
        [WayneOrderLine deleteAllOrderLines];
        txtUsername.text = @"";
        [btnIP setEnabled:YES];
        [btnIP setHidden:NO];
        [btnLogout setEnabled:NO];
        [btnLogout setHidden:YES];
        btnLogin.titleLabel.text = @"Login";
        [txtUsername setEnabled:YES];
        editSubmitAsk = @"YES";
    }
}

//- (IBAction)btnSyncStores:(id)sender {
//    Sync *sync = [[Sync alloc] init];
//    [sync syncWayneOrderLines
//     :txtUsername.text withPassword:txtPassword.text];
////    [self performSegueWithIdentifier:@"mainView" sender:self];
//}

@end
