//
//  WCOrdDetail.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 8/22/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WayneOrderHeader.h"

@interface WCOrdDetail : UIViewController

@property (nonatomic, retain) WayneOrderHeader * orderHeaderInfo;
@property (retain, nonatomic) IBOutlet UILabel *lblShipMethod;

//billed to
@property (retain, nonatomic) IBOutlet UILabel *bName;

//ship to
@property (retain, nonatomic) IBOutlet UILabel *sName;


- (IBAction)btnBack:(id)sender;

@end
