//
//  WayneOrdersTableVC.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 8/6/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#define DATE @"Orders Sorted By Date"
#define CUST @"Orders Sorted By Customer"
#define BTNDATE @"Sort By Date"
#define BTNCUST @"Sort By Customer"

#import "WayneOrdersTableVC.h"
#import "WayneOrdersScreenVC.h"
#import "WayneOrderHeader.h"
#import "WayneOrdersCustomerTableVC.h"
#import "WCDateScreenVC.h"

@interface WayneOrdersTableVC ()

@end

@implementation WayneOrdersTableVC
@synthesize ordersArray;
@synthesize dateFormatter;
@synthesize dateAcc;
@synthesize dateRec;
@synthesize btnPickDate;
@synthesize btnSortBy;
@synthesize btnBarTitle;
@synthesize sortingConvention;
@synthesize allTableData;
@synthesize filteredTableData;
@synthesize letters;
@synthesize searchBar;
@synthesize isFiltered;
@synthesize pickerView;
@synthesize useDateToShip;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![self.sortingConvention isEqualToString:CUST] && ![self.sortingConvention isEqualToString:DATE]) {
        self.sortingConvention = CUST;
    }
    
    // notification for post working
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"UpdateDateData"
                                               object:nil];
    
    // hide btnPickDate
    btnPickDate.width = .00001;
    btnPickDate.enabled = NO;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date1 = [NSDate date];
    useDateToShip = [[OrderHeader alloc] init];
    useDateToShip.DateToShip = [self.dateFormatter stringFromDate:date1];
    
    
    self.ordersArray = [[NSMutableArray alloc] init];
    self.ordersArray = [WayneOrderHeader getAllOrderHeaders];
    
//    if ([btnBarTitle.titleLabel.text isEqual: CUST]) {
    if ([self.sortingConvention isEqualToString:CUST]) {
        [self getUniqueCustomers];
    } else {
        self.allTableData = [ordersArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = [(WayneOrderHeader*)a DateAccepted];
            NSString *second = [(WayneOrderHeader*)b DateAccepted];
            return [first compare:second];
        }];
    }
    
    
    
    NSLog(@"ASD %@", useDateToShip.DateToShip);
    
    if (self.ordersArray.count == 0) {
        WayneOrderHeader *temp = [[WayneOrderHeader alloc] init];
        temp.CustName = @"No";
        temp.StoreName = @"Records";
        temp.DateAccepted = @"";
        temp.OrderNum = 0;
        [self.ordersArray addObject:temp];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"No orders" message:@"There are no orders in the system at this time..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    
    [orderTableView reloadData];
    [self updateTableData:@""];
}

- (void)getUniqueCustomers {
    NSMutableArray *tmpOrders = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.ordersArray.count; i++) {
        WayneOrderHeader *tmpHdr = [self.ordersArray objectAtIndex:i];
        // may have to add more fields.
        NSDictionary *tmpDict = [NSDictionary dictionaryWithObjectsAndKeys:tmpHdr.CustName, @"name", nil];
        [tmpOrders addObject:tmpDict];
    }
    
    NSLog(@"Unique CustNames:\n %@", [tmpOrders valueForKeyPath:@"@distinctUnionOfObjects.name"]);
    NSArray *uniqueCustArray = [tmpOrders valueForKeyPath:@"@distinctUnionOfObjects.name"];
    [self.ordersArray removeAllObjects];
    for (int i = 0; i < uniqueCustArray.count; i++) {
        WayneOrderHeader *tmp = [WayneOrderHeader getOrderHeaderWhereCustomer:[uniqueCustArray objectAtIndex:i]];
        [self.ordersArray addObject:tmp];
    }
    self.allTableData = [ordersArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(WayneOrderHeader*)a CustName];
        NSString *second = [(WayneOrderHeader*)b CustName];
        return [first compare:second];
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        else
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Grab the object for the specified row and section
    NSString* letter = [letters objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
    WayneOrderHeader* tmpOrder = (WayneOrderHeader*)[arrayForLetter objectAtIndex:indexPath.row];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
//        if (![btnBarTitle.titleLabel.text isEqual: CUST]) {
        if ([self.sortingConvention isEqualToString:DATE]) {

            // The device is an iPad running iPhone 3.2 or later.
            cell.textLabel.text = [NSString stringWithFormat:@"Store: %@", tmpOrder.StoreName];
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"Customer: %@", tmpOrder.CustName];
        }
    }
    else
    {
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        // The device is an iPhone or iPod touch.
//        if (![btnBarTitle.titleLabel.text isEqual: CUST]) {
        if ([self.sortingConvention isEqualToString:DATE]) {
        // The device is an iPad running iPhone 3.2 or later.
            cell.textLabel.text = [NSString stringWithFormat:@"Store: %@", tmpOrder.StoreName];
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"Cust: %@", tmpOrder.CustName];
            
        }
    }
    
