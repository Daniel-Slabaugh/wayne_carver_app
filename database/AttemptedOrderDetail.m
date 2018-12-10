//
//  AttemptedOrderDetail.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/24/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "AttemptedOrderDetail.h"
#import "DBManager.h"

@implementation AttemptedOrderDetail
@synthesize OrderNum;
@synthesize ItemNo;
@synthesize Nameset;
@synthesize ProgName;
@synthesize Name;
@synthesize NameType;
@synthesize QtyOrdered;



+ (void) deleteAllOrderDetails {
    NSString *query = [NSString stringWithFormat:@"delete from %@", TBL_ATTEMPTEDORDERLINE];
    
    sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
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
    
    AttemptedOrderDetail * model = [[AttemptedOrderDetail alloc] init];
    
    model.OrderNum = sqlite3_column_int(dbStmt, 0);
    model.ItemNo = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 1)];
    model.Nameset = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 2)];
    model.ProgName = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 3)];
    model.Name = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 4)];
    model.NameType = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 5)];
    model.QtyOrdered = sqlite3_column_int(dbStmt, 6);
    
	return model;
}

+ (NSMutableArray*) getAllOrderDetails {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@", TBL_ATTEMPTEDORDERLINE];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [AttemptedOrderDetail fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [AttemptedOrderDetail fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (NSMutableArray*) getOrderDetailsWhereOrder:(AttemptedOrderLine*)orderLine {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    //Check for 's
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)orderLine.ProgName != [NSNull null]) {
        orderLine.ProgName = [[orderLine.ProgName componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }
    if ((NSNull *)orderLine.ItemNo != [NSNull null]) {
        orderLine.ItemNo = [[orderLine.ItemNo componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }
    
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@ = %ld and %@ = '%@' and %@ = '%@'",
                        TBL_ATTEMPTEDORDERLINE,
                        FLD_ORDERNUM,
                        (long)orderLine.OrderNum,
                        FLD_DITEMNO,
                        orderLine.ItemNo,
                        FLD_PROGNAME,
                        orderLine.ProgName];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [AttemptedOrderDetail fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [AttemptedOrderDetail fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (NSMutableArray*) getOrderDetailsWhereOrderNumber:(NSInteger)orderNum {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@ = %ld", TBL_ATTEMPTEDORDERLINE, FLD_ORDERNUM, (long)orderNum];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [AttemptedOrderDetail fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [AttemptedOrderDetail fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (NSInteger) beginOrderDetailInsert {
    NSString *query = [NSString stringWithFormat:@"BEGIN TRANSACTION"];
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        return (int)sqlite3_last_insert_rowid([DBManager sharedManager]);
    } else {
        NSLog(@"ERROR on query: = %@\n result: = %ld", query, (long)result);
    }
    return - result;
}

+ (NSInteger) endOrderDetailInsert {
    NSString *query = [NSString stringWithFormat:@"COMMIT"];
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        return (int)sqlite3_last_insert_rowid([DBManager sharedManager]);
    } else {
        NSLog(@"ERROR on query: = %@\n result: = %ld", query, (long)result);
    }
    return - result;
}




+ (NSInteger) updateOrderDetail:(AttemptedOrderDetail *)data {
    
    //Check for 's
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)data.Name != [NSNull null]) {
        data.Name = [[data.Name componentsSeparatedByCharactersInSet:charactersToRemove ]
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
    if ((NSNull *)data.Name != [NSNull null]) {
        data.ProgName = [[data.ProgName componentsSeparatedByCharactersInSet:charactersToRemove ]
                     componentsJoinedByString:@"''"];
    }
    
	NSString *query = [NSString stringWithFormat:@"update %@ set %@ = %ld where %@ = %ld and %@ = '%@' and %@ = '%@' and %@ = '%@' and %@ = '%@'",
                       TBL_ATTEMPTEDORDERLINE,
                       FLD_QTYORDERED,
                       (long)data.QtyOrdered,
                       FLD_ORDERNUM,
                       (long)data.OrderNum,
                       FLD_DITEMNO,
                       data.ItemNo,
                       FLD_NAMESET,
                       data.Nameset,
                       FLD_PROGNAME,
                       data.ProgName,
                       FLD_NAME,
                       data.Name
                       ];
    
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        return (int)sqlite3_last_insert_rowid([DBManager sharedManager]);
    }
    return - result;
}





+ (NSInteger) insertInto:(AttemptedOrderDetail*)data {
    //Check for 's
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)data.Name != [NSNull null]) {
        data.Name = [[data.Name componentsSeparatedByCharactersInSet:charactersToRemove ]
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
    if ((NSNull *)data.Name != [NSNull null]) {
        data.ProgName = [[data.ProgName componentsSeparatedByCharactersInSet:charactersToRemove ]
                         componentsJoinedByString:@"''"];
    }
    
	NSString *query = [NSString stringWithFormat:@"insert into %@(%@, %@, %@, %@, %@, %@, %@) values(%ld, '%@', '%@', '%@', '%@', '%@', %ld)",
                       TBL_ATTEMPTEDORDERLINE,
                       FLD_ORDERNUM,
                       FLD_DITEMNO, 
                       FLD_NAMESET,
                       FLD_PROGNAME,
                       FLD_NAME,
                       FLD_NAMETYPE,
                       FLD_QTYORDERED,
                       (long)data.OrderNum,
                       data.ItemNo,
                       data.Nameset,
                       data.ProgName,
                       data.Name,
                       data.NameType,
                       (long)data.QtyOrdered
                       ];
    
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        return (int)sqlite3_last_insert_rowid([DBManager sharedManager]);
    } else {
        NSLog(@"ERROR on query: = %@\n result: = %ld", query, (long)result);
    }
    return - result;
}

@end
