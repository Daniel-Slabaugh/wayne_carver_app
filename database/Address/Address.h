//
//  Address.h
//  wayne mobile
//
//  Created by Daniel Slabaugh on 10/25/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define  TBL_ADDRESS        @"Addresses"
#define  FLD_PKID           @"PKID"
#define  FLD_STOREID        @"StoreID"
#define  FLD_CUSTNUM        @"CustNum"
#define  FLD_NAME           @"Name"
#define  FLD_AADDR1         @"Addr1"
#define  FLD_AADDR2         @"Addr2"
#define  FLD_CITY           @"City"
#define  FLD_STATE          @"State"
#define  FLD_COUNTRY        @"Country"
#define  FLD_AZIP           @"Zip"





@interface Address : NSObject
{
    NSInteger  PKID;
    NSString * StoreID;
    NSString * CustNum;
    NSString * Name;
    NSString * Addr1;
    NSString * Addr2;
    NSString * City;
    NSString * State;
    NSString * Country;
    NSString * Zip;

}

@property (nonatomic) NSInteger PKID;
@property (nonatomic, retain) NSString * StoreID;
@property (nonatomic, retain) NSString * CustNum;
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSString * Addr1;
@property (nonatomic, retain) NSString * Addr2;
@property (nonatomic, retain) NSString * City;
@property (nonatomic, retain) NSString * State;
@property (nonatomic, retain) NSString * Country;
@property (nonatomic, retain) NSString * Zip;



+ (BOOL) deleteWhere:(NSInteger)uid;
+ (void) deleteAllAddresses;

+ (id) fetch:(sqlite3_stmt *)dbStmt;

+ (NSMutableArray*) getAllAddresses;

+ (Address*) getAddressWhereStore:(NSString *)store;
+ (NSMutableArray*) getAddressesWhere:(NSString*)customerNum;

+ (NSInteger) insertInto:(Address*) data;


@end
