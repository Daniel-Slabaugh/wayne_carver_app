//
//  Store.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/15/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "Store.h"
#import "DBManager.h"

@implementation Store
@synthesize ID;
@synthesize StoreID;
@synthesize CustomerNum;



- (void) dealloc {
    [ID release];
    [StoreID release];
    [CustomerNum release];
    [super dealloc];
}

+ (void) deleteAllStores {
    NSString *query = [NSString stringWithFormat:@"delete from %@", TBL_STORE];
    
    sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    
    //    return rst;
}

+ (BOOL) deleteWhere:(NSInteger)uid {
    NSString *query = [NSString stringWithFormat:@"delete from %@ where %@ = %d", TBL_STORE, FLD_ID, uid];
    
    BOOL rst = (sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL) == SQLITE_OK);
    
    return rst;
}







+ (id) fetch:(sqlite3_stmt *)dbStmt {
    NSInteger res = sqlite3_step(dbStmt);
	if (res != SQLITE_ROW)
		return nil;
    
    Store * model = [[[Store alloc] init] autorelease];
    
    model.ID = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 0)];
    model.StoreID = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 1)];
    model.CustomerNum = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 2)];
    
	return model;
}


+ (NSMutableArray*) getAllStores {
    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@", TBL_STORE];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [Store fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [Store fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (NSMutableArray*) getStoresWhere:(NSString *)customerNum {
    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", TBL_STORE, FLD_CUSTOMERNUM, customerNum];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [Store fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [Store fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (NSInteger) insertInto:(Store*)data {
    // come back to
    if ((NSNull *)data.StoreID != [NSNull null]) {
        NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
        data.StoreID = [[data.StoreID componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }
    
    
	NSString *query = [NSString stringWithFormat:@"insert into %@(%@, %@, %@) values('%@', '%@', '%@')",
                       TBL_STORE,
                       FLD_ID,
                       FLD_STOREID,
                       FLD_CUSTOMERNUM,
                       data.ID,
                       data.StoreID,
                       data.CustomerNum
                       ];
    
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        return sqlite3_last_insert_rowid([DBManager sharedManager]);
    } else {
        NSLog(@"ERROR on Insert = %@\n result = %d", query, result);
    }
    return - result;
}

@end
