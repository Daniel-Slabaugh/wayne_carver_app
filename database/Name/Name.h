//
//  Name.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/16/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define  TBL_NAME        @"Names"
#define  FLD_NAMESET     @"Nameset"
#define  FLD_NAME        @"Name"
#define  FLD_NAMETYPE    @"NameType"
#define  FLD_NUMOFPEGS   @"NumOfPegs"

@interface Name : NSObject
{
    NSString * Nameset;
    NSString * TheName;
    NSString * NameType;
    NSString * NumOfPegs;
}

@property (nonatomic, retain) NSString * Nameset;
@property (nonatomic, retain) NSString * TheName;
@property (nonatomic, retain) NSString * NameType;
@property (nonatomic, retain) NSString * NumOfPegs;


+ (BOOL) deleteWhere:(NSInteger)uid;
+ (void) deleteAllNames;

+ (id) fetch:(sqlite3_stmt *)dbStmt;

+ (NSMutableArray*) getAllNames;

+ (NSMutableArray*) getNamesWhere:(NSString*)nameSet;

+ (NSInteger) beginNameInsert;
+ (NSInteger) endNameInsert;
+ (NSInteger) insertInto:(Name*) data;


@end
