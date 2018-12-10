//
//  WayneOrdersCustomerTableVC.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 8/12/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "WayneOrdersCustomerTableVC.h"
#import "WayneOrdersScreenVC.h"

#define UNSHIPED @"UNSHIPPED"
#define NEEDSATTN @"NEEDATTN"
#define NORMAL @"NORMAL"

@interface WayneOrdersCustomerTableVC ()

@end

@implementation WayneOrdersCustomerTableVC
@synthesize allTableData;
@synthesize orderInfo;
@synthesize dateFormatter;
@synthesize dateAcc;
@synthesize dateRec;
@synthesize sortType;

- (void) dealloc {
    [allTableData release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationController.navigationBarHidden = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    NSMutableArray * unsorted = [[NSMutableArray alloc] init];
    if ([sortType isEqualToString:UNSHIPED]) {
        NSMutableArray * tmpAllUnsorted = [WayneOrderHeader getAllOrderHeaders];
        for (WayneOrderHeader *tmpHdr in tmpAllUnsorted) {
            if (!([tmpHdr.HeartwoodStatus isEqualToString:@"Closed/Shipped"] || [tmpHdr.HeartwoodStatus isEqualToString:@"CANCELED"])) {
                [unsorted addObject:tmpHdr];
            }
        }
        self.allTableData = [unsorted sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = [(WayneOrderHeader*)a DateAccepted];
            NSString *second = [(WayneOrderHeader*)b DateAccepted];
            return [first compare:second];
        }];
#warning changed for needsattn
    } else if ([sortType isEqualToString:NEEDSATTN]) {
        NSMutableArray * tmpAllUnsorted = [WayneOrderHeader getAllOrderHeaders];
        for (WayneOrderHeader *tmpHdr in tmpAllUnsorted) {
            if ([tmpHdr.RepActionReq isEqualToString:@"1"]) {
                [unsorted addObject:tmpHdr];
            }
        }
        self.allTableData = [unsorted sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = [(WayneOrderHeader*)a DateAccepted];
            NSString *second = [(WayneOrderHeader*)b DateAccepted];
            return [first compare:second];
        }];
    } else {
        
        NSMutableArray * unsorted = [WayneOrderHeader getOrderHeadersWhereCustomer:orderInfo.CustName];
        self.allTableData = [unsorted sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = [(WayneOrderHeader*)a DateAccepted];
            NSString *second = [(WayneOrderHeader*)b DateAccepted];
            return [first compare:second];
        }];
        
    }
    
    [customerTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Returns the number of items in the array associated with the letter for this section.
    return self.allTableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        else
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    //remove all previous buttons and labels added to cell subview
    for (UIButton* tmpbtn in cell.subviews) {
        //        for (UIButton*tmpSubviewbtn in tmpbtn.subviews) { // this is for if the double subview model still needs to work.
        if ([tmpbtn isKindOfClass:[UIButton class]]) { // change all of these back to tmpSubviewbtn for double subview model
            [tmpbtn removeFromSuperview];
        } else if ([tmpbtn isKindOfClass:[UILabel class]]) {
            [tmpbtn removeFromSuperview];
        }
        //        }
    }
    
    
    WayneOrderHeader* tmpOrder = (WayneOrderHeader*)[allTableData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Store: %@", tmpOrder.StoreName];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    else
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    if ([tmpOrder.DateAccepted isEqual:@"<null>"] || [tmpOrder.DateAccepted isEqual:@"(null)"]) {
        NSLog(@"%@", tmpOrder.DateReceived);
        dateRec = [self.dateFormatter dateFromString:tmpOrder.DateReceived];
        [self.dateFormatter setDateFormat:@"MM-dd-yyyy"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Received on: %@", [self.dateFormatter stringFromDate:dateRec]];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    } else {
        dateAcc = [self.dateFormatter dateFromString:tmpOrder.DateAccepted];
        [self.dateFormatter setDateFormat:@"MM-dd-yyyy"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Accepted on: %@", [self.dateFormatter stringFromDate:dateAcc]];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    if ([tmpOrder.RepActionReq isEqual:@"1"]) {
        [cell.textLabel setTextColor:[UIColor redColor]];
        [cell.detailTextLabel setTextColor:[UIColor redColor]];
        //insert description label
        UILabel *lblDescription = [[UILabel alloc] init];
        lblDescription.frame = CGRectMake(450.0, 5.0, 275.0, 140.0);
        lblDescription.text =  [NSString stringWithFormat:@"Status: %@\nAction Required!", tmpOrder.Status];
        [lblDescription setFont:[UIFont boldSystemFontOfSize:20]];
        [lblDescription setTextAlignment:NSTextAlignmentLeft];
        [lblDescription setAdjustsFontSizeToFitWidth:YES];
        [lblDescription setNumberOfLines:2];
        [lblDescription setMinimumScaleFactor:.5];
        [lblDescription setTextColor:[UIColor redColor]];
        [cell addSubview:lblDescription];
        [lblDescription release];
    } else {
        //insert description label
        UILabel *lblDescription = [[UILabel alloc] init];
        lblDescription.frame = CGRectMake(450.0, 5.0, 275.0, 40.0);
        if ([tmpOrder.Status isEqual:(@"<null>")] || [tmpOrder.Status isEqual:@"(null)"]) {
            lblDescription.text = @"No Status Available";
        } else {
            lblDescription.text =  [NSString stringWithFormat:@"Status: %@", tmpOrder.Status];
        }
        [lblDescription setFont:[UIFont boldSystemFontOfSize:20]];
        [lblDescription setTextAlignment:NSTextAlignmentLeft];
        [lblDescription setAdjustsFontSizeToFitWidth:YES];
        [lblDescription setNumberOfLines:1];
        [lblDescription setMinimumScaleFactor:.5];
        [lblDescription setTextColor:[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]];
        [cell addSubview:lblDescription];
        [lblDescription release];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WayneOrderHeader* tmpOrder = (WayneOrderHeader*)[allTableData objectAtIndex:indexPath.row];
    
    if([tmpOrder.RepActionReq isEqual:@"1"]) {
        return 150.0;
    }
    // "Else"
    return 55.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WayneOrderHeader* ordHdr = (WayneOrderHeader*)[self.allTableData objectAtIndex:indexPath.row];
    
    WayneOrdersScreenVC *view = [self.storyboard instantiateViewControllerWithIdentifier:@"wayneOrder"];
    view.orderHeaderInfo = ordHdr;
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)btnback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
