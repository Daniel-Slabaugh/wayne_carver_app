//
//  IP.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/2/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IP : NSObject


+(void)setValuesFromPreferences;
+(NSString *) getIP;
+(NSString *) getPort;
+(NSString *) setIP:(NSString *) ipAddress;
+(NSString *) setPort:(NSString *) port;



@end
