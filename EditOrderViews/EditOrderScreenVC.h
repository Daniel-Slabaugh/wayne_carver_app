//
//  EditOrderScreenVC.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/26/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderHeader.h"
#import "OrderLine.h"


@interface EditOrderScreenVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * orderTableView;
    IBOutlet UIPickerView *pickerView;
    NSMutableArray *numbersArray;
    UITableViewCell *cellSelected;
    NSInteger numItemsOrdered;
    BOOL deleteItem;
}

@property (nonatomic, retain) OrderLine * orderLineInfo;
@property (nonatomic, retain) OrderHeader * orderHeaderInfo;
@property (nonatomic, retain) NSArray * allTableData;
@property (strong, nonatomic) NSMutableDictionary* filteredTableData;
@property (strong, nonatomic) NSArray* letters;
@property (retain, nonatomic) UITableViewCell *cellSelected;
@property (nonatomic, assign) bool isFiltered;
@property (readonly, retain) UIView *inputAccessoryView;
@property (retain, nonatomic) IBOutlet UIButton *btnTxtToFill;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *btnBadItemCount;
- (IBAction)btnBadItemCount:(id)sender;
- (IBAction)btnSave:(id)sender;
- (IBAction)btnBack:(id)sender;
- (IBAction)btnDelete:(id)sender;

@end