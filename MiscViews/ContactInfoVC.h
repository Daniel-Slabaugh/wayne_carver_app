//
//  ContactInfoVC.h
//  wayne mobile
//
//  Created by Daniel Slabaugh on 7/27/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactInfoVC : UIViewController
- (IBAction)btnBack:(id)sender;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UILabel *lblUserID;
@property (retain, nonatomic) IBOutlet UILabel *lblName;
@property (retain, nonatomic) IBOutlet UILabel *lblEmail;
@property (retain, nonatomic) IBOutlet UILabel *lblPhone;
@property (retain, nonatomic) IBOutlet UILabel *lblCell;
@property (retain, nonatomic) IBOutlet UILabel *lblFAX;
@end
