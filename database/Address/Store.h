//
//  Address.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/15/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define  TBL_STORE          @"Stores"
#define  FLD_ID             @"ID"
#define  FLD_STOREID        @"StoreID"
#define  FLD_CUSTOMERNUM    @"CustomerNum"

@interface Store : NSObject
{
    NSString * ID;
    NSString * StoreID;
}

@property (nonatomic, retain) NSString * ID;
@property (nonatomic, retain) NSString * StoreID;
@property (nonatomic, retain) NSString * CustomerNum;


+ (BOOL) deleteWhere:(NSInteger)uid;
+ (void) deleteAllStores;

+ (id) fetch:(sqlite3_stmt *)dbStmt;

+ (NSMutableArray*) getAllStores;

+ (NSMutableArray*) getStoresWhere:(NSString*)customerNum;

+ (NSInteger) insertInto:(Store*) data;


@end
