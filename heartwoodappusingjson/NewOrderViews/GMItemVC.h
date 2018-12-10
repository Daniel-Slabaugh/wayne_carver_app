//
//  GMItemVC.h
//  wayne mobile
//
//  Created by Delphi Dev Computer on 7/10/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMOrderLine.h"

@interface GMItemVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
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

@property (nonatomic, retain) GMOrderLine *orderLineInfo;
@property (nonatomic, retain) NSMutableArray *orderLineArray;

@property (nonatomic, retain) NSString * status;


@end
