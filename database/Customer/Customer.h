//
//  Customer.h
//  wayne mobile
//
//  Created by Daniel Slabaugh on 7/1/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define  TBL_CUSTOMER   @"Customers"
#define  FLD_CUSTNUM    @"CustNum"
#define  FLD_CUSTNAME   @"CustName"
#define  FLD_PHONE1     @"Phone1"
#define  FLD_PHONE2     @"Phone2"
#define  FLD_FAX        @"FAX"
#define  FLD_CPRSN      @"Cntctprsn"
#define  FLD_EMAIL      @"Email"
#define  FLD_ADDR1      @"ADDR1"
#define  FLD_ADDR2      @"ADDR2"
#define  FLD_CITY       @"City"
#define  FLD_STATE      @"State"
#define  FLD_ZIP        @"ZipCode"
#define  FLD_COUNTRY    @"Country"

@interface Customer : NSObject
{
    NSString * CustNum;
    NSString * CustName;
    NSString * Phone1;
    NSString * Phone2;
    NSString * FAX;
    NSString * Cntctprsn;
    NSString * Email;
    NSString * ADDR1;
    NSString * ADDR2;
    NSString * City;
    NSString * State;
    NSString * Zip;
    NSString * Country;
}

@property (nonatomic, retain) NSString * CustNum;
@property (nonatomic, retain) NSString * CustName;
@property (nonatomic, retain) NSString * Phone1;
@property (nonatomic, retain) NSString * Phone2;
@property (nonatomic, retain) NSString * FAX;
@property (nonatomic, retain) NSString * Cntctprsn;
@property (nonatomic, retain) NSString * Email;
@property (nonatomic, retain) NSString * ADDR1;
@property (nonatomic, retain) NSString * ADDR2;
@property (nonatomic, retain) NSString * City;
@property (nonatomic, retain) NSString * State;
@property (nonatomic, retain) NSString * Zip;
@property (nonatomic, retain) NSString * Country;

+ (BOOL) deleteWhere:(NSInteger)uid;

+ (void) deleteAllCustomers;

+ (id) fetch:(sqlite3_stmt *)dbStmt;

+ (NSMutableArray*) getAllCustomers;
+ (Customer*) getCustomerWhereCustomerNumber:(NSString*)custNum;


+ (NSInteger) insertInto:(Customer*) data;

@end
