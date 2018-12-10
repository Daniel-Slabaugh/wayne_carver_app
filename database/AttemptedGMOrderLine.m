//
//  AttemptedGMOrderLine.m
//  wayne mobile
//
//  Created by Delphi Dev Computer on 7/3/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import "AttemptedGMOrderLine.h"
#import "DBManager.h"

@implementation AttemptedGMOrderLine
@synthesize PKID;
@synthesize OrderNum;
@synthesize ItemNum;
@synthesize Quantity;
@synthesize BadItems;
@synthesize Price;
@synthesize ArtNum;
@synthesize NameDrop;
@synthesize PDFPrice;


+ (void) deleteAllOrderLines {
    NSString *query = [NSString stringWithFormat:@"delete from %@", TBL_ATTEMPTEDGMORDERLINE];
    
    sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
}

+ (BOOL) deleteWhereLine:(NSInteger)PKID {
    NSString *query = [NSString stringWithFormat:@"delete from %@ where (%@ = %ld)", TBL_ATTEMPTEDGMORDERLINE, FLD_PKID, (long)PKID];
    
    BOOL rst = (sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL) == SQLITE_OK);
    
    return rst;
}


+ (BOOL) deleteWhere:(NSInteger)uid {
    NSString *query = [NSString stringWithFormat:@"delete from %@ where %@ = %ld", TBL_ATTEMPTEDGMORDERLINE, FLD_ORDERNUM, (long)uid];
    
    BOOL rst = (sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL) == SQLITE_OK);
    
    return rst;
}

+ (id) fetch:(sqlite3_stmt *)dbStmt {
    NSInteger res = sqlite3_step(dbStmt);
    if (res != SQLITE_ROW)
        return nil;
    
    AttemptedGMOrderLine * model = [[AttemptedGMOrderLine alloc] init];
    
    model.PKID = sqlite3_column_int(dbStmt, 0);
    model.OrderNum = sqlite3_column_int(dbStmt, 1);
    model.ItemNum = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 2)];
    model.Quantity = sqlite3_column_int(dbStmt, 3);
    model.BadItems = sqlite3_column_int(dbStmt, 4);
    model.Price = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 5)];
    model.ArtNum = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 6)];
    model.NameDrop = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 7)];
    model.PDFPrice = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 8)];

    return model;
}

+ (NSMutableArray*) getAllOrderLines {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@", TBL_ATTEMPTEDGMORDERLINE];
    
    char *sql = (char *)[query UTF8String];
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [AttemptedGMOrderLine fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [AttemptedGMOrderLine fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (NSMutableArray*) getOrderLinesWhere:(NSInteger)OrderNum {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@ = %ld", TBL_ATTEMPTEDGMORDERLINE, FLD_ORDERNUM, (long)OrderNum];
    
    char *sql = (char *)[query UTF8String];
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [AttemptedGMOrderLine fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [AttemptedGMOrderLine fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (NSInteger) updateOrderLine:(AttemptedGMOrderLine *)data {
    
    //Check for 's
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    
    if ((NSNull *)data.ArtNum != [NSNull null]) {
        data.ArtNum = [[data.ArtNum componentsSeparatedByCharactersInSet:charactersToRemove]
                         componentsJoinedByString:@"''"];
    }
    
    if ((NSNull *)data.NameDrop != [NSNull null]) {
        data.NameDrop = [[data.NameDrop componentsSeparatedByCharactersInSet:charactersToRemove]
                       componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.ItemNum != [NSNull null]) {
        data.ItemNum = [[data.ItemNum componentsSeparatedByCharactersInSet:charactersToRemove]
                         componentsJoinedByString:@"''"];
    }

    NSString *query = [NSString stringWithFormat:@"update %@ set %@ = '%@', %@ = %ld, %@ = %ld, %@ = %@, %@ = '%@', %@ = '%@', %@ = '%@' where %@ = %ld",
                       TBL_ATTEMPTEDGMORDERLINE,
                       FLD_LITEMNUM,
                       data.ItemNum,
                       FLD_QUANTITY,
                       (long)data.Quantity,
                       FLD_BADITEMS,
                       (long)data.BadItems,
                       FLD_PRICE,
                       data.Price,
                       FLD_ARTNUM,
                       data.ArtNum,
                       FLD_NAMEDROP,
                       data.NameDrop,
                       FLD_PDFPRICE,
                       data.PDFPrice,
                       FLD_PKID,
                       (long)data.PKID
                       ];
    
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        return (int)sqlite3_last_insert_rowid([DBManager sharedManager]);
    } else {
        NSLog(@"ERROR SQL RESULT = %ld", (long)result);
    }
    return - result;
}

+ (NSInteger) insertInto:(AttemptedGMOrderLine*)data {
    
    //Check for 's
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    
    if ((NSNull *)data.ArtNum != [NSNull null]) {
        data.ArtNum = [[data.ArtNum componentsSeparatedByCharactersInSet:charactersToRemove]
                       componentsJoinedByString:@"''"];
    }
    
    if ((NSNull *)data.NameDrop != [NSNull null]) {
        data.NameDrop = [[data.NameDrop componentsSeparatedByCharactersInSet:charactersToRemove]
                         componentsJoinedByString:@"''"];
    }
    
    NSString *query = [NSString stringWithFormat:@"insert into %@(%@, %@, %@, %@, %@, %@, %@, %@) values(%ld, '%@', %ld, %ld, '%@', '%@', '%@', '%@')",
                       TBL_ATTEMPTEDGMORDERLINE,
                       FLD_ORDERNUM,
                       FLD_LITEMNUM,
                       FLD_QUANTITY,
                       FLD_BADITEMS,
                       FLD_PRICE,
                       FLD_ARTNUM,
                       FLD_NAMEDROP,
                       FLD_PDFPRICE,
                       (long)data.OrderNum,
                       data.ItemNum,
                       (long)data.Quantity,
                       (long)data.BadItems,
                       data.Price,
                       data.ArtNum,
                       data.NameDrop,
                       data.PDFPrice
                       ];
    
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        return (int)sqlite3_last_insert_rowid([DBManager sharedManager]);
    } else {
        NSLog(@"ERROR ERROR HELP");
    }
    return - result;
}

@end
