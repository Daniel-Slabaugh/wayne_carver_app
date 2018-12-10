//
//  GMInfoVC.m
//  wayne mobile
//
//  Created by Delphi Dev Computer on 7/30/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import "GMInfoVC.h"

@interface GMInfoVC ()

@end

@implementation GMInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
