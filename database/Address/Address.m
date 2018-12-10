//
//  Address.m
//  wayne mobile
//
//  Created by Daniel Slabaugh on 10/25/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "Address.h"
#import "DBManager.h"

@implementation Address
@synthesize PKID;
@synthesize StoreID;
@synthesize CustNum;
@synthesize Name;
@synthesize Addr1;
@synthesize Addr2;
@synthesize City;
@synthesize State;
@synthesize Country;
@synthesize Zip;



+ (void) deleteAllAddresses {
    NSString *query = [NSString stringWithFormat:@"delete from %@", TBL_ADDRESS];
    
    sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    
    //    return rst;
}

+ (BOOL) deleteWhere:(NSInteger)uid {
    NSString *query = [NSString stringWithFormat:@"delete from %@ where %@ = %ld", TBL_ADDRESS, FLD_STOREID, (long)uid];
    
    BOOL rst = (sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL) == SQLITE_OK);
    
    return rst;
}

+ (id) fetch:(sqlite3_stmt *)dbStmt {
    NSInteger res = sqlite3_step(dbStmt);
	if (res != SQLITE_ROW)
		return nil;
    
    Address * model = [[Address alloc] init];
    
    model.PKID = sqlite3_column_int(dbStmt, 0);
    model.StoreID = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 1)];
    model.CustNum = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 2)];
    model.Name = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 3)];
    model.Addr1 = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 4)];
    model.Addr2 = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 5)];
    model.City = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 6)];
    model.State = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 7)];
    model.Country = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 8)];
    model.Zip = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 9)];

	return model;
}


+ (NSMutableArray*) getAllAddresses {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@", TBL_ADDRESS];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [Address fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [Address fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (Address*) getAddressWhereStore:(NSString *)store {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    //Check for 's
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)store != [NSNull null]) {
        store = [[store componentsSeparatedByCharactersInSet:charactersToRemove ]
                         componentsJoinedByString:@"''"];
    } else {
        store = @"";
    }
    
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", TBL_ADDRESS, FLD_STOREID, store];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
    {
        NSLog(@"ERROR ERROR ERROR");
        Address *tmpAddress = [list objectAtIndex:0];
        return tmpAddress;
    }
    id data = [Address fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [Address fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    Address *tmpAddress = [[Address alloc] init];
    
    if (list.count > 0 ) {
        tmpAddress = [list objectAtIndex:0];
    } else {
        tmpAddress.StoreID = @"Store Having Problem, please contact Wayne Carver";
    }
    
    
    return tmpAddress;
    
}

+ (NSMutableArray*) getAddressesWhere:(NSString *)custNum {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    //Check for 's
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)custNum != [NSNull null]) {
        custNum = [[custNum componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }
    
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", TBL_ADDRESS, FLD_CUSTNUM, custNum];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [Address fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [Address fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (NSInteger) insertInto:(Address*)data {
    
    //Check for 's
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)data.StoreID != [NSNull null]) {
        data.StoreID = [[data.StoreID componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.CustNum != [NSNull null]) {
        data.CustNum = [[data.CustNum componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Name != [NSNull null]) {
        data.Name = [[data.Name componentsSeparatedByCharactersInSet:charactersToRemove ]
                         componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Addr1 != [NSNull null]) {
        data.Addr1 = [[data.Addr1 componentsSeparatedByCharactersInSet:charactersToRemove ]
                      componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Addr2 != [NSNull null]) {
        data.Addr2 = [[data.Addr2 componentsSeparatedByCharactersInSet:charactersToRemove ]
                      componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.City != [NSNull null]) {
        data.City = [[data.City componentsSeparatedByCharactersInSet:charactersToRemove ]
                     componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.State != [NSNull null]) {
        data.State = [[data.State componentsSeparatedByCharactersInSet:charactersToRemove ]
                      componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Country != [NSNull null]) {
        data.Country = [[data.Country componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Zip != [NSNull null]) {
        data.Zip = [[data.Zip componentsSeparatedByCharactersInSet:charactersToRemove ]
                    componentsJoinedByString:@"''"];
    }
    
	NSString *query = [NSString stringWithFormat:@"insert into %@(%@, %@, %@, %@, %@, %@, %@, %@, %@) values('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                       TBL_ADDRESS,
                       FLD_STOREID,
                       FLD_CUSTNUM,
                       FLD_NAME,
                       FLD_AADDR1,
                       FLD_AADDR2,
                       FLD_CITY,
                       FLD_STATE,
                       FLD_COUNTRY,
                       FLD_AZIP,
                       data.StoreID,
                       data.CustNum,
                       data.Name,
                       data.Addr1,
                       data.Addr2,
                       data.City,
                       data.State,
                       data.Country,
                       data.Zip
                       ];
    
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        return (int)sqlite3_last_insert_rowid([DBManager sharedManager]);
    } else {
        NSLog(@"ERROR on Insert = %@\n result = %ld", query, (long)result);
    }
    return - result;
}

@end
