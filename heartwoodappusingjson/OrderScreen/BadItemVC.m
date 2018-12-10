//
//  BadItemVC.m
//  wayne mobile
//
//  Created by Daniel Slabaugh on 10/29/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "BadItemVC.h"

@interface BadItemVC ()

@end

@implementation BadItemVC
@synthesize lblBadItems;
@synthesize orderLine;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    numbersArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 100; i++) {
        [numbersArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    [self showShipPicker];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerViewDataSource

- (void)slideDownDidStop {
	// the date picker has finished sliding downwards, so remove it from the view hierarchy
	[self->pickerView removeFromSuperview];
}

- (void)hidePicker {
    CGRect pickerShipFrame = self->pickerView.frame;
    pickerShipFrame.origin.y = self.view.frame.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.40];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
    self->pickerView.frame = pickerShipFrame;
    [UIView commitAnimations];
}

- (void)showShipPicker {
    for (UIView* view in self.view.subviews) {
		if ([view isKindOfClass:[UITextField class]])
			[view resignFirstResponder];
	}
    // the date picker might already be showing, so don't add it to our view
    if (self->pickerView.superview == nil)
    {
        CGRect startFrame = self->pickerView.frame;
        CGRect endFrame = self->pickerView.frame;
        
        // the start position is below the bottom of the visible frame
        startFrame.origin.y = self.view.frame.size.height;
        
        // the end position is slid up by the height of the view
        endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
        
        self->pickerView.frame = startFrame;
        
        [self.view addSubview:self->pickerView];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.40];
        self->pickerView.frame = endFrame;
        [UIView commitAnimations];
        
        for (int row = 0; row < numbersArray.count; row++) {
            if (orderLine.BadItems == [[numbersArray objectAtIndex:row] intValue]) {
                [pickerView selectRow:row inComponent:0 animated:YES];
            }
        }
        lblBadItems.text = [NSString stringWithFormat:@"%ld Defective Items", (long)orderLine.BadItems];
    }

}

- (NSString *)pickerView:(UIPickerView *)pickerViewShip titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSString *returnStr = @"";
    if (pickerViewShip == self->pickerView)
	{
        returnStr = [numbersArray objectAtIndex:row];
	}
	
	return returnStr;
}

- (void)pickerView:(UIPickerView *)pickerViewShip didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (pickerViewShip == pickerView)	// don't show selection for the custom picker
	{
		// report the selection to the UI label
        lblBadItems.text = [NSString stringWithFormat:@"%@ Defective Items", [numbersArray objectAtIndex:[pickerViewShip selectedRowInComponent:0]]];
        orderLine.BadItems = [[numbersArray objectAtIndex:[pickerViewShip selectedRowInComponent:0]] intValue];
	}
}

- (CGFloat)pickerView:(UIPickerView *)pickerViewShip widthForComponent:(NSInteger)component {
	return 120.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerViewShip rowHeightForComponent:(NSInteger)component {
	return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerViewShip numberOfRowsInComponent:(NSInteger)component {
    return numbersArray.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (IBAction)btDone:(id)sender {
    [self hidePicker];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
