//
//  Sync.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/3/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "Sync.h"

#import "GlobalVariables.h"
#import <QuartzCore/QuartzCore.h>
#import "DeviceIdentifiers.h"
#import "SVProgressHUD.h"
#import "HTTPRequest.h"
#import "SBJson.h"
#import "IP.h"

//db tables
#import "User.h"
#import "Customer.h"
#import "Address.h"
#import "Item.h"
#import "Name.h"
#import "OrderLine.h"
#import "OrderDetail.h"
#import "WayneOrderHeader.h"
#import "WayneOrderLine.h"
#import "OrderHeader.h"
#import "Ship.h"
#import "TrackingNumber.h"
#import "GMItem.h"
#import "DateLastSynced.h"

#define POST    @"Posted"
#define GMPOST  @"GMPosted"
#define START   @"Started"




@implementation Sync

@synthesize usersArray;
@synthesize orderHeaderInfo;
@synthesize gmorderHeaderInfo;
@synthesize dateFormatter;

- (void)syncAll:(NSString*)user withPassword:(NSString*)password reSync:(BOOL)shouldSync {
    allCall = YES;
    post = NO;
    if (shouldSync) {
        reSync = YES;
    } else {
        reSync = NO;
    }
    // set needed variables to use after call:
    [self syncUser:user.uppercaseString withPassword:password];
}

- (void)syncUser:(NSString*)user withPassword:(NSString*)password {
    
    // prep for https request
    if (!apiRequester)
        apiRequester = [[HTTPRequest alloc] init];
    apiRequester.delegate = self;
    
    [SVProgressHUD showWithStatus:@"Loading User Data"];
    apiType = APIRetrive;
    
    //get unique identifier (ad id)
    advertisingIdentifier = [DeviceIdentifiers IDFA];
    NSString *ipAddress = [IP getIP];
    NSString *port = [IP getPort];
    NSString *queryURL =[NSString stringWithFormat:@"https://%@:%@/%@returnuserrecord/%@/%@/%@", ipAddress, port, URL, user, password, advertisingIdentifier];
    NSURL *url = [NSURL URLWithString: queryURL];
    
    callType  = SYNC_USER;
    [apiRequester sendRequestTo:url usingVerb:@"GET" withParameters:nil withAPIName:nil];
}

- (void)syncCustomer:(NSString*)user withPassword:(NSString*)password {
    
    // prep for https request
    if (!apiRequester)
        apiRequester = [[HTTPRequest alloc] init];
    apiRequester.delegate = self;
    
    [SVProgressHUD showWithStatus:@"Loading Customer Data"];
    apiType = APIRetrive;
    
    //get unique identifier (ad id)
    advertisingIdentifier = [DeviceIdentifiers IDFA];
    NSString *ipAddress = [IP getIP];
    NSString *port = [IP getPort];
    NSString *queryURL =[NSString stringWithFormat:@"https://%@:%@/%@returncustomers/%@/%@/%@", ipAddress, port, URL, user, password, advertisingIdentifier];
    NSURL *url = [NSURL URLWithString: queryURL];
    
    callType  = SYNC_CUST;
    [apiRequester sendRequestTo:url usingVerb:@"GET" withParameters:nil withAPIName:nil];
}

- (void)syncItems:(NSString*)user withPassword:(NSString*)password {
    
    // prep for https request
    if (!apiRequester)
        apiRequester = [[HTTPRequest alloc] init];
    apiRequester.delegate = self;
    
    [SVProgressHUD showWithStatus:@"Loading Item Data"];
    apiType = APIRetrive;
    
    //get unique identifier (ad id)
    advertisingIdentifier = [DeviceIdentifiers IDFA];
    NSString *ipAddress = [IP getIP];
    NSString *port = [IP getPort];
    NSString *queryURL =[NSString stringWithFormat:@"https://%@:%@/%@returnitems/%@/%@/%@", ipAddress, port, URL, user, password, advertisingIdentifier];
    NSURL *url = [NSURL URLWithString: queryURL];
    
    callType  = SYNC_ITEM;
    [apiRequester sendRequestTo:url usingVerb:@"GET" withParameters:nil withAPIName:nil];
}

- (void)syncNames:(NSString*)user withPassword:(NSString*)password {
    
    // prep for https request
    if (!apiRequester)
        apiRequester = [[HTTPRequest alloc] init];
    apiRequester.delegate = self;
    
    [SVProgressHUD showWithStatus:@"Loading Name Data"];
    apiType = APIRetrive;
    
    //get unique identifier (ad id)
    advertisingIdentifier = [DeviceIdentifiers IDFA];
    NSString *ipAddress = [IP getIP];
    NSString *port = [IP getPort];
    NSString *queryURL =[NSString stringWithFormat:@"https://%@:%@/%@returnnames/%@/%@/%@", ipAddress, port, URL, user, password, advertisingIdentifier];
    NSURL *url = [NSURL URLWithString: queryURL];
    
    callType  = SYNC_NAME;
    [apiRequester sendRequestTo:url usingVerb:@"GET" withParameters:nil withAPIName:nil];
}

- (void)syncAddresses:(NSString*)user withPassword:(NSString*)password {
    
    // prep for https request
    if (!apiRequester)
        apiRequester = [[HTTPRequest alloc] init];
    apiRequester.delegate = self;
    
    [SVProgressHUD showWithStatus:@"Loading Address Data"];
    apiType = APIRetrive;
    
    //get unique identifier (ad id)
    advertisingIdentifier = [DeviceIdentifiers IDFA];
    NSString *ipAddress = [IP getIP];
    NSString *port = [IP getPort];
    NSString *queryURL =[NSString stringWithFormat:@"https://%@:%@/%@getshippingaddresses/%@/%@/%@", ipAddress, port, URL, user, password, advertisingIdentifier];
    NSURL *url = [NSURL URLWithString: queryURL];
    
    callType  = SYNC_ADDRESS;
    [apiRequester sendRequestTo:url usingVerb:@"GET" withParameters:nil withAPIName:nil];
}

- (void)syncTrackingNumbers:(NSString*)user withPassword:(NSString*)password {
    
    // prep for https request
    if (!apiRequester)
        apiRequester = [[HTTPRequest alloc] init];
    apiRequester.delegate = self;
    
    [SVProgressHUD showWithStatus:@"Loading Tracking Data"];
    apiType = APIRetrive;
    
    //get unique identifier (ad id)
    advertisingIdentifier = [DeviceIdentifiers IDFA];
    NSString *ipAddress = [IP getIP];
    NSString *port = [IP getPort];
    NSString *queryURL =[NSString stringWithFormat:@"https://%@:%@/%@returntrackinginfo/%@/%@/%@", ipAddress, port, URL, user, password, advertisingIdentifier];
    NSURL *url = [NSURL URLWithString: queryURL];
    
    callType  = SYNC_ORDTRK;
    [apiRequester sendRequestTo:url usingVerb:@"GET" withParameters:nil withAPIName:nil];
}

- (void)syncWayneOrderHeaders:(NSString*)user withPassword:(NSString*)password {
    
    // prep for https request
    if (!apiRequester)
        apiRequester = [[HTTPRequest alloc] init];
    apiRequester.delegate = self;
    
    [SVProgressHUD showWithStatus:@"Loading WC Data"];
    apiType = APIRetrive;
    
    //get unique identifier (ad id)
    advertisingIdentifier = [DeviceIdentifiers IDFA];
    NSString *ipAddress = [IP getIP];
    NSString *port = [IP getPort];
    NSString *queryURL =[NSString stringWithFormat:@"https://%@:%@/%@returnorderstatushdrs/%@/%@/%@", ipAddress, port, URL, user, password, advertisingIdentifier];
    NSURL *url = [NSURL URLWithString: queryURL];
    
    callType  = SYNC_WHDR;
    [apiRequester sendRequestTo:url usingVerb:@"GET" withParameters:nil withAPIName:nil];
}

- (void)syncUnshippedWayneOrderHeaders:(NSString*)user withPassword:(NSString*)password {
    
    // prep for https request
    if (!apiRequester)
        apiRequester = [[HTTPRequest alloc] init];
    apiRequester.delegate = self;
    
    [SVProgressHUD showWithStatus:@"Loading WC Data"];
    apiType = APIRetrive;
    
    //get unique identifier (ad id)
    advertisingIdentifier = [DeviceIdentifiers IDFA];
    NSString *ipAddress = [IP getIP];
    NSString *port = [IP getPort];
    NSString *queryURL =[NSString stringWithFormat:@"https://%@:%@/%@returnunshippedorderstatushdrs/%@/%@/%@", ipAddress, port, URL, user, password, advertisingIdentifier];
    NSURL *url = [NSURL URLWithString: queryURL];
    
    callType  = SYNC_UWHDR;
    [apiRequester sendRequestTo:url usingVerb:@"GET" withParameters:nil withAPIName:nil];
}

