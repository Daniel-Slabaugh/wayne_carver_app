//
//  CustomerTableVC
//  wayne mobile
//
//  Created by Daniel Slabaugh on 7/5/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMOrderHeader.h"

@interface CustomerTableVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * customerTableView;
}

- (IBAction)btnback:(id)sender;

@property (nonatomic, retain) NSArray * customersArray;

@property (strong, nonatomic) NSArray* allTableData;
@property (strong, nonatomic) NSMutableDictionary* filteredTableData;
@property (strong, nonatomic) NSArray* letters;

@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) bool isFiltered;


@property (nonatomic, retain) NSString * status;

@property (nonatomic, retain) GMOrderHeader *gmorderHeaderInfo;


@end
