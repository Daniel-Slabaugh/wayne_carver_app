//
//  WayneOrderHeader.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 8/6/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define  TBL_WAYNEORDERHEADER      @"WayneOrderHeader"
#define  FLD_CUSTNUM            @"CustNum"
#define  FLD_PONUM              @"PONum"
#define  FLD_ORDERNUM           @"OrderNum"
#define  FLD_USERID             @"UserID"
#define  FLD_HEARTWOODSTATUS    @"HeartwoodStatus"
#define  FLD_TERMS              @"Terms"
#define  FLD_SHIPMETHOD         @"ShipMethod"
#define  FLD_CUSTNAME           @"CustName"
#define  FLD_PROCESSEDBY        @"ProcessedBy"
#define  FLD_DATERECEIVED       @"DateReceived"
#define  FLD_DATEACCEPTED       @"DateAccepted"
#define  FLD_SAPSHIPDATE        @"SAPShipDate"
#define  FLD_BILLNAME           @"BillName"
#define  FLD_BILLADDR1          @"BillADDR1"
#define  FLD_BILLADDR2          @"BillADDR2"
#define  FLD_BILLCITY           @"BillCity"
#define  FLD_BILLSTATE          @"BillState"
#define  FLD_BILLZIP            @"BillZip"
#define  FLD_STORENAME          @"StoreName"
#define  FLD_STOREADDR1         @"StoreADDR1"
#define  FLD_STOREADDR2         @"StoreADDR2"
#define  FLD_STORECITY          @"StoreCity"
#define  FLD_STORESTATE         @"StoreState"
#define  FLD_STOREZIP           @"StoreZip"
#define  FLD_TOTALAMT           @"TotalAmt"
#define  FLD_STATUS             @"Status"
#define  FLD_REPACTREQ          @"RepActionReq"
#define  FLD_ACTIONMSG          @"ActionMsg"
#define  FLD_STATUSDATE         @"StatusDate"
#define  FLD_PDFTYPE            @"PDFType"



@interface WayneOrderHeader : NSObject
{
    NSString * CustNum;
    NSString * PONum;
    NSInteger OrderNum;
    NSString * UserID;
    NSString * HeartwoodStatus;
    NSString * Terms;
    NSString * ShipMethod;
    NSString * CustName;
    NSString * ProcessedBy;
    NSString * DateReceived;
    NSString * DateAccepted;
    NSString * SAPShipDate;
    NSString * BillName;
    NSString * BillADDR1;
    NSString * BillADDR2;
    NSString * BillCity;
    NSString * BillState;
    NSString * BillZip;
    NSString * StoreName;
    NSString * StoreADDR1;
    NSString * StoreADDR2;
    NSString * StoreCity;
    NSString * StoreState;
    NSString * StoreZip;
    float TotalAmt;
    NSString * Status;
    NSString * RepActionReq;
    NSString * ActionMsg;
    NSString * StatusDate;
    NSString * PDFType;
}

@property (nonatomic, retain) NSString * CustNum;
@property (nonatomic, retain) NSString * PONum;
@property (nonatomic) NSInteger OrderNum;
@property (nonatomic, retain) NSString * UserID;
@property (nonatomic, retain) NSString * HeartwoodStatus;
@property (nonatomic, retain) NSString * Terms;
@property (nonatomic, retain) NSString * ShipMethod;
@property (nonatomic, retain) NSString * CustName;
@property (nonatomic, retain) NSString * ProcessedBy;
@property (nonatomic, retain) NSString * DateReceived;
@property (nonatomic, retain) NSString * DateAccepted;
@property (nonatomic, retain) NSString * SAPShipDate;
@property (nonatomic, retain) NSString * BillName;
@property (nonatomic, retain) NSString * BillADDR1;
@property (nonatomic, retain) NSString * BillADDR2;
@property (nonatomic, retain) NSString * BillCity;
@property (nonatomic, retain) NSString * BillState;
@property (nonatomic, retain) NSString * BillZip;
@property (nonatomic, retain) NSString * StoreName;
@property (nonatomic, retain) NSString * StoreADDR1;
@property (nonatomic, retain) NSString * StoreADDR2;
@property (nonatomic, retain) NSString * StoreCity;
@property (nonatomic, retain) NSString * StoreState;
@property (nonatomic, retain) NSString * StoreZip;
@property (nonatomic)float TotalAmt;
@property (nonatomic, retain) NSString * Status;
@property (nonatomic, retain) NSString * RepActionReq;
@property (nonatomic, retain) NSString * ActionMsg;
@property (nonatomic, retain) NSString * StatusDate;
@property (nonatomic, retain) NSString * PDFType;



+ (BOOL) deleteWhere:(NSInteger)uid;
+ (BOOL) deleteWhereStatusNot:(NSString*)Status;
+ (void) deleteAllOrderHeaders;

+ (id) fetch:(sqlite3_stmt *)dbStmt;

+ (NSMutableArray*) getAllOrderHeaders;
+ (WayneOrderHeader*) getOrderHeaderWhereOrderNum:(NSInteger)OrderNum;
+ (NSMutableArray*) getOrderHeadersWhereCustomer:(NSString*)customer;
+ (WayneOrderHeader*) getOrderHeaderWhereCustomer:(NSString*)customer;
+ (NSMutableArray*) getOrderHeadersAfterDate:(NSDate*)date;


+ (NSInteger) beginInsert;
+ (NSInteger) endInsert;
+ (NSInteger) insertInto:(WayneOrderHeader*) data;




@end
