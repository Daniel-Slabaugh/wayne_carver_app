//
//  GMOrderScreenVC.h
//  wayne mobile
//
//  Created by Delphi Dev Computer on 6/12/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMOrderHeader.h"


@interface GMOrderScreenVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate>
{
    IBOutlet UITableView *orderLineView;
    IBOutlet UIScrollView *scrollView;
    NSInteger numItemsOrdered;
}

- (IBAction)btnSave:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnSave;
- (IBAction)btnCancel:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *btnCancel;

@property (nonatomic, retain) GMOrderHeader * orderHeaderInfo;
@property (nonatomic, retain) NSMutableArray * orderLineArray;
@property (nonatomic, retain) NSMutableArray * artNumbers;
@property (nonatomic, retain) NSMutableArray * nameDrop;
@property (nonatomic, strong) NSString *alertAction;
@property (retain, nonatomic) UITableViewCell *cellSelected;

@property (retain, nonatomic) IBOutlet UITextField *txtArt1;
@property (retain, nonatomic) IBOutlet UITextField *txtArt2;
@property (retain, nonatomic) IBOutlet UITextField *txtArt3;
@property (retain, nonatomic) IBOutlet UITextField *txtArt4;
@property (retain, nonatomic) IBOutlet UITextField *txtArt5;
@property (retain, nonatomic) IBOutlet UITextField *txtArt6;

@property (retain, nonatomic) IBOutlet UITextField *txtNewCustomArt1;
@property (retain, nonatomic) IBOutlet UITextField *txtNewCustomArt2;
@property (retain, nonatomic) IBOutlet UITextField *txtNewCustomArt3;
- (IBAction)txtNewCustomArt:(id)sender;
@property (nonatomic) BOOL newArt;

@property (retain, nonatomic) IBOutlet UITextField *txtOptionalNameDrop1;
@property (retain, nonatomic) IBOutlet UITextField *txtOptionalNameDrop2;
@property (retain, nonatomic) IBOutlet UITextField *txtOptionalNameDrop3;


-(void)saveData;

@end
