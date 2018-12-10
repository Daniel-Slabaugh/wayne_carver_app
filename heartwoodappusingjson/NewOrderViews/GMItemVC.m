//
//  GMItemVC.m
//  wayne mobile
//
//  Created by Delphi Dev Computer on 7/10/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import "GMItemVC.h"
#import "GMItem.h"

#define NEW                 @"NewLine"
//Not using the edit capability for now, may implement in a later version
//#define EDIT                @"EditLine"

@interface GMItemVC ()

@end

@implementation GMItemVC
@synthesize allTableData;
@synthesize filteredTableData;
@synthesize letters;
@synthesize searchBar;
@synthesize isFiltered;
@synthesize status;
@synthesize orderLineInfo;
@synthesize orderLineArray;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray * unsortedCustomers = [GMItem getAllItems];
    self.allTableData = [unsortedCustomers sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first =  [(GMItem*)a ItemNum];
        NSString *second = [(GMItem*)b ItemNum];
        return [first compare:second];
    }];
    
    
    [customerTableView reloadData];
    [self updateTableData:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    GMItem* gmItem = (GMItem*)[arrayForLetter objectAtIndex:indexPath.row];
    
    cell.textLabel.text = gmItem.ItemNum;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:20]];
        // The device is an iPad running iPhone 3.2 or later.
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",gmItem.ItemDescription];
    }
    else
    {
        // The device is an iPhone or iPod touch.
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",gmItem.ItemDescription];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setNumberOfLines:2];
    }
    
    
    return cell;
}

-(void)updateTableData:(NSString*)searchString {
    filteredTableData = [[NSMutableDictionary alloc] init];
    
    for (GMItem* gmItem in allTableData) {
        bool isMatch = false;
        if(searchString.length == 0)
        {
            // If our search string is empty, everything is a match
            isMatch = true;
        }
        else
        {
            // If we have a search string, check to see if it matches the food's name or description
            NSRange nameRange = [gmItem.ItemNum rangeOfString:searchString options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [gmItem.ItemDescription rangeOfString:searchString options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
                isMatch = true;
        }
//        if ([status isEqualToString:NEW]) {
//            for (GMOrderLine* tmpItem in orderLineArray) {
//                if ([gmItem.ItemNum isEqualToString:tmpItem.ItemNum])
//                    isMatch = false;
//            }
//        }

        
        // If we have a match...
        if(isMatch)
        {
            if (gmItem.Minimum == 6) {
                // Find the first letter of the item's name. This will be its group
                NSString* firstLetter = nil;
                
                firstLetter = @"  6 Pcs";
                
                // Check to see if we already have an array for this group
                NSMutableArray* arrayForLetter = (NSMutableArray*)[filteredTableData objectForKey:firstLetter];
                if(arrayForLetter == nil)
                {
                    // If we don't, create one, and add it to our dictionary
                    arrayForLetter = [[NSMutableArray alloc] init];
                    [filteredTableData setValue:arrayForLetter forKey:firstLetter];
                }
                
                // Finally, add the item to this group's array
                [arrayForLetter addObject:gmItem];
            } else if (gmItem.Minimum == 12) {
                
                // Find the first letter of the item's name. This will be its group
                NSString* firstLetter = @" 12 Pcs";
                
                // Check to see if we already have an array for this group
                NSMutableArray* arrayForLetter = (NSMutableArray*)[filteredTableData objectForKey:firstLetter];
                if(arrayForLetter == nil)
                {
                    // If we don't, create one, and add it to our dictionary
                    arrayForLetter = [[NSMutableArray alloc] init];
                    [filteredTableData setValue:arrayForLetter forKey:firstLetter];
                }
                
                // Finally, add the item to this group's array
                [arrayForLetter addObject:gmItem];
            } else {
                
                // Find the first letter of the item's name. This will be its group
                NSString* firstLetter = @"Other";
                
                // Check to see if we already have an array for this group
                NSMutableArray* arrayForLetter = (NSMutableArray*)[filteredTableData objectForKey:firstLetter];
                if(arrayForLetter == nil)
                {
                    // If we don't, create one, and add it to our dictionary
                    arrayForLetter = [[NSMutableArray alloc] init];
                    [filteredTableData setValue:arrayForLetter forKey:firstLetter];
                }
                
                // Finally, add the item to this group's array
                [arrayForLetter addObject:gmItem];
            }
        }
    }
    
    // Make a copy of our dictionary's keys, and sort them
    letters = [[NSArray alloc] initWithArray:[[filteredTableData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    
    // Finally, refresh the table
    [customerTableView reloadData];
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
    GMItem* gmItem = (GMItem*)[arrayForLetter objectAtIndex:indexPath.row];
    
    orderLineInfo.ItemNum = gmItem.ItemNum;
    
    if ([status isEqualToString:NEW]) {
        [GMOrderLine insertInto:orderLineInfo];
    }
//    else if ([status isEqualToString:EDIT]) {
//        [GMOrderLine updateOrderLine:orderLineInfo WithOldItemNum:oldItemNum];
//    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"GMOUpdateData" object:self];

    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)btnback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

