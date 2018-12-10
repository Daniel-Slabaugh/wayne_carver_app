//
//  AttemptedOrderHeader.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/22/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "AttemptedOrderHeader.h"
#import "DBManager.h"

@implementation AttemptedOrderHeader
@synthesize OrderNum;
@synthesize UserID;
@synthesize CustNum;
@synthesize StoreID;
@synthesize PONum;
@synthesize LocalStatus;
@synthesize HeartwoodStatus;
@synthesize ShipMethod;
@synthesize NotBefore;
@synthesize Notes;
@synthesize DateToShip;
@synthesize DateCreated;
@synthesize DateEdited;
@synthesize DateAttempted;
@synthesize PDFType;




+ (void) deleteAllOrderHeaders {
    NSString *query = [NSString stringWithFormat:@"delete from %@", TBL_ATTEMPTEDORDERHEADER];
    
    sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
}

+ (BOOL) deleteWhere:(NSInteger)uid {
    NSString *query = [NSString stringWithFormat:@"delete from %@ where %@ = %ld", TBL_ATTEMPTEDORDERHEADER, FLD_ORDERNUM, (long)uid];
    
    BOOL rst = (sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL) == SQLITE_OK);
    
    return rst;
}

+ (id) fetch:(sqlite3_stmt *)dbStmt {
    NSInteger res = sqlite3_step(dbStmt);
	if (res != SQLITE_ROW)
		return nil;
    
    AttemptedOrderHeader * model = [[AttemptedOrderHeader alloc] init];
    
    model.OrderNum = sqlite3_column_int(dbStmt, 0);
    model.UserID = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 1)];
    model.CustNum = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 2)];
    model.StoreID = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 3)];
    model.PONum = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 4)];
    model.LocalStatus = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 5)];
    model.HeartwoodStatus = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 6)];
    model.ShipMethod = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 7)];
    model.NotBefore = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 8)];
    model.Notes = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 9)];
    model.DateToShip = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 10)];
    model.DateCreated = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 11)];
    model.DateEdited = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 12)];
    model.DateAttempted = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 13)];
    model.PDFType = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 14)];
	return model;
}

+ (NSMutableArray*) getAllOrderHeaders {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@", TBL_ATTEMPTEDORDERHEADER];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [AttemptedOrderHeader fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [AttemptedOrderHeader fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (AttemptedOrderHeader*) getLastOrderHeaderEntered {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select MAX(%@) from %@", FLD_ORDERNUM, TBL_ATTEMPTEDORDERHEADER];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK) {
        NSLog(@"didn't work");
        AttemptedOrderHeader *badOrdHdr = [list objectAtIndex:0];
        return badOrdHdr;
    }
    
    id data = [AttemptedOrderHeader fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [AttemptedOrderHeader fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    AttemptedOrderHeader *tmpOrdHdr = [list objectAtIndex:0];
    
    return tmpOrdHdr;
}

+ (AttemptedOrderHeader*) getOrderHeaderWhereOrderNum:(NSInteger)OrderNum {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@ = %ld", TBL_ATTEMPTEDORDERHEADER, FLD_ORDERNUM, (long)OrderNum];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
    {
        NSLog(@"ERROR");
        AttemptedOrderHeader *tmpOrder = [list objectAtIndex:0];
        return tmpOrder;
    }
    id data = [AttemptedOrderHeader fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [AttemptedOrderHeader fetch:stmt];
    }
    sqlite3_finalize(stmt);
    if (list.count == 0) {
        NSLog(@"Error, no cust found, just giving normal back");
        
        return [[AttemptedOrderHeader alloc] init];
    }
    AttemptedOrderHeader *tmpOrder = [list objectAtIndex:0];
    return tmpOrder;
}

+ (NSInteger) updateOrderHeader:(AttemptedOrderHeader*)data {
    
    NSString *tmpStoreID;
    NSString *tmpShipMethod;
    NSString *tmpNotes;
    
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)data.StoreID != [NSNull null]) {
        tmpStoreID = [[data.StoreID componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    } else {
        tmpStoreID = @"";
    }
    if ((NSNull *)data.ShipMethod != [NSNull null]) {
        tmpShipMethod = [[data.ShipMethod componentsSeparatedByCharactersInSet:charactersToRemove ]
                           componentsJoinedByString:@"''"];
    } else {
        tmpShipMethod = @"";
    }
    if ((NSNull *)data.Notes != [NSNull null]) {
        tmpNotes = [[data.Notes componentsSeparatedByCharactersInSet:charactersToRemove ]
                      componentsJoinedByString:@"''"];
    } else {
        tmpNotes = @"";
    }
    
	NSString *query = [NSString stringWithFormat:@"update %@ set %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@' where %@ = %ld",
                       TBL_ATTEMPTEDORDERHEADER,
                       FLD_USERID,
                       data.UserID,
                       FLD_CUSTNUM,
                       data.CustNum,
                       FLD_STOREID,
                       tmpStoreID,
                       FLD_PONUM,
                       data.PONum,
                       FLD_LOCALSTATUS,
                       data.LocalStatus,
                       FLD_HTWDSTATUS,
                       data.HeartwoodStatus,
                       FLD_SHIPMETHOD,
                       tmpShipMethod,
                       FLD_NOTBEFORE,
                       data.NotBefore,
                       FLD_NOTES,
                       tmpNotes,
                       FLD_DATETOSHIP,
                       data.DateToShip,
                       FLD_DATECREATED,
                       data.DateCreated,
                       FLD_DATEEDITED,
                       data.DateEdited,
                       FLD_DATEPOSTED,
                       data.DateAttempted,
                       FLD_PDFTYPE,
                       data.PDFType,
                       FLD_ORDERNUM,
                       (long)data.OrderNum
                       ];
    
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        return sqlite3_last_insert_rowid([DBManager sharedManager]);
    }
    return - result;
}

+ (NSInteger) insertInto:(AttemptedOrderHeader*)data {
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)data.StoreID != [NSNull null]) {
        data.StoreID = [[data.StoreID componentsSeparatedByCharactersInSet:charactersToRemove ]
                         componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.ShipMethod != [NSNull null]) {
        data.ShipMethod = [[data.ShipMethod componentsSeparatedByCharactersInSet:charactersToRemove ]
                      componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Notes != [NSNull null]) {
        data.Notes = [[data.Notes componentsSeparatedByCharactersInSet:charactersToRemove ]
                      componentsJoinedByString:@"''"];
    }
    
	NSString *query = [NSString stringWithFormat:@"insert into %@(%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@) values('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                       TBL_ATTEMPTEDORDERHEADER,
                       FLD_USERID,
                       FLD_CUSTNUM,
                       FLD_STOREID,
                       FLD_PONUM,
                       FLD_LOCALSTATUS,
                       FLD_HTWDSTATUS,
                       FLD_SHIPMETHOD,
                       FLD_NOTBEFORE,
                       FLD_NOTES,
                       FLD_DATETOSHIP,
                       FLD_DATECREATED,
                       FLD_DATEEDITED,
                       FLD_DATEPOSTED,
                       FLD_PDFTYPE,
                       data.UserID,
                       data.CustNum,
                       data.StoreID,
                       data.PONum,
                       data.LocalStatus,
                       data.HeartwoodStatus,
                       data.ShipMethod,
                       data.NotBefore,
                       data.Notes,
                       data.DateToShip,
                       data.DateCreated,
                       data.DateEdited,
                       data.DateAttempted,
                       data.PDFType
                       ];
    
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        return sqlite3_last_insert_rowid([DBManager sharedManager]);
    }
    return - result;
}

@end
