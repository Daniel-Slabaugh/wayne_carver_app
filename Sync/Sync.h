//
//  Sync.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/3/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPRequestDelegate.h"
#import "OrderHeader.h"
#import "GMOrderHeader.h"

#define SYNC_USER @"syncUser"
#define SYNC_CUST @"syncCustomers"
#define SYNC_ADDRESS @"syncAddresses"
#define SYNC_ITEM @"syncItems"
#define SYNC_NAME @"syncNames"
#define SYNC_CHECK @"checkSync"
#define SYNC_CLEAR @"clearSync"
#define SYNC_ORDTRK @"syncTrack"
#define SYNC_SHIP @"syncShip"
#define SYNC_POST @"postOrder"
#define SYNC_POST_LINE @"postOrderLine"
#define SYNC_WHDR @"WayneOrderHeader"
#define SYNC_WLNE @"WayneOrderLine"
#define SYNC_UWHDR @"UnshippedWayneOrderHeader"
#define SYNC_UWLNE @"UnshippedWayneOrderLine"
#define SYNC_GMITEM @"GMItem"
#define SYNC_GMPOST @"gmpostOrder"
#define SYNC_ORDSTATUS @"OrderStatuses"
#define SYNC_CHECKORDER @"CheckOrderPost"
//#define URL @"datasnap/rest/TServerMethods1/" //test server Mark's Desktop
#define URL @"RepServer/RepServer_service.dll/datasnap/rest/TServerMethods1/" //live IIS Server


enum {
    APINone,
    APIRetrive,
    APIPost,
};

@class HTTPRequest;
@interface Sync : NSObject <HTTPRequestDelegate> {
    
    HTTPRequest * apiRequester;
    NSUInteger apiType;
    NSString *responseData;
    NSString *callType;
    BOOL allCall;
    BOOL post;
    BOOL gmpost;
    BOOL reSync;
    
    //rep and customer
    NSMutableArray *UserID;
    NSMutableArray *FirstName;
    NSMutableArray *LastName;
    NSMutableArray *CompanyName;
    NSMutableArray *MailAddr1;
    NSMutableArray *MailAddr2;
    NSMutableArray *MailCity;
    NSMutableArray *MailState;
    NSMutableArray *MailZip;
    NSMutableArray *MailCountry;
    NSMutableArray *ShipAddr1;
    NSMutableArray *ShipAddr2;
    NSMutableArray *ShipCity;
    NSMutableArray *ShipState;
    NSMutableArray *ShipZip;
    NSMutableArray *ShipCountry;
    NSMutableArray *Phone;
    NSMutableArray *FAX;
    NSMutableArray *Cell;
    NSMutableArray *Email;
    NSMutableArray *Password;
    NSMutableArray *CustNum;
    NSMutableArray *CustName;
    NSMutableArray *Phone1;
    NSMutableArray *Phone2;
    NSMutableArray *Cntctprsn;
    NSMutableArray *ADDR1;
    NSMutableArray *ADDR2;
    NSMutableArray *City;
    NSMutableArray *State;
    NSMutableArray *Zip;
    NSMutableArray *Country;
    
    //Items and Names
    NSMutableArray *MAD;
    NSMutableArray *CustomerNum;
    NSMutableArray *ProgName;
    NSMutableArray *ItemNo;
    NSMutableArray *Nameset;
    NSMutableArray *TheName;
    NSMutableArray *NameType;
    NSMutableArray *NumOfPegs;
    NSMutableArray *Description;
    
    //Addresses
    NSMutableArray *StoreID;
    NSMutableArray *Named;
    
    //SyncNeeded
    NSMutableArray *RecordNeedsTransfer;
    
    //ShipTypes
    NSMutableArray *ShipType;
    
    //WayneOrderHeader
    NSMutableArray *PONum;
    NSMutableArray *OrderNum;
    NSMutableArray *HeartwoodStatus;
    NSMutableArray *Terms;
    NSMutableArray *ShipMethod;
    NSMutableArray *ProcessedBy;
    NSMutableArray *DateReceived;
    NSMutableArray *DateAccepted;
    NSMutableArray *SAPShipDate;
    NSMutableArray *BillName;
    NSMutableArray *BillADDR1;
    NSMutableArray *BillADDR2;
    NSMutableArray *BillCity;
    NSMutableArray *BillState;
    NSMutableArray *BillZip;
    NSMutableArray *StoreName;
    NSMutableArray *StoreADDR1;
    NSMutableArray *StoreADDR2;
    NSMutableArray *StoreCity;
    NSMutableArray *StoreState;
    NSMutableArray *StoreZip;
    NSMutableArray *TotalAmt;
    //OrderStatuses
    NSMutableArray *Status;
    NSMutableArray *RepActionReq;
    NSMutableArray *ActionMsg;
    NSMutableArray *StatusDate;
    //Unshipped
    NSMutableArray *unshippedOrders;
    
