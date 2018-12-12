//
//  WCPDFViewController.m
//  PDFRenderer
//
//  Created by Yuichi Fujiki on 3/28/12.
//  Copyright (c) 2012 Daniel Slabaugh. All rights reserved.
//

#import "WCPDFViewController.h"
#import "PDFPriceScreen.h"

@implementation WCPDFViewController

@synthesize orderHeaderInfo;
@synthesize filePath = _filePath;
@synthesize oldFilePath = _oldFilePath;
@synthesize btnPrices;
@synthesize wayneOrderHeaderInfo;
@synthesize gmOrderHeaderInfo;
@synthesize switchShowPrice;
@synthesize txtIncludePrices;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];




    // notification for Summary PDF
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"PDFPriceUpdate"
                                               object:nil];

    if ([self.orderHeaderInfo.PDFType isEqualToString:@"Posted"] || [self.gmOrderHeaderInfo.PDFType isEqualToString:@"GMPosted"]) {
        [switchShowPrice setHidden:YES];
        [switchShowPrice setEnabled:NO];
        [txtIncludePrices setTitle:@""];
        [txtIncludePrices setEnabled:NO];
    } else {
        [switchShowPrice setHidden:NO];
        [switchShowPrice setEnabled:YES];
        [txtIncludePrices setTitle:@"Include Prices:"];
        [txtIncludePrices setEnabled:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];


    self.filePath = [self getPDFFilePath];

    //    PDFType = orderHeaderInfo.PDFType;


    if (switchShowPrice.isOn == YES) {
        if ([self.orderHeaderInfo.PDFType isEqualToString:@"FULL"] ) {
            [PDFRenderer fullPDF:self.filePath forOrder:self.orderHeaderInfo includePrice:YES];
            [btnPrices setTitle:@"Set Prices"];
            [btnPrices setEnabled:YES];
            [txtIncludePrices setTitle:@"Include Prices:"];
            [switchShowPrice setHidden:NO];
        }
        if ([self.orderHeaderInfo.PDFType isEqualToString:@"SUMMARY"] ) {
            [PDFRenderer summaryPDF:self.filePath forOrder:self.orderHeaderInfo includePrice:YES];
            [btnPrices setTitle:@"Set Prices"];
            [btnPrices setEnabled:YES];
            [txtIncludePrices setTitle:@"Include Prices:"];
            [switchShowPrice setHidden:NO];
        }
        if ([self.gmOrderHeaderInfo.PDFType isEqualToString:@"GMORDER"] ) {
            [PDFRenderer gmPDF:self.filePath forOrder:self.gmOrderHeaderInfo includePrice:YES];
            [btnPrices setTitle:@"Set Prices"];
            [btnPrices setEnabled:YES];
            [txtIncludePrices setTitle:@"Include Prices:"];
            [switchShowPrice setHidden:NO];
        }
        NSLog(@"%@", self.wayneOrderHeaderInfo.PDFType);

        if ([self.wayneOrderHeaderInfo.PDFType isEqualToString:@"WAYNE"] ) {
            [PDFRenderer waynePDF:self.filePath forOrder:self.wayneOrderHeaderInfo];
            [btnPrices setTitle:@""];
            [btnPrices setEnabled:NO];
            [txtIncludePrices setTitle:@""];
            [switchShowPrice setHidden:YES];
        }
        if ([self.orderHeaderInfo.PDFType isEqualToString:@"Posted"] ) {
            [PDFRenderer postedPDF:self.filePath forOrder:self.orderHeaderInfo includePrice:NO];
            [btnPrices setTitle:@""];
            [btnPrices setEnabled:NO];
            [txtIncludePrices setTitle:@""];
            [switchShowPrice setHidden:YES];
        }
        if ([self.gmOrderHeaderInfo.PDFType isEqualToString:@"GMPosted"] ) {
            [PDFRenderer gmPostedPDF:self.filePath forOrder:self.gmOrderHeaderInfo includePrice:NO];
            [btnPrices setTitle:@""];
            [btnPrices setEnabled:NO];
            [txtIncludePrices setTitle:@""];
            [switchShowPrice setHidden:YES];
        }

    } else {
        if ([self.orderHeaderInfo.PDFType isEqualToString:@"FULL"] ) {
            [PDFRenderer fullPDF:self.filePath forOrder:self.orderHeaderInfo includePrice:NO];
            [btnPrices setTitle:@""];
            [btnPrices setEnabled:NO];
            [txtIncludePrices setTitle:@"Include Prices:"];
            [switchShowPrice setHidden:NO];
        }
        if ([self.orderHeaderInfo.PDFType isEqualToString:@"SUMMARY"] ) {
            [PDFRenderer summaryPDF:self.filePath forOrder:self.orderHeaderInfo includePrice:NO];
            [btnPrices setTitle:@""];
            [btnPrices setEnabled:NO];
            [txtIncludePrices setTitle:@"Include Prices:"];
            [switchShowPrice setHidden:NO];
        }
        if ([self.gmOrderHeaderInfo.PDFType isEqualToString:@"GMORDER"] ) {
            [PDFRenderer gmPDF:self.filePath forOrder:self.gmOrderHeaderInfo includePrice:NO];
            [btnPrices setTitle:@""];
            [btnPrices setEnabled:NO];
            [txtIncludePrices setTitle:@"Include Prices:"];
            [switchShowPrice setHidden:NO];
        }
        NSLog(@"%@", self.wayneOrderHeaderInfo.PDFType);
        if ([self.wayneOrderHeaderInfo.PDFType isEqualToString:@"WAYNE"] ) {
            [PDFRenderer waynePDF:self.filePath forOrder:self.wayneOrderHeaderInfo];
            [btnPrices setTitle:@""];
            [btnPrices setEnabled:NO];
            [txtIncludePrices setTitle:@""];
            [switchShowPrice setHidden:YES];
        }
        if ([self.orderHeaderInfo.PDFType isEqualToString:@"Posted"] ) {
            [PDFRenderer postedPDF:self.filePath forOrder:self.orderHeaderInfo includePrice:NO];
            [btnPrices setTitle:@""];
            [btnPrices setEnabled:NO];
            [txtIncludePrices setTitle:@""];
            [switchShowPrice setHidden:YES];
        }
        if ([self.gmOrderHeaderInfo.PDFType isEqualToString:@"GMPosted"] ) {
            [PDFRenderer gmPostedPDF:self.filePath forOrder:self.gmOrderHeaderInfo includePrice:NO];
            [btnPrices setTitle:@""];
            [btnPrices setEnabled:NO];
            [txtIncludePrices setTitle:@""];
            [switchShowPrice setHidden:YES];
        }
    }

    [self showPDFFile];
    self.feedbackMsg.hidden = YES;
}