- (void)syncWayneOrderLines:(NSString*)user withPassword:(NSString*)password {
    
    // prep for https request
    if (!apiRequester)
        apiRequester = [[HTTPRequest alloc] init];
    apiRequester.delegate = self;
    
    [SVProgressHUD showWithStatus:@"Loading WC Data"];
    apiType = APIRetrive;
    
    //get unique identifier (ad id)
    advertisingIdentifier = [DeviceIdentifiers IDFA];
    NSString *ipAddress = [IP getIP];
    NSString *port = [IP getPort];
    NSString *queryURL =[NSString stringWithFormat:@"https://%@:%@/%@returnorderstatuslines/%@/%@/%@", ipAddress, port, URL, user, password, advertisingIdentifier];
    NSURL *url = [NSURL URLWithString: queryURL];
    
    callType  = SYNC_WLNE;
    [apiRequester sendRequestTo:url usingVerb:@"GET" withParameters:nil withAPIName:nil];
}

- (void)syncUnshippedWayneOrderLines:(NSString*)user withPassword:(NSString*)password {
    
    // prep for https request
    if (!apiRequester)
        apiRequester = [[HTTPRequest alloc] init];
    apiRequester.delegate = self;
    
    [SVProgressHUD showWithStatus:@"Loading WC Data"];
    apiType = APIRetrive;
    
    //get unique identifier (ad id)
    advertisingIdentifier = [DeviceIdentifiers IDFA];
    NSString *ipAddress = [IP getIP];
    NSString *port = [IP getPort];
    NSString *queryURL =[NSString stringWithFormat:@"https://%@:%@/%@returnunshippedorderstatuslines/%@/%@/%@", ipAddress, port, URL, user, password, advertisingIdentifier];
    NSURL *url = [NSURL URLWithString: queryURL];
    
    callType  = SYNC_UWLNE;
    [apiRequester sendRequestTo:url usingVerb:@"GET" withParameters:nil withAPIName:nil];
}

- (void)checkSyncNeeded:(NSString *)user withPassword:(NSString *)password {
    
    // prep for https request
    if (!apiRequester)
        apiRequester = [[HTTPRequest alloc] init];
    apiRequester.delegate = self;
    
    apiType = APIRetrive;
    
    //get unique identifier (ad id)
    advertisingIdentifier = [DeviceIdentifiers IDFA];
    NSString *ipAddress = [IP getIP];
    NSString *port = [IP getPort];
    NSString *queryURL =[NSString stringWithFormat:@"https://%@:%@/%@issyncneeded/%@/%@/%@", ipAddress, port, URL, user, password, advertisingIdentifier];
    NSURL *url = [NSURL URLWithString: queryURL];
    
    callType  = SYNC_CHECK;
    [apiRequester sendRequestTo:url usingVerb:@"GET" withParameters:nil withAPIName:nil];
}

- (void)clearSyncNeeded:(NSString *)user withPassword:(NSString *)password {
    
    // prep for https request
    if (!apiRequester)
        apiRequester = [[HTTPRequest alloc] init];
    apiRequester.delegate = self;
    
    [SVProgressHUD showWithStatus:@"Finishing..."];
    apiType = APIRetrive;
    
    //get unique identifier (ad id)
    advertisingIdentifier = [DeviceIdentifiers IDFA];
    NSString *ipAddress = [IP getIP];
    NSString *port = [IP getPort];
    NSString *queryURL =[NSString stringWithFormat:@"https://%@:%@/%@clearsyncstatus/%@/%@/%@", ipAddress, port, URL, user, password, advertisingIdentifier];
    NSLog(@"url = %@", queryURL);
    NSURL *url = [NSURL URLWithString: queryURL];
    
    callType = SYNC_CLEAR;
    [apiRequester sendRequestTo:url usingVerb:@"GET" withParameters:nil withAPIName:nil];
}

- (void)syncShipMethods:(NSString *)user withPassword:(NSString *)password {
    
    // prep for https request
    if (!apiRequester)
        apiRequester = [[HTTPRequest alloc] init];
    apiRequester.delegate = self;
    
    [SVProgressHUD showWithStatus:@"Finishing..."];
    apiType = APIRetrive;
    
    //get unique identifier (ad id)
    advertisingIdentifier = [DeviceIdentifiers IDFA];
    NSString *ipAddress = [IP getIP];
    NSString *port = [IP getPort];
    NSString *queryURL =[NSString stringWithFormat:@"https://%@:%@/%@returnShipMethods/%@/%@/%@", ipAddress, port, URL, user, password, advertisingIdentifier];
    NSLog(@"url = %@", queryURL);
    NSURL *url = [NSURL URLWithString: queryURL];
    
    callType = SYNC_SHIP;
    [apiRequester sendRequestTo:url usingVerb:@"GET" withParameters:nil withAPIName:nil];
}

- (void)syncGMItems:(NSString *)user withPassword:(NSString *)password {
    
    // prep for https request
    if (!apiRequester)
        apiRequester = [[HTTPRequest alloc] init];
    apiRequester.delegate = self;
    
    [SVProgressHUD showWithStatus:@"Loading GMItem Data"];
    apiType = APIRetrive;
    
    //get unique identifier (ad id)
    advertisingIdentifier = [DeviceIdentifiers IDFA];
    NSString *ipAddress = [IP getIP];
    NSString *port = [IP getPort];
    NSString *queryURL =[NSString stringWithFormat:@"https://%@:%@/%@returngmitems/%@/%@/%@", ipAddress, port, URL, user, password, advertisingIdentifier];
    NSURL *url = [NSURL URLWithString: queryURL];
    
    callType  = SYNC_GMITEM;
    [apiRequester sendRequestTo:url usingVerb:@"GET" withParameters:nil withAPIName:nil];
}

#warning post here
- (void)postOrder:(NSString *)user withPassword:(NSString *)password withOrderData:(NSDictionary*)data withOrderHeader:(OrderHeader*)odrHeader {
    // assign order header info to storing variable
    orderHeaderInfo = odrHeader;
    
    // prep for https request
    if (!apiRequester)
        apiRequester = [[HTTPRequest alloc] init];
    apiRequester.delegate = self;
    
    if (!data){
        NSLog(@"Data not good, please try to retrive customer data again.");
        return;
    }
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *jsonCommand =  [writer stringWithObject:data];
    NSLog(@"%@", jsonCommand);
    [SVProgressHUD showWithStatus:@"Sending Order"];
    apiType = APIPost;
    
    advertisingIdentifier = [DeviceIdentifiers IDFA];
    NSString *ipAddress = [IP getIP];
    NSString *port = [IP getPort];
    
    BOOL offset = [[NSTimeZone systemTimeZone] isDaylightSavingTime];
    NSInteger timeZone = [[NSTimeZone systemTimeZone] secondsFromGMT]/60;
    timeZone -= offset ? 60: 0;
    
    NSString *queryURL =[NSString stringWithFormat:@"https://%@:%@/%@postorder/%@/%@/%@/%ld", ipAddress, port, URL, user, password, advertisingIdentifier, (long)timeZone];
    NSLog(@"url = %@", queryURL);
    NSURL *url = [NSURL URLWithString: queryURL];
    callType = SYNC_POST;
    [apiRequester sendRequestTo:url usingVerb:@"POST" withPlainText:jsonCommand];
}

// not currently in use
//- (void)postOrderLine:(NSString *)user withPassword:(NSString *)password withOrderData:(NSDictionary*)data withOrderHeader:(OrderHeader*)odrHeader number:(NSString *)num of:(NSString *)total {
//    // assign order header info to storing variable
//    orderHeaderInfo = odrHeader;
//    
//    // prep for https request
//    if (!apiRequester)
//        apiRequester = [[HTTPRequest alloc] init];
//    apiRequester.delegate = self;
//    
//    if (!data){
//        NSLog(@"Data not good, please try to retrive customer data again.");
//        return;
//    }
//    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
//    NSString *jsonCommand =  [writer stringWithObject:data];
//    NSLog(@"%@", jsonCommand);
//    [SVProgressHUD showWithStatus:@"Sending Order"];
//    apiType = APIPost;
//    
//    advertisingIdentifier = [DeviceIdentifiers IDFA];
//    NSString *ipAddress = [IP getIP];
//    NSString *port = [IP getPort];
//    
//    BOOL offset = [[NSTimeZone systemTimeZone] isDaylightSavingTime];
//    NSInteger timeZone = [[NSTimeZone systemTimeZone] secondsFromGMT]/60;
//    timeZone -= offset ? 60: 0;
//    
//    NSString *queryURL =[NSString stringWithFormat:@"https://%@:%@/%@postorderline/%@/%@/%@/%ld", ipAddress, port, URL, user, password, advertisingIdentifier, (long)timeZone]; //, num, total];
//    NSLog(@"url = %@", queryURL);
//    NSURL *url = [NSURL URLWithString: queryURL];
//    callType = SYNC_POST_LINE;
//    [apiRequester sendRequestTo:url usingVerb:@"POST" withPlainText:jsonCommand];
//}

