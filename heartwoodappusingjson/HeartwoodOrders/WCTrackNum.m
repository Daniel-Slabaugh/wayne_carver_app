//
//  WCTrackNum.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 06/09/2014.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import "WCTrackNum.h"
#import "EditOrderScreenVC.h"
#import "PDFViewController.h"

#import "OrderLine.h"
#import "Item.h"
#import "TrackingNumber.h"


@interface WCTrackNum ()

@end

@implementation WCTrackNum
@synthesize orderHeaderInfo;
@synthesize cellSelected;

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
    [self.view setBackgroundColor:[[UIColor alloc] initWithRed:194.0 / 255 green:213.0 / 255 blue:221.0 / 255 alpha:1.0]];
    
    self.tableArray = [TrackingNumber getTrackingNumbersWhereOrder:orderHeaderInfo.OrderNum];
    
    NSLog(@"%ld", (long)orderHeaderInfo.OrderNum); //[self.tableArray objectAtIndex:0]);
    
    [editDetailTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"TrkngNumID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    TrackingNumber *trackNo = [self.tableArray objectAtIndex:indexPath.row];
    
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", trackNo.TrackingNumber];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iPhone 3.2 or later.
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:20]];
    }
    else
    {
        // The device is an iPhone or iPod touch.
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TrackingNumber *trackNo = [self.tableArray objectAtIndex:indexPath.row];
    
//    NSString *companyID = [trackNo.TrackingNumber substringWithRange:NSMakeRange(0, 2)];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.packagetrackr.com/track/%@",trackNo.TrackingNumber]]];
    
//    NSString *message = [NSString stringWithFormat:"Copy or Track?"];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Would you like to copy the tracking number or "
//                                                    message:message
//                                                   delegate:self
//                                          cancelButtonTitle:@"Cancel"
//                                          otherButtonTitles:@"Done", nil];
//    [alert setAlertViewStyle:UIAlertViewStyleSecureTextInput]; // Gives us the password field
//    [alert show];

    //http://www.packagetrackr.com/track/420969219405501699320017456671
    
//    if ([companyID isEqual:@"1Z"]) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://wwwapps.ups.com/WebTracking/processInputRequest?HTMLVersion=5.0&tracknums_displayed=5&TypeOfInquiryNumber=T&loc=en_US&InquiryNumber1=%@&AgreeToTermsAndConditions=yes&track.x=25&track.y=9",trackNo.TrackingNumber]]];
//    } else if ([companyID isEqual:@"06"]) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://wwwapps.ups.com/WebTracking/processInputRequest?HTMLVersion=5.0&tracknums_displayed=5&TypeOfInquiryNumber=T&loc=en_US&InquiryNumber1=%@&AgreeToTermsAndConditions=yes&tra/Users/danielslabaugh/Desktop/ios_development.cerck.x=25&track.y=9",trackNo.TrackingNumber]]];
//    } else {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://tools.usps.com/go/TrackConfirmAction_input?origTrackNum=%@", trackNo.TrackingNumber]]];
//    }
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnSummary:(id)sender {
    // update order line pdf prices
    for (OrderLine *orderline in self.tableArray) {
        [OrderLine updateOrderLine:orderline];
    }
    //send notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PDFPriceUpdate" object:self];
    [self dismissViewControllerAnimated:NO completion:nil];
}

//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        
//        NSMutableArray *users = [User getAllUsers];
//        User *user = [users objectAtIndex:0];
//        
//        password = [[alertView textFieldAtIndex:0] text];
//        if (![password isEqual: user.Password]) {
//            [self presentAlertViewForPassword];
//        }
//    } else {
//        [self presentAlertViewForPassword];
//    }
//    
//}

- (void)dealloc {
    [orderHeaderInfo release];
    [cellSelected release];
    [super dealloc];
}

@end
