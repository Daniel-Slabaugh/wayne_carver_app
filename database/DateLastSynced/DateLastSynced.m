//
//  DateLastSynced.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/9/15.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import "DBManager.h"
#import "DateLastSynced.h"

@implementation DateLastSynced
@synthesize EntryNum;
@synthesize DateSynced;



+ (void) deleteAllDatesLastSynced {
    NSString *query = [NSString stringWithFormat:@"delete from %@", TBL_DATELASTSYNCED];
    
    sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    
    //    return rst;
}



+ (id) fetch:(sqlite3_stmt *)dbStmt {
    NSInteger res = sqlite3_step(dbStmt);
	if (res != SQLITE_ROW)
		return nil;
    
    DateLastSynced * model = [[DateLastSynced alloc] init];
    
    model.EntryNum = sqlite3_column_int(dbStmt, 0);
    model.DateSynced = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 1)];
    
	return model;
}


+ (NSMutableArray*) getAllDatesLastSynced {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@", TBL_DATELASTSYNCED];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [DateLastSynced fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [DateLastSynced fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (DateLastSynced*) getLastDateLastSynced {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select MAX(%@) from %@", FLD_ENTRYNUM, TBL_DATELASTSYNCED];
    
    char *sql = (char *)[query UTF8String];
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK) {
        NSLog(@"didn't work");
        DateLastSynced *badLstSnd = [list objectAtIndex:0];
        return badLstSnd;
    }
    
    id data = [DateLastSynced fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [DateLastSynced fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    DateLastSynced *tmpLstSnd = [list objectAtIndex:0];
    
    return tmpLstSnd;
}


+ (NSInteger) insertInto:(DateLastSynced*)data {
    
	NSString *query = [NSString stringWithFormat:@"insert into %@(%@) values('%@')",
                       TBL_DATELASTSYNCED,
                       FLD_DATELASTSYNCED,
                       data.DateSynced
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
