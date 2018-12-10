//
//  DateLastSynced.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/9/15.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define  TBL_DATELASTSYNCED         @"DateLastSynced"
#define  FLD_ENTRYNUM               @"EntryNum"
#define  FLD_DATELASTSYNCED         @"DateSynced"


@interface DateLastSynced : NSObject
{
    NSInteger EntryNum;
    NSString * DateSynced;
}

@property (nonatomic) NSInteger EntryNum;
@property (nonatomic, retain) NSString *DateSynced;

+ (void) deleteAllDatesLastSynced;

+ (id) fetch:(sqlite3_stmt *)dbStmt;

+ (NSMutableArray*) getAllDatesLastSynced;

+ (DateLastSynced*) getLastDateLastSynced;

+ (NSInteger) insertInto:(DateLastSynced*) data;

@end