- (void) receiveTestNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"PDFPriceUpdate"])
    {
        [self viewWillAppear:YES];

    }
}

-(NSString*)getPDFFilePath {

    NSString* fileName = [NSString stringWithFormat:@"Order%ld.pdf", (long)orderHeaderInfo.OrderNum];

    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFilePath = [path stringByAppendingPathComponent:fileName];

    return pdfFilePath;
}

//-(NSString*)getTemplatePDFFilePath
//{
//    NSString* fileName = @"Old.pdf";
//
//    NSArray *arrayPaths =
//    NSSearchPathForDirectoriesInDomains(
//                                        NSDocumentDirectory,
//                                        NSUserDomainMask,
//                                        YES);
//    NSString *path = [arrayPaths objectAtIndex:0];
//    NSString* pdfFilePath = [path stringByAppendingPathComponent:fileName];
//
//    return pdfFilePath;
//}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations
//    return YES;
//}

#pragma mark - Draw PDF
- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showPDFFile {
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 25, 768, 953)];

    NSURL *url = [NSURL fileURLWithPath:self.filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:request];

    [self.view addSubview:webView];
}

- (IBAction)btnEmail:(id)sender {
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
        self.feedbackMsg.hidden = NO;
        self.feedbackMsg.text = @"Device not configured to send mail.";
    }
}

- (IBAction)btnPrices:(id)sender {
    PDFPriceScreen *pdfView = [self.storyboard instantiateViewControllerWithIdentifier:@"PDFPrice"];
    if ([self.gmOrderHeaderInfo.PDFType isEqualToString:@"GMORDER"]) {
        pdfView.type = GM;
        pdfView.gmorderHeaderInfo = gmOrderHeaderInfo;
    } else {
        pdfView.type = NP;
        pdfView.orderHeaderInfo = orderHeaderInfo;
    }

    pdfView.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentViewController:pdfView animated:YES completion:nil];
}

- (IBAction)switchShowPrice:(id)sender {
    //    if ([sender isOn]) {
    //        [btnPrices setTitle:@"Set Prices"];
    //        [btnPrices setEnabled:YES];
    //    } else {
    //        [btnPrices setTitle:@""];
    //        [btnPrices setEnabled:NO];
    //    }
    [self viewWillAppear:NO];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Rotation

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
// -------------------------------------------------------------------------------
//    shouldAutorotateToInterfaceOrientation:
//  Disable rotation on iOS 5.x and earlier.  Note, for iOS 6.0 and later all you
//  need is "UISupportedInterfaceOrientations" defined in your Info.plist
// -------------------------------------------------------------------------------
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
#endif

#pragma mark - Actions

// -------------------------------------------------------------------------------
//    showMailPicker:
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
        self.feedbackMsg.hidden = NO;
        self.feedbackMsg.text = @"Device not configured to send mail.";
    }
}

