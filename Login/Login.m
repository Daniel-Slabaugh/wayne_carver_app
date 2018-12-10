//
//  Login.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 8/31/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "Login.h"
#import "GlobalVariables.h"

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

#import "IntroVC.h"

@interface Login ()

@end

@implementation Login
@synthesize message;
@synthesize lblLogin;
@synthesize txtLogin;
@synthesize btnLogin;

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
    NSMutableArray *users = [User getAllUsers];
    User *user = [users objectAtIndex:0];
    
    lblLogin.text = [NSString stringWithFormat:@"%@ %@", user.FirstName, user.LastName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnLogin:(id)sender {
    NSMutableArray *users = [User getAllUsers];
    User *user = [users objectAtIndex:0];
    
    if (![txtLogin.text isEqual: user.Password]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong Password"
                                                        message:@"Please try again"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault]; 
        [alert show];
        [txtLogin setText:@""];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)btnLogout:(id)sender {
    NSLog(@"Logging out...");
//    [User deleteAllUsers];
//    [Customer deleteAllCustomers];
//    [Address deleteAllAddresses];
//    [Item deleteAllItems];
//    [Name deleteAllNames];
//    //            No longer deleting order info. Instead, this info is still stored and only displayed when the correct user is signed in.
//    //            [OrderHeader deleteAllOrder
//    //            [OrderLine deleteAllOrderLines];
//    //            [OrderDetail deleteAllOrderDetails];
//    //            [GMOrderHeader deleteAllOrderHeaders];
//    //            [GMOrderLine deleteAllOrderLines];
//    [WayneOrderHeader deleteAllOrderHeaders];
//    [WayneOrderLine deleteAllOrderLines];
//    [GMItem deleteAllItems];
    [self dismissViewControllerAnimated:YES completion:^(void) {
        IntroVC *editOrderScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"Intro"];
        [self.navigationController pushViewController:editOrderScreen animated:YES];
//        UIViewController *topController = [self topViewControllerWithRootViewController:UIApplication.sharedApplication.delegate.window.rootViewController];
//        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[topController.navigationController viewControllers]];
//        [self.navigationController popToViewController:[allViewControllers objectAtIndex:0] animated:YES];
    }];
    editSubmitAsk = @"YES";

}


- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
