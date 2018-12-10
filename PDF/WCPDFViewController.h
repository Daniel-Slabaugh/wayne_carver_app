//
//  WCPDFViewController.h
//  PDFRenderer
//
//  Created by Yuichi Fujiki on 3/28/12.
//  Copyright (c) 2012 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "PDFRenderer.h"

#import "OrderHeader.h"
#import "OrderLine.h"
#import "OrderDetail.h"
#import "WayneOrderHeader.h"
#import "GMOrderHeader.h"

#define GM @"GeneralMerchandise"
#define NP @"NameProgram"


@interface WCPDFViewController : UIViewController < MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate >


@property (nonatomic, retain) OrderHeader * orderHeaderInfo;
@property (nonatomic, retain) WayneOrderHeader * wayneOrderHeaderInfo;
@property (nonatomic, retain) GMOrderHeader * gmOrderHeaderInfo;
@property (nonatomic, retain) NSString * filePath;
@property (nonatomic, retain) NSString * oldFilePath;

// UILabel for displaying the result of the sending the message.
@property (retain, nonatomic) IBOutlet UILabel *feedbackMsg;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *btnPrices;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *txtIncludePrices;
@property (retain, nonatomic) IBOutlet UISwitch *switchShowPrice;


- (IBAction)btnBack:(id)sender;
- (void) showPDFFile;
- (IBAction)btnEmail:(id)sender;
- (IBAction)btnPrices:(id)sender;
- (IBAction)switchShowPrice:(id)sender;

@end

