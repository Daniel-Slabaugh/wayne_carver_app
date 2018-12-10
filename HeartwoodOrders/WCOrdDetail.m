//
//  WCOrdDetail.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 8/22/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "WCOrdDetail.h"

@interface WCOrdDetail ()

@end

@implementation WCOrdDetail
@synthesize orderHeaderInfo;
@synthesize lblShipMethod;
//billed to
@synthesize bName;
//ship to
@synthesize sName;

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
    
    [self.view setBackgroundColor:[[UIColor alloc] initWithRed:194.0 / 255 green:213.0 / 255 blue:221.0 / 255 alpha:1.0]];
    
    if ([orderHeaderInfo.ShipMethod isEqual:@"(null)"]) {
        lblShipMethod.text = @"";
    } else {
        lblShipMethod.text = [NSString stringWithFormat:@"Ship Method: %@", orderHeaderInfo.ShipMethod];
    }
    
    //billed to
    if ([orderHeaderInfo.BillName isEqual:@"(null)"]) {
        bName.text = @"";
    } else {
        bName.text = [NSString stringWithFormat:@"%@\n", orderHeaderInfo.BillName];;
    }
    if (![orderHeaderInfo.BillADDR1 isEqual:@"<null>"]) {
        bName.text = [NSString stringWithFormat:@"%@%@\n", bName.text, orderHeaderInfo.BillADDR1];
    }
    if (![orderHeaderInfo.BillADDR2 isEqual:@"<null>"]) {
        bName.text = [NSString stringWithFormat:@"%@%@\n", bName.text, orderHeaderInfo.BillADDR2];
    }
    if (![orderHeaderInfo.BillCity isEqual:@"(null)"]) {
        bName.text = [NSString stringWithFormat:@"%@%@\n", bName.text, orderHeaderInfo.BillCity];
    }
    if (![orderHeaderInfo.BillState isEqual:@"<null>"]) {
        bName.text = [NSString stringWithFormat:@"%@%@\n", bName.text, orderHeaderInfo.BillState];
    }
    if (![orderHeaderInfo.BillZip isEqual:@"<null>"]) {
        bName.text = [NSString stringWithFormat:@"%@%@\n", bName.text, orderHeaderInfo.BillZip];
    }
    //ship to
    if ([orderHeaderInfo.StoreName isEqual:@"(null)"]) {
        sName.text = @"";
    } else {
        sName.text = orderHeaderInfo.StoreName;
    }
    if (![orderHeaderInfo.StoreADDR1 isEqual:@"<null>"]) {
        sName.text = [NSString stringWithFormat:@"%@%@\n", sName.text, orderHeaderInfo.StoreADDR1];
    }
    if (![orderHeaderInfo.StoreADDR2 isEqual:@"<null>"]) {
        sName.text = [NSString stringWithFormat:@"%@%@\n", sName.text, orderHeaderInfo.StoreADDR2];
    }
    if (![orderHeaderInfo.StoreCity isEqual:@"(null)"]) {
        sName.text = [NSString stringWithFormat:@"%@%@\n", sName.text, orderHeaderInfo.StoreCity];
    }
    if (![orderHeaderInfo.StoreState isEqual:@"<null>"]) {
        sName.text = [NSString stringWithFormat:@"%@%@\n", sName.text, orderHeaderInfo.StoreState];
    }
    if (![orderHeaderInfo.StoreZip isEqual:@"<null>"]) {
        sName.text = [NSString stringWithFormat:@"%@%@\n", sName.text, orderHeaderInfo.StoreZip];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
