//
//  HeartwoodAppUserViewController.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/3/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "UserVC.h"
#import "GlobalVariables.h"
#import "WayneOrdersTableVC.h"
#import "CustomerTableVC.h"
#import "EditingTableVC.h"
#import "WCPDFViewController.h"
#import "WayneWebsiteVC.h"
#import "ContactInfoVC.h"
#import "AddressInfoVC.h"
#import "SVProgressHUD.h"
#import "Sync.h"
#import "WayneOrdersCustomerTableVC.h"
#import "DateLastSynced.h"

#import "User.h"
#import "Customer.h"
#import "Address.h"
#import "OrderHeader.h"
#import "GMOrderHeader.h"
#import "Item.h"
#import "Name.h"

#define DORESYNC      @"DoResync"
#define RESYNC      @"Resync"


@interface UserVC ()

@end

@implementation UserVC
@synthesize usersArray;
@synthesize lblRepID;
@synthesize lblWelcome;
@synthesize dateFormatter;
@synthesize action;
@synthesize btnNeedAttention;
@synthesize btnNeedAttnSub;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.usersArray = [User getAllUsers];
    
    if ([usersArray count] != 0) {
        User *user = [self.usersArray objectAtIndex:0];
        lblWelcome.text = [NSString stringWithFormat:@"Welcome %@ %@!", [user.FirstName stringByTrimmingCharactersInSet:
                                                                         [NSCharacterSet whitespaceCharacterSet]], [user.LastName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        
        // notification for post working
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveTestNotification:)
                                                     name:@"StatusSyncDone"
                                                   object:nil];
        
        // notification for post working
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveTestNotification:)
                                                     name:@"ResyncDone"
                                                   object:nil];
        
        
        lblRepID.text = user.UserID;
        
        
        if ([editSubmitAsk isEqualToString:@"YES"]) {
            
            int tmpCount = 0;
            NSMutableArray *tmpArray = [OrderHeader getAllOrderHeaders];
            NSMutableArray *tmpGMArray = [GMOrderHeader getAllOrderHeaders];
            BOOL show = NO;
            
            for (OrderHeader *tmpHdr in tmpArray) {
                if ([tmpHdr.LocalStatus isEqualToString:@"Edited"] || [tmpHdr.LocalStatus isEqualToString:@"Started"]) {
                    if ([tmpHdr.UserID isEqualToString:user.UserID]) {
                        show = YES;
                        tmpCount++;
                    }
                }
            }
            for (GMOrderHeader *tmpHdr in tmpGMArray) {
                if ([tmpHdr.LocalStatus isEqualToString:@"Edited"] || [tmpHdr.LocalStatus isEqualToString:@"Started"]) {
                    if ([tmpHdr.UserID isEqualToString:user.UserID]) {
                        show = YES;
                        tmpCount++;
                    }
                }
            }
            if (show) {
                NSString *message = [NSString stringWithFormat:@"You have %ld unsubmitted orders on your iPad.", (long)tmpCount];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unsubmitted Orders"
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
            }
            editSubmitAsk = @"NO";
        }
    }
    
    [[self tabBarController] setHidesBottomBarWhenPushed:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    
    
    //do stuff...
    [self testInternetConnection];
    if ([needsSync isEqual:@"true"]) {
        lblWelcome.text = @"PLEASE SYNC!!!";
    } else {
        usersArray = [User getAllUsers];
        if ([usersArray count] != 0) {
            User *user = [self.usersArray objectAtIndex:0];
            lblWelcome.text = [NSString stringWithFormat:@"Welcome %@ %@!", [user.FirstName stringByTrimmingCharactersInSet:
                                                                          [NSCharacterSet whitespaceCharacterSet]], [user.LastName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            lblRepID.text = user.UserID;
        }
    }
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    // Getting time last synced and compariing it to current time
    NSArray *array = [DateLastSynced getAllDatesLastSynced];
    DateLastSynced *dateLastSynced =  [array objectAtIndex:0];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *tmpDateCreated = [dateFormatter dateFromString:dateLastSynced.DateSynced];
    NSDate *tmpDateNow = [NSDate date];
    NSTimeInterval timeSinceLastSync = [tmpDateNow timeIntervalSinceDate:tmpDateCreated];
    NSLog(@"Entry gotten: %@. Time last synced: %@. Time now: %@. Time since Sync: %f", dateLastSynced.DateSynced, tmpDateCreated, tmpDateNow, timeSinceLastSync);
    // if a day has past
    if (timeSinceLastSync > 48000) {
        // display message asking them to resync.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Re-sync?"
                                                        message:@"You haven't updated your iPad in over a day. We recommend you re-sync."
                                                       delegate:self
                                              cancelButtonTitle:@"Ignore"
                                              otherButtonTitles:@"Re-sync", nil];
        action = DORESYNC;
        [alert setAlertViewStyle:UIAlertViewStyleDefault]; // Gives us the username and password password field
        [alert show];
        
    }
    
    
    int tmpWayneCount = 0;
    
    NSMutableArray *tmpWayneArray = [WayneOrderHeader getAllOrderHeaders];
    for (WayneOrderHeader *tmpWayne in tmpWayneArray) {
        if ([tmpWayne.RepActionReq isEqual:@"1"]) {
            tmpWayneCount++;
        }
    }
    if (tmpWayneCount > 0) {
        NSLog(@"GOTSOME");
        [btnNeedAttention setEnabled:true];
        [btnNeedAttention setHidden:false];
        [btnNeedAttnSub setEnabled:true];
        [btnNeedAttnSub setHidden:false];
    } else {
        NSLog(@"GOT NONE");
        [btnNeedAttention setEnabled:false];
        [btnNeedAttention setHidden:true];
        [btnNeedAttnSub setEnabled:false];
        [btnNeedAttnSub setHidden:true];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([orderSent isEqual:@"orderSent"]) {
        orderSent = nil;
        [SVProgressHUD showSuccessWithStatus:@"Order successfully sent to Wayne Carver!"];
    }
}

- (IBAction)btnNewOrder:(id)sender {
    CustomerTableVC *customerView = [self.storyboard instantiateViewControllerWithIdentifier:@"customerTable"];
    [self.navigationController pushViewController:customerView animated:YES];
}

- (IBAction)btnEditOrders:(id)sender {
    EditingTableVC *editView = [self.storyboard instantiateViewControllerWithIdentifier:@"editingTable"];
    editView.status = @"Started";
    [self.navigationController pushViewController:editView animated:YES];
}

- (IBAction)btniPadOrders:(id)sender {
    EditingTableVC *editView = [self.storyboard instantiateViewControllerWithIdentifier:@"editingTable"];
    editView.status = @"Posted";
    [self.navigationController pushViewController:editView animated:YES];
}

- (IBAction)btnSubmittedOrders:(id)sender {
    WayneOrdersTableVC *submittedView = [self.storyboard instantiateViewControllerWithIdentifier:@"wayneOrdersTable"];
    [self.navigationController pushViewController:submittedView animated:YES];
}

- (IBAction)btnViewUnshippedOrders:(id)sender {
    self.usersArray = [User getAllUsers];
    //disable ip access if there is one
    if ([usersArray count] != 0) {
        Sync *sync = [Sync alloc];
        User *user  = [usersArray objectAtIndex:0];
        [sync syncUnshippedWayneOrderHeaders:user.UserID withPassword:user.Password];
    }
}

- (IBAction)btnWebsite:(id)sender {
    WayneWebsiteVC *websiteView = [self.storyboard instantiateViewControllerWithIdentifier:@"website"];
    [self.navigationController pushViewController:websiteView animated:YES];
}

- (IBAction)btnContactInfo:(id)sender {
    ContactInfoVC *contactView = [self.storyboard instantiateViewControllerWithIdentifier:@"contact"];
    [self.navigationController pushViewController:contactView animated:YES];
}

- (IBAction)btnShippingInfo:(id)sender {
    AddressInfoVC *addressView = [self.storyboard instantiateViewControllerWithIdentifier:@"address"];
    [self.navigationController pushViewController:addressView animated:YES];
}

- (IBAction)btnTutorialVideo:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://youtu.be/un-mZ3WoNxU"]];
}



// Checks if we have an internet connection or not
- (void)testInternetConnection {
    __weak typeof(self) weakSelf = self;

    internetReachableFoo = [Reachability reachabilityWithHostname:[NSString stringWithFormat:@"www.heartwood.com"]];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Yayyy, we have the interwebs!");
            self->usersArray = [User getAllUsers];
            //disable ip access if there is one
            if ([self->usersArray count] != 0) {
                Sync *sync = [Sync alloc];
                User *user  = [self->usersArray objectAtIndex:0];
                [sync checkSyncNeeded:user.UserID withPassword:user.Password];
            }
        });
    };
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Someone broke the internet :(");
            needsSync = false;
            self->usersArray = [User getAllUsers];
            if ([self->usersArray count] != 0) {
                User *user = [self->usersArray objectAtIndex:0];
                self->lblWelcome.text = [NSString stringWithFormat:@"Welcome %@ %@", user.FirstName, user.LastName];
                self->lblRepID.text = user.UserID;
            }
        });
    };
    [internetReachableFoo startNotifier];
}

