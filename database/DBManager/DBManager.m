//
//  DBManager.m
//  wayne mobile
//
//  Created by Chenggong Huang on 7/19/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

static sqlite3 * gDBHandler = nil;

+ (BOOL)initDatabase {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    NSString * path = LOCAL_DATABASE_PATH;
    
    NSString * bundlePath = [[NSBundle mainBundle] pathForResource:@"Heartwood" ofType:@"sqlite"];
    
    if (![fileManager fileExistsAtPath:path]) {
        if (![fileManager copyItemAtPath:bundlePath toPath:LOCAL_DATABASE_PATH error:nil])
            return NO;
    }
    
    sqlite3 * database;
    if (sqlite3_open([path UTF8String], &database) != SQLITE_OK) {
        return NO;
    }
    
    gDBHandler = database;
    
    return YES;
}

+ (sqlite3*) sharedManager {
    if (gDBHandler == nil)
    {
        [DBManager initDatabase];
    }
    return gDBHandler;
}

@end