- (void)gmpostOrder:(NSString *)user withPassword:(NSString *)password withOrderheader:(NSDictionary*)data {
    // prep for https request
    if (!apiRequester)
        apiRequester = [[HTTPRequest alloc] init];
    apiRequester.delegate = self;
    
    if (!data){
        NSLog(@"Data not good, please try to retrive customer data again.");
        return;
    }
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *jsonCommand = [writer stringWithObject:data];
    NSLog(@"%@", jsonCommand);
    [SVProgressHUD showWithStatus:@"Sending Order"];
    apiType = APIPost;
    
    advertisingIdentifier = [DeviceIdentifiers IDFA];
    NSString *ipAddress = [IP getIP];
    NSString *port = [IP getPort];
    
    BOOL offset = [[NSTimeZone systemTimeZone] isDaylightSavingTime];
    NSInteger timeZone = [[NSTimeZone systemTimeZone] secondsFromGMT]/60;
    timeZone -= offset ? 60: 0;
    
    NSString *queryURL =[NSString stringWithFormat:@"https://%@:%@/%@gmpostorder/%@/%@/%@/%ld", ipAddress, port, URL, user, password, advertisingIdentifier, (long)timeZone];
    NSLog(@"url = %@", queryURL);
    NSURL *url = [NSURL URLWithString: queryURL];
    callType = SYNC_GMPOST;
    [apiRequester sendRequestTo:url usingVerb:@"POST" withPlainText:jsonCommand];
}


- (void)syncOrderReceived:(NSString *)user withPassword:(NSString *)password withorderPKID:(NSString *)PKID {

        // prep for https request
        if (!apiRequester)
            apiRequester = [[HTTPRequest alloc] init];
        apiRequester.delegate = self;

        [SVProgressHUD showWithStatus:@"Loading Order Data"];
        apiType = APIRetrive;

        //get unique identifier (ad id)
        advertisingIdentifier = [DeviceIdentifiers IDFA];
        NSString *ipAddress = [IP getIP];
        NSString *port = [IP getPort];
        NSString *queryURL =[NSString stringWithFormat:@"https://%@:%@/%@returnorderreceived/%@/%@/%@/%@", ipAddress, port, URL, user, password, advertisingIdentifier, PKID];
        NSURL *url = [NSURL URLWithString: queryURL];
        NSLog(@"url = %@", queryURL);

        callType  = SYNC_CHECKORDER;
        [apiRequester sendRequestTo:url usingVerb:@"GET" withParameters:nil withAPIName:nil];
}


#pragma mark - parsing orders methods


- (void) parseAndProcessUserWithResponse: (NSString *) response {
    if (apiType == APIRetrive) {
        NSDictionary *items = [response JSONValue];
        
        if (items == nil) {
            // Parse Error
            apiType = APINone;
            return;
        }
        
        if (responseData != nil) {
            responseData = nil;
        }
        
        responseData = [NSString stringWithString:response];
        
        NSArray *list = [items objectForKey:@"result"];
        
        if (!list || list.count == 0) {
            apiType = APINone;
            return;
        }
        
        [User deleteAllUsers];
        
        NSDictionary * object = [list objectAtIndex:0];
        
        UserID = [object objectForKey:@"UserID"];
        FirstName = [object objectForKey:@"FirstName"];
        LastName = [object objectForKey:@"LastName"];
        CompanyName = [object objectForKey:@"CompanyName"];
        MailAddr1 = [object objectForKey:@"MailADDR1"];
        MailAddr2 = [object objectForKey:@"MailADDR2"];
        MailCity = [object objectForKey:@"MailCity"];
        MailState = [object objectForKey:@"MailState"];
        MailZip = [object objectForKey:@"MailZip"];
        MailCountry = [object objectForKey:@"MailCountry"];
        ShipAddr1 = [object objectForKey:@"ShipADDR1"];
        ShipAddr2 = [object objectForKey:@"ShipADDR2"];
        ShipCity = [object objectForKey:@"ShipCity"];
        ShipState = [object objectForKey:@"ShipState"];
        ShipZip = [object objectForKey:@"ShipZip"];
        ShipCountry = [object objectForKey:@"ShipCountry"];
        Phone = [object objectForKey:@"Phone"];
        FAX = [object objectForKey:@"FAX"];
        Cell = [object objectForKey:@"Cell"];
        Email = [object objectForKey:@"Email"];
        Password = [object objectForKey:@"Password"];
        
        // insert into Users
        
        for (int i = 0; i < UserID.count; i ++) {
            User * user = [[User alloc] init];
            
            user.UserID = [UserID objectAtIndex:i];
            user.FirstName = [FirstName objectAtIndex:i];
            user.LastName = [LastName objectAtIndex:i];
            user.CompanyName = [CompanyName objectAtIndex:i];
            user.MailADDR1 = [MailAddr1 objectAtIndex:i];
            user.MailADDR2 = [MailAddr2 objectAtIndex:i];
            user.MailCity = [MailCity objectAtIndex:i];
            user.MailState = [MailState objectAtIndex:i];
            user.MailZip = [MailZip objectAtIndex:i];
            user.MailCountry = [MailCountry objectAtIndex:i];
            user.ShipADDR1 = [ShipAddr1 objectAtIndex:i];
            user.ShipADDR2 = [ShipAddr2 objectAtIndex:i];
            user.ShipCity = [ShipCity objectAtIndex:i];
            user.ShipState = [ShipState objectAtIndex:i];
            user.ShipZip = [ShipZip objectAtIndex:i];
            user.ShipCountry = [ShipCountry objectAtIndex:i];
            user.Phone = [Phone objectAtIndex:i];
            user.FAX = [FAX objectAtIndex:i];
            user.Cell = [Cell objectAtIndex:i];
            user.Email = [Email objectAtIndex:i];
            user.Password = [Password objectAtIndex:i];
            
            [User insertInto:user];
            
        }
    }
    if (allCall) {
        self.usersArray = [User getAllUsers];
        User *theUser = [self.usersArray objectAtIndex:0];
        [self syncCustomer:theUser.UserID withPassword:theUser.Password];
    } else if(reSync == NO) {
        [self syncCompleted];
        apiType = APINone;
    }
}

- (void) parseAndProcessCustomersWithResponse: (NSString *) response {
    if (apiType == APIRetrive) {
        NSDictionary *items = [response JSONValue];
        
        if (items == nil) {
            // Parse Error
            apiType = APINone;
            return;
        }
        if (responseData != nil) {
            responseData = nil;
        }
        
        responseData = [NSString stringWithString:response];
        NSArray *list = [items objectForKey:@"result"];
        
        if (!list || list.count == 0) {
            apiType = APINone;
            return;
        }
        
        [Customer deleteAllCustomers];
        
        NSDictionary * object = [list objectAtIndex:0];
        
        
        CustNum = [object objectForKey:@"CustNum"];
        CustName = [object objectForKey:@"CustName"];
        Phone1 = [object objectForKey:@"Phone1"];
        Phone2 = [object objectForKey:@"Phone2"];
        FAX = [object objectForKey:@"FAX"];
        Cntctprsn = [object objectForKey:@"Cntctprsn"];
        Email = [object objectForKey:@"Email"];
        ADDR1 = [object objectForKey:@"ADDR1"];
        ADDR2 = [object objectForKey:@"ADDR2"];
        City = [object objectForKey:@"City"];
        State = [object objectForKey:@"State"];
        Zip = [object objectForKey:@"Zip"];
        Country = [object objectForKey:@"Country"];
        
        for (int i = 0; i < CustNum.count; i ++) {
            Customer * customer = [[Customer alloc] init];
            
            customer.CustNum = [CustNum objectAtIndex:i];
            customer.CustName = [CustName objectAtIndex:i];
            customer.Phone1 = [Phone1 objectAtIndex:i];
            customer.Phone2 = [Phone2 objectAtIndex:i];
            customer.FAX = [FAX objectAtIndex:i];
            customer.Cntctprsn = [Cntctprsn objectAtIndex:i];
            customer.Email = [Email objectAtIndex:i];
            customer.ADDR1 = [ADDR1 objectAtIndex:i];
            customer.ADDR2 = [ADDR2 objectAtIndex:i];
            customer.City = [City objectAtIndex:i];
            customer.State = [State objectAtIndex:i];
            customer.Zip = [Zip objectAtIndex:i];
            customer.Country = [Country objectAtIndex:i];
            
            [Customer insertInto:customer];
            
        }
        if (allCall) {
            self.usersArray = [User getAllUsers];
            User *theUser = [self.usersArray objectAtIndex:0];
            //[self syncStores:theUser.UserID withPassword:theUser.Password];
            [self syncItems:theUser.UserID withPassword:theUser.Password];
        } else if(reSync == NO) {
            [self syncCompleted];
            apiType = APINone;
        }
    }
}