//    if (![btnBarTitle.titleLabel.text isEqual: CUST]) {
    if ([self.sortingConvention isEqualToString:DATE]) {
        if ([tmpOrder.DateAccepted isEqual:@"<null>"]) {
            if (![tmpOrder.DateReceived isEqual:@"(null)"]) {
                NSLog(@"%@", tmpOrder.DateReceived);
                [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
                dateRec = [self.dateFormatter dateFromString:tmpOrder.DateReceived];
                [self.dateFormatter setDateFormat:@"MM-dd-yyyy"];
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"Received on: %@", [self.dateFormatter stringFromDate:dateRec]];
                [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
            }
        } else {
            dateAcc = [self.dateFormatter dateFromString:tmpOrder.DateAccepted];
            [self.dateFormatter setDateFormat:@"MM-dd-yyyy"];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Accepted on: %@", [self.dateFormatter stringFromDate:dateAcc]];
            [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
    } else {
        NSMutableArray *countArray = [WayneOrderHeader getOrderHeadersWhereCustomer:tmpOrder.CustName];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu Orders",  (unsigned long)countArray.count];
        }
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // Each letter is a section title
    NSString* key = [letters objectAtIndex:section];
    return key;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of letters in our letter array. Each letter represents a section.
    return letters.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Returns the number of items in the array associated with the letter for this section.
    NSString* letter = [letters objectAtIndex:section];
    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
    return arrayForLetter.count;
}

-(void)updateTableData:(NSString*)searchString {
    filteredTableData = [[NSMutableDictionary alloc] init];
    
    for (WayneOrderHeader* customer in allTableData)
    {
        bool isMatch = false;
        if(searchString.length == 0)
        {
            // If our search string is empty, everything is a match
            isMatch = true;
        }
        else
        {
            // If we have a search string, check to see if it matches the food's name or description
            NSRange nameRange = [customer.CustName rangeOfString:searchString options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [customer.CustNum rangeOfString:searchString options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
                isMatch = true;
        }
        
        // If we have a match...
        if(isMatch)
        {
            // Find the first letter of the item's name. This will be its group
            if ([customer.CustName isEqual:@""]) {
                customer.CustName = @" ";
            }
            NSString* firstLetter = [customer.CustName substringToIndex:1];
            
            // Check to see if we already have an array for this group
            NSMutableArray* arrayForLetter = (NSMutableArray*)[filteredTableData objectForKey:firstLetter];
            if(arrayForLetter == nil)
            {
                // If we don't, create one, and add it to our dictionary
                arrayForLetter = [[NSMutableArray alloc] init];
                [filteredTableData setValue:arrayForLetter forKey:firstLetter];
            }
            
            // Finally, add the item to this group's array
            [arrayForLetter addObject:customer];
        }
    }
    
    // Make a copy of our dictionary's keys, and sort them
    letters = [[NSArray alloc] initWithArray:[[filteredTableData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    
    // Finally, refresh the table
    [orderTableView reloadData];
    
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    [self updateTableData:text];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return letters;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index {
    return index;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Grab the object for the specified row and section
    NSString* letter = [letters objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
    WayneOrderHeader* ordHdr = (WayneOrderHeader*)[arrayForLetter objectAtIndex:indexPath.row];
    
//    if ([btnBarTitle.titleLabel.text isEqual: CUST]) {
    if ([self.sortingConvention isEqualToString:CUST]) {
        WayneOrdersCustomerTableVC *orderView = [self.storyboard instantiateViewControllerWithIdentifier:@"wayneCustomerTable"];
        orderView.sortType = @"NORMAL";
        orderView.orderInfo = ordHdr;
        [self.navigationController pushViewController:orderView animated:YES];
    } else {
        
        WayneOrdersScreenVC *orderView = [self.storyboard instantiateViewControllerWithIdentifier:@"wayneOrder"];
        orderView.orderHeaderInfo = ordHdr;
        [self.navigationController pushViewController:orderView animated:YES];
    }
}

- (IBAction)btnPickDate:(id)sender {
	[self showPicker];
}

- (void)showPicker {
    WCDateScreenVC *editDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"WCDateScreen"];
    editDetailView.orderHeaderInfo = useDateToShip;
    editDetailView.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentViewController:editDetailView animated:YES completion:nil];
}



- (IBAction)btnSortBy:(id)sender {
//    if ([btnBarTitle.titleLabel.text isEqual:CUST]) {
    if ([self.sortingConvention isEqualToString:CUST]) {
        btnBarTitle.titleLabel.text = DATE;
        self.sortingConvention = DATE;
        btnSortBy.title = BTNCUST;
        btnPickDate.enabled = YES;
        btnPickDate.title = @"Pick Date";
        btnPickDate.width = .0;
        [self showPicker];
    } else {
        btnBarTitle.titleLabel.text = CUST;
        self.sortingConvention = CUST;
        btnSortBy.title = BTNDATE;
        btnPickDate.enabled = NO;
        btnPickDate.width = .00001;
        self.ordersArray = [WayneOrderHeader getAllOrderHeaders];
        [self getUniqueCustomers];
        [self updateTableData:@""];
        [orderTableView reloadData];
    }
}

- (void) receiveTestNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"UpdateDateData"]) {
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter1 setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter1 setTimeZone:[NSTimeZone systemTimeZone]];
        NSDate *date = [dateFormatter1 dateFromString:useDateToShip.DateToShip];
        
        self.ordersArray = [WayneOrderHeader getOrderHeadersAfterDate:date];
        
        NSLog(@"Date::: %@", useDateToShip.DateToShip);
        self.allTableData = [ordersArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = [(WayneOrderHeader*)a DateAccepted];
            NSString *second = [(WayneOrderHeader*)b DateAccepted];
            return [first compare:second];
        }];
        [self updateTableData:@""];
    }
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDateInfo:(id)sender {
    
    NSString *message = @"All times for submitted orders are in Chicago's timezone: Central Standard Time. (UTC - 5)";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time Info"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert setAlertViewStyle:UIAlertViewStyleSecureTextInput]; // Gives us the password field
    [alert show];
}

#pragma unimportant

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    [orderTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