- (void)receiveTestNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"StatusSyncDone"]) {
        
        WayneOrdersCustomerTableVC *orderView = [self.storyboard instantiateViewControllerWithIdentifier:@"wayneCustomerTable"];
        orderView.sortType = @"UNSHIPPED";
        [self.navigationController pushViewController:orderView animated:YES];
    } else if ([[notification name] isEqualToString:@"ResyncDone"]) {
        [SVProgressHUD showSuccessWithStatus:@"Sucessfully Resynced"];
        [SVProgressHUD dismiss];
    }
}

- (void)doResync {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Re-sync"
                                                    message:@"Enter Username and Password"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Re-sync", nil];
    action = RESYNC;
    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput]; // Gives us the username and password password field
    [alert show];
}

- (void)resync:(NSString *)user withPassword:(NSString *)pass {
    Sync *sync = [Sync alloc];
    [sync syncAll:user withPassword:pass reSync:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if ([action isEqual:DORESYNC]) {
            [self doResync];
        } else if([action isEqual:RESYNC]) {
            [self resync:[[alertView textFieldAtIndex:0] text] withPassword:[[alertView textFieldAtIndex:1] text]];
        }
    }
}


- (IBAction)btnNeedAttention:(id)sender {
    WayneOrdersCustomerTableVC *orderView = [self.storyboard instantiateViewControllerWithIdentifier:@"wayneCustomerTable"];
    orderView.sortType = @"NEEDATTN";
    [self.navigationController pushViewController:orderView animated:YES];
}


@end