- (void) parseAndProcessItemsWithResponse: (NSString *) response {
    if (apiType == APIRetrive) {
        NSDictionary *items = [response JSONValue];
        
        
        if (items == nil) {
            // Parse Error
            apiType = APINone;
            return;
        }
        
        if (responseData != nil) {
            responseData = nil;
        }
        
        responseData = [NSString stringWithString:response];
        
        NSArray *list = [items objectForKey:@"result"];
        
        if (!list || list.count == 0) {
            apiType = APINone;
            return;
        }
        
        [Item deleteAllItems];
        
        NSDictionary * object = [list objectAtIndex:0];
        
        CustNum = [object objectForKey:@"CustNum"];
        ProgName = [object objectForKey:@"PROGRMNAME"];
        ItemNo = [object objectForKey:@"ITEMNO"];
        Nameset = [object objectForKey:@"NAMESET"];
        MAD = [object objectForKey:@"MAD"];
        Description = [object objectForKey:@"Description"];
        
        // insert into Items
        for (int i = 0; i < CustNum.count; i ++) {
            Item * item = [[Item alloc] init];
            
            item.CustNum = [CustNum objectAtIndex:i];
            item.ProgName = [ProgName objectAtIndex:i];
            item.ItemNo = [ItemNo objectAtIndex:i];
            item.Nameset = [Nameset objectAtIndex:i];
            item.MAD = [MAD objectAtIndex:i];
            item.Description = [Description objectAtIndex:i];
            
            //used to see what items were coming in
            //NSLog([NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@", item.CustNum, item.ProgName, item.ItemNo, item.Nameset, item.MAD, item.Description]);
            
            [Item insertInto:item];
            
        }
    }
    if (allCall) {
        self.usersArray = [User getAllUsers];
        User *theUser = [self.usersArray objectAtIndex:0];
        [self syncNames:theUser.UserID withPassword:theUser.Password];
    } else if(reSync == NO) {
        [self syncCompleted];
        apiType = APINone;
    }
}

- (void) parseAndProcessNamesWithResponse: (NSString *) response {
    if (apiType == APIRetrive) {
        NSDictionary *items = [response JSONValue];
        
        if (items == nil) {
            // Parse Error
            apiType = APINone;
            return;
        }
        
        if (responseData != nil) {
            responseData = nil;
        }
        
        responseData = [NSString stringWithString:response];
        
        NSArray *list = [items objectForKey:@"result"];
        
        if (!list || list.count == 0) {
            apiType = APINone;
            return;
        }
        
        [Name deleteAllNames];
        
        NSDictionary * object = [list objectAtIndex:0];
        
        Nameset = [object objectForKey:@"NAMESET"];
        TheName = [object objectForKey:@"NAME"];
        NameType = [object objectForKey:@"NAMETYPE"];
        NumOfPegs = [object objectForKey:@"NUMOFPEGS"];
        
        // call begin sql insert
        [Name beginNameInsert];
        
        // insert into Names
        for (int i = 0; i < TheName.count; i ++) {
            Name * name = [[Name alloc] init];
            
            name.Nameset = [Nameset objectAtIndex:i];
            name.TheName = [TheName objectAtIndex:i];
            name.NameType = [NameType objectAtIndex:i];
            name.NumOfPegs = [NumOfPegs objectAtIndex:i];
            
            [Name insertInto:name];
        }
        // call end sql insert
        [Name endNameInsert];
    }
    if (allCall) {
        self.usersArray = [User getAllUsers];
        User *theUser = [self.usersArray objectAtIndex:0];
        [self syncAddresses:theUser.UserID withPassword:theUser.Password];
    } else if(reSync == NO) {
        [self syncCompleted];
        apiType = APINone;
    }
}

- (void) parseAndProcessAddressesWithResponse: (NSString *) response {
    if (apiType == APIRetrive) {
        NSDictionary *items = [response JSONValue];
        if (items == nil) {
            // Parse Error
            apiType = APINone;
            return;
        }
        
        if (responseData != nil) {
            responseData = nil;
        }
        
        responseData = [NSString stringWithString:response];
        
        NSArray *list = [items objectForKey:@"result"];
        
        if (!list || list.count == 0) {
            apiType = APINone;
            return;
        }
        
        [Address deleteAllAddresses];
        
        NSDictionary * object = [list objectAtIndex:0];
        
        StoreID = [object objectForKey:@"StoreID"];
        CustNum = [object objectForKey:@"CustNum"];
        Named = [object objectForKey:@"Name"];
        ADDR1 = [object objectForKey:@"Addr1"];
        ADDR2 = [object objectForKey:@"Addr2"];
        City = [object objectForKey:@"City"];
        State = [object objectForKey:@"State"];
        Country = [object objectForKey:@"Country"];
        Zip = [object objectForKey:@"Zip"];
        
        
        // insert into Stores
        
        for (int i = 0; i < StoreID.count; i ++) {
            Address * address = [[Address alloc] init];
            
            address.StoreID = [StoreID objectAtIndex:i];
            address.CustNum = [CustNum objectAtIndex:i];
            address.Name = [Named objectAtIndex:i];
            address.Addr1 = [ADDR1 objectAtIndex:i];
            address.Addr2 = [ADDR2 objectAtIndex:i];
            address.City = [City objectAtIndex:i];
            address.State = [State objectAtIndex:i];
            address.Country = [Country objectAtIndex:i];
            address.Zip = [Zip objectAtIndex:i];
            
            [Address insertInto:address];
            
        }
    }
    
    if (allCall) {
        self.usersArray = [User getAllUsers];
        User *theUser = [self.usersArray objectAtIndex:0];
        [self syncTrackingNumbers:theUser.UserID withPassword:theUser.Password];
    } else if(reSync == NO) {
        [self syncCompleted];
        apiType = APINone;
    }
}

- (void) parseAndProcessTrackingNumbersWithResponse: (NSString *) response {
    if (apiType == APIRetrive) {
        NSDictionary *items = [response JSONValue];
        if (items == nil) {
            // Parse Error
            apiType = APINone;
            return;
        }
        
        if (responseData != nil) {
            responseData = nil;
        }
        
        responseData = [NSString stringWithString:response];
        
        NSArray *list = [items objectForKey:@"result"];
        
        if (!list || list.count == 0) {
            apiType = APINone;
            return;
        }
        
        [TrackingNumber deleteAllTrackingNumbers];
        
        NSDictionary * object = [list objectAtIndex:0];
        
        OrderNum = [object objectForKey:@"OrderNo"];
        TrackingNumbers = [object objectForKey:@"TrackingNo"];
        
        // call begin sql insert
        [TrackingNumber beginTrackingNumberInsert];
        
        // insert into TrackingNumbers
        for (int i = 0; i < OrderNum.count; i ++) {
            TrackingNumber * trackingNum = [[TrackingNumber alloc] init];
            
            trackingNum.OrderNum = [[OrderNum objectAtIndex:i] intValue];
            trackingNum.TrackingNumber = [TrackingNumbers objectAtIndex:i];
//            NSLog(@"Order: %ld, Tracking: %@", (long)trackingNum.OrderNum, trackingNum.TrackingNumber);
            

            [TrackingNumber insertInto:trackingNum];
            }
        
        
        // call end sql insert
        [TrackingNumber endTrackingNumberInsert];
    }
    

    if (allCall) {
        self.usersArray = [User getAllUsers];
        User *theUser = [self.usersArray objectAtIndex:0];
        [self syncWayneOrderHeaders:theUser.UserID withPassword:theUser.Password];
    } else if(post) {
        NSLog(@"Successfully Posted");
#warning Here do add email code
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PostWorked" object:self];

        
        [DateLastSynced deleteAllDatesLastSynced];
        
        // setting date last synced.
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        DateLastSynced *lastSynced = [[DateLastSynced alloc] init];
        lastSynced.DateSynced = [self.dateFormatter stringFromDate:[NSDate date]];
        [DateLastSynced insertInto:lastSynced];
    } else if(gmpost) {
        NSLog(@"Gen Merch Successfully Posted");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GMPostWorked" object:self];
        
        
        [DateLastSynced deleteAllDatesLastSynced];

        // setting date last synced.
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        DateLastSynced *lastSynced = [[DateLastSynced alloc] init];
        lastSynced.DateSynced = [self.dateFormatter stringFromDate:[NSDate date]];
        [DateLastSynced insertInto:lastSynced];
    } else if(reSync == NO) {
        [self syncCompleted];
        apiType = APINone;
    }
}

