//
//  AttemptedOrderLine.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/24/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "AttemptedOrderLine.h"
#import "DBManager.h"

@implementation AttemptedOrderLine
@synthesize OrderNum;
@synthesize ItemNo;
@synthesize Nameset;
@synthesize Quantity;
@synthesize BadItems;
@synthesize PDFPrice;
@synthesize ProgName;



+ (void) deleteAllOrderLines {
    NSString *query = [NSString stringWithFormat:@"delete from %@", TBL_ATTEMPTEDORDERLINE];
    
    sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
}

+ (BOOL) deleteWhere:(NSInteger)ordNum Item:(NSString*)item {
    NSString *query = [NSString stringWithFormat:@"delete from %@ where (%@ = %ld and %@ = '%@')", TBL_ATTEMPTEDORDERLINE, FLD_ORDERNUM, (long)ordNum, FLD_LITEMNO, item];
    
    BOOL rst = (sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL) == SQLITE_OK);
    
    return rst;
}


+ (BOOL) deleteWhere:(NSInteger)uid {
    NSString *query = [NSString stringWithFormat:@"delete from %@ where %@ = %ld", TBL_ATTEMPTEDORDERLINE, FLD_ORDERNUM, (long)uid];
    
    BOOL rst = (sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL) == SQLITE_OK);
    
    return rst;
}

+ (id) fetch:(sqlite3_stmt *)dbStmt {
    NSInteger res = sqlite3_step(dbStmt);
	if (res != SQLITE_ROW)
		return nil;
    
    AttemptedOrderLine * model = [[AttemptedOrderLine alloc] init];
    
    model.OrderNum = sqlite3_column_int(dbStmt, 0);
    model.ItemNo = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 1)];
    model.Nameset = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 2)];
    model.Quantity = sqlite3_column_int(dbStmt, 3);
    model.BadItems = sqlite3_column_int(dbStmt, 4);
    model.PDFPrice = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 5)];
    model.ProgName = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 6)];


	return model;
}

+ (NSMutableArray*) getAllOrderLines {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@", TBL_ATTEMPTEDORDERLINE];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [AttemptedOrderLine fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [AttemptedOrderLine fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (NSMutableArray*) getOrderLinesWhere:(NSInteger)OrderNum {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@ = %ld", TBL_ATTEMPTEDORDERLINE, FLD_ORDERNUM, (long)OrderNum];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [AttemptedOrderLine fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [AttemptedOrderLine fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (NSInteger) updateOrderLine:(AttemptedOrderLine *)data {
    
    //Check for 's
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)data.ProgName != [NSNull null]) {
        data.ProgName = [[data.ProgName componentsSeparatedByCharactersInSet:charactersToRemove]
                        componentsJoinedByString:@"''"];
    }

	NSString *query = [NSString stringWithFormat:@"update %@ set %@ = %ld, %@ = %ld, %@ = %@ where %@ = %ld and %@ = '%@' and %@ = '%@'",
                       TBL_ATTEMPTEDORDERLINE,
                       FLD_QUANTITY,
                       (long)data.Quantity,
                       FLD_BADITEMS,
                       (long)data.BadItems,
                       FLD_PDFPRICE,
                       data.PDFPrice,
                       FLD_ORDERNUM,
                       (long)data.OrderNum,
                       FLD_LITEMNO,
                       data.ItemNo,
                       FLD_PROGNAME,
                       data.ProgName
                       ];
    
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        return sqlite3_last_insert_rowid([DBManager sharedManager]);
    }
    return - result;
}

+ (NSInteger) insertInto:(AttemptedOrderLine*)data {
    
    //Check for 's
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)data.ProgName != [NSNull null]) {
        data.ProgName = [[data.ProgName componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }

	NSString *query = [NSString stringWithFormat:@"insert into %@(%@, %@, %@, %@, %@, %@, %@) values(%ld, '%@', '%@', %ld, %ld, '%@', '%@')",
                       TBL_ATTEMPTEDORDERLINE,
                       FLD_ORDERNUM,
                       FLD_LITEMNO,
                       FLD_NAMESET,
                       FLD_QUANTITY,
                       FLD_BADITEMS,
                       FLD_PDFPRICE,
                       FLD_PROGNAME,
                       (long)data.OrderNum,
                       data.ItemNo,
                       data.Nameset,
                       (long)data.Quantity,
                       (long)data.BadItems,
                       data.PDFPrice,
                       data.ProgName
                       ];
    
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        return sqlite3_last_insert_rowid([DBManager sharedManager]);
    } else {
        NSLog(@"ERROR ERROR ERROR");
    }
    return - result;
}

@end