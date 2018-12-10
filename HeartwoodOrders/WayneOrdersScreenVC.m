//
//  HeartwoodOrdersScreenVC.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 8/6/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "WayneOrdersScreenVC.h"
#import <QuartzCore/QuartzCore.h>
#import "WayneOrderLine.h"
#import "WCOrdDetail.h"
#import "WCOrdLine.h"
#import "WCTrackNum.h"
#import "WCPDFViewController.h"

@interface WayneOrdersScreenVC ()

@end

@implementation WayneOrdersScreenVC
@synthesize orderHeaderInfo;
@synthesize orderLineArray;
@synthesize scrollView;
//general
@synthesize lblStatus;
@synthesize lblMessage;
@synthesize lblWayneRep;
@synthesize lblCustomer;
@synthesize lblPONum;
@synthesize lblTerms;
@synthesize lblAccepted;
@synthesize lblShipDate;

//money
@synthesize lblTotal;

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
    
    orderLineView.layer.borderWidth = 2;
    orderLineView.layer.borderColor = [[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]CGColor];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    if ([orderHeaderInfo.ActionMsg isEqual:(@"<null>")] || [orderHeaderInfo.ActionMsg isEqual:@"(null)"] || [orderHeaderInfo.ActionMsg isEqual:@""]) {
        lblMessage.text = @"";
    } else {
        NSLog(@"Action Msg: %@", orderHeaderInfo.ActionMsg);
        lblMessage.text = [NSString stringWithFormat:@"ATTENTION: %@", orderHeaderInfo.ActionMsg];
        if ([orderHeaderInfo.RepActionReq isEqual:(@"1")]) {
            [lblMessage setTextColor:[UIColor redColor]];
        } else {
            [lblMessage setTextColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]];
        }
    }

    if ([orderHeaderInfo.ProcessedBy isEqual:(@"<null>")] || [orderHeaderInfo.ProcessedBy isEqual:@"(null)"]) {
        [lblWayneRep setText:@""];
    } else {
        [lblWayneRep setText:[NSString stringWithFormat: @"Wayne Contact: %@", orderHeaderInfo.ProcessedBy]];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iPhone 3.2 or later.
        [self->scrollView setContentSize:CGSizeMake(768, 1450)];
        self->scrollView.frame = CGRectMake(0, 0, 768, 1250);
    }
    else
    {
        // The device is an iPhone or iPod touch.
        [self->scrollView setContentSize:CGSizeMake(320, 875)];
        self->scrollView.frame = CGRectMake(0, 45, 320, 600);
    }
    [self.view addSubview:self->scrollView];
    
    //initialize Labels
    if ([orderHeaderInfo.Status isEqual:(@"<null>")] || [orderHeaderInfo.Status isEqual:@"(null)"]) {
        lblStatus.text = @"";
    } else {
        if ([orderHeaderInfo.RepActionReq isEqual:@"1"]) {
            lblStatus.text =  [NSString stringWithFormat:@"Status: %@\nAction Required!", orderHeaderInfo.Status];
        } else {
            lblStatus.text = [NSString stringWithFormat:@"Status: %@", orderHeaderInfo.Status];
        }
        if ([orderHeaderInfo.RepActionReq isEqual:(@"1")]) {
            [lblStatus setTextColor:[UIColor redColor]];
        } else {
            [lblStatus setTextColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]];
        }
    }
    if ([orderHeaderInfo.CustName isEqual:@"(null)"]) {
        lblCustomer.text = @"";
    } else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // The device is an iPad running iPhone 3.2 or later.
            lblCustomer.text = [NSString stringWithFormat:@"Customer: %@", orderHeaderInfo.CustName];
        }
        else
        {
            // The device is an iPhone or iPod touch.
            lblCustomer.text = [NSString stringWithFormat:@"Cust: %@", orderHeaderInfo.CustName];
        }
    }
    if ([orderHeaderInfo.PONum isEqual:@"<null>"]) {
        lblPONum.text = @"No P.O #";
    } else {
        lblPONum.text = [NSString stringWithFormat:@"P.O. #: %@", orderHeaderInfo.PONum];
    }
    if ([orderHeaderInfo.Terms isEqual:@"<null>"]) {
        lblTerms.text = @"No Terms";
    } else {
        lblTerms.text = [NSString stringWithFormat:@"Terms: %@", orderHeaderInfo.Terms];
    }
    
    //date received or accepted
    if ([orderHeaderInfo.DateAccepted isEqual:@"<null>"]) {
        if ([orderHeaderInfo.DateReceived isEqual:@"(null)"]) {
            lblAccepted.text = @"";
        } else {
            NSDate *date = [self.dateFormatter dateFromString:orderHeaderInfo.DateReceived];
            [self.dateFormatter setDateFormat:@"MM-dd-yyyy"];
            lblAccepted.text = [NSString stringWithFormat:@"Received on: %@",[self.dateFormatter stringFromDate:date]];
            [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
    } else {
        NSDate *date = [self.dateFormatter dateFromString:orderHeaderInfo.DateAccepted];
        [self.dateFormatter setDateFormat:@"MM-dd-yyyy"];
        lblAccepted.text = [NSString stringWithFormat:@"Accepted on: %@",[self.dateFormatter stringFromDate:date]];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    // ship date (From SAP)
    if ([orderHeaderInfo.SAPShipDate isEqual:(@"<null>")] || [orderHeaderInfo.SAPShipDate isEqual:@"(null)"]) {
        lblShipDate.text = @"Ship Date Not Available";
    } else {
        NSDate *dateAcc = [self.dateFormatter dateFromString:orderHeaderInfo.SAPShipDate];
        [self.dateFormatter setDateFormat:@"MM-dd-yyyy"];
        lblShipDate.text = [NSString stringWithFormat:@"Ship Date: %@",[self.dateFormatter stringFromDate:dateAcc]];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [NSString stringWithFormat:@"Ship Date: %@", orderHeaderInfo.SAPShipDate];
    }
    
    lblTotal.text = [NSString stringWithFormat:@"%.2f", orderHeaderInfo.TotalAmt];
    
    // set up ItemOrderlist for tableview
    self.orderLineArray = [[NSMutableArray alloc] init];
    self.orderLineArray = [WayneOrderLine getOrderLinesWhere:orderHeaderInfo.OrderNum];
    
    if (self.orderLineArray.count == 0) {
        NSString *message = [NSString stringWithFormat:@"Error: Please call wayne carver and tell them there is an error with order #%ld.", (long)orderHeaderInfo.OrderNum];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something Wrong"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [orderLineView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnExit:(id)sender {
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    [self.navigationController popToViewController:[allViewControllers objectAtIndex:1] animated:YES];
}

- (IBAction)btnCreatePdf:(id)sender {
    WCPDFViewController *pdfView = [self.storyboard instantiateViewControllerWithIdentifier:@"WCPDFViewController"];
    orderHeaderInfo.PDFType = @"WAYNE";
    pdfView.wayneOrderHeaderInfo = orderHeaderInfo;
    [self.navigationController pushViewController:pdfView animated:YES];
}

#pragma tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    return (self.orderLineArray.count + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"OrderTableCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        } else {
            if (indexPath.row == 0)
                cell.accessoryType = UITableViewCellAccessoryNone;
            else
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            // The device is an iPad running iPhone 3.2 or later.
            UILabel* txtQty = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 75, 43)];
            [txtQty setNumberOfLines:2];
            txtQty.tag = 1;
            [cell addSubview:txtQty];
            
            //QtyShip Txtbox
            UILabel* txtShipQty = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 75, 43)];
            [txtShipQty setNumberOfLines:2];
            txtShipQty.tag = 2;
            [cell addSubview:txtShipQty];
            
            //QtyBckord Txtbox
            UILabel* txtBOQty = [[UILabel alloc] initWithFrame:CGRectMake(145, 5, 75, 43)];
            [txtBOQty setNumberOfLines:2];
            txtBOQty.tag = 3;
            [cell addSubview:txtBOQty];
            
            //Item # Txtbox
            UILabel* txtItem = [[UILabel alloc] initWithFrame:CGRectMake(210, 5, 75, 43)];
            [txtItem setNumberOfLines:2];
            txtItem.tag = 4;
            [cell addSubview:txtItem];
            
            //Item Desc Txtbox
            UILabel* txtDesc = [[UILabel alloc] initWithFrame:CGRectMake(300, 5, 380, 43)];
            [txtDesc setNumberOfLines:2];
            txtDesc.tag = 5;
            [cell addSubview:txtDesc];
            
            //Price Txtbox
            UILabel* txtPrice = [[UILabel alloc] initWithFrame:CGRectMake(585, 5, 75, 43)];
            [txtPrice setNumberOfLines:2];
            txtPrice.tag = 6;
            [cell addSubview:txtPrice];
            
            //Total Txtbox
            UILabel* txtTotal = [[UILabel alloc] initWithFrame:CGRectMake(680, 5, 125, 43)];
            [txtTotal setNumberOfLines:2];
            txtTotal.tag = 7;
            [cell addSubview:txtTotal];
        }
        else
        {
            // The device is an iPhone or iPod touch.
            UILabel* txtQty = [[UILabel alloc] initWithFrame:CGRectMake(256, 5, 75, 43)];
            [txtQty setNumberOfLines:2];
            txtQty.tag = 1;
            [cell addSubview:txtQty];
            
            //QtyShip Txtbox
            UILabel* txtShipQty = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [txtShipQty setNumberOfLines:2];
            txtShipQty.tag = 2;
            [cell addSubview:txtShipQty];
            
            //QtyBckord Txtbox
            UILabel* txtBOQty = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [txtBOQty setNumberOfLines:2];
            txtBOQty.tag = 3;
            [cell addSubview:txtBOQty];
            
            //Item # Txtbox
            UILabel* txtItem = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [txtItem setNumberOfLines:2];
            txtItem.tag = 4;
            [cell addSubview:txtItem];
            
            //Item Desc Txtbox
            UILabel* txtDesc = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 240, 38)];
            [txtDesc setNumberOfLines:2];
            txtDesc.tag = 5;
            [cell addSubview:txtDesc];
            
            //Price Txtbox
            UILabel* txtPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [txtPrice setNumberOfLines:2];
            txtPrice.tag = 6;
            [cell addSubview:txtPrice];
            
            //Total Txtbox
            UILabel* txtTotal = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [txtTotal setNumberOfLines:2];
            txtTotal.tag = 7;
            [cell addSubview:txtTotal];
        }
    }
    
    
    UILabel* txtQty = (UILabel*)[cell viewWithTag:1];
    UILabel* txtShipQty = (UILabel*)[cell viewWithTag:2];
    UILabel* txtBOQty = (UILabel*)[cell viewWithTag:3];
    UILabel* txtItem = (UILabel*)[cell viewWithTag:4];
    UILabel* txtDesc = (UILabel*)[cell viewWithTag:5];
    UILabel* txtPrice = (UILabel*)[cell viewWithTag:6];
    UILabel* txtTotal = (UILabel*)[cell viewWithTag:7];
    
    if (indexPath.row == 0) {
        
        [txtQty setText:@"Qty\nOrd"];
        
        //QtyShip Txtbox
        [txtShipQty setText:@"Qty\nShip"];
        
        //QtyBckord Txtbox
        [txtBOQty setText:@"Qty\nB/O"];
        
        //Item # Txtbox
        [txtItem setText:@"\nItem #"];
        
        //Item Desc Txtbox
        [txtDesc setText:@"\nItem Description"];
        
        //Price Txtbox
        [txtPrice setText:@"\nPrice"];
        
        //Total Txtbox
        [txtTotal setText:@"\nAmount"];
    } else {
        WayneOrderLine * tmpOrderLine = nil;
        tmpOrderLine = [self.orderLineArray objectAtIndex:indexPath.row -1];
        
        //Qty Txtbox
        [txtQty setText:[NSString stringWithFormat:@"%ld", (long)tmpOrderLine.QtyOrdered]];
        
        //QtyShip Txtbox
        [txtShipQty setText:[NSString stringWithFormat:@"%ld", (long)tmpOrderLine.QtyShipped]];
        
        //QtyBckord Txtbox
        [txtBOQty setText:[NSString stringWithFormat:@"%ld", (long)tmpOrderLine.QtyBackordered]];
        
        //Item # Txtbox
        [txtItem setText:[NSString stringWithFormat:@"%@", tmpOrderLine.ItemNo]];
        
        //Item Desc Txtbox
        [txtDesc setText:[NSString stringWithFormat:@"%@", tmpOrderLine.ItemDesc]];
        
        //Price Txtbox
        [txtPrice setText:[NSString stringWithFormat:@"%.2f", tmpOrderLine.PricePerPiece]];
        
        //Total Txtbox
        [txtTotal setText:[NSString stringWithFormat:@"%.2f", tmpOrderLine.LineTotal]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0) {
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
        {
            WayneOrderLine *tmpOrderLine = [self.orderLineArray objectAtIndex:indexPath.row -1];
            
            WCOrdLine *orderLinesView = [self.storyboard instantiateViewControllerWithIdentifier:@"WCOrdLine"];
            orderLinesView.orderLineInfo = tmpOrderLine;
            [self.navigationController presentViewController:orderLinesView animated:YES completion:nil];
        }
    }
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Items In Order";
}

- (IBAction)btnShowDetails:(id)sender {
    WCOrdDetail *orderDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"WCOrdDetail"];
    orderDetailView.orderHeaderInfo = orderHeaderInfo;
    orderDetailView.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentViewController:orderDetailView animated:YES completion:nil];
}

- (IBAction)btnTrackingNumbers:(id)sender {
    WCTrackNum *trackNumView = [self.storyboard instantiateViewControllerWithIdentifier:@"WCTrackNum"];
    trackNumView.orderHeaderInfo = orderHeaderInfo;
    trackNumView.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentViewController:trackNumView animated:YES completion:nil];

}

@end
