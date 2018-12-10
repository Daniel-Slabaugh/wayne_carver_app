//
//  HTTPRequest.h
//  HeartwoodAppUsingJson
//
//  Created by Chenggong Huang on 6/12/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPRequestDelegate.h"

@interface HTTPRequest : NSObject
{
@private
    NSMutableData *receivedData;
    NSString *mimeType;
    NSURLConnection *conn;
    BOOL asynchronous;
    NSObject<HTTPRequestDelegate> *delegate;
}

@property (nonatomic, readonly) NSData *receivedData;
@property (nonatomic) BOOL asynchronous;
@property (nonatomic, copy) NSString *mimeType;
@property (retain, nonatomic) NSObject<HTTPRequestDelegate> *delegate;

//makes the request to the server
- (void)sendRequestTo:(NSURL *)url usingVerb:(NSString *)verb withParameters:(NSDictionary *)parameters withAPIName:(NSString*)apiName;

- (void)sendRequestTo:(NSURL *)url usingVerb:(NSString *)verb withPlainText:(NSString*) plainText;

//cancels the connection
- (void)cancelConnection;

//returns the string form of NSData
- (NSString *)responseAsText;

@end
