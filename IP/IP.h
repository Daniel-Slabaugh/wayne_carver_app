//
//  IP.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 12/20/2018.
//  Copyright (c) 2018 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IP : NSObject


+(void)setValuesFromPreferences;
+(NSString *) getIP;
+(NSString *) getPort;
+(NSString *) setIP:(NSString *) ipAddress;
+(NSString *) setPort:(NSString *) port;

#pragma userSettings
+(NSString *) getLoginTimout;
+(NSString *) getEmailSending;
+(NSString *) getEmail;
+(NSString *) setLoginTimout:(NSString *) logout;
+(NSString *) setEmailSending:(NSString *) sendEmail;
+(NSString *) setEmail:(NSString *) address;



@end
