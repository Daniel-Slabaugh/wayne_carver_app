//
//  User.m
//  HeartwoodApp
//
//  Created by Chenggong Huang on 6/26/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "User.h"
#import "DBManager.h"

@implementation User

@synthesize UserID;
@synthesize FirstName;
@synthesize LastName;
@synthesize CompanyName;
@synthesize MailADDR1;
@synthesize MailADDR2;
@synthesize MailCity;
@synthesize MailState;
@synthesize MailZip;
@synthesize MailCountry;
@synthesize ShipADDR1;
@synthesize ShipADDR2;
@synthesize ShipCity;
@synthesize ShipState;
@synthesize ShipZip;
@synthesize ShipCountry;
@synthesize Phone;
@synthesize FAX;
@synthesize Cell;
@synthesize Email;
@synthesize Password;

@synthesize UserActive;
@synthesize UserRemoteEnabled;
@synthesize RecordNeedsTransfer;
@synthesize CommCheckDest;
@synthesize Territories;




+ (void) deleteAllUsers {
    NSString *query = [NSString stringWithFormat:@"delete from %@", TBL_USER];
    
    sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    
//    return rst;
}

+ (BOOL) deleteWhere:(NSInteger)uid {
    NSString *query = [NSString stringWithFormat:@"delete from %@ where %@ = %ld", TBL_USER, FLD_USERID, (long)uid];
    
    BOOL rst = (sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL) == SQLITE_OK);
    
    return rst;
}


+ (id) fetch:(sqlite3_stmt *)dbStmt {
    NSInteger res = sqlite3_step(dbStmt);
	if (res != SQLITE_ROW)
		return nil;
    
    User * model = [[User alloc] init];
    
    model.UserID = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 0)];
    model.FirstName = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 1)];
    model.LastName = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 2)];
    model.CompanyName = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 3)];
    model.MailADDR1 = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 4)];
    model.MailADDR2 = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 5)];
    model.MailCity = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 6)];
    model.MailState = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 7)];
    model.MailZip = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 8)];
    model.MailCountry = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 9)];
    model.ShipADDR1 = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 10)];
    model.ShipADDR2 = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 11)];
    model.ShipCity = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 12)];
    model.ShipState = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 13)];
    model.ShipZip = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 14)];;
    model.ShipCountry = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 15)];
    model.Phone = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 16)];
    model.FAX = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 17)];
    model.Cell = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 18)];;
    model.Email = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 19)];
    model.Password = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 20)];
    model.UserActive = sqlite3_column_int(dbStmt, 21);
    model.UserRemoteEnabled = sqlite3_column_int(dbStmt, 22);
    model.RecordNeedsTransfer = sqlite3_column_int(dbStmt, 23);
    model.CommCheckDest = sqlite3_column_int(dbStmt, 24);
    model.Territories = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 25)];
    
	return model;
}

