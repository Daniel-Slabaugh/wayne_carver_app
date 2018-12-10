//
//  GMOrderHeader.m
//  wayne mobile
//
//  Created by Delphi Dev Computer on 7/3/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import "GMOrderHeader.h"
#import "DBManager.h"

@implementation GMOrderHeader
@synthesize OrderNum;
@synthesize UserID;
@synthesize PONum;
@synthesize LocalStatus;
@synthesize HeartwoodStatus;
@synthesize BillTo;
@synthesize BAddress;
@synthesize BCity;
@synthesize BState;
@synthesize BZip;
@synthesize BPhoneFax;
@synthesize ShipTo;
@synthesize SAddress;
@synthesize SCity;
@synthesize SState;
@synthesize SZip;
@synthesize ShipMethod;
@synthesize NotBefore;
@synthesize Notes;
@synthesize DateToShip;
@synthesize DateToCancel;
@synthesize DateCreated;
@synthesize DateEdited;
@synthesize DatePosted;
@synthesize CustNum;
@synthesize StoreID;
@synthesize PDFType;




+ (void) deleteAllOrderHeaders {
    NSString *query = [NSString stringWithFormat:@"delete from %@", TBL_GMORDERHEADER];
    
    sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
}

+ (BOOL) deleteWhere:(NSInteger)uid {
    NSString *query = [NSString stringWithFormat:@"delete from %@ where %@ = %ld", TBL_GMORDERHEADER, FLD_ORDERNUM, (long)uid];
    
    BOOL rst = (sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL) == SQLITE_OK);
    
    return rst;
}

+ (id) fetch:(sqlite3_stmt *)dbStmt {
    NSInteger res = sqlite3_step(dbStmt);
    if (res != SQLITE_ROW)
        return nil;
    
    
    GMOrderHeader * model = [[GMOrderHeader alloc] init];
    
    model.OrderNum = sqlite3_column_int(dbStmt, 0);;
    model.UserID = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 1)];
    model.PONum = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 2)];
    model.LocalStatus = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 3)];
    model.HeartwoodStatus = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 4)];
    model.ShipMethod = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 5)];
    model.NotBefore = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 6)];
    model.Notes = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 7)];
    model.BillTo = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 8)];
    model.BAddress = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 9)];
    model.BCity = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 10)];
    model.BState = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 11)];
    model.BZip = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 12)];
    model.BPhoneFax = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 13)];
    model.ShipTo = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 14)];
    model.SAddress = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 15)];
    model.SCity = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 16)];
    model.SState = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 17)];
    model.SZip = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 18)];
    model.DateToShip = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 19)];
    model.DateToCancel = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 20)];
    model.DateCreated = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 21)];
    model.DateEdited = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 22)];
    model.DatePosted = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 23)];
    model.CustNum = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 24)];
    model.StoreID = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 25)];
    model.PDFType = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 26)];
    return model;
}

