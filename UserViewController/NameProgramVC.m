//
//  NameProgramVC.m
//  wayne mobile
//
//  Created by Delphi Dev Computer on 6/11/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import "NameProgramVC.h"
#import "GlobalVariables.h"
#import "WayneOrdersTableVC.h"
#import "CustomerTableVC.h"
#import "EditingTableVC.h"
#import "WayneWebsiteVC.h"
#import "ContactInfoVC.h"
#import "AddressInfoVC.h"
#import "SVProgressHUD.h"
#import "Sync.h"

#import "User.h"
#import "Customer.h"
#import "Address.h"
#import "Item.h"
#import "Name.h"

#define NP  @"NameProg"

@interface NameProgramVC ()

@end

@implementation NameProgramVC
@synthesize usersArray;
@synthesize lblRepID;
@synthesize lblWelcome;
@synthesize lblEdtOrd;

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
        lblWelcome.text = @"Name Programs";
    }
    [[self tabBarController] setHidesBottomBarWhenPushed:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    //create order header
    NSMutableArray *tmpArray = [User getAllUsers];
    User *user = [tmpArray objectAtIndex:0];
    
    int tmpCount = 0;
    NSMutableArray *tmpGMArray = [OrderHeader getAllOrderHeaders];
    BOOL show = NO;
    
    for (OrderHeader *tmpHdr in tmpGMArray) {
        if ([tmpHdr.LocalStatus isEqualToString:@"Edited"] || [tmpHdr.LocalStatus isEqualToString:@"Started"]) {
            if ([tmpHdr.UserID isEqualToString:user.UserID]) {
                show = YES;
                tmpCount++;
            }
        }
    }
    if (show) {
        if (tmpCount == 1)
            lblEdtOrd.text = [NSString stringWithFormat:@"1 Unsubmitted Order"];
        else
            lblEdtOrd.text = [NSString stringWithFormat:@"%ld Unsubmitted Orders", (long)tmpCount];
    } else {
        lblEdtOrd.text = @"";
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([orderSent isEqual:@"orderSent"]) {
        orderSent = nil;
        NSMutableArray *tmpArray = [User getAllUsers];
        User *user = [tmpArray objectAtIndex:0];
        if ([[user.UserID substringToIndex:1] isEqualToString:@"S"]) {
            
            NSString *message = @"Do you want to email your rep and tell them you've sent this order in?";
            // The device is an iPhone or iPod touch.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Order Confirmation"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"NO"
                                                  otherButtonTitles:@"YES", nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault]; // Gives us the password field
            [alert show];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"Order successfully sent to Wayne Carver!"];
        }
    }
}

- (IBAction)btnNewOrder:(id)sender {
    CustomerTableVC *customerView = [self.storyboard instantiateViewControllerWithIdentifier:@"customerTable"];
    customerView.status = NP;
    [self.navigationController pushViewController:customerView animated:YES];
}

- (IBAction)btnEditOrders:(id)sender {
    EditingTableVC *editView = [self.storyboard instantiateViewControllerWithIdentifier:@"editingTable"];
    editView.status = @"Edited";
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


#pragma mark - Actions

// -------------------------------------------------------------------------------
//	showMailPicker:
//  IBAction for the Compose Mail button.
// -------------------------------------------------------------------------------
- (IBAction)showMailPicker:(id)sender {
    // You must check that the current device can send email messages before you
    // attempt to create an instance of MFMailComposeViewController.  If the
    // device can not send email messages,
    // [[MFMailComposeViewController alloc] init] will return nil.  Your app
    // will crash when it calls -presentViewController:animated:completion: with
    // a nil view controller.
    if ([MFMailComposeViewController canSendMail])
        // The device can send email.
    {
        [self displayMailComposerSheet];
    }
    else
        // The device can not send email.
    {
        //        self.feedbackMsg.hidden = NO;
        self.feedbackMsg = @"Device not configured to send mail.";
    }
}

#pragma mark - Compose Mail/SMS

// -------------------------------------------------------------------------------
//	displayMailComposerSheet
//  Displays an email composition interface inside the application.
//  Populates all the Mail fields.
// -------------------------------------------------------------------------------
- (void)displayMailComposerSheet {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    NSMutableArray *tmpArray = [User getAllUsers];
    User *user = [tmpArray objectAtIndex:0];
    
    [picker setSubject:[NSString stringWithFormat:@"Service User %@ %@ sent in Name Program Order", user.FirstName, user.LastName]];
    
    
    //    if([self.PDFType isEqualToString:@"Posted"]) {
    //        // Set up recipients
    //        NSArray *toRecipients = [NSArray arrayWithObject:@"joshua@heartwood.com"];
    //        [picker setToRecipients:toRecipients];
    //    }
    
    
    //	// Set up recipients
    //	NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
    //	NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    //	NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
    //
    //	[picker setToRecipients:toRecipients];
    //	[picker setCcRecipients:ccRecipients];
    //	[picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email
    //    NSString *path = self.filePath; //[[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"pdf"];
    //    NSData *myData = [NSData dataWithContentsOfFile:path];
    //    [picker addAttachmentData:myData mimeType:@"pdf" fileName:@"Order.pdf"];
    
    // Fill out the email body text
    NSString *emailBody = @"I have just submitted a name program order to Wayne carver. You can now resync your iPad in order to see this order.";
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentViewController:picker animated:YES completion:NULL];
}


#pragma mark - Delegate Methods

// -------------------------------------------------------------------------------
//	mailComposeController:didFinishWithResult:
//  Dismisses the email composition interface when users tap Cancel or Send.
//  Proceeds to update the message field with the result of the operation.
// -------------------------------------------------------------------------------
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //    self.feedbackMsg.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            self.feedbackMsg = @"Result: Mail sending canceled";
            break;
        case MFMailComposeResultSaved:
            self.feedbackMsg = @"Result: Mail saved";
            break;
        case MFMailComposeResultSent:
            self.feedbackMsg = @"Result: Mail sent";
            break;
        case MFMailComposeResultFailed:
            self.feedbackMsg = @"Result: Mail sending failed";
            break;
        default:
            self.feedbackMsg = @"Result: Mail not sent";
            break;
    }
    
    // The device is an iPhone or iPod touch.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.feedbackMsg
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault]; // Gives us the password field
    [alert show];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self showMailPicker:self];
    } else {
        
    }
}

@end

