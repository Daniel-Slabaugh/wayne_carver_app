//
//  Name.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/16/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "Name.h"
#import "DBManager.h"

@implementation Name
@synthesize Nameset;
@synthesize TheName;
@synthesize NameType;
@synthesize NumOfPegs;





+ (void) deleteAllNames {
    NSString *query = [NSString stringWithFormat:@"delete from %@", TBL_NAME];
    
    sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    
    //    return rst;
}

+ (BOOL) deleteWhere:(NSInteger)uid {
    NSString *query = [NSString stringWithFormat:@"delete from %@ where %@ = %ld", TBL_NAME, FLD_NAMESET, (long)uid];
    
    BOOL rst = (sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL) == SQLITE_OK);
    
    return rst;
}







+ (id) fetch:(sqlite3_stmt *)dbStmt {
    NSInteger res = sqlite3_step(dbStmt);
	if (res != SQLITE_ROW)
		return nil;
    
    Name * model = [[Name alloc] init];
    
    model.Nameset = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 0)];
    model.TheName = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 1)];
    model.NameType = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 2)];
    model.NumOfPegs = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 3)];
	return model;
}


+ (NSMutableArray*) getAllNames {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@", TBL_NAME];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [Name fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [Name fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}


+ (NSMutableArray*)getNamesWhere:(NSString*)nameSet {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    //Check for 's
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)nameSet != [NSNull null]) {
        nameSet = [[nameSet componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }
    
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", TBL_NAME, FLD_NAMESET, nameSet];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [Name fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [Name fetch:stmt];
    }
    sqlite3_finalize(stmt);

    return list;
}

+ (NSInteger) beginNameInsert {
    NSString *query = [NSString stringWithFormat:@"BEGIN TRANSACTION"];
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        return (int)sqlite3_last_insert_rowid([DBManager sharedManager]);
    } else {
        NSLog(@"ERROR on query: = %@\n result: = %ld", query, (long)result);
    }
    return - result;
}

+ (NSInteger) endNameInsert {
    NSString *query = [NSString stringWithFormat:@"COMMIT"];
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        return (int)sqlite3_last_insert_rowid([DBManager sharedManager]);
    } else {
        NSLog(@"ERROR on query: = %@\n result: = %ld", query, (long)result);
    }
    return - result;
}

+ (NSInteger) insertInto:(Name *)data {
    
    //Check for 's
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)data.TheName != [NSNull null]) {
        data.TheName = [[data.TheName componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Nameset != [NSNull null]) {
        data.Nameset = [[data.Nameset componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.NameType != [NSNull null]) {
        data.NameType = [[data.NameType componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }
    
    
	NSString *query = [NSString stringWithFormat:@"insert into %@(%@, %@, %@, %@) values('%@', '%@', '%@', '%@')",
                       TBL_NAME,
                       FLD_NAMESET,
                       FLD_NAME,
                       FLD_NAMETYPE,
                       FLD_NUMOFPEGS,
                       data.Nameset,
                       data.TheName,
                       data.NameType,
                       data.NumOfPegs
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