- (void) parseAndProcessWayneOrderHeadersWithResponse: (NSString *) response {
    if (apiType == APIRetrive) {
        NSDictionary *items = [response JSONValue];
        
        if (items == nil) {
            // Parse Error
            apiType = APINone;
            return;
        }
        if (responseData != nil) {
            responseData = nil;
        }
        
        responseData = [NSString stringWithString:response];
        NSArray *list = [items objectForKey:@"result"];
        
        if (!list || list.count == 0) {
            apiType = APINone;
            return;
        }
        
        [WayneOrderHeader deleteAllOrderHeaders];
        
        NSDictionary * object = [list objectAtIndex:0];
        
        
        CustNum = [object objectForKey:@"CustNum"];
        PONum = [object objectForKey:@"PONum"];
        OrderNum = [object objectForKey:@"OrderNo"];
        UserID = [object objectForKey:@"UserID"];
        HeartwoodStatus = [object objectForKey:@"HeartwoodStatus"];
        Terms = [object objectForKey:@"Terms"];
        ShipMethod = [object objectForKey:@"ShipMethod"];
        CustName = [object objectForKey:@"CustName"];
        ProcessedBy = [object objectForKey:@"ProcessedBy"];
        DateReceived = [object objectForKey:@"FmtDateReceived"];
        DateAccepted = [object objectForKey:@"FmtDateAccepted"];
        SAPShipDate = [object objectForKey:@"FmtSAPShipDate"];
        BillName = [object objectForKey:@"BillName"];
        BillADDR1 = [object objectForKey:@"BillAddr1"];
        BillADDR2 = [object objectForKey:@"BillAddr2"];
        BillCity = [object objectForKey:@"BillCity"];
        BillState = [object objectForKey:@"BillState"];
        BillZip = [object objectForKey:@"BillZip"];
        StoreName = [object objectForKey:@"StoreName"];
        StoreADDR1= [object objectForKey:@"StoreAddr1"];
        StoreADDR2 = [object objectForKey:@"StoreAddr2"];
        StoreCity = [object objectForKey:@"StoreCity"];
        StoreState = [object objectForKey:@"StoreState"];
        StoreZip = [object objectForKey:@"StoreZip"];
        TotalAmt = [object objectForKey:@"TotalAmt"];
        Status = [object objectForKey:@"Status"];
        RepActionReq = [object objectForKey:@"RepActionRequired"];
        ActionMsg = [object objectForKey:@"Message"];
        StatusDate = [object objectForKey:@"FmtStatusTimestamp"];
        

        [WayneOrderHeader beginInsert];
        
        for (int i = 0; i < OrderNum.count; i ++) {
            WayneOrderHeader * wayneOrder = [[WayneOrderHeader alloc] init];
            
            
//            NSLog(@"total amt: %@", [TotalAmt objectAtIndex:i]);
            
            wayneOrder.CustNum = [CustNum objectAtIndex:i];
            wayneOrder.PONum = [PONum objectAtIndex:i];
            wayneOrder.OrderNum = [[OrderNum objectAtIndex:i] intValue];
            wayneOrder.UserID = [UserID objectAtIndex:i];
            wayneOrder.HeartwoodStatus = [HeartwoodStatus objectAtIndex:i];
            wayneOrder.Terms = [Terms objectAtIndex:i];
            wayneOrder.ShipMethod = [ShipMethod objectAtIndex:i];
            wayneOrder.CustName = [CustName objectAtIndex:i];
            wayneOrder.ProcessedBy = [ProcessedBy objectAtIndex:i];
            wayneOrder.DateReceived = [DateReceived objectAtIndex:i];
            wayneOrder.DateAccepted = [DateAccepted objectAtIndex:i];
            wayneOrder.SAPShipDate = [SAPShipDate objectAtIndex:i];
            wayneOrder.BillName = [BillName objectAtIndex:i];
            wayneOrder.BillADDR1 = [BillADDR1 objectAtIndex:i];
            wayneOrder.BillADDR2 = [BillADDR2 objectAtIndex:i];
            wayneOrder.BillCity = [BillCity objectAtIndex:i];
            wayneOrder.BillState = [BillState objectAtIndex:i];
            wayneOrder.BillZip = [BillZip objectAtIndex:i];
            wayneOrder.StoreName = [StoreName objectAtIndex:i];
            wayneOrder.StoreADDR1 = [StoreADDR1 objectAtIndex:i];
            wayneOrder.StoreADDR2 = [StoreADDR2 objectAtIndex:i];
            wayneOrder.StoreCity = [StoreCity objectAtIndex:i];
            wayneOrder.StoreState = [StoreState objectAtIndex:i];
            wayneOrder.StoreZip = [StoreZip objectAtIndex:i];
            NSString *testy = [TotalAmt objectAtIndex:i];
            
//            NSLog(@"string: %@", testy);
            
            if ([testy isEqual: [NSNull null]]) {
                wayneOrder.TotalAmt = 0.0f;
            } else {
                wayneOrder.TotalAmt = [[TotalAmt objectAtIndex:i] floatValue];
            }
            wayneOrder.Status = [Status objectAtIndex:i];
            wayneOrder.RepActionReq = [[RepActionReq objectAtIndex:i] stringValue];
            wayneOrder.ActionMsg = [ActionMsg objectAtIndex:i];
            wayneOrder.StatusDate = [StatusDate objectAtIndex:i];
            
            
//            if (![wayneOrder.RepActionReq isEqual:@"(null)"]) {
//                NSLog(@"order no: %ld, repactreq: %@", (long)wayneOrder.OrderNum, wayneOrder.RepActionReq);
//            }
//            NSLog(@"ordNo: %ld RaR: %@, %@", (long)wayneOrder.OrderNum, wayneOrder.RepActionReq, [RepActionReq objectAtIndex:i]);
            
            
            [WayneOrderHeader insertInto:wayneOrder];
            
//            NSLog(@"Heartwood Status: %@ Status: %@", wayneOrder.HeartwoodStatus, wayneOrder.Status);

            
        }
        
        [WayneOrderHeader endInsert];
        if (allCall) {
            self.usersArray = [User getAllUsers];
            User *theUser = [self.usersArray objectAtIndex:0];
            [self syncWayneOrderLines:theUser.UserID withPassword:theUser.Password];
        } else if(post || gmpost) {
            self.usersArray = [User getAllUsers];
            User *theUser = [self.usersArray objectAtIndex:0];
            [self syncWayneOrderLines:theUser.UserID withPassword:theUser.Password];
        } else if(reSync == NO) {
            [self syncCompleted];
            apiType = APINone;
        }
    }
}

- (void) parseAndProcessUnshippedWayneOrderHeadersWithResponse: (NSString *) response {
    if (apiType == APIRetrive) {
        NSDictionary *items = [response JSONValue];
        
        if (items == nil) {
            // Parse Error
            apiType = APINone;
            return;
        }
        if (responseData != nil) {
            responseData = nil;
        }
        
        responseData = [NSString stringWithString:response];
        NSArray *list = [items objectForKey:@"result"];
        NSLog(@"%@", responseData);
        
        if (!list || list.count == 0) {
            apiType = APINone;
            return;
        }
        
        [WayneOrderHeader deleteWhereStatusNot:@"Closed/Shipped"];
        
        NSDictionary * object = [list objectAtIndex:0];
        
        
        CustNum = [object objectForKey:@"CustNum"];
        PONum = [object objectForKey:@"PONum"];
        OrderNum = [object objectForKey:@"OrderNo"];
        UserID = [object objectForKey:@"UserID"];
        HeartwoodStatus = [object objectForKey:@"HeartwoodStatus"];
        Terms = [object objectForKey:@"Terms"];
        ShipMethod = [object objectForKey:@"ShipMethod"];
        CustName = [object objectForKey:@"CustName"];
        ProcessedBy = [object objectForKey:@"ProcessedBy"];
        DateReceived = [object objectForKey:@"FmtDateReceived"];
        DateAccepted = [object objectForKey:@"FmtDateAccepted"];
        SAPShipDate = [object objectForKey:@"FmtSAPShipDate"];
        BillName = [object objectForKey:@"BillName"];
        BillADDR1 = [object objectForKey:@"BillAddr1"];
        BillADDR2 = [object objectForKey:@"BillAddr2"];
        BillCity = [object objectForKey:@"BillCity"];
        BillState = [object objectForKey:@"BillState"];
        BillZip = [object objectForKey:@"BillZip"];
        StoreName = [object objectForKey:@"StoreName"];
        StoreADDR1= [object objectForKey:@"StoreAddr1"];
        StoreADDR2 = [object objectForKey:@"StoreAddr2"];
        StoreCity = [object objectForKey:@"StoreCity"];
        StoreState = [object objectForKey:@"StoreState"];
        StoreZip = [object objectForKey:@"StoreZip"];
        TotalAmt = [object objectForKey:@"TotalAmt"];
        Status = [object objectForKey:@"Status"];
        RepActionReq = [object objectForKey:@"RepActionRequired"];
        ActionMsg = [object objectForKey:@"Message"];
        StatusDate = [object objectForKey:@"FmtStatusTimestamp"];
        
        [WayneOrderHeader beginInsert];
        unshippedOrders = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < OrderNum.count; i ++) {
            WayneOrderHeader * wayneOrder = [[WayneOrderHeader alloc] init];
            
            wayneOrder.CustNum = [CustNum objectAtIndex:i];
            wayneOrder.PONum = [PONum objectAtIndex:i];
            wayneOrder.OrderNum = [[OrderNum objectAtIndex:i] intValue];
            wayneOrder.UserID = [UserID objectAtIndex:i];
            wayneOrder.HeartwoodStatus = [HeartwoodStatus objectAtIndex:i];
            wayneOrder.Terms = [Terms objectAtIndex:i];
            wayneOrder.ShipMethod = [ShipMethod objectAtIndex:i];
            wayneOrder.CustName = [CustName objectAtIndex:i];
            wayneOrder.ProcessedBy = [ProcessedBy objectAtIndex:i];
            wayneOrder.DateReceived = [DateReceived objectAtIndex:i];
            wayneOrder.DateAccepted = [DateAccepted objectAtIndex:i];
            wayneOrder.SAPShipDate = [SAPShipDate objectAtIndex:i];
            wayneOrder.BillName = [BillName objectAtIndex:i];
            wayneOrder.BillADDR1 = [BillADDR1 objectAtIndex:i];
            wayneOrder.BillADDR2 = [BillADDR2 objectAtIndex:i];
            wayneOrder.BillCity = [BillCity objectAtIndex:i];
            wayneOrder.BillState = [BillState objectAtIndex:i];
            wayneOrder.BillZip = [BillZip objectAtIndex:i];
            wayneOrder.StoreName = [StoreName objectAtIndex:i];
            wayneOrder.StoreADDR1 = [StoreADDR1 objectAtIndex:i];
            wayneOrder.StoreADDR2 = [StoreADDR2 objectAtIndex:i];
            wayneOrder.StoreCity = [StoreCity objectAtIndex:i];
            wayneOrder.StoreState = [StoreState objectAtIndex:i];
            wayneOrder.StoreZip = [StoreZip objectAtIndex:i];
            wayneOrder.TotalAmt = [[TotalAmt objectAtIndex:i] floatValue];
            wayneOrder.Status = [Status objectAtIndex:i];
            wayneOrder.RepActionReq = [[RepActionReq objectAtIndex:i] stringValue];
            wayneOrder.ActionMsg = [ActionMsg objectAtIndex:i];
            wayneOrder.StatusDate = [StatusDate objectAtIndex:i];
            
            [WayneOrderHeader insertInto:wayneOrder];
            [unshippedOrders addObject:wayneOrder];
            }
        
        [WayneOrderHeader endInsert];

        self.usersArray = [User getAllUsers];
        User *theUser = [self.usersArray objectAtIndex:0];
        [self syncUnshippedWayneOrderLines:theUser.UserID withPassword:theUser.Password];

    }
}

