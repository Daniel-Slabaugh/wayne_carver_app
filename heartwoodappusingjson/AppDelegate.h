//
//  AppDelegate.h
//  wayne mobile
//
//  Created by Daniel Slabaugh on 5/30/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *userID;
    NSString *userPassword;
    NSString *password;
    NSString *wrongPassword;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) NSString *alertString;
@property (nonatomic) BOOL dontShow;









@end