    //WayneOrderLine
    NSMutableArray *OrderNo;
    NSMutableArray *QtyOrdered;
    NSMutableArray *QtyShipped;
    NSMutableArray *QtyBackordered;
    NSMutableArray *ItemDesc;
    NSMutableArray *PricePerPiece;
    NSMutableArray *LineTotal;
    
    //TrackingNumbers
    NSMutableArray *ShippingCompany;
    NSMutableArray *TrackingNumbers;
    
    //GMItems
    NSMutableArray *PriceSmallQ;
    NSMutableArray *PriceMedQ;
    NSMutableArray *PriceLargeQ;
    NSMutableArray *Minimum;
    NSMutableArray *Increment;
    NSMutableArray *NameDropOnly;

    //OrderCheck
    NSMutableArray *CheckOrderPKID;

}


@property (retain, nonatomic) NSMutableArray *usersArray;
@property (nonatomic, retain) OrderHeader * orderHeaderInfo; // used to store information for post so making post official is immediate
@property (nonatomic, retain) GMOrderHeader * gmorderHeaderInfo;
@property (nonatomic, strong) NSDateFormatter *dateFormatter; //used to do do date operations for post


- (void) parseAndProcessUserWithResponse: (NSString *) response;
- (void) parseAndProcessCustomersWithResponse: (NSString *) response;
//- (void) parseAndProcessStoresWithResponse: (NSString *) response;
- (void) parseAndProcessItemsWithResponse: (NSString *) response;
- (void) parseAndProcessNamesWithResponse: (NSString *) response;
- (void) parseAndProcessWayneOrderHeadersWithResponse: (NSString *) response;
- (void) parseAndProcessUnshippedWayneOrderHeadersWithResponse: (NSString *) response;
- (void) parseAndProcessWayneOrderLinesWithResponse: (NSString *) response;
- (void) parseAndProcessUnshippedWayneOrderLinesWithResponse: (NSString *) response;
- (void) parseAndProcessCheckSyncWithResponse: (NSString *) response;
- (void) parseAndProcessClearSyncWithResponse: (NSString *) response;
- (void) parseAndProcessShipAddressesWithResponse: (NSString *) response;
- (void) parseAndProcessTrackingNumbersWithResponse: (NSString *) response;


- (void)syncAll:(NSString*)user withPassword:(NSString*)password reSync:(BOOL)shouldSync;
- (void)syncUser:(NSString*)user withPassword:(NSString*)password;
- (void)syncCustomer:(NSString*)user withPassword:(NSString*)password;
//- (void)syncStores:(NSString*)user withPassword:(NSString*)password;
- (void)syncItems:(NSString*)user withPassword:(NSString*)password;
- (void)syncNames:(NSString*)user withPassword:(NSString*)password;
- (void)syncWayneOrderHeaders:(NSString*)user withPassword:(NSString*)password;
- (void)syncUnshippedWayneOrderHeaders:(NSString*)user withPassword:(NSString*)password;
- (void)syncWayneOrderLines:(NSString*)user withPassword:(NSString*)password;
- (void)syncUnshippedWayneOrderLines:(NSString*)user withPassword:(NSString*)password;
- (void)checkSyncNeeded:(NSString*)user withPassword:(NSString*)password;
- (void)clearSyncNeeded:(NSString*)user withPassword:(NSString*)password;
- (void)syncShipMethods:(NSString *)user withPassword:(NSString *)password;
- (void)syncTrackingNumbers:(NSString *)user withPassword:(NSString *)password;



//GM SYNCS AND POSTS
- (void)syncGMItems:(NSString *)user withPassword:(NSString *)password;
- (void)parseAndProcessGMItemsWithResponse: (NSString *)response;


- (void)postOrder:(NSString *)user withPassword:(NSString *)password withOrderData:(NSDictionary*)data withOrderHeader:(OrderHeader*)odrHeader;
// not currently in use
//- (void)postOrderLine:(NSString *)user withPassword:(NSString *)password withOrderData:(NSDictionary*)data withOrderHeader:(OrderHeader*)odrHeader number:(NSString*)num of:(NSString*)total;

- (void)gmpostOrder:(NSString *)user withPassword:(NSString *)password withOrderheader:(NSDictionary*)data;

- (void) parseAndProcessPostWithResponse: (NSString *) response;
- (void) parseAndProcessgmPostWithResponse: (NSString *) response;

- (void)syncOrderReceived:(NSString *)user withPassword:(NSString *)password withorderPKID:(NSString *)PKID;
- (void) parseAndProcessOrderReceivedWithResponse: (NSString *) response;


- (void) syncCompleted;




@end
