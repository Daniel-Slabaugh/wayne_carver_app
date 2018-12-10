//
//  EditDetailScreenVC.h
//  wayne mobile
//
//  Created by Daniel Slabaugh on 10/26/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderHeader.h"
#import "GMOrderHeader.h"

@interface EditDetailScreenVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * editDetailTableView;
}

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSMutableArray * tableArray;
@property (nonatomic, retain) OrderHeader * orderHeaderInfo;
@property (nonatomic, retain) GMOrderHeader * gmorderHeaderInfo;


- (IBAction)btnBack:(id)sender;


@end


