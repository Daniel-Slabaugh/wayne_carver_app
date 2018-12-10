//
//  HTTPRequestDelegate.h
//  HeartwoodAppUsingJson
//
//  Created by Chenggong Huang on 6/12/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTTPRequest;

@protocol HTTPRequestDelegate

@required
- (void)httpRequest:(HTTPRequest *)request didRetrieveData:(NSData *)data;

@optional
- (void)httpRequest:(HTTPRequest *)request didFailWithError:(NSError *)error;
- (void)httpRequest:(HTTPRequest *)request didReceiveStatusCode:(int)statusCode;

@end
