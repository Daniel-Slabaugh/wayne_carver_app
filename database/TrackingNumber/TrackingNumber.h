//
//  TrackingNumber.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 6/9/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define  TBL_TRACKINGNUMBER         @"TrackingNumber"
#define  FLD_ORDERNUM               @"OrderNum"
#define  FLD_SHIPCOMPANY            @"ShipCompany"
#define  FLD_TRACKINGNUMBER         @"TrackingNumber"


@interface TrackingNumber : NSObject
{
    NSInteger OrderNum;
    NSString * ShipCompany;
    NSString * TrackingNumber;
}

@property (nonatomic) NSInteger OrderNum;
@property (nonatomic, retain) NSString * ShipCompany;
@property (nonatomic, retain) NSString * TrackingNumber;

+ (BOOL) deleteWhere:(NSInteger)uid;
+ (void) deleteAllTrackingNumbers;

+ (id) fetch:(sqlite3_stmt *)dbStmt;

+ (NSMutableArray*) getAllTrackingNumbers;

+ (NSMutableArray*) getTrackingNumbersWhereOrder:(NSInteger)orderNum;
//+ (NSMutableArray*) getAddressesWhere:(NSString*)customerNum;

+ (NSInteger) insertInto:(TrackingNumber*) data;

+ (NSInteger) beginTrackingNumberInsert;
+ (NSInteger) endTrackingNumberInsert;

@end
