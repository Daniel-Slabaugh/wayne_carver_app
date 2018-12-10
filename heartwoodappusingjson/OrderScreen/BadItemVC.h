//
//  BadItemVC.h
//  wayne mobile
//
//  Created by Daniel Slabaugh on 10/29/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderLine.h"

@interface BadItemVC : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet UIPickerView *pickerView;
    NSMutableArray *numbersArray;
}

@property (nonatomic, retain) OrderLine *orderLine;
@property (retain, nonatomic) IBOutlet UILabel *lblBadItems;

- (IBAction)btDone:(id)sender;

@end
