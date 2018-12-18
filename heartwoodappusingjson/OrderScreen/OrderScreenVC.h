//
//  OrderScreenVC.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/17/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "Address.h"
#import "OrderLine.h"

@interface OrderScreenVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * orderTableView;
    UITableViewCell *cellSelected;
    NSInteger numItemsOrdered;
}

@property (nonatomic, retain) NSString *alertViewAction;
@property (nonatomic, retain) OrderLine *orderlineinfo;
@property (nonatomic, retain) Item * itemInfo;
@property (nonatomic, retain) Address * addressInfo; 
@property (nonatomic, retain) NSArray * allTableData;
@property (strong, nonatomic) NSMutableDictionary* filteredTableData;
@property (strong, nonatomic) NSArray* letters;
@property (retain, nonatomic) UITableViewCell *cellSelected;
@property (nonatomic, assign) bool isFiltered;
@property (readonly, retain) UIView *inputAccessoryView;
@property (retain, nonatomic) IBOutlet UIButton *btnTxtToFill;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *btnBadItems;
- (IBAction)btnBadItems:(id)sender;

- (IBAction)btnBack:(id)sender;
- (IBAction)btnSaveAndSend:(id)sender;
@end
