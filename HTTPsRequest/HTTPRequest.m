//
//  HTTPRequest.m
//  HeartwoodAppUsingJson
//
//  Created by Chenggong Huang on 6/12/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "HTTPRequest.h"

@interface HTTPRequest (Private)
- (void)startConnection:(NSURLRequest *)request;
@end

@implementation HTTPRequest

@synthesize receivedData;
@synthesize asynchronous;
@synthesize mimeType;
@synthesize delegate;

#pragma mark -
#pragma mark Constructor and destructor

- (id)init
{
    if(self = [super init])
    {
        receivedData = [[NSMutableData alloc] init];
        conn = nil;
        
        asynchronous = YES;
        mimeType = @"text/html";
        delegate = nil;
    }
    
    return self;
}

- (void)dealloc
{
    receivedData = nil;
    self.mimeType = nil;
}

#pragma mark -
#pragma mark Public methods

- (void)sendRequestTo:(NSURL *)url usingVerb:(NSString *)verb withParameters:(NSDictionary *)parameters withAPIName:(NSString*)apiName
{
    NSData *body = nil;
    NSMutableString *params = nil;
    NSString *contentType = @"text/html; charset=utf-8";
    NSURL *finalURL = url;
    if (parameters != nil)
    {
        params = [[NSMutableString alloc] init];
        if(apiName != nil)
            [params appendFormat:@"%@?", apiName];
        for (id key in parameters)
        {
            NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            CFStringRef value = (__bridge CFStringRef)[[parameters objectForKey:key] copy];
            // Escape even the "reserved" characters for URLs
            // as defined in http://www.ietf.org/rfc/rfc2396.txt
            CFStringRef encodedValue = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                               value,
                                                                               NULL,
                                                                               (CFStringRef)@";/?:@&=+$,",
                                                                               kCFStringEncodingUTF8);
            [params appendFormat:@"%@=%@&", encodedKey, encodedValue];
            CFRelease(value);
            CFRelease(encodedValue);
        }
        [params deleteCharactersInRange:NSMakeRange([params length] - 1, 1)];
    }
    
    if ([verb isEqualToString:@"POST"] || [verb isEqualToString:@"PUT"])
    {
        contentType = @"application/x-www-form-urlencoded; charset=utf-8";
        body = [params dataUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        if (parameters != nil)
        {
            NSString *urlWithParams;
            if(apiName != nil)
                urlWithParams = [[url absoluteString] stringByAppendingFormat:@"%@", params];
            else
                urlWithParams = [[url absoluteString] stringByAppendingFormat:@"?%@", params];
            finalURL = [NSURL URLWithString:urlWithParams];
            
            NSLog(@"API = %@",urlWithParams);
        } else {
            NSLog(@"API = %@",[finalURL absoluteString]);
        }
    }
    
    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    [headers setValue:contentType forKey:@"Content-Type"];
    [headers setValue:mimeType forKey:@"Accept"];
    [headers setValue:@"no-cache" forKey:@"Cache-Control"];
    [headers setValue:@"no-cache" forKey:@"Pragma"];
    [headers setValue:@"close" forKey:@"Connection"]; // Avoid HTTP 1.1 "keep alive" for the connection
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:finalURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:20.0];
    [request setHTTPMethod:verb];
    [request setAllHTTPHeaderFields:headers];
    if (parameters != nil)
    {
        [request setHTTPBody:body];
    }
    [self startConnection:request];
}

- (void)sendRequestTo:(NSURL *)url usingVerb:(NSString *)verb withPlainText:(NSString*) plainText
{
    if (!plainText) return;
    
    NSData *body = nil;
    NSString *contentType = @"text/html; charset=utf-8";
    NSURL *finalURL = url;
    
    if ([verb isEqualToString:@"POST"] || [verb isEqualToString:@"PUT"])
    {
        contentType = @"text/plain; charset=utf-8";
        body = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        NSString * urlWithParams = [[url absoluteString] stringByAppendingFormat:@"%@", plainText];
        finalURL = [NSURL URLWithString:urlWithParams];
    }
    
    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    [headers setValue:contentType forKey:@"Content-Type"];
    [headers setValue:@"application/json" forKey:@"Accept"];
    [headers setValue:@"close" forKey:@"Connection"]; // Avoid HTTP 1.1 "keep alive" for the connection
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:finalURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:20.0];
    [request setHTTPMethod:verb];
    [request setAllHTTPHeaderFields:headers];
    if (plainText != nil)
    {
        [request setHTTPBody:body];
    }
    [self startConnection:request];
}

- (void)cancelConnection
{
    [conn cancel];
    conn = nil;
}

- (NSString *)responseAsText
{
    return [[NSString alloc] initWithData:receivedData
                                 encoding:NSUTF8StringEncoding];
}

#pragma mark -
#pragma mark Private methods

- (void)startConnection:(NSURLRequest *)request
{
    if (asynchronous)
    {
        [self cancelConnection];
        conn = [[NSURLConnection alloc] initWithRequest:request
                                               delegate:self
                                       startImmediately:YES];
        
        if (!conn)
        {
            if ([delegate respondsToSelector:@selector(wrapper:didFailWithError:)])
            {
                NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObject:[request URL] forKey:NSURLErrorFailingURLStringErrorKey];
                [info setObject:@"Could not open connection" forKey:NSLocalizedDescriptionKey];
                NSError* error = [NSError errorWithDomain:@"Wrapper" code:1 userInfo:info];
                [delegate httpRequest:self didFailWithError:error];
            }
        }
    }
    else
    {
        NSURLResponse* response = [[NSURLResponse alloc] init];
        NSError* error = [[NSError alloc] init];
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        [receivedData setData:data];
        response = nil;
        error = nil;
    }
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int statusCode = (int)[httpResponse statusCode];
    switch (statusCode)
    {
        case 200:
            break;
        default:
        {
            if ([delegate respondsToSelector:@selector(httpRequest:didReceiveStatusCode:)])
            {
                [delegate httpRequest:self didReceiveStatusCode:statusCode];
            }
            break;
        }
    }
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self cancelConnection];
    if ([delegate respondsToSelector:@selector(httpRequest:didFailWithError:)])
    {
        [delegate httpRequest:self didFailWithError:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self cancelConnection];
    
    NSLog(@"String: %@", receivedData);
    
    
    if ([delegate respondsToSelector:@selector(httpRequest:didRetrieveData:)])
    {
        [delegate httpRequest:self didRetrieveData:receivedData];
    }
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}

@end
