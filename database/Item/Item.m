//
//  Item.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/16/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "Item.h"
#import "DBManager.h"

@implementation Item
@synthesize CustNum;
@synthesize ProgName;
@synthesize ItemNo;
@synthesize Nameset;
@synthesize MAD;
@synthesize Description;



+ (void) deleteAllItems {
    NSString *query = [NSString stringWithFormat:@"delete from %@", TBL_ITEM];
    
    sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    
    //    return rst;
}

+ (BOOL) deleteWhere:(NSInteger)uid {
    NSString *query = [NSString stringWithFormat:@"delete from %@ where %@ = %ld", TBL_ITEM, FLD_CUSTNUM, (long)uid];
    
    BOOL rst = (sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL) == SQLITE_OK);
    
    return rst;
}

+ (id) fetch:(sqlite3_stmt *)dbStmt {
    NSInteger res = sqlite3_step(dbStmt);
	if (res != SQLITE_ROW)
		return nil;
    
    Item * model = [[Item alloc] init];
    
    model.CustNum = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 0)];
    model.ProgName = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 1)];
    model.ItemNo = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 2)];
    model.Nameset = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 3)];
    model.MAD = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 4)];
    model.Description = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 5)];
	return model;
}

+ (NSString*) getItemDesc:(NSString *)ItemNo {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    NSString *desc = @"";
    
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", TBL_ITEM, FLD_ITEMNO, ItemNo];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return desc;
    
    id data = [Item fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [Item fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    Item *item = [list objectAtIndex:0];
    
    return item.Description;
}

+ (NSMutableArray*) getItemsWhere:(NSString *)custNum {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)custNum != [NSNull null]) {
        custNum = [[custNum componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }
    
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", TBL_ITEM, FLD_CUSTNUM, custNum];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [Item fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [Item fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (NSMutableArray*) getAllItems {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@", TBL_ITEM];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [Item fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [Item fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (NSInteger) insertInto:(Item *)data {
    
    //Check for 's
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)data.CustNum != [NSNull null]) {
        data.CustNum = [[data.CustNum componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.ProgName != [NSNull null]) {
        data.ProgName = [[data.ProgName componentsSeparatedByCharactersInSet:charactersToRemove ]
                         componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.ItemNo != [NSNull null]) {
        data.ItemNo = [[data.ItemNo componentsSeparatedByCharactersInSet:charactersToRemove ]
                       componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Nameset != [NSNull null]) {
        data.Nameset = [[data.Nameset componentsSeparatedByCharactersInSet:charactersToRemove ]
                       componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Description != [NSNull null]) {
        data.Description = [[data.Description componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.MAD != [NSNull null]) {
        data.MAD = [[data.MAD componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }    
    
	NSString *query = [NSString stringWithFormat:@"insert into %@(%@, %@, %@, %@, %@, %@) values('%@', '%@', '%@', '%@', '%@', '%@')",
                       TBL_ITEM,
                       FLD_CUSTNUM,
                       FLD_PROGNAME,
                       FLD_ITEMNO,
                       FLD_NAMESET,
                       FLD_MAD,
                       FLD_DESC,
                       data.CustNum,
                       data.ProgName,
                       data.ItemNo,
                       data.Nameset,
                       data.MAD,
                       data.Description
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
