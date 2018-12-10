//
//  GMArtNameVC.h
//  wayne mobile
//
//  Created by Daniel Slabaugh on 7/14/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMOrderLine.h"



@interface GMArtNameVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * customerTableView;
}

- (IBAction)btnback:(id)sender;

@property (strong, nonatomic) NSArray* allTableData;

@property (nonatomic, retain) NSString *artNameInfo;
@property (nonatomic, retain) NSMutableArray *artNameArray;
@property (nonatomic, retain) GMOrderLine *orderLineInfo;
@property (nonatomic) BOOL newArt;

@property (nonatomic, retain) NSString * status;

@property (retain, nonatomic) IBOutlet UIButton *barButtonLabel;

@end
