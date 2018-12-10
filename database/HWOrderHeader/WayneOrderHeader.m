//
//  WayneOrderHeader.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 8/6/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "WayneOrderHeader.h"
#import "DBManager.h"

@implementation WayneOrderHeader
@synthesize CustNum;
@synthesize PONum;
@synthesize OrderNum;
@synthesize UserID;
@synthesize HeartwoodStatus;
@synthesize Terms;
@synthesize ShipMethod;
@synthesize CustName;
@synthesize ProcessedBy;
@synthesize DateReceived;
@synthesize DateAccepted;
@synthesize SAPShipDate;
@synthesize BillName;
@synthesize BillADDR1;
@synthesize BillADDR2;
@synthesize BillCity;
@synthesize BillState;
@synthesize BillZip;
@synthesize StoreName;
@synthesize StoreADDR1;
@synthesize StoreADDR2;
@synthesize StoreCity;
@synthesize StoreState;
@synthesize StoreZip;
@synthesize TotalAmt;
@synthesize Status;
@synthesize RepActionReq;
@synthesize ActionMsg;
@synthesize StatusDate;
@synthesize PDFType;




+ (void) deleteAllOrderHeaders {
    NSString *query = [NSString stringWithFormat:@"delete from %@", TBL_WAYNEORDERHEADER];
    
    sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
}

+ (BOOL) deleteWhere:(NSInteger)uid {
    NSString *query = [NSString stringWithFormat:@"delete from %@ where %@ = %ld", TBL_WAYNEORDERHEADER, FLD_ORDERNUM, (long)uid];
    
    BOOL rst = (sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL) == SQLITE_OK);
    
    return rst;
}

+ (BOOL) deleteWhereStatusNot:(NSString *)Status {
    NSString *query = [NSString stringWithFormat:@"delete from %@ where %@ <> '%@'", TBL_WAYNEORDERHEADER, FLD_STATUS, Status];
    
    BOOL rst = (sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL) == SQLITE_OK);
    
    return rst;
}

+ (id) fetch:(sqlite3_stmt *)dbStmt {
    NSInteger res = sqlite3_step(dbStmt);
	if (res != SQLITE_ROW)
		return nil;
    
    WayneOrderHeader * model = [[WayneOrderHeader alloc] init];
    
    model.CustNum = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt,0)];
    model.PONum = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 1)];
    model.OrderNum = sqlite3_column_int(dbStmt, 2);
    model.UserID = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 3)];
    model.HeartwoodStatus = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 4)];
    model.Terms = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 5)];
    model.ShipMethod = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 6)];
    model.CustName = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 7)];
    model.ProcessedBy = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 8)];
    model.DateReceived = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 9)];
    model.DateAccepted = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 10)];
    model.SAPShipDate = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 11)];
    model.BillName = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 12)];
    model.BillADDR1 = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 13)];
    model.BillADDR2 = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 14)];
    model.BillCity = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 15)];
    model.BillState = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 16)];
    model.BillZip = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 17)];
    model.StoreName = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 18)];
    model.StoreADDR1 = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 19)];
    model.StoreADDR2 = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 20)];
    model.StoreCity = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 21)];
    model.StoreState = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 22)];
    model.StoreZip = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 23)];
    model.TotalAmt = sqlite3_column_double(dbStmt, 24);
    model.Status = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 25)];
    model.RepActionReq = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 26)];
    model.ActionMsg = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 27)];
    model.StatusDate = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 28)];
    model.PDFType = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 29)];

    
	return model;
}

+ (NSMutableArray*) getAllOrderHeaders {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@", TBL_WAYNEORDERHEADER];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [WayneOrderHeader fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [WayneOrderHeader fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (WayneOrderHeader*) getOrderHeaderWhereOrderNum:(NSInteger)OrderNum {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@ = %ld", TBL_WAYNEORDERHEADER, FLD_ORDERNUM, (long)OrderNum];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
    {
        NSLog(@"ERROR");
        WayneOrderHeader *tmpOrder = [list objectAtIndex:0];
        return tmpOrder;
    }
    id data = [WayneOrderHeader fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [WayneOrderHeader fetch:stmt];
    }
    sqlite3_finalize(stmt);
    if (list.count == 0) {
        NSLog(@"Error, no cust found, just giving normal back");
        
        return [[WayneOrderHeader alloc] init];
    }
    WayneOrderHeader *tmpOrder = [list objectAtIndex:0];
    return tmpOrder;
}

