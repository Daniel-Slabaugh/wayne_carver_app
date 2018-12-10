//
//  ContactInfoVC.m
//  wayne mobile
//
//  Created by Daniel Slabaugh on 7/27/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "ContactInfoVC.h"
#import "User.h"

@interface ContactInfoVC ()

@end

@implementation ContactInfoVC
@synthesize lblCell;
@synthesize lblEmail;
@synthesize lblFAX;
@synthesize lblName;
@synthesize lblPhone;
@synthesize lblUserID;
@synthesize scrollView;

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
    NSMutableArray *users = [User getAllUsers];
    User *user = [users objectAtIndex:0];
    lblUserID.text = user.UserID;
    lblName.text = [NSString stringWithFormat:@"%@ %@", user.FirstName, user.LastName];
    lblCell.text = user.Cell;
    lblEmail.text = user.Email;
    lblFAX.text = user.FAX;
    lblPhone.text = user.Phone;
    
    if (!(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
    {
        // The device is an iPhone or iPod touch.
        [self->scrollView setContentSize:CGSizeMake(320, 740)];
        self->scrollView.frame = CGRectMake(0, 45, 320, 575);
        [self.view addSubview:self->scrollView];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
