//
//  WayneOrderLine.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 8/7/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "WayneOrderLine.h"
#import "DBManager.h"

@implementation WayneOrderLine
@synthesize OrderNum;
@synthesize QtyOrdered;
@synthesize QtyShipped;
@synthesize QtyBackordered;
@synthesize ItemNo;
@synthesize ItemDesc;
@synthesize PricePerPiece;
@synthesize LineTotal;


+ (void) deleteAllOrderLines {
    NSString *query = [NSString stringWithFormat:@"delete from %@", TBL_WAYNEORDERLINE];
    
    sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
}

+ (BOOL) deleteWhereOrderNum:(NSInteger)orderNum {
    NSString *query = [NSString stringWithFormat:@"delete from %@ where %@ = %ld", TBL_WAYNEORDERLINE, FLD_WORDERNUM, (long)orderNum];
    
    BOOL rst = (sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL) == SQLITE_OK);
    
    return rst;
}

+ (id) fetch:(sqlite3_stmt *)dbStmt {
    NSInteger res = sqlite3_step(dbStmt);
	if (res != SQLITE_ROW)
		return nil;
    
    WayneOrderLine * model = [[WayneOrderLine alloc] init];

    model.OrderNum = sqlite3_column_int(dbStmt, 0);
    model.QtyOrdered = sqlite3_column_int(dbStmt, 1);
    model.QtyShipped = sqlite3_column_int(dbStmt, 2);
    model.QtyBackordered = sqlite3_column_int(dbStmt, 3);
    model.ItemNo = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 4)];
    model.ItemDesc = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 5)];
    model.PricePerPiece = sqlite3_column_double(dbStmt, 6);
    model.LineTotal = sqlite3_column_double(dbStmt, 7);
    
    
	return model;
}

+ (NSMutableArray*) getAllOrderLines {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@", TBL_WAYNEORDERLINE];
        
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [WayneOrderLine fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [WayneOrderLine fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (NSMutableArray*) getOrderLinesWhere:(NSInteger)OrderNum {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@ = %ld", TBL_WAYNEORDERLINE, FLD_WORDERNUM, (long)OrderNum];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [WayneOrderLine fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [WayneOrderLine fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (NSInteger) insertInto:(WayneOrderLine*)data {
    
    //Check for 's
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)data.ItemNo != [NSNull null]) {
        data.ItemNo = [[data.ItemNo componentsSeparatedByCharactersInSet:charactersToRemove ]
                       componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.ItemDesc != [NSNull null]) {
        data.ItemDesc = [[data.ItemDesc componentsSeparatedByCharactersInSet:charactersToRemove ]
                         componentsJoinedByString:@"''"];
    }
    
    
	NSString *query = [NSString stringWithFormat:@"insert into %@(%@, %@, %@, %@, %@, %@, %@, %@) values(%ld, %ld, %ld, %ld, '%@', '%@', %f, %f)",
                       TBL_WAYNEORDERLINE,
                       FLD_WORDERNUM,
                       FLD_QTYORDERED,
                       FLD_QTYSHIPPED,
                       FLD_QTYBACKORDERED,
                       FLD_WITEMNO,
                       FLD_ITEMDESC,
                       FLD_PRICEPERPIECE,
                       FLD_LINETOTAL,
                       (long)data.OrderNum,
                       (long)data.QtyOrdered,
                       (long)data.QtyShipped,
                       (long)data.QtyBackordered,
                       data.ItemNo,
                       data.ItemDesc,
                       data.PricePerPiece,
                       data.LineTotal
                       ];
    
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        return (int)sqlite3_last_insert_rowid([DBManager sharedManager]);
    } else {
        NSLog(@"ERROR Insert = %@\n result = %ld", query, (long)result);
    }
    return - result;
}

+ (NSInteger) beginInsert {
    NSString *query = [NSString stringWithFormat:@"BEGIN TRANSACTION"];
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        return (int)sqlite3_last_insert_rowid([DBManager sharedManager]);
    } else {
        NSLog(@"ERROR on query: = %@\n result: = %ld", query, (long)result);
    }
    return - result;
}

+ (NSInteger) endInsert {
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

