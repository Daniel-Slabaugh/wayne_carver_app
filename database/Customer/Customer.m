//
//  Customer.m
//  wayne mobile
//
//  Created by Daniel Slabaugh on 7/1/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "Customer.h"
#import "DBManager.h"

@implementation Customer

@synthesize CustNum;
@synthesize CustName;
@synthesize Phone1;
@synthesize Phone2;
@synthesize FAX;
@synthesize Cntctprsn;
@synthesize Email;
@synthesize ADDR1;
@synthesize ADDR2;
@synthesize City;
@synthesize State;
@synthesize Zip;
@synthesize Country;



+ (void) deleteAllCustomers {
    NSString *query = [NSString stringWithFormat:@"delete from %@", TBL_CUSTOMER];
    
    sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    
    //    return rst;
}

+ (BOOL) deleteWhere:(NSInteger)uid {
    NSString *query = [NSString stringWithFormat:@"delete from %@ where %@ = %ld", TBL_CUSTOMER, FLD_CUSTNUM, (long)uid];
    
    BOOL rst = (sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL) == SQLITE_OK);
    
    return rst;
}

+ (id) fetch:(sqlite3_stmt *)dbStmt {
    NSInteger res = sqlite3_step(dbStmt);
	if (res != SQLITE_ROW)
		return nil;
    
    Customer * model = [[Customer alloc] init];
    
    model.CustNum = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 0)];
    model.CustName = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 1)];
    model.Phone1 = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 2)];
    model.Phone2 = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 3)];
    model.FAX = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 4)];
    model.Cntctprsn = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 5)];
    model.Email = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 6)];
    model.ADDR1 = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 7)];
    model.ADDR2 = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 8)];
    model.City = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 9)];
    model.State = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 10)];
    model.Zip = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 11)];
    model.Country = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 12)];
    
	return model;
}

+ (NSMutableArray*) getAllCustomers {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@", TBL_CUSTOMER];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [Customer fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [Customer fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (Customer*) getCustomerWhereCustomerNumber:(NSString*)custNum {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", TBL_CUSTOMER, FLD_CUSTNUM, custNum];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
    {
        NSLog(@"ERROR");
        Customer *tmpCust = [list objectAtIndex:0];
        return tmpCust;
    }
    
    id data = [Customer fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [Customer fetch:stmt];
    }
    sqlite3_finalize(stmt);
    if (list.count == 0) {
        NSLog(@"Error, no cust found, just giving normal back");

        return [[Customer alloc] init];
    }
    Customer *tmpCust = [list objectAtIndex:0];
    return tmpCust;
}


+ (NSInteger) insertInto:(Customer *)data {
    
    //Check for 's
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)data.CustNum != [NSNull null]) {
        data.CustNum = [[data.CustNum componentsSeparatedByCharactersInSet:charactersToRemove ]
                         componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.CustName != [NSNull null]) {
        data.CustName = [[data.CustName componentsSeparatedByCharactersInSet:charactersToRemove ]
                         componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Phone1 != [NSNull null]) {
        data.Phone1 = [[data.Phone1 componentsSeparatedByCharactersInSet:charactersToRemove ]
                      componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Phone2 != [NSNull null]) {
        data.Phone2 = [[data.Phone2 componentsSeparatedByCharactersInSet:charactersToRemove ]
                      componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.FAX != [NSNull null]) {
        data.FAX = [[data.FAX componentsSeparatedByCharactersInSet:charactersToRemove ]
                      componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Cntctprsn != [NSNull null]) {
        data.Cntctprsn = [[data.Cntctprsn componentsSeparatedByCharactersInSet:charactersToRemove ]
                      componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Email != [NSNull null]) {
        data.Email = [[data.Email componentsSeparatedByCharactersInSet:charactersToRemove ]
                      componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.ADDR1 != [NSNull null]) {
        data.ADDR1 = [[data.ADDR1 componentsSeparatedByCharactersInSet:charactersToRemove ]
                      componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.ADDR2 != [NSNull null]) {
        data.ADDR2 = [[data.ADDR2 componentsSeparatedByCharactersInSet:charactersToRemove ]
                      componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.City != [NSNull null]) {
        data.City = [[data.City componentsSeparatedByCharactersInSet:charactersToRemove ]
                      componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.State != [NSNull null]) {
        data.State = [[data.State componentsSeparatedByCharactersInSet:charactersToRemove ]
                      componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Zip != [NSNull null]) {
        data.Zip = [[data.Zip componentsSeparatedByCharactersInSet:charactersToRemove ]
                      componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Country != [NSNull null]) {
        data.Country = [[data.Country componentsSeparatedByCharactersInSet:charactersToRemove ]
                      componentsJoinedByString:@"''"];
    }
    
	NSString *query = [NSString stringWithFormat:@"insert into %@(%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@) values('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                       TBL_CUSTOMER,
                       FLD_CUSTNUM,
                       FLD_CUSTNAME,
                       FLD_PHONE1,
                       FLD_PHONE2,
                       FLD_FAX,
                       FLD_CPRSN,
                       FLD_EMAIL,
                       FLD_ADDR1,
                       FLD_ADDR2,
                       FLD_CITY,
                       FLD_STATE,
                       FLD_ZIP,
                       FLD_COUNTRY,
                       data.CustNum,
                       data.CustName,
                       data.Phone1,
                       data.Phone2,
                       data.FAX,
                       data.Cntctprsn,
                       data.Email,
                       data.ADDR1,
                       data.ADDR2,
                       data.City,
                       data.State,
                       data.Zip,
                       data.Country
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
