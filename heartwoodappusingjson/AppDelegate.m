//
//  AppDelegate.m
//  wayne mobile
//
//  Created by Daniel Slabaugh on 5/30/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//


#import "AppDelegate.h"
#import "GlobalVariables.h"
#import "IntroVC.h"
#import "DeviceIdentifiers.h"
#import "Login.h"
#import "IP.h"

//db tables
#import "User.h"
#import "DBManager.h"



@implementation AppDelegate



@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize dontShow;
@synthesize alertString;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    BOOL yesno = [DBManager initDatabase];
    if (yesno) {
        NSLog(@"Database opened Correctly");
    } else {
        NSLog(@"Problem With Database");
    }
    //set preference values
    [IP setValuesFromPreferences];
    
    //ask about tutorial first time.
    [self application:application];
    //reset alertview to notify about unsubmitted orders
    editSubmitAsk = @"YES";
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
#warning CHEKCING LOGIN
    // for uialertveiw password checking. No longer using
    //    wrongPassword = @"";
    //    [self presentAlertViewForPassword];
    
    
    UIViewController *topController = [self topViewControllerWithRootViewController:UIApplication.sharedApplication.delegate.window.rootViewController];
    // if  a formsheet is alerady displaying we need to hide it and then display login formsheet
    if (topController.modalPresentationStyle == UIModalPresentationFormSheet) {
        [topController dismissViewControllerAnimated:YES completion:^(void) {
            UIViewController *viewcont = [self topViewControllerWithRootViewController:UIApplication.sharedApplication.delegate.window.rootViewController];
            Login *login = [viewcont.storyboard instantiateViewControllerWithIdentifier:@"login"];
            login.modalPresentationStyle = UIModalPresentationFormSheet;
            [viewcont.navigationController presentViewController:login animated:YES completion:nil];
        }];
    } else {
        
        Login *login = [topController.storyboard instantiateViewControllerWithIdentifier:@"login"];
        login.modalPresentationStyle = UIModalPresentationFormSheet;
        [topController.navigationController presentViewController:login animated:YES completion:nil];
    }
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)presentAlertViewForPassword
{
    NSMutableArray *users = [User getAllUsers];
    if ([users count] != 0 && !dontShow) {
        User *user = [users objectAtIndex:0];
        NSString *message = [NSString stringWithFormat:@"%@Please enter %@ %@'s password.",
                             wrongPassword,
                             [user.FirstName stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]],
                             [user.LastName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        // The device is an iPhone or iPod touch.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter Password"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Enter"
                                              otherButtonTitles:nil];
        [alert setAlertViewStyle:UIAlertViewStyleSecureTextInput]; // Gives us the password field
        [alert show];
        dontShow = YES;
        alertString = @"USER";
        wrongPassword = @"";
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://youtu.be/un-mZ3WoNxU"]];
        
    } else if ([alertString isEqualToString:@"USER"]) {
        dontShow = NO;
        NSMutableArray *users = [User getAllUsers];
        User *user = [users objectAtIndex:0];
        
        password = [[alertView textFieldAtIndex:0] text];
        if (![password isEqual: user.Password]) {
            wrongPassword = @"Wrong Password. ";
            [self presentAlertViewForPassword];
        }
    }
}


- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"notFirstRun"]) {
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        if( [inputText length] >= 1 )
        {
            return YES;
        }
        else
        {
            return NO;
        }
    } else {
        return YES;
    }
}




-(void)application:(UIApplication *)application {
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
//    if (! [defaults boolForKey:@"notFirstRun"]) {
//        // display alert...
//        NSString *message = @"Have you watched the tutorial? It is very important that you do!";
//        // The device is an iPhone or iPod touch.
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tutorial?"
//                                                        message:message
//                                                       delegate:self
//                                              cancelButtonTitle:@"Yes"
//                                              otherButtonTitles:@"NO", nil];
//        [alert setAlertViewStyle:UIAlertViewStyleDefault];
//        [alert show];
//        [defaults setBool:YES forKey:@"notFirstRun"];
//        alertString = @"FIRST";
//    }
    // rest of initialization ...
    
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

#warning network test..
@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}

@end
