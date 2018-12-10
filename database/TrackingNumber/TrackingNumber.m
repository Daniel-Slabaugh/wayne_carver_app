//
//  TrackingNumber.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 6/9/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import "TrackingNumber.h"
#import "DBManager.h"

@implementation TrackingNumber
@synthesize OrderNum;
@synthesize ShipCompany;
@synthesize TrackingNumber;



+ (void) deleteAllTrackingNumbers {
    NSString *query = [NSString stringWithFormat:@"delete from %@", TBL_TRACKINGNUMBER];
    
    sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    
    //    return rst;
}

+ (BOOL) deleteWhere:(NSInteger)uid {
    NSString *query = [NSString stringWithFormat:@"delete from %@ where %@ = %ld", TBL_TRACKINGNUMBER, FLD_ORDERNUM, (long)uid];
    
    BOOL rst = (sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL) == SQLITE_OK);
    
    return rst;
}

+ (id) fetch:(sqlite3_stmt *)dbStmt {
    NSInteger res = sqlite3_step(dbStmt);
	if (res != SQLITE_ROW)
		return nil;
    
    TrackingNumber * model = [[TrackingNumber alloc] init];
    
    model.OrderNum = sqlite3_column_int(dbStmt, 0);
    model.ShipCompany = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 1)];
    model.TrackingNumber = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 2)];
    
	return model;
}


+ (NSMutableArray*) getAllTrackingNumbers {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@", TBL_TRACKINGNUMBER];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [TrackingNumber fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [TrackingNumber fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (NSMutableArray*) getTrackingNumbersWhereOrder:(NSInteger)orderNum {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@ = '%ld'", TBL_TRACKINGNUMBER, FLD_ORDERNUM, (long)orderNum];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [TrackingNumber fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [TrackingNumber fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (NSInteger) insertInto:(TrackingNumber*)data {
    
    //Check for 's
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)data.ShipCompany != [NSNull null]) {
        data.ShipCompany = [[data.ShipCompany componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.TrackingNumber != [NSNull null]) {
        data.TrackingNumber = [[data.TrackingNumber componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }
    
	NSString *query = [NSString stringWithFormat:@"insert into %@(%@, %@, %@) values(%ld, '%@', '%@')",
                       TBL_TRACKINGNUMBER,
                       FLD_ORDERNUM,
                       FLD_SHIPCOMPANY,
                       FLD_TRACKINGNUMBER,
                       (long)data.OrderNum,
                       data.ShipCompany,
                       data.TrackingNumber
                       ];
    
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        return (int)sqlite3_last_insert_rowid([DBManager sharedManager]);
    } else {
        NSLog(@"ERROR on Insert = %@\n result = %ld", query, (long)result);
    }
    return - result;
}

+ (NSInteger) beginTrackingNumberInsert {
    NSString *query = [NSString stringWithFormat:@"BEGIN TRANSACTION"];
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        return (int)sqlite3_last_insert_rowid([DBManager sharedManager]);
    } else {
        NSLog(@"ERROR on query: = %@\n result: = %ld", query, (long)result);
    }
    return - result;
}

+ (NSInteger) endTrackingNumberInsert {
    NSString *query = [NSString stringWithFormat:@"COMMIT"];
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        return (int)sqlite3_last_insert_rowid([DBManager sharedManager]);
    } else {
        NSLog(@"ERROR on query: = %@\n result: = %ld", query, (long)result);
    }
    return - result;
}

@end