- (void) parseAndProcessWayneOrderLinesWithResponse: (NSString *) response {
    if (apiType == APIRetrive) {
        NSDictionary *items = [response JSONValue];
        
        if (items == nil) {
            // Parse Error
            apiType = APINone;
            return;
        }
        if (responseData != nil) {
            responseData = nil;
        }
        
        responseData = [NSString stringWithString:response];
        NSArray *list = [items objectForKey:@"result"];
        
        if (!list || list.count == 0) {
            apiType = APINone;
            return;
        }
        
        [WayneOrderLine deleteAllOrderLines];
        
        NSDictionary * object = [list objectAtIndex:0];
        
        OrderNo = [object objectForKey:@"OrderNo"];
        QtyOrdered = [object objectForKey:@"QtyOrdered"];
        QtyShipped = [object objectForKey:@"QtyShipped"];
        QtyBackordered = [object objectForKey:@"QtyBackordered"];
        ItemNo = [object objectForKey:@"ItemNo"];
        ItemDesc = [object objectForKey:@"ItemDesc"];
        PricePerPiece = [object objectForKey:@"PricePerPiece"];
        LineTotal = [object objectForKey:@"LineTotal"];        
        
        [WayneOrderLine beginInsert];
        
        for (int i = 0; i < OrderNo.count; i ++) {
            WayneOrderLine * wayneOrder = [[WayneOrderLine alloc] init];
            
            wayneOrder.OrderNum = [[OrderNo objectAtIndex:i] intValue];
            wayneOrder.QtyOrdered = [[QtyOrdered objectAtIndex:i] intValue];
            wayneOrder.QtyShipped = [[QtyShipped objectAtIndex:i] intValue];
            wayneOrder.QtyBackordered = [[QtyBackordered objectAtIndex:i] intValue];
            wayneOrder.ItemNo = [ItemNo objectAtIndex:i];
            wayneOrder.ItemDesc = [ItemDesc objectAtIndex:i];
            wayneOrder.PricePerPiece = [[PricePerPiece objectAtIndex:i] floatValue];
            wayneOrder.LineTotal = [[LineTotal objectAtIndex:i] floatValue];
            
            [WayneOrderLine insertInto:wayneOrder];
            
        }
    
        [WayneOrderLine endInsert];
        
        if (allCall) {
            self.usersArray = [User getAllUsers];
            User *theUser = [self.usersArray objectAtIndex:0];
            [self syncGMItems:theUser.UserID withPassword:theUser.Password];
        } else if(post || gmpost) {
            self.usersArray = [User getAllUsers];
            User *theUser = [self.usersArray objectAtIndex:0];
            [self syncTrackingNumbers:theUser.UserID withPassword:theUser.Password];
        } else if(reSync == NO) {
            [self syncCompleted];
            apiType = APINone;
        }
    }
}

- (void) parseAndProcessUnshippedWayneOrderLinesWithResponse: (NSString *) response {
    if (apiType == APIRetrive) {
        NSDictionary *items = [response JSONValue];
        
        if (items == nil) {
            // Parse Error
            apiType = APINone;
            return;
        }
        if (responseData != nil) {
            responseData = nil;
        }
        
        responseData = [NSString stringWithString:response];
        NSArray *list = [items objectForKey:@"result"];
        
        if (!list || list.count == 0) {
            apiType = APINone;
            return;
        }
        
        for (WayneOrderHeader* ordHdr in unshippedOrders) {
            [WayneOrderLine deleteWhereOrderNum:ordHdr.OrderNum];
        }
        
        NSDictionary * object = [list objectAtIndex:0];
        
        OrderNo = [object objectForKey:@"OrderNo"];
        QtyOrdered = [object objectForKey:@"QtyOrdered"];
        QtyShipped = [object objectForKey:@"QtyShipped"];
        QtyBackordered = [object objectForKey:@"QtyBackordered"];
        ItemNo = [object objectForKey:@"ItemNo"];
        ItemDesc = [object objectForKey:@"ItemDesc"];
        PricePerPiece = [object objectForKey:@"PricePerPiece"];
        LineTotal = [object objectForKey:@"LineTotal"];
        
        [WayneOrderLine beginInsert];
        
        for (int i = 0; i < OrderNo.count; i ++) {
            WayneOrderLine * wayneOrder = [[WayneOrderLine alloc] init];
            
            wayneOrder.OrderNum = [[OrderNo objectAtIndex:i] intValue];
            wayneOrder.QtyOrdered = [[QtyOrdered objectAtIndex:i] intValue];
            wayneOrder.QtyShipped = [[QtyShipped objectAtIndex:i] intValue];
            wayneOrder.QtyBackordered = [[QtyBackordered objectAtIndex:i] intValue];
            wayneOrder.ItemNo = [ItemNo objectAtIndex:i];
            wayneOrder.ItemDesc = [ItemDesc objectAtIndex:i];
            wayneOrder.PricePerPiece = [[PricePerPiece objectAtIndex:i] floatValue];
            wayneOrder.LineTotal = [[LineTotal objectAtIndex:i] floatValue];
            
            [WayneOrderLine insertInto:wayneOrder];
            
        }
        
        [WayneOrderLine endInsert];
        
        [self statusSyncCompleted];
        apiType = APINone;
    }
}

