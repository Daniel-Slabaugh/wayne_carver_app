//
//  WCOrdLine.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 8/26/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "WCOrdLine.h"

@interface WCOrdLine ()

@end

@implementation WCOrdLine
@synthesize orderLineInfo;
@synthesize lblDesc;
@synthesize lblItemNum;
@synthesize lblItemTotal;
@synthesize lblPiecePrice;
@synthesize lblQtyBO;
@synthesize lblQtyOrd;
@synthesize lblQtyShip;

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
    
    //Qty Txtbox
    [lblQtyOrd setText:[NSString stringWithFormat:@"%ld", (long)orderLineInfo.QtyOrdered]];
    
    //QtyShip Txtbox
    [lblQtyShip setText:[NSString stringWithFormat:@"%ld", (long)orderLineInfo.QtyShipped]];
    
    //QtyBckord Txtbox
    [lblQtyBO setText:[NSString stringWithFormat:@"%ld", (long)orderLineInfo.QtyBackordered]];
    
    //Item # Txtbox
    [lblItemNum setText:[NSString stringWithFormat:@"%@", orderLineInfo.ItemNo]];
    
    //Item Desc Txtbox
    [lblDesc setText:[NSString stringWithFormat:@"%@", orderLineInfo.ItemDesc]];
    
    //Price Txtbox
    [lblPiecePrice setText:[NSString stringWithFormat:@"%.2f", orderLineInfo.PricePerPiece]];
    
    //Total Txtbox
    [lblItemTotal setText:[NSString stringWithFormat:@"%.2f", orderLineInfo.LineTotal]];
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
