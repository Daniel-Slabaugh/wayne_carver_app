//
//  IP.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/2/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "IP.h"

@implementation IP


+(void)setValuesFromPreferences {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    #warning check to see IP. 
    NSDictionary *initialSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"50.233.127.2", @"ipaddress",
                                     //@"162.17.9.117", @"ipaddress",
                                     @"50000", @"port",
                                     //    @"192.168.1.246", @"ipaddress",
                                     //    @"8082", @"port", nil];
                                     
                                     // setting for 
                                     @"YES", @"loginTimeout",
                                     @"NO", @"sendBackupEmail",
                                     @"daniel@heartwood.com", @"backupEmail",
                                     nil];

    [userDefaults registerDefaults:initialSettings];
}


+(NSString *) getIP {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:@"ipaddress"];
}

+(NSString *) getPort {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:@"port"];
}


+(NSString *) setIP:(NSString *) ipAddress {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setValue:ipAddress forKey:@"ipaddress"];

    return [userDefaults stringForKey:@"ipaddress"];
}

+(NSString *) setPort:(NSString *) port {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue:port forKey:@"port"];
    
    return [userDefaults stringForKey:@"port"];
}

+(NSString *) getLoginTimout {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:@"loginTimeout"];
}

+(NSString *) getEmailSending {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:@"sendBackupEmail"];
}
+(NSString *) getEmail {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:@"backupEmail"];
}


+(NSString *) setLoginTimout:(NSString *) logout {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue:logout forKey:@"loginTimeout"];
    
    return [userDefaults stringForKey:@"loginTimeout"];
}

+(NSString *) setEmailSending:(NSString *) sendEmail {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue:sendEmail forKey:@"sendBackupEmail"];
    
    return [userDefaults stringForKey:@"sendBackupEmail"];
}

+(NSString *) setEmail:(NSString *) address {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue:address forKey:@"backupEmail"];
    
    return [userDefaults stringForKey:@"backupEmail"];
}

@end