// -------------------------------------------------------------------------------
//    showSMSPicker:
//  IBAction for the Compose SMS button.
// -------------------------------------------------------------------------------
- (IBAction)showSMSPicker:(id)sender {
    // You must check that the current device can send SMS messages before you
    // attempt to create an instance of MFMessageComposeViewController.  If the
    // device can not send SMS messages,
    // [[MFMessageComposeViewController alloc] init] will return nil.  Your app
    // will crash when it calls -presentViewController:animated:completion: with
    // a nil view controller.
    if ([MFMessageComposeViewController canSendText])
        // The device can send email.
    {
        [self displaySMSComposerSheet];
    }
    else
        // The device can not send email.
    {
        self.feedbackMsg.hidden = NO;
        self.feedbackMsg.text = @"Device not configured to send SMS.";
    }
}

#pragma mark - Compose Mail/SMS

// -------------------------------------------------------------------------------
//    displayMailComposerSheet
//  Displays an email composition interface inside the application.
//  Populates all the Mail fields.
// -------------------------------------------------------------------------------
- (void)displayMailComposerSheet {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;


    if ([self.orderHeaderInfo.PDFType isEqualToString:@"WAYNE"] ) {
        [picker setSubject:@"Wayne Carver Order"];
    } else if([self.orderHeaderInfo.PDFType isEqualToString:@"Posted"] || [self.gmOrderHeaderInfo.PDFType isEqualToString:@"GMPosted"]) {
        [picker setSubject:@"iPad Order History"];
    } else {
        [picker setSubject:@"Proposed Order"];
    }

    if([self.orderHeaderInfo.PDFType isEqualToString:@"Posted"]) {
        // Set up recipients
        NSArray *toRecipients = [NSArray arrayWithObject:@"joshua@heartwood.com"];
        [picker setToRecipients:toRecipients];
    }


    //    // Set up recipients
    //    NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
    //    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    //    NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
    //
    //    [picker setToRecipients:toRecipients];
    //    [picker setCcRecipients:ccRecipients];
    //    [picker setBccRecipients:bccRecipients];

    // Attach an image to the email
    NSString *path = self.filePath; //[[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"pdf"];
    NSData *myData = [NSData dataWithContentsOfFile:path];
    [picker addAttachmentData:myData mimeType:@"pdf" fileName:@"Order.pdf"];

    // Fill out the email body text
    if ([self.orderHeaderInfo.PDFType isEqualToString:@"WAYNE"] ) {
        NSString *emailBody = @"Here is the Wayne Carver order!";
        [picker setMessageBody:emailBody isHTML:NO];
    } else if([self.orderHeaderInfo.PDFType isEqualToString:@"Posted"] || [self.gmOrderHeaderInfo.PDFType isEqualToString:@"GMPosted"]) {
        NSString *emailBody = @"Something went wrong with the iPad app... \n I have talked to ______ about this. \n I am sending the unrecieved order in this email to Wayne Carver to be entered.";
        [picker setMessageBody:emailBody isHTML:NO];
    } else {
        NSString *emailBody = @"Here is the proposed Wayne Carver order!";
        [picker setMessageBody:emailBody isHTML:NO];
    }
    [self presentViewController:picker animated:YES completion:NULL];
}

// -------------------------------------------------------------------------------
//    displayMailComposerSheet
//  Displays an SMS composition interface inside the application.
// -------------------------------------------------------------------------------
- (void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;

    // You can specify one or more preconfigured recipients.  The user has
    // the option to remove or add recipients from the message composer view
    // controller.
    /* picker.recipients = @[@"Phone number here"]; */

    // You can specify the initial message text that will appear in the message
    // composer view controller.
    picker.body = @"Hello from California!";

    [self presentViewController:picker animated:YES completion:NULL];
}


#pragma mark - Delegate Methods

// -------------------------------------------------------------------------------
//    mailComposeController:didFinishWithResult:
//  Dismisses the email composition interface when users tap Cancel or Send.
//  Proceeds to update the message field with the result of the operation.
// -------------------------------------------------------------------------------
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    self.feedbackMsg.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            self.feedbackMsg.text = @"Result: Mail sending canceled";
            break;
        case MFMailComposeResultSaved:
            self.feedbackMsg.text = @"Result: Mail saved";
            break;
        case MFMailComposeResultSent:
            self.feedbackMsg.text = @"Result: Mail sent";
            break;
        case MFMailComposeResultFailed:
            self.feedbackMsg.text = @"Result: Mail sending failed";
            break;
        default:
            self.feedbackMsg.text = @"Result: Mail not sent";
            break;
    }

    [self dismissViewControllerAnimated:YES completion:NULL];
}

// -------------------------------------------------------------------------------
//    messageComposeViewController:didFinishWithResult:
//  Dismisses the message composition interface when users tap Cancel or Send.
//  Proceeds to update the feedback message field with the result of the
//  operation.
// -------------------------------------------------------------------------------
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    self.feedbackMsg.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MessageComposeResultCancelled:
            self.feedbackMsg.text = @"Result: SMS sending canceled";
            break;
        case MessageComposeResultSent:
            self.feedbackMsg.text = @"Result: SMS sent";
            break;
        case MessageComposeResultFailed:
            self.feedbackMsg.text = @"Result: SMS sending failed";
            break;
        default:
            self.feedbackMsg.text = @"Result: SMS not sent";
            break;
    }

    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end

