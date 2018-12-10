//
//  WCOrdLine.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 8/26/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WayneOrderLine.h"

@interface WCOrdLine : UIViewController

@property (nonatomic, retain) WayneOrderLine * orderLineInfo;
@property (retain, nonatomic) IBOutlet UILabel *lblDesc;
@property (retain, nonatomic) IBOutlet UILabel *lblItemNum;
@property (retain, nonatomic) IBOutlet UILabel *lblQtyOrd;
@property (retain, nonatomic) IBOutlet UILabel *lblQtyShip;
@property (retain, nonatomic) IBOutlet UILabel *lblQtyBO;
@property (retain, nonatomic) IBOutlet UILabel *lblPiecePrice;
@property (retain, nonatomic) IBOutlet UILabel *lblItemTotal;
- (IBAction)btnBack:(id)sender;

@end
