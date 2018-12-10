//
//  WayneOrdersTableVC.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 8/6/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderHeader.h"

@interface WayneOrdersTableVC : UIViewController
{
    IBOutlet UITableView * orderTableView;
}

@property (nonatomic, retain) NSArray * customersArray;
@property (strong, nonatomic) NSArray* allTableData;
@property (strong, nonatomic) NSMutableDictionary* filteredTableData;
@property (strong, nonatomic) NSArray* letters;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) bool isFiltered;
@property (nonatomic, retain) NSString *sortingConvention;


@property (nonatomic, retain) NSMutableArray * ordersArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *dateRec;
@property (nonatomic, strong) NSDate *dateAcc;
@property (nonatomic, retain) OrderHeader * useDateToShip;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnPickDate;
- (IBAction)btnPickDate:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnSortBy;
- (IBAction)btnSortBy:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnBarTitle;
@property (retain, nonatomic) IBOutlet UIDatePicker *pickerView;

- (IBAction)btnBack:(id)sender;
- (IBAction)btnDateInfo:(id)sender;

@end