+ (NSMutableArray*) getAllOrderHeaders {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@", TBL_GMORDERHEADER];
    
    char *sql = (char *)[query UTF8String];
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [GMOrderHeader fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [GMOrderHeader fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (GMOrderHeader*) getLastOrderHeaderEntered {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select MAX(%@) from %@", FLD_ORDERNUM, TBL_GMORDERHEADER];
    
    char *sql = (char *)[query UTF8String];
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK) {
        NSLog(@"didn't work");
        GMOrderHeader *badOrdHdr = [list objectAtIndex:0];
        return badOrdHdr;
    }
    
    id data = [GMOrderHeader fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [GMOrderHeader fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    GMOrderHeader *tmpOrdHdr = [list objectAtIndex:0];
    
    return tmpOrdHdr;
}

+ (GMOrderHeader*) getOrderHeaderWhereOrderNum:(NSInteger)OrderNum {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@ = %ld", TBL_GMORDERHEADER, FLD_ORDERNUM, (long)OrderNum];
    
    char *sql = (char *)[query UTF8String];
    
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
    {
        NSLog(@"ERROR");
        GMOrderHeader *tmpOrder = [list objectAtIndex:0];
        return tmpOrder;
    }
    id data = [GMOrderHeader fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [GMOrderHeader fetch:stmt];
    }
    sqlite3_finalize(stmt);
    if (list.count == 0) {
        NSLog(@"Error, no cust found, just giving normal back");
        
        return [[GMOrderHeader alloc] init];
    }
    GMOrderHeader *tmpOrder = [list objectAtIndex:0];
    return tmpOrder;
}

+ (NSInteger) updateOrderHeader:(GMOrderHeader*)data {
    
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
    
    NSString *query = [NSString stringWithFormat:@"update %@ set %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@', %@ = '%@' where %@ = %ld",
                       TBL_GMORDERHEADER,
                       FLD_USERID,
                       data.UserID,
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
                       FLD_BILLTO,
                       data.BillTo,
                       FLD_BADDRESS,
                       data.BAddress,
                       FLD_BCITY,
                       data.BCity,
                       FLD_BZIP,
                       data.BZip,
                       FLD_BPHONEFAX,
                       data.BPhoneFax,
                       FLD_SHIPTO,
                       data.ShipTo,
                       FLD_SADDRESS,
                       data.SAddress,
                       FLD_SCITY1,
                       data.SCity,
                       FLD_SSTATE1,
                       data.SState,
                       FLD_SZIP1,
                       data.SZip,
                       FLD_DATETOSHIP,
                       data.DateToShip,
                       FLD_DATETOCANCEL,
                       data.DateToCancel,
                       FLD_DATECREATED,
                       data.DateCreated,
                       FLD_DATEEDITED,
                       data.DateEdited,
                       FLD_DATEPOSTED,
                       data.DatePosted,
                       FLD_CUSTNUM,
                       data.CustNum,
                       FLD_STOREID,
                       tmpStoreID,
                       FLD_PDFTYPE,
                       data.PDFType,
                       FLD_ORDERNUM,
                       (long)data.OrderNum
                       ];
    
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    if (result == SQLITE_OK) {
        return (int)sqlite3_last_insert_rowid([DBManager sharedManager]);
    } else {
        NSLog(@"ERROR on Insert = %@\n result = %ld", query, (long)result);
    }
    return - result;
}

+ (NSInteger) insertInto:(GMOrderHeader*)data {
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
    if ((NSNull *)data.UserID != [NSNull null]) {
        data.UserID = [[data.UserID componentsSeparatedByCharactersInSet:charactersToRemove ]
                      componentsJoinedByString:@"''"];
    } else {
        NSLog(@"Here we go");
    }
    
    NSString *query = [NSString stringWithFormat:@"insert into %@(%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@) values('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@',  '%@', '%@', '%@')",
                       TBL_GMORDERHEADER,
                       FLD_USERID,
                       FLD_PONUM,
                       FLD_LOCALSTATUS,
                       FLD_HTWDSTATUS,
                       FLD_SHIPMETHOD,
                       FLD_NOTBEFORE,
                       FLD_NOTES,
                       FLD_BILLTO,
                       FLD_BADDRESS,
                       FLD_BCITY,
                       FLD_BSTATE,
                       FLD_BZIP,
                       FLD_BPHONEFAX,
                       FLD_SHIPTO,
                       FLD_SADDRESS,
                       FLD_SCITY1,
                       FLD_SSTATE1,
                       FLD_SZIP1,
                       FLD_DATETOSHIP,
                       FLD_DATETOCANCEL,
                       FLD_DATECREATED,
                       FLD_DATEEDITED,
                       FLD_DATEPOSTED,
                       FLD_CUSTNUM,
                       FLD_STOREID,
                       FLD_PDFTYPE,
                       data.UserID,
                       data.PONum,
                       data.LocalStatus,
                       data.HeartwoodStatus,
                       data.ShipMethod,
                       data.NotBefore,
                       data.Notes,
                       data.BillTo,
                       data.BAddress,
                       data.BCity,
                       data.BState,
                       data.BZip,
                       data.BPhoneFax,
                       data.ShipTo,
                       data.SAddress,
                       data.SCity,
                       data.SState,
                       data.SZip,
                       data.DateToShip,
                       data.DateToCancel,
                       data.DateCreated,
                       data.DateEdited,
                       data.DatePosted,
                       data.CustNum,
                       data.StoreID,
                       data.PDFType
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
