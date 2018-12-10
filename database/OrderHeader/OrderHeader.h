//
//  OrderHeader.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/22/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define  TBL_ORDERHEADER    @"OrderHeader"
#define  FLD_ORDERNUM       @"OrderNum"
#define  FLD_USERID         @"UserID"
#define  FLD_CUSTNUM        @"CustNum"
#define  FLD_STOREID        @"StoreID"
#define  FLD_PONUM          @"PONum"
#define  FLD_LOCALSTATUS    @"LocalStatus"
#define  FLD_HTWDSTATUS     @"HeartwoodStatus"
#define  FLD_SHIPMETHOD     @"ShipMethod"
#define  FLD_NOTBEFORE      @"NotBefore"
#define  FLD_NOTES          @"Notes"
#define  FLD_DATETOSHIP     @"DateToShip"
#define  FLD_DATECREATED    @"DateCreated"
#define  FLD_DATEEDITED     @"DateEdited"
#define  FLD_DATEPOSTED     @"DatePosted"
#define  FLD_PDFTYPE        @"PDFType"


@interface OrderHeader : NSObject
{
    NSInteger OrderNum;
    NSString * UserID;
    NSString * CustNum;
    NSString * StoreID;
    NSString * PONum;
    NSString * LocalStatus;
    NSString * HeartwoodStatus;
    NSString * ShipMethod;
    NSString * NotBefore;
    NSString * Notes;
    NSString * DateToShip;
    NSString * DateCreated;
    NSString * DateEdited;
    NSString * DatePosted;
    NSString * PDFType;
}

@property (nonatomic) NSInteger OrderNum;
@property (nonatomic, retain) NSString * UserID;
@property (nonatomic, retain) NSString * CustNum;
@property (nonatomic, retain) NSString * StoreID;
@property (nonatomic, retain) NSString * PONum;
@property (nonatomic, retain) NSString * LocalStatus;
@property (nonatomic, retain) NSString * HeartwoodStatus;
@property (nonatomic, retain) NSString * ShipMethod;
@property (nonatomic, retain) NSString * NotBefore;
@property (nonatomic, retain) NSString * Notes;
@property (nonatomic, retain) NSString * DateToShip;
@property (nonatomic, retain) NSString * DateCreated;
@property (nonatomic, retain) NSString * DateEdited;
@property (nonatomic, retain) NSString * DatePosted;
@property (nonatomic, retain) NSString * PDFType;


+ (BOOL) deleteWhere:(NSInteger)uid;
+ (void) deleteAllOrderHeaders;

+ (id) fetch:(sqlite3_stmt *)dbStmt;

+ (NSMutableArray*) getAllOrderHeaders;
+ (OrderHeader*) getLastOrderHeaderEntered;
+ (OrderHeader*) getOrderHeaderWhereOrderNum:(NSInteger)OrderNum;



+ (NSInteger) insertInto:(OrderHeader*) data;
+ (NSInteger) updateOrderHeader:(OrderHeader*)data;




@end
