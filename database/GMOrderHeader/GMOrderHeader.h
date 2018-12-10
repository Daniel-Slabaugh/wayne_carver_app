//
//  GMOrderHeader.h
//  wayne mobile
//
//  Created by Delphi Dev Computer on 7/3/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define  TBL_GMORDERHEADER  @"GMOrderHeader"
#define  FLD_ORDERNUM       @"OrderNum"
#define  FLD_USERID         @"UserID"
#define  FLD_PONUM          @"PONum"
#define  FLD_LOCALSTATUS    @"LocalStatus"
#define  FLD_HTWDSTATUS     @"HeartwoodStatus"
#define  FLD_SHIPMETHOD     @"ShipMethod"
#define  FLD_NOTBEFORE      @"NotBefore"
#define  FLD_NOTES          @"Notes"
#define  FLD_BILLTO         @"BillTo"
#define  FLD_BADDRESS       @"BAddress"
#define  FLD_BCITY          @"BCity"
#define  FLD_BSTATE         @"BState"
#define  FLD_BZIP           @"BZip"
#define  FLD_BPHONEFAX      @"BPhoneFax"
#define  FLD_SHIPTO         @"ShipTo"
#define  FLD_SADDRESS       @"SAddress"
#define  FLD_SCITY1         @"SCity"
#define  FLD_SSTATE1        @"SState"
#define  FLD_SZIP1          @"SZip"
#define  FLD_DATETOSHIP     @"DateToShip"
#define  FLD_DATETOCANCEL   @"DateToCancel"
#define  FLD_DATECREATED    @"DateCreated"
#define  FLD_DATEEDITED     @"DateEdited"
#define  FLD_DATEPOSTED     @"DatePosted"
#define  FLD_CUSTNUM        @"CustNum"
#define  FLD_STOREID        @"StoreID"
#define  FLD_PDFTYPE        @"PDFType"



@interface GMOrderHeader : NSObject
{
    NSInteger OrderNum;
    NSString * UserID;
    NSString * PONum;
    NSString * LocalStatus;
    NSString * HeartwoodStatus;
    NSString * ShipMethod;
    NSString * NotBefore;
    NSString * Notes;
    NSString * BillTo;
    NSString * BAddress;
    NSString * BCity;
    NSString * BState;
    NSString * BZip;
    NSString * BPhoneFax;
    NSString * ShipTo;
    NSString * SAddress;
    NSString * SCity;
    NSString * SState;
    NSString * SZip;
    NSString * DateToShip;
    NSString * DateToCancel;
    NSString * DateCreated;
    NSString * DateEdited;
    NSString * DatePosted;
    NSString * CustNum;
    NSString * StoreID;
    NSString * PDFType;
}

@property (nonatomic) NSInteger OrderNum;
@property (nonatomic, retain) NSString * UserID;
@property (nonatomic, retain) NSString * PONum;
@property (nonatomic, retain) NSString * LocalStatus;
@property (nonatomic, retain) NSString * HeartwoodStatus;
@property (nonatomic, retain) NSString * ShipMethod;
@property (nonatomic, retain) NSString * NotBefore;
@property (nonatomic, retain) NSString * Notes;
@property (nonatomic, retain) NSString * BillTo;
@property (nonatomic, retain) NSString * BAddress;
@property (nonatomic, retain) NSString * BCity;
@property (nonatomic, retain) NSString * BState;
@property (nonatomic, retain) NSString * BZip;
@property (nonatomic, retain) NSString * BPhoneFax;
@property (nonatomic, retain) NSString * ShipTo;
@property (nonatomic, retain) NSString * SAddress;
@property (nonatomic, retain) NSString * SCity;
@property (nonatomic, retain) NSString * SState;
@property (nonatomic, retain) NSString * SZip;
@property (nonatomic, retain) NSString * DateToShip;
@property (nonatomic, retain) NSString * DateToCancel;
@property (nonatomic, retain) NSString * DateCreated;
@property (nonatomic, retain) NSString * DateEdited;
@property (nonatomic, retain) NSString * DatePosted;
@property (nonatomic, retain) NSString * CustNum;
@property (nonatomic, retain) NSString * StoreID;
@property (nonatomic, retain) NSString * PDFType;


+ (BOOL) deleteWhere:(NSInteger)uid;
+ (void) deleteAllOrderHeaders;

+ (id) fetch:(sqlite3_stmt *)dbStmt;

+ (NSMutableArray*) getAllOrderHeaders;
+ (GMOrderHeader*) getLastOrderHeaderEntered;
+ (GMOrderHeader*) getOrderHeaderWhereOrderNum:(NSInteger)OrderNum;



+ (NSInteger) insertInto:(GMOrderHeader*) data;
+ (NSInteger) updateOrderHeader:(GMOrderHeader*)data;




@end