- (void) parseAndProcessGMItemsWithResponse: (NSString *) response {
    if (apiType == APIRetrive) {
        NSDictionary *items = [response JSONValue];
        
        
        if (items == nil) {
            // Parse Error
            apiType = APINone;
            return;
        }
        
        if (responseData != nil) {
            responseData = nil;
        }
        
        responseData = [NSString stringWithString:response];
        
        NSArray *list = [items objectForKey:@"result"];
        
        if (!list || list.count == 0) {
            apiType = APINone;
            return;
        }
        
        [GMItem deleteAllItems];
        
        NSDictionary * object = [list objectAtIndex:0];
        
        ItemNo = [object objectForKey:@"ItemNum"];
        ItemDesc = [object objectForKey:@"ItemDescription"];
        PriceSmallQ = [object objectForKey:@"PriceSmallQ"];
        PriceMedQ = [object objectForKey:@"PriceMedQ"];
        PriceLargeQ = [object objectForKey:@"PriceLargeQ"];
        Minimum = [object objectForKey:@"Minimum"];
        Increment = [object objectForKey:@"Increment"];
        NameDropOnly = [object objectForKey:@"NameDropOnly"];
        
        
        // insert into Items
        for (int i = 0; i < ItemNo.count; i ++) {
            GMItem * gmItem = [[GMItem alloc] init];
            
            gmItem.ItemNum = [ItemNo objectAtIndex:i];
            gmItem.ItemDescription = [ItemDesc objectAtIndex:i];
            gmItem.PriceSmallQ = [PriceSmallQ objectAtIndex:i];
            gmItem.PriceMedQ = [PriceMedQ objectAtIndex:i];
            gmItem.PriceLargeQ = [PriceLargeQ objectAtIndex:i];
            gmItem.Minimum = [[Minimum objectAtIndex:i] intValue];
            gmItem.Increment = [[Increment objectAtIndex:i] intValue];
            gmItem.NameDropOnly = [[NameDropOnly objectAtIndex:i] intValue];
            
            
//            //used to see what items were coming in
//            NSLog(@"%@, %@, %d", gmItem.ItemNum, gmItem.ItemDescription, gmItem.NameDropOnly);
//            NSLog(@"%@", [NameDropOnly objectAtIndex:i]);

            
            [GMItem insertInto:gmItem];
            
        }
    }
    if (allCall) {
        self.usersArray = [User getAllUsers];
        User *theUser = [self.usersArray objectAtIndex:0];
        [self syncShipMethods:theUser.UserID withPassword:theUser.Password];
    } else if(reSync == NO) {
        [self syncCompleted];
        apiType = APINone;
    }
}

- (void) parseAndProcessCheckSyncWithResponse: (NSString *) response {
    if (apiType == APIRetrive) {
        NSDictionary *items = [response JSONValue];
        
        if (items == nil) {
            // Parse Error
            apiType = APINone;
            return;
        }
        
        if (responseData != nil) {
            responseData = nil;
        }
        
        responseData = [NSString stringWithString:response];
        
        NSArray *list = [items objectForKey:@"result"];
        
        if (!list || list.count == 0) {
            apiType = APINone;
            return;
        }
        
        NSDictionary * object = [list objectAtIndex:0];
        
        RecordNeedsTransfer = [object objectForKey:@"SyncRes"];
        
        // insert into Names
        for (int i = 0; i < RecordNeedsTransfer.count; i ++) {
            
            if ([[RecordNeedsTransfer objectAtIndex:i] isEqual:@"0"]) {
                needsSync = @"false";
            } else {
                needsSync = @"true";
            }
        }
    }
    NSLog(@"%@", needsSync);
    apiType = APINone;
}

- (void) parseAndProcessShipAddressesWithResponse: (NSString *) response {
    if (apiType == APIRetrive) {
        NSDictionary *items = [response JSONValue];
        
        if (items == nil) {
            // Parse Error
            apiType = APINone;
            return;
        }
        
        if (responseData != nil) {
            responseData = nil;
        }
        
        responseData = [NSString stringWithString:response];
        
        NSArray *list = [items objectForKey:@"result"];
        
        if (!list || list.count == 0) {
            apiType = APINone;
            return;
        }
        
        [Ship deleteAllShipTypes];
        
        NSDictionary * object = [list objectAtIndex:0];
        
        ShipType = [object objectForKey:@"ShipType"];
        
        
        // insert into shipType
        for (int i = 0; i < ShipType.count; i ++) {
            Ship * ship = [[Ship alloc] init];
            
            ship.ShipType = [ShipType objectAtIndex:i];
            
            [Ship insertInto:ship];
            
        }
    }
    if (allCall) {
        self.usersArray = [User getAllUsers];
        User *theUser = [self.usersArray objectAtIndex:0];
        [self clearSyncNeeded:theUser.UserID withPassword:theUser.Password];
    } else if(reSync == NO) {
        [self syncCompleted];
        apiType = APINone;
    }
}

- (void) parseAndProcessClearSyncWithResponse: (NSString *) response {
    if (apiType == APIRetrive) {
        NSDictionary *items = [response JSONValue];
        
        if (items == nil) {
            // Parse Error
            apiType = APINone;
            return;
        }
        
        if (responseData != nil) {
            responseData = nil;
        }
        
        responseData = [NSString stringWithString:response];
        
        NSArray *list = [items objectForKey:@"result"];
        
        if (!list || list.count == 0) {
            apiType = APINone;
            return;
        }
        
        NSDictionary * object = [list objectAtIndex:0];
        
        RecordNeedsTransfer = [object objectForKey:@"SyncRes"];
        
        // insert into Names
        for (int i = 0; i < RecordNeedsTransfer.count; i ++) {
            
            if ([[RecordNeedsTransfer objectAtIndex:i] isEqual:@"0"]) {
                needsSync = @"false";
            } else {
                needsSync = @"true";
            }
        }
    }
    NSLog(@"%@", needsSync);
    apiType = APINone;
    if (reSync == NO) {
        [self syncCompleted];
    } else {
        [DateLastSynced deleteAllDatesLastSynced];
        
        // setting date last synced.
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        DateLastSynced *lastSynced = [[DateLastSynced alloc] init];
        lastSynced.DateSynced = [self.dateFormatter stringFromDate:[NSDate date]];
        [DateLastSynced insertInto:lastSynced];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ResyncDone" object:self];

    }
}


#warning post processing