+ (NSMutableArray*) getOrderHeadersWhereCustomer:(NSString *)customer {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    //Check for 's
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)customer != [NSNull null]) {
        customer = [[customer componentsSeparatedByCharactersInSet:charactersToRemove ]
                     componentsJoinedByString:@"''"];
    }
    
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", TBL_WAYNEORDERHEADER, FLD_CUSTNAME, customer];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
    {
        NSLog(@"ERROR");
        return list;
    }
    id data = [WayneOrderHeader fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [WayneOrderHeader fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (WayneOrderHeader*) getOrderHeaderWhereCustomer:(NSString *)customer {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)customer != [NSNull null]) {
        customer = [[customer componentsSeparatedByCharactersInSet:charactersToRemove ]
                         componentsJoinedByString:@"''"];
    }
    
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", TBL_WAYNEORDERHEADER, FLD_CUSTNAME, customer];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
    {
        NSLog(@"ERROR");
        WayneOrderHeader *tmpHdr = nil;
        
        return tmpHdr;
    }
    id data = [WayneOrderHeader fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [WayneOrderHeader fetch:stmt];
    }
    sqlite3_finalize(stmt);
    WayneOrderHeader *tmpHdr = [list objectAtIndex:0];
    
    return tmpHdr;
}

+ (NSMutableArray*) getOrderHeadersAfterDate:(NSDate *)date {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    NSMutableArray *returnList = [[NSMutableArray alloc] init];
    
    
    NSString * query = [NSString stringWithFormat:@"select * from %@", TBL_WAYNEORDERHEADER];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
    {
        NSLog(@"ERROR");
        return list;
    }
    id data = [WayneOrderHeader fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [WayneOrderHeader fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    for (int i = 0; i < list.count; i++) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        WayneOrderHeader *tmpOrder = [list objectAtIndex:i];
        NSString *dateToCompare = [dateFormatter stringFromDate:date];
        NSDate *orderDateAcc = [dateFormatter dateFromString:tmpOrder.DateAccepted];
        NSDate *orderDateRec = [dateFormatter dateFromString:tmpOrder.DateReceived];
        
        // compare dates
        if (orderDateAcc) {
            if (!([tmpOrder.DateAccepted compare:dateToCompare] == NSOrderedAscending)) {
                [returnList addObject:tmpOrder];
            }
        } else if (orderDateRec) {
            if (!([tmpOrder.DateReceived compare:dateToCompare] == NSOrderedAscending)) {
                [returnList addObject:tmpOrder];
            }
        } else {
            NSLog(@"No Dates");
        }
        
    }
    return returnList;
}

+ (NSInteger) insertInto:(WayneOrderHeader*)data {
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)data.PONum != [NSNull null]) {
        data.PONum = [[data.PONum componentsSeparatedByCharactersInSet:charactersToRemove ]
                         componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.CustName != [NSNull null]) {
        data.CustName = [[data.CustName componentsSeparatedByCharactersInSet:charactersToRemove ]
                         componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.BillName != [NSNull null]) {
        data.BillName = [[data.BillName componentsSeparatedByCharactersInSet:charactersToRemove ]
                         componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.BillADDR1 != [NSNull null]) {
        data.BillADDR1 = [[data.BillADDR1 componentsSeparatedByCharactersInSet:charactersToRemove ]
                          componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.BillADDR2 != [NSNull null]) {
        data.BillADDR2 = [[data.BillADDR2 componentsSeparatedByCharactersInSet:charactersToRemove ]
                          componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.BillCity != [NSNull null]) {
        data.BillCity = [[data.BillCity componentsSeparatedByCharactersInSet:charactersToRemove ]
                         componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.StoreName != [NSNull null]) {
        data.StoreName = [[data.StoreName componentsSeparatedByCharactersInSet:charactersToRemove ]
                          componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.StoreADDR1 != [NSNull null]) {
        data.StoreADDR1 = [[data.StoreADDR1 componentsSeparatedByCharactersInSet:charactersToRemove ]
                           componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.StoreADDR2 != [NSNull null]) {
        data.StoreADDR2 = [[data.StoreADDR2 componentsSeparatedByCharactersInSet:charactersToRemove ]
                           componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.StoreCity != [NSNull null]) {
        data.StoreCity = [[data.StoreCity componentsSeparatedByCharactersInSet:charactersToRemove ]
                          componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Status != [NSNull null]) {
        data.Status = [[data.Status componentsSeparatedByCharactersInSet:charactersToRemove ]
                          componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.RepActionReq != [NSNull null]) {
        data.RepActionReq = [[data.RepActionReq componentsSeparatedByCharactersInSet:charactersToRemove ]
                          componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.ActionMsg != [NSNull null]) {
        data.ActionMsg = [[data.ActionMsg componentsSeparatedByCharactersInSet:charactersToRemove ]
                          componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.StatusDate != [NSNull null]) {
        data.StatusDate = [[data.StatusDate componentsSeparatedByCharactersInSet:charactersToRemove ]
                          componentsJoinedByString:@"''"];
    }
    
    
    NSString *query = [NSString stringWithFormat:@"insert into %@(%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@) values('%@', '%@', %ld, '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', %f, '%@', '%@', '%@', '%@', '%@')",
                       TBL_WAYNEORDERHEADER,
                       FLD_CUSTNUM,
                       FLD_PONUM,
                       FLD_ORDERNUM,
                       FLD_USERID,
                       FLD_HEARTWOODSTATUS,
                       FLD_TERMS,
                       FLD_SHIPMETHOD,
                       FLD_CUSTNAME,
                       FLD_PROCESSEDBY,
                       FLD_DATERECEIVED,
                       FLD_DATEACCEPTED,
                       FLD_SAPSHIPDATE,
                       FLD_BILLNAME,
                       FLD_BILLADDR1,
                       FLD_BILLADDR2,
                       FLD_BILLCITY,
                       FLD_BILLSTATE,
                       FLD_BILLZIP,
                       FLD_STORENAME,
                       FLD_STOREADDR1,
                       FLD_STOREADDR2,
                       FLD_STORECITY,
                       FLD_STORESTATE,
                       FLD_STOREZIP,
                       FLD_TOTALAMT,
                       FLD_STATUS,
                       FLD_REPACTREQ,
                       FLD_ACTIONMSG,
                       FLD_STATUSDATE,
                       FLD_PDFTYPE,
                       data.CustNum,
                       data.PONum,
                       (long)data.OrderNum,
                       data.UserID,
                       data.HeartwoodStatus,
                       data.Terms,
                       data.ShipMethod,
                       data.CustName,
                       data.ProcessedBy,
                       data.DateReceived,
                       data.DateAccepted,
                       data.SAPShipDate,
                       data.BillName,
                       data.BillADDR1,
                       data.BillADDR2,
                       data.BillCity,
                       data.BillState,
                       data.BillZip,
                       data.StoreName,
                       data.StoreADDR1,
                       data.StoreADDR2,
                       data.StoreCity,
                       data.StoreState,
                       data.StoreZip,
                       data.TotalAmt,
                       data.Status,
                       data.RepActionReq,
                       data.ActionMsg,
                       data.StatusDate,
                       data.PDFType
                       ];
    
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
//    NSLog(@"Insert = %@\n result = %ld", query, (long)result);
    if (result == SQLITE_OK) {
        return (int)sqlite3_last_insert_rowid([DBManager sharedManager]);
    } else {
        NSLog(@"ERROR on query: = %@\n result: = %ld", query, (long)result);
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
