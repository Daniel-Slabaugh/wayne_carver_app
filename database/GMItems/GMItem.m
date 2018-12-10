//
//  GMItems.m
//  wayne mobile
//
//  Created by Delphi Dev Computer on 7/9/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import "GMItem.h"
#import "DBManager.h"

@implementation GMItem
@synthesize PKID;
@synthesize ItemNum;
@synthesize ItemDescription;
@synthesize PriceSmallQ;
@synthesize PriceMedQ;
@synthesize PriceLargeQ;
@synthesize Minimum;
@synthesize Increment;
@synthesize NameDropOnly;




+ (void) deleteAllItems {
    NSString *query = [NSString stringWithFormat:@"delete from %@", TBL_GMITEM];
    
    sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    
    //    return rst;
}

+ (BOOL) deleteWhere:(NSInteger)uid {
    NSString *query = [NSString stringWithFormat:@"delete from %@ where %@ = %ld", TBL_GMITEM, FLD_ITEMNUM, (long)uid];
    
    BOOL rst = (sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL) == SQLITE_OK);
    
    return rst;
}

+ (id) fetch:(sqlite3_stmt *)dbStmt {
    NSInteger res = sqlite3_step(dbStmt);
    if (res != SQLITE_ROW)
        return nil;
    
    GMItem * model = [[GMItem alloc] init];
    
    model.PKID = sqlite3_column_int(dbStmt, 0);
    model.ItemNum = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 1)];
    model.ItemDescription = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 2)];
    model.PriceSmallQ = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 3)];
    model.PriceMedQ = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 4)];
    model.PriceLargeQ = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 5)];
    model.Minimum = sqlite3_column_int(dbStmt,6);
    model.Increment = sqlite3_column_int(dbStmt, 7);
    model.NameDropOnly = sqlite3_column_int(dbStmt, 8);

    return model;
}

+ (NSString*) getItemDesc:(NSString *)ItemNum {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    NSString *desc = @"";
    
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", TBL_GMITEM, FLD_ITEMNUM, ItemNum];
    
    char *sql = (char *)[query UTF8String];
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return desc;
    
    id data = [GMItem fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [GMItem fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    GMItem *gmItem = [list objectAtIndex:0];
    
    return gmItem.ItemDescription;
}

+ (GMItem*) getItemWhere:(NSString *)itemNum {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", TBL_GMITEM, FLD_ITEMNUM, itemNum];
    
    char *sql = (char *)[query UTF8String];
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK) {
        NSLog(@"ERROR ERROR ERROR ERROR");
        GMItem *gmItem = [[GMItem alloc] init];
    
        return gmItem;
    }
    
    id data = [GMItem fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [GMItem fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    GMItem *gmItem1 = [list objectAtIndex:0];

    return gmItem1;
}

+ (NSMutableArray*) getAllItems {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@", TBL_GMITEM];
    
    char *sql = (char *)[query UTF8String];
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [GMItem fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [GMItem fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (NSInteger) insertInto:(GMItem *)data {
    
    //Check for 's
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)data.ItemDescription != [NSNull null]) {
        data.ItemDescription = [[data.ItemDescription componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }
    
    NSString *query = [NSString stringWithFormat:@"insert into %@(%@, %@, %@, %@, %@, %@, %@, %@) values('%@', '%@', '%@', '%@', '%@', %ld, %ld, %ld)",
                       TBL_GMITEM,
                       FLD_ITEMNUM,
                       FLD_ITEMDESCRIPTION,
                       FLD_PRICESMALLQ,
                       FLD_PRICEMEDQ,
                       FLD_PRICELARGEQ,
                       FLD_MINIMUM,
                       FLD_INCREMEMT,
                       FLD_NAMEDROPONLY,
                       data.ItemNum,
                       data.ItemDescription,
                       data.PriceSmallQ,
                       data.PriceMedQ,
                       data.PriceLargeQ,
                       (long)data.Minimum,
                       (long)data.Increment,
                       (long)data.NameDropOnly
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
