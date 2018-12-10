//
//  WayneWebsiteVC.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/26/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "WayneWebsiteVC.h"

@interface WayneWebsiteVC ()

@end

@implementation WayneWebsiteVC
@synthesize webWayneCarver;

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
    NSString *urlAddress = @"http://www.waynecarver.com/";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webWayneCarver loadRequest:requestObj];
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