+ (NSMutableArray*) getAllUsers {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@", TBL_USER];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [User fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [User fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}


+ (User*) getUser {
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@", TBL_USER];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
    {
        NSLog(@"ERROR");
        User *tmpUser = [list objectAtIndex:0];
        return tmpUser;
    }
    
    id data = [User fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [User fetch:stmt];
    }
    sqlite3_finalize(stmt);
    if (list.count == 0) {
        NSLog(@"Error, no user found, just giving normal back");
        User *errorUser = [[User alloc] init];
        return errorUser;
    }
    User *tmpUser = [list objectAtIndex:0];
    return tmpUser;
}

#pragma check for apostrophie prospective mehod

// check for apostrophes
- (NSString*) apostrophe:(NSString*)string {
    //Check for 's
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    if ((NSNull *)string != [NSNull null]) {
        string = [[string componentsSeparatedByCharactersInSet:charactersToRemove ]
                       componentsJoinedByString:@"''"];
    }
    return string;
}



+ (NSInteger) insertInto:(User *)data {
    
    
    //Check for 's
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    
    
    if ((NSNull *)data.UserID != [NSNull null]) {
        data.UserID = [[data.UserID componentsSeparatedByCharactersInSet:charactersToRemove ]
                         componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.FirstName != [NSNull null]) {
        data.FirstName = [[data.FirstName componentsSeparatedByCharactersInSet:charactersToRemove ]
                      componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.LastName != [NSNull null]) {
        data.LastName = [[data.LastName componentsSeparatedByCharactersInSet:charactersToRemove ]
                      componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.CompanyName != [NSNull null]) {
        data.CompanyName = [[data.CompanyName componentsSeparatedByCharactersInSet:charactersToRemove ]
                       componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.MailADDR1 != [NSNull null]) {
        data.MailADDR1 = [[data.MailADDR1 componentsSeparatedByCharactersInSet:charactersToRemove ]
                          componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.MailADDR2 != [NSNull null]) {
        data.MailADDR2 = [[data.MailADDR2 componentsSeparatedByCharactersInSet:charactersToRemove ]
                         componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.MailCity != [NSNull null]) {
        data.MailCity = [[data.MailCity componentsSeparatedByCharactersInSet:charactersToRemove ]
                          componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.MailState != [NSNull null]) {
        data.MailState = [[data.MailState componentsSeparatedByCharactersInSet:charactersToRemove ]
                         componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.MailZip != [NSNull null]) {
        data.MailZip = [[data.MailZip componentsSeparatedByCharactersInSet:charactersToRemove ]
                            componentsJoinedByString:@"''"];
    }
        if ((NSNull *)data.MailCountry != [NSNull null]) {
        data.MailCountry = [[data.MailCountry componentsSeparatedByCharactersInSet:charactersToRemove ]
                       componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.ShipADDR1 != [NSNull null]) {
        data.ShipADDR1 = [[data.ShipADDR1 componentsSeparatedByCharactersInSet:charactersToRemove ]
                          componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.ShipADDR2 != [NSNull null]) {
        data.ShipADDR2 = [[data.ShipADDR2 componentsSeparatedByCharactersInSet:charactersToRemove ]
                          componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.ShipCity != [NSNull null]) {
        data.ShipCity = [[data.ShipCity componentsSeparatedByCharactersInSet:charactersToRemove ]
                         componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.ShipState != [NSNull null]) {
        data.ShipState = [[data.ShipState componentsSeparatedByCharactersInSet:charactersToRemove ]
                          componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.ShipZip != [NSNull null]) {
        data.ShipZip = [[data.ShipZip componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.ShipCountry != [NSNull null]) {
        data.ShipCountry = [[data.ShipCountry componentsSeparatedByCharactersInSet:charactersToRemove ]
                            componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Phone != [NSNull null]) {
        data.Phone = [[data.Phone componentsSeparatedByCharactersInSet:charactersToRemove ]
                          componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.FAX != [NSNull null]) {
        data.FAX = [[data.FAX componentsSeparatedByCharactersInSet:charactersToRemove ]
                          componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Cell != [NSNull null]) {
        data.Cell = [[data.Cell componentsSeparatedByCharactersInSet:charactersToRemove ]
                         componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Email != [NSNull null]) {
        data.Email = [[data.Email componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Password != [NSNull null]) {
        data.Password = [[data.Password componentsSeparatedByCharactersInSet:charactersToRemove ]
                            componentsJoinedByString:@"''"];
    }
    if ((NSNull *)data.Territories != [NSNull null]) {
        data.Territories = [[data.Territories componentsSeparatedByCharactersInSet:charactersToRemove ]
                         componentsJoinedByString:@"''"];
    }    
    
	NSString *query = [NSString stringWithFormat:@"insert into %@(%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@) values('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', %d, %d, %d, %d, '%@')",
                       TBL_USER,
                       FLD_USERID,
                       FLD_FNAME,
                       FLD_LNAME,
                       FLD_CNAME,
                       FLD_MADDR1,
                       FLD_MADDR2,
                       FLD_MCITY,
                       FLD_MSTATE,
                       FLD_MZIP,
                       FLD_MCOUNTRY,
                       FLD_SADDR1,
                       FLD_SADDR2,
                       FLD_SCITY,
                       FLD_SSTATE,
                       FLD_SZIP,
                       FLD_SCOUNTRY,
                       FLD_PHONE,
                       FLD_FAX,
                       FLD_CELL,
                       FLD_EMAIL,
                       FLD_PASSWORD,
                       FLD_USERACTIVE,
                       FLD_USERREMOTEENABLED,
                       FLD_RECORDNEEDSTRANSFER,
                       FLD_COMMCHECKDEST,
                       FLD_TERRITORIES,
                       data.UserID,
                       data.FirstName,
                       data.LastName,
                       data.CompanyName,
                       data.MailADDR1,
                       data.MailADDR2,
                       data.MailCity,
                       data.MailState,
                       data.MailZip,
                       data.MailCountry,
                       data.ShipADDR1,
                       data.ShipADDR2,
                       data.ShipCity,
                       data.ShipState,
                       data.ShipZip,
                       data.ShipCountry,
                       data.Phone,
                       data.FAX,
                       data.Cell,
                       data.Email,
                       data.Password,
                       data.UserActive,
                       data.UserRemoteEnabled,
                       data.RecordNeedsTransfer,
                       data.CommCheckDest,
                       data.Territories
                       ];
    
    NSInteger result = sqlite3_exec ([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    NSLog(@"Insert = %@\n result = %ld", query, (long)result);
    if (result == SQLITE_OK) {
        return (int)sqlite3_last_insert_rowid([DBManager sharedManager]);
    }
    return - result;    
}

@end
