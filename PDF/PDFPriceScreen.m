//
//  PDFPriceScreen.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 11/26/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "PDFPriceScreen.h"
#import "EditOrderScreenVC.h"
#import "WCPDFViewController.h"

#import "OrderLine.h"
#import "Item.h"
#import "GMOrderLine.h"
#import "GMItem.h"

#define GM @"GeneralMerchandise"
#define NP @"NameProgram"


@interface PDFPriceScreen ()

@end

@implementation PDFPriceScreen
@synthesize orderHeaderInfo;
@synthesize gmorderHeaderInfo;
@synthesize cellSelected;
@synthesize type;

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
    
    if ([type isEqualToString:NP])
        self.tableArray = [OrderLine getOrderLinesWhere:orderHeaderInfo.OrderNum];
    else if ([type isEqualToString:GM])
        self.tableArray = [GMOrderLine getOrderLinesWhere:gmorderHeaderInfo.OrderNum];

    [editDetailTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"ItemCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        //Label
        UILabel* txtQty = [[UILabel alloc] initWithFrame:CGRectMake(380, 5, 75, 43)];
        [txtQty setNumberOfLines:2];
        txtQty.tag = 1;
        [txtQty setTextColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]];
        [txtQty setFont:[UIFont systemFontOfSize:40]];
        [cell addSubview:txtQty];
    }
    else
    {
        //Label
        UILabel* txtQty = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 75, 43)];
        [txtQty setNumberOfLines:2];
        txtQty.tag = 1;
        [txtQty setTextColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]];
        [txtQty setFont:[UIFont systemFontOfSize:20]];
        [cell addSubview:txtQty];
    }
    
    
    UILabel* txtQty = (UILabel*)[cell viewWithTag:1];
    [txtQty setText:@"$"];
    
    
    // Text field
    UITextField *txtField = [[UITextField alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iPhone 3.2 or later.
        txtField.frame = CGRectMake(0, 10, 100, 40);
        [txtField setFont:[UIFont boldSystemFontOfSize:40]];
        [txtField setAdjustsFontSizeToFitWidth:YES];
        
    }
    else
    {
        // The device is an iPhone or iPod touch.
        txtField.frame = CGRectMake(0, 10, 40, 30);
        [txtField setFont:[UIFont boldSystemFontOfSize:22]];
    }
    
    
    if ([type isEqualToString:NP]) {
        OrderLine *orderline = [self.tableArray objectAtIndex:indexPath.row];
        
        NSString *desc = [Item getItemDesc:orderline.ItemNo];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", desc];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", orderline.ItemNo];
        if ([orderline.PDFPrice isEqual:@"(null)"]) {
            txtField.text = @"";
        } else {
            txtField.text = [NSString stringWithFormat:@"%.2f", [orderline.PDFPrice doubleValue]];
        }
        
    } else if ([type isEqualToString:GM]) {
        GMOrderLine *orderline = [self.tableArray objectAtIndex:indexPath.row];
        
        NSString *desc = [GMItem getItemDesc:orderline.ItemNum];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", desc];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", orderline.ItemNum];
        
        if ([orderline.PDFPrice isEqual:@"(null)"]) {
            txtField.text = @"";
        } else {
            txtField.text = [NSString stringWithFormat:@"%.2f", [orderline.PDFPrice doubleValue]];
        }
    }

    txtField.layer.borderColor =[[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]CGColor];
    [txtField.layer setBorderWidth:1.0];
    
    [txtField setTextColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]];
    //    [txtField setBackgroundColor:[[UIColor alloc] initWithRed:194.0 / 255 green:213.0 / 255 blue:221.0 / 255 alpha:1.0]];

    [txtField addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
//    [txtField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [txtField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];

    txtField.keyboardType = UIKeyboardTypeNumberPad;
    cell.accessoryView = txtField;

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

-(void)textFieldDidBeginEditing:(UITextField *)txtField{
#warning superview
    cellSelected = (UITableViewCell*)[txtField superview];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        editDetailTableView.contentInset =  UIEdgeInsetsMake(0, 0, 295, 0);
        [editDetailTableView scrollToRowAtIndexPath:[editDetailTableView indexPathForCell:cellSelected] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else
    {
        editDetailTableView.contentInset =  UIEdgeInsetsMake(0, 0, 200, 0);
        [editDetailTableView scrollToRowAtIndexPath:[editDetailTableView indexPathForCell:cellSelected] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
//
//- (void)textFieldDidChange:(UITextField *)txtField {
//    cellSelected = (UITableViewCell*)[txtField superview];
//
//    // changed from [(UITableView *)cellSelected.superview indexPathForCell:cellSelected]
//    NSIndexPath *indexPath = [editDetailTableView indexPathForCell:cellSelected];
//
//    if ([type isEqualToString:NP]) {
//        OrderLine* tmpOrderLine = (OrderLine*)[self.tableArray objectAtIndex:indexPath.row];
//        tmpOrderLine.PDFPrice = [NSString stringWithFormat:@"%.2f", [txtField.text doubleValue]];
//        txtField.text = [NSString stringWithFormat:@"%@", tmpOrderLine.PDFPrice];
//    } else if ([type isEqualToString:GM]) {
//        GMOrderLine* tmpOrderLine = (GMOrderLine*)[self.tableArray objectAtIndex:indexPath.row];
//        tmpOrderLine.PDFPrice = [NSString stringWithFormat:@"%.2f", [txtField.text doubleValue]];
//        txtField.text = [NSString stringWithFormat:@"%@", tmpOrderLine.PDFPrice];
//    }
//}


-(void)textFieldDidEndEditing:(UITextField *)txtField{
    cellSelected = (UITableViewCell*)[txtField superview];
    
    // changed from [(UITableView *)cellSelected.superview indexPathForCell:cellSelected]
    NSIndexPath *indexPath = [editDetailTableView indexPathForCell:cellSelected];
    
    if ([type isEqualToString:NP]) {
        OrderLine* tmpOrderLine = (OrderLine*)[self.tableArray objectAtIndex:indexPath.row];
        tmpOrderLine.PDFPrice = [NSString stringWithFormat:@"%.2f", [txtField.text doubleValue]];
        txtField.text = [NSString stringWithFormat:@"%@", tmpOrderLine.PDFPrice];
    } else if ([type isEqualToString:GM]) {
        GMOrderLine* tmpOrderLine = (GMOrderLine*)[self.tableArray objectAtIndex:indexPath.row];
        tmpOrderLine.PDFPrice = [NSString stringWithFormat:@"%.2f", [txtField.text doubleValue]];
        txtField.text = [NSString stringWithFormat:@"%@", tmpOrderLine.PDFPrice];
    }

    cellSelected = nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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

    if(cellSelected) {

        NSIndexPath *indexPath = [editDetailTableView indexPathForCell:cellSelected];

        if ([type isEqualToString:NP]) {
            UITextField *txtField = (UITextField*)cellSelected.accessoryView;
            OrderLine* tmpOrderLine = (OrderLine*)[self.tableArray objectAtIndex:indexPath.row];
            tmpOrderLine.PDFPrice = [NSString stringWithFormat:@"%.2f", [txtField.text doubleValue]];
            txtField.text = [NSString stringWithFormat:@"%@", tmpOrderLine.PDFPrice];
        } else if ([type isEqualToString:GM]) {
            UITextField *txtField = (UITextField*)cellSelected.accessoryView;
            GMOrderLine* tmpOrderLine = (GMOrderLine*)[self.tableArray objectAtIndex:indexPath.row];
            tmpOrderLine.PDFPrice = [NSString stringWithFormat:@"%.2f", [txtField.text doubleValue]];
            txtField.text = [NSString stringWithFormat:@"%@", tmpOrderLine.PDFPrice];
        }
        
        cellSelected = nil;
    }
    
    // update order line pdf prices
    if ([type isEqualToString:NP]) {
        for (OrderLine *orderline in self.tableArray) {
            [OrderLine updateOrderLine:orderline];
        }
    } else if ([type isEqualToString:GM]) {
        for (GMOrderLine *orderline in self.tableArray) {
            [GMOrderLine updateOrderLine:orderline];
        }
    }
    //send notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PDFPriceUpdate" object:self];
    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
