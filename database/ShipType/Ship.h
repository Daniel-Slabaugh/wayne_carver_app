//
//  ShipType.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/30/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


#define  TBL_SHIPTYPE     @"ShipTypes"
#define  FLD_SHIPTYPE     @"ShipType"
@interface Ship : NSObject
{
    NSString * ShipType;
}

@property (nonatomic, retain) NSString * ShipType;

+ (void) deleteAllShipTypes;

+ (id) fetch:(sqlite3_stmt *)dbStmt;

+ (NSMutableArray*) getAllShipTypes;

+ (NSInteger) insertInto:(Ship*) data;


@end
