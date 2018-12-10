//
//  GMArtNameVC.m
//  wayne mobile
//
//  Created by Daniel Slabaugh on 7/14/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import "GMArtNameVC.h"
#import "GMItem.h"

#define ART                 @"SelectingArt"
#define NAME                @"SelectingName"

@interface GMArtNameVC ()

@end

@implementation GMArtNameVC
@synthesize allTableData;
@synthesize artNameInfo;
@synthesize artNameArray;
@synthesize orderLineInfo;
@synthesize newArt;
@synthesize status;
@synthesize barButtonLabel;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([status isEqualToString:ART]) {
        [barButtonLabel setTitle:[NSString stringWithFormat:@"Select art for %@", [GMItem getItemDesc:orderLineInfo.ItemNum]] forState:UIControlStateNormal];
    } else if ([status isEqualToString:NAME]) {
        [barButtonLabel setTitle:[NSString stringWithFormat:@"Select name drop for %@", [GMItem getItemDesc:orderLineInfo.ItemNum]] forState:UIControlStateNormal];
    }
    
    self.allTableData = artNameArray;
    
    [customerTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Returns the number of items in the array associated with this table.
    return allTableData.count;
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

    NSString* string = (NSString*)[allTableData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = string;

    
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:20]];

    //if last item is new art say so, else old art
    if ([status isEqualToString:ART]) {
        if (newArt == YES && indexPath.row == 0 && indexPath.section == 0) {
            cell.detailTextLabel.text = @"New Custom Art";
        } else if (indexPath.row == (artNameArray.count - 1)) {
            cell.detailTextLabel.text = @"No Art";
        } else {
            cell.detailTextLabel.text = @"Repeat Art";
        }
    } else if ([status isEqualToString:NAME]) {
        cell.detailTextLabel.text = @"";
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* string = (NSString*)[allTableData objectAtIndex:indexPath.row];
    
    if ([status isEqualToString:ART]) {
        orderLineInfo.ArtNum = string;
    } else if ([status isEqualToString:NAME]) {
        orderLineInfo.NameDrop = string;
    }
    
    [GMOrderLine updateOrderLine:orderLineInfo];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GMOUpdateData" object:self];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)btnback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end