- (void) parseAndProcessPostWithResponse: (NSString *) response {

    if ([response isEqualToString:@"{\"error\":\"Message content is not a valid JSON value.\"}"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"JSON BROKEN"
                                                        message:@"Your json was too long. This is a bug. Please call/email Wayne Carver and tell them."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    } else if ([response isEqualToString:@"{\"error\":\"FAILED\"}"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your Order did not send, please try again"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            orderHeaderInfo.LocalStatus = START;
            [alert show];
    } else if (apiType == APIPost) {


            NSDictionary *items = [response JSONValue];

            if (items == nil) {
                // Parse Error
                apiType = APINone;
                return;
            }

            if (responseData != nil) {
                responseData = nil;
            }

            responseData = [NSString stringWithString:response];

            NSArray *list = [items objectForKey:@"result"];

            if (!list || list.count == 0) {
                apiType = APINone;
                return;
            }


            NSDictionary * object = [list objectAtIndex:0];

            CheckOrderPKID = [object objectForKey:@"OrdCheck"];

            NSString *test = [CheckOrderPKID objectAtIndex:0];




//
//        NSLog(@"ORDER PKID: %@", CheckOrderPKID);
//
//        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
//        [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//        [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//        orderHeaderInfo.DatePosted = [self.dateFormatter stringFromDate:[NSDate date]];
//        
//        
//        
//        orderSent = @"orderSent";
//        // no longer deleting order, instead moving it to posted order screen.
//        //        [OrderHeader deleteWhere:orderHeaderInfo.OrderNum];
//        orderHeaderInfo.LocalStatus = POST;
//#warning comment out here to repost order wo it going to order history
//        [OrderHeader updateOrderHeader:orderHeaderInfo];

        NSLog(@"CHECK TEST RESPONSE %@", response);
    

        
//        post = YES;
        self.usersArray = [User getAllUsers];
        User *theUser = [self.usersArray objectAtIndex:0];

        [self syncOrderReceived:theUser.UserID withPassword:theUser.Password withorderPKID:test];

        
//        [self syncWayneOrderHeaders:theUser.UserID withPassword:theUser.Password];
    } else {
        apiType = APINone;
    }
}


- (void) parseAndProcessOrderReceivedWithResponse:(NSString *)response {



    NSDictionary *items = [response JSONValue];

    if (items == nil) {
        // Parse Error
        apiType = APINone;
        return;
    }

    if (responseData != nil) {
        responseData = nil;
    }

    responseData = [NSString stringWithString:response];

    NSArray *list = [items objectForKey:@"result"];

    if (!list || list.count == 0) {
        apiType = APINone;
        return;
    }


    NSDictionary * object = [list objectAtIndex:0];

    CheckOrderPKID = [object objectForKey:@"OrderReceivedelse"];

    NSString *test = [CheckOrderPKID objectAtIndex:0];

    NSLog(@"Is Confirmed: %@", test);

    if ([test isEqual:@"TRUE"]) {

        NSLog(@"Is Confirmed: %@", test);

        orderSent = @"orderSent";
        orderHeaderInfo.LocalStatus = POST;
        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        orderHeaderInfo.DatePosted = [self.dateFormatter stringFromDate:[NSDate date]];
#warning comment out here to repost order wo it going to order history
        [OrderHeader updateOrderHeader:orderHeaderInfo];
        post = YES;

        self.usersArray = [User getAllUsers];
        User *theUser = [self.usersArray objectAtIndex:0];
        [self syncWayneOrderHeaders:theUser.UserID withPassword:theUser.Password];
    } else {
        orderHeaderInfo.LocalStatus = START;
        [OrderHeader updateOrderHeader:orderHeaderInfo];
        apiType = APINone;
    }
}


// NOT CURRENTLY IN USE
//- (void) parseAndProcessPostLineWithResponse: (NSString *) response {
//    
//    NSLog(@"response: %@", response);
//    
//    if ([response isEqualToString:@"{\"error\":\"Message content is not a valid JSON value.\"}"]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"JSON BROKEN"
//                                                        message:@"Your json was too long. This is a bug. Please call/email Wayne Carver and tell them."
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//    } else if (apiType == APIPost) {
//        
//        
//        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
//        [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//        [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//        orderHeaderInfo.DatePosted = [self.dateFormatter stringFromDate:[NSDate date]];
//        
//        
//        
//        orderSent = @"orderSent";
//        // no longer deleting order, instead moving it to posted order screen.
//        //        [OrderHeader deleteWhere:orderHeaderInfo.OrderNum];
//        orderHeaderInfo.LocalStatus = POST;
//        
//#warning commented out
////        [OrderHeader updateOrderHeader:orderHeaderInfo];
//        
//        
//        post = YES;
//        self.usersArray = [User getAllUsers];
//        User *theUser = [self.usersArray objectAtIndex:0];
//        
//        [self syncWayneOrderHeaders:theUser.UserID withPassword:theUser.Password];
//    } else {
//        apiType = APINone;
//    }
//}

- (void) parseAndProcessgmPostWithResponse: (NSString *) response {
    
    if ([response isEqualToString:@"{\"error\":\"Message content is not a valid JSON value.\"}"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"JSON BROKEN"
                                                        message:@"Your json was too long. This is a bug. Please call/email Wayne Carver and tell them."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else if (apiType == APIPost) {
        
        
        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        gmorderHeaderInfo.DatePosted = [self.dateFormatter stringFromDate:[NSDate date]];
        
        orderSent = @"orderSent";
        gmorderHeaderInfo.LocalStatus = GMPOST;
        
        [GMOrderHeader updateOrderHeader:gmorderHeaderInfo];
        
        
        gmpost = YES;
        self.usersArray = [User getAllUsers];
        User *theUser = [self.usersArray objectAtIndex:0];
        
        [self syncWayneOrderHeaders:theUser.UserID withPassword:theUser.Password];
    } else {
        apiType = APINone;
    }
}


#pragma mark - HTTPRequestDelegate
//This method is called after a successful return of a string. It could be null, error code or json
- (void)httpRequest:(HTTPRequest *)request didRetrieveData:(NSData *)data {
    [SVProgressHUD dismiss];
    //Convert the data to string
    NSString *jsonText = [apiRequester responseAsText];
    
    NSLog(@"Response = %@", jsonText);
    
    if (jsonText != nil)
    {
        //check to see if the return string is a null due to some problems.
        if([jsonText isEqualToString:@"null"] || [jsonText isEqualToString:@"{\"result\":[null]}"])
        {
            if (![callType isEqualToString:SYNC_CHECK]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"No Data Received. Make sure you have correctly entered your Username and Password and the IP and Port are correct."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                if (allCall && !reSync && ![callType isEqualToString:SYNC_USER]) {
                    NSLog(@"Clearing because of failed sync...");
                    [User deleteAllUsers];
                    [Customer deleteAllCustomers];
                    [Address deleteAllAddresses];
                    [Item deleteAllItems];
                    [Name deleteAllNames];
//                    No longer deleting order info. Instead, this info is still stored and only displayed when the correct user is signed in.
//                    [OrderHeader deleteAllOrderHeaders];
//                    [OrderLine deleteAllOrderLines];
//                    [OrderDetail deleteAllOrderDetails];
                    [WayneOrderHeader deleteAllOrderHeaders];
                    [WayneOrderLine deleteAllOrderLines];
                }
            }
            return;
        }
        if ([callType isEqualToString:SYNC_USER]) {
            [self parseAndProcessUserWithResponse:jsonText];
        } else if ([callType isEqualToString:SYNC_CUST]){
            [self parseAndProcessCustomersWithResponse:jsonText];
        } else if ([callType isEqualToString:SYNC_ADDRESS]){
            [self parseAndProcessAddressesWithResponse:jsonText];
        } else if ([callType isEqualToString:SYNC_ITEM]){
            [self parseAndProcessItemsWithResponse:jsonText];
        } else if ([callType isEqualToString:SYNC_NAME]){
            [self parseAndProcessNamesWithResponse:jsonText];
        } else if ([callType isEqualToString:SYNC_CHECK]){
            [self parseAndProcessCheckSyncWithResponse:jsonText];
        } else if ([callType isEqualToString:SYNC_CLEAR]){
            [self parseAndProcessClearSyncWithResponse:jsonText];
        } else if ([callType isEqualToString:SYNC_SHIP]){
            [self parseAndProcessShipAddressesWithResponse:jsonText];
        } else if ([callType isEqualToString:SYNC_POST]){
            [self parseAndProcessPostWithResponse:jsonText];
        } else if ([callType isEqualToString:SYNC_CHECKORDER]){
            [self parseAndProcessOrderReceivedWithResponse:jsonText];
            // NOT CURRENTLY IN USE
//        }else if ([callType isEqualToString:SYNC_POST_LINE]){
//            [self parseAndProcessPostLineWithResponse:jsonText];
        } else if ([callType isEqualToString:SYNC_WHDR]){
            [self parseAndProcessWayneOrderHeadersWithResponse:jsonText];
        } else if ([callType isEqualToString:SYNC_WLNE]){
            [self parseAndProcessWayneOrderLinesWithResponse:jsonText];
        } else if ([callType isEqualToString:SYNC_ORDTRK]){
            [self parseAndProcessTrackingNumbersWithResponse:jsonText];
        } else if ([callType isEqualToString:SYNC_GMITEM]){
            [self parseAndProcessGMItemsWithResponse:jsonText];
        } else if ([callType isEqualToString:SYNC_GMPOST]){
            [self parseAndProcessgmPostWithResponse:jsonText];
        } else if ([callType isEqualToString:SYNC_UWHDR]) {
            [self parseAndProcessUnshippedWayneOrderHeadersWithResponse:jsonText];
        } else if ([callType isEqualToString:SYNC_UWLNE]) {
            [self parseAndProcessUnshippedWayneOrderLinesWithResponse:jsonText];
        }
    }
}

//this is called when an error occurs in the communication.
- (void)httpRequest:(HTTPRequest *)request didFailWithError:(NSError *)error {
    //hide waiting activity view
    [SVProgressHUD dismiss];
    if (![callType isEqualToString:SYNC_CHECK]) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Unable to Connect. Please check your Internet connection. If you are connected, check your IP and Port." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        if (allCall && !reSync && ![callType isEqualToString:SYNC_USER]) {
            NSLog(@"Clearing because of failed sync...");
            [User deleteAllUsers];
            [Customer deleteAllCustomers];
            [Address deleteAllAddresses];
            [Item deleteAllItems];
            [Name deleteAllNames];
//            No longer deleting order info. Instead, this info is still stored and only displayed when the correct user is signed in.
//            [OrderHeader deleteAllOrderHeaders];
//            [OrderLine deleteAllOrderLines];
//            [OrderDetail deleteAllOrderDetails];
            [WayneOrderHeader deleteAllOrderHeaders];
            [WayneOrderLine deleteAllOrderLines];
        }
    }
}

//This method is called to indicate that a status code was received.
//Developers can use this to show proper responses to the users
- (void)httpRequest:(HTTPRequest *)request didReceiveStatusCode:(int)statusCode {
    //hide waiting activity view
    [SVProgressHUD dismiss];
	switch (statusCode)
	{
		case 200:
			break;
		default:
		{
            if (![callType isEqualToString:SYNC_CHECK]) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Request Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                
                if (allCall && !reSync && ![callType isEqualToString:SYNC_USER]) {
                    NSLog(@"Clearing because of failed sync...");
                    [User deleteAllUsers];
                    [Customer deleteAllCustomers];
                    [Address deleteAllAddresses];
                    [Item deleteAllItems];
                    [Name deleteAllNames];
//                    No longer deleting order info. Instead, this info is still stored and only displayed when the correct user is signed in.
//                    [OrderHeader deleteAllOrderHeaders];
//                    [OrderLine deleteAllOrderLines];
//                    [OrderDetail deleteAllOrderDetails];
                    [WayneOrderHeader deleteAllOrderHeaders];
                    [WayneOrderLine deleteAllOrderLines];
                }
            }
 		}
	}
}

- (void) syncCompleted {
    // All instances of TestClass will be notified
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SyncDone" object:self];
    
    [DateLastSynced deleteAllDatesLastSynced];
    
    // setting date last synced.
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    DateLastSynced *lastSynced = [[DateLastSynced alloc] init];
    lastSynced.DateSynced = [self.dateFormatter stringFromDate:[NSDate date]];
    [DateLastSynced insertInto:lastSynced];
}

- (void) statusSyncCompleted {
    // All instances of TestClass will be notified
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StatusSyncDone" object:self];
}

@end
