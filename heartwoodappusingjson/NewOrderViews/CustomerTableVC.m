//
//  CustomerTableVC.m
//  wayne mobile
//
//  Created by Daniel Slabaugh on 7/5/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "CustomerTableVC.h"
#import "ItemTableVC.h"
#import "AddressTableVC.h"
#import "Customer.h"
#import "GMBillingShippingInfoVC.h"

#define NP  @"NameProg"
#define GM  @"GeneralMerchandise"


@interface CustomerTableVC ()


@end

@implementation CustomerTableVC
@synthesize allTableData;
@synthesize filteredTableData;
@synthesize letters;
@synthesize searchBar;
@synthesize isFiltered;
@synthesize status;
@synthesize gmorderHeaderInfo;




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
    
    NSMutableArray * unsortedCustomers = [Customer getAllCustomers];
    self.allTableData = [unsortedCustomers sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(Customer*)a CustName];
        NSString *second = [(Customer*)b CustName];
        return [first compare:second];
    }];
    
    
    [customerTableView reloadData];
    [self updateTableData:@""];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        else
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Grab the object for the specified row and section
    NSString* letter = [letters objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
    Customer* customer = (Customer*)[arrayForLetter objectAtIndex:indexPath.row];
    
    cell.textLabel.text = customer.CustName;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:20]];
        // The device is an iPad running iPhone 3.2 or later.
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Customer # %@",customer.CustNum];
    }
    else
    {
        // The device is an iPhone or iPod touch.
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Cust # %@",customer.CustNum];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setNumberOfLines:2];
    }
    
    
    return cell;
}

- (void)updateTableData:(NSString*)searchString {
    filteredTableData = [[NSMutableDictionary alloc] init];
    
    for (Customer* customer in allTableData)
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
            // Find the first letter of the food's name. This will be its group
            NSString* firstLetter = [customer.CustName substringToIndex:1];
            
            // Check to see if we already have an array for this group
            NSMutableArray* arrayForLetter = (NSMutableArray*)[filteredTableData objectForKey:firstLetter];
            if(arrayForLetter == nil)
            {
                // If we don't, create one, and add it to our dictionary
                arrayForLetter = [[NSMutableArray alloc] init];
                [filteredTableData setValue:arrayForLetter forKey:firstLetter];
            }
            
            // Finally, add the food to this group's array
            [arrayForLetter addObject:customer];
        }
    }
    
    // Make a copy of our dictionary's keys, and sort them
    letters = [[NSArray alloc] initWithArray:[[filteredTableData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    
    // Finally, refresh the table
    [customerTableView reloadData];
}

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    [self updateTableData:text];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return letters;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index {
    return index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Grab the object for the specified row and section
    NSString* letter = [letters objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
    Customer* customer = (Customer*)[arrayForLetter objectAtIndex:indexPath.row];
    
    if ([status isEqualToString:NP]) {
        AddressTableVC *addressTableView = [self.storyboard instantiateViewControllerWithIdentifier:@"addressTable"];
        addressTableView.customerInfo = customer;
        [self.navigationController pushViewController:addressTableView animated:YES];
    }
    if ([status isEqualToString:GM]) {
        gmorderHeaderInfo.CustNum = customer.CustNum;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)btnback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)viewDidUnload {
//    [self setSearchBar:nil];
//    [super viewDidUnload];
//}

//To enable rotation
- (BOOL)shouldAutorotate {
    return YES;
}


@end
