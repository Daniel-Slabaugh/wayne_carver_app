//
//  EditDetailScreenVC.m
//  wayne mobile
//
//  Created by Daniel Slabaugh on 10/26/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "EditDetailScreenVC.h"

#import "EditOrderScreenVC.h"

#import "Ship.h"
#import "Address.h"

@interface EditDetailScreenVC ()

@end

@implementation EditDetailScreenVC
@synthesize orderHeaderInfo;
@synthesize gmorderHeaderInfo;
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

    
    if ([type isEqualToString:@"Store"]) {
        NSMutableArray * unsortedStores = [Address getAddressesWhere:orderHeaderInfo.CustNum];
        NSArray * sorted = [[NSArray alloc] initWithArray:[unsortedStores sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = [(Address*)a StoreID];
            NSString *second = [(Address*)b StoreID];
            return [first compare:second];
        }]];
        self.tableArray = [NSMutableArray arrayWithArray:sorted];
    } else if ([type isEqualToString:@"ShipMethod"] || [type isEqualToString:@"GMShipMethod"]) {
        NSMutableArray * unsortedShip = [Ship getAllShipTypes];
        NSArray * sorted = [[NSArray alloc] initWithArray:[unsortedShip sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = [(Ship*)a ShipType];
            NSString *second = [(Ship*)b ShipType];
            return [first compare:second];
        }]];
        self.tableArray = [NSMutableArray arrayWithArray:sorted];
    } else if ([type isEqualToString:@"GMStore"]) {
        NSMutableArray * unsortedStores = [Address getAddressesWhere:gmorderHeaderInfo.CustNum];
        NSArray * sorted = [[NSArray alloc] initWithArray:[unsortedStores sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = [(Address*)a StoreID];
            NSString *second = [(Address*)b StoreID];
            return [first compare:second];
        }]];
        self.tableArray = [NSMutableArray arrayWithArray:sorted];
    }

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
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    if ([type isEqualToString:@"Store"] || [type isEqualToString:@"GMStore"]) {
        Address * store = nil;
        store = [self.tableArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", store.StoreID, store.Addr1];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@ %@", store.City, store.State, store.Zip];
    } else if ([type isEqualToString:@"ShipMethod"] || [type isEqualToString:@"GMShipMethod"]) {
        Ship *shipping = nil;
        
        shipping = [self.tableArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", shipping.ShipType];
    }
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([type isEqualToString:@"Store"]) {
        Address *tmpAddress = [self.tableArray objectAtIndex:indexPath.row];
        orderHeaderInfo.StoreID = tmpAddress.StoreID;
    } else if ([type isEqualToString:@"ShipMethod"]) {
        Ship *tmpShip = [self.tableArray objectAtIndex:indexPath.row];
        orderHeaderInfo.ShipMethod = tmpShip.ShipType;
    } else if ([type isEqualToString:@"GMStore"]) {
        Address *tmpAddress = [self.tableArray objectAtIndex:indexPath.row];
        gmorderHeaderInfo.StoreID = tmpAddress.StoreID;
    } else if ([type isEqualToString:@"GMShipMethod"]) {
        Ship *tmpShip = [self.tableArray objectAtIndex:indexPath.row];
        gmorderHeaderInfo.ShipMethod = tmpShip.ShipType;
    }
    
    if ([type isEqualToString:@"Store"] || [type isEqualToString:@"ShipMethod"]) {
        //send notification
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:self];
    } else if([type isEqualToString:@"GMStore"] || [type isEqualToString:@"GMShipMethod"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GMUpdateData" object:self];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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



