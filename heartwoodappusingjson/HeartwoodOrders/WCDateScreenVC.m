//
//  WCDateScreenVC.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 11/27/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "WCDateScreenVC.h"
#define kPickerAnimationDuration 0.40


@interface WCDateScreenVC ()

@end

@implementation WCDateScreenVC
@synthesize txtDate;
@synthesize orderHeaderInfo;
@synthesize txtShown;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    txtDate.text = orderHeaderInfo.DateToShip;
    
    
	for (UIView* view in self.view.subviews) {
		if ([view isKindOfClass:[UITextField class]])
			[view resignFirstResponder];
	}
    

    // initialize and design nsdateformatter and set txtdate to right date and format
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *tmpDate = [self.dateFormatter  dateFromString:orderHeaderInfo.DateToShip];
    txtDate.text = [self.dateFormatter stringFromDate:tmpDate];
    self.pickerView.date = [self.dateFormatter dateFromString:txtDate.text];
    
    txtShown.text = [NSString stringWithFormat:@"Show all orders on or after: %@", [self.dateFormatter stringFromDate:tmpDate]];

}

- (void)viewDidAppear:(BOOL)animated {
    [self ShowPicker];
}

- (void)ShowPicker {
    // the date picker might already be showing, so don't add it to our view
    if (self.pickerView.superview == nil)
    {
        CGRect startFrame = self.pickerView.frame;
        CGRect endFrame = self.pickerView.frame;
        
        // the start position is below the bottom of the visible frame
        startFrame.origin.y = self.view.frame.size.height;
        
        // the end position is slid up by the height of the view
        endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
        
        self.pickerView.frame = startFrame;
        self.pickerView.datePickerMode = UIDatePickerModeDate;
        
        [self.view addSubview:self.pickerView];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kPickerAnimationDuration];
        self.pickerView.frame = endFrame;
        [UIView commitAnimations];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma uipickerview

- (void)slideDownDidStop {
	// the date picker has finished sliding downwards, so remove it from the view hierarchy
	[self.pickerView removeFromSuperview];
}

- (void)hideDatePicker {
    CGRect pickerFrame = self.pickerView.frame;
    pickerFrame.origin.y = self.view.frame.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kPickerAnimationDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
    self.pickerView.frame = pickerFrame;
    [UIView commitAnimations];
}

- (IBAction)dateAction:(id)sender {
	txtDate.text = [self.dateFormatter stringFromDate:self.pickerView.date];
    txtShown.text = [NSString stringWithFormat:@"Show all orders on or after: %@", [self.dateFormatter stringFromDate:self.pickerView.date]];
}

- (void)dealloc {
    [txtDate release];
    [txtShown release];
    [super dealloc];
}

- (IBAction)btnDone:(id)sender {
    [self hideDatePicker];
    
    orderHeaderInfo.DateToShip = txtDate.text;
    
    //send notification to main edit screen
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateDateData" object:self];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end