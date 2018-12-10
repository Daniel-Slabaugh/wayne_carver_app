//
//  ShipType.m
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/30/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "Ship.h"
#import "DBManager.h"


@implementation Ship
@synthesize ShipType;


+ (void) deleteAllShipTypes{
    NSString *query = [NSString stringWithFormat:@"delete from %@", TBL_SHIPTYPE];
    
    sqlite3_exec([DBManager sharedManager], [query UTF8String], NULL, NULL, NULL);
    
    //    return rst;
}


+ (id) fetch:(sqlite3_stmt *)dbStmt {
    NSInteger res = sqlite3_step(dbStmt);
	if (res != SQLITE_ROW)
		return nil;
    
    Ship * model = [[Ship alloc] init];
    
    model.ShipType = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(dbStmt, 0)];
	return model;
}


+ (NSMutableArray*) getAllShipTypes {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSString * query = [NSString stringWithFormat:@"select * from %@", TBL_SHIPTYPE];
    
	char *sql = (char *)[query UTF8String];
	
	sqlite3_stmt *stmt;
	if (sqlite3_prepare_v2([DBManager sharedManager], sql, (int)strlen(sql), &stmt, NULL) != SQLITE_OK)
        return list;
    
    id data = [Ship fetch:stmt];
    while (data) {
        [list addObject:data];
        data = [Ship fetch:stmt];
    }
    sqlite3_finalize(stmt);
    
    return list;
}

+ (NSInteger) insertInto:(Ship *)data {
    //Check for 's
    if ((NSNull *)data.ShipType != [NSNull null]) {
        NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"'"];
        data.ShipType = [[data.ShipType componentsSeparatedByCharactersInSet:charactersToRemove ]
                        componentsJoinedByString:@"''"];
    }
    
	NSString *query = [NSString stringWithFormat:@"insert into %@(%@) values('%@')",
                       TBL_SHIPTYPE,
                       FLD_SHIPTYPE,
                       data.ShipType
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
