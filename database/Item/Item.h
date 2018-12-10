//
//  Item.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/16/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


#define  TBL_ITEM        @"Items"
#define  FLD_CUSTNUM     @"CustNum"
#define  FLD_PROGNAME    @"ProgName"
#define  FLD_ITEMNO      @"ItemNO"
#define  FLD_NAMESET     @"Nameset"
#define  FLD_MAD         @"MAD"
#define  FLD_DESC        @"Description"

@interface Item : NSObject
{
    NSString * CustNum;
    NSString * ProgName;
    NSString * ItemNo;
    NSString * Nameset;
    NSString * MAD;
    NSString * Description;
}

@property (nonatomic, retain) NSString * CustNum;
@property (nonatomic, retain) NSString * ProgName;
@property (nonatomic, retain) NSString * ItemNo;
@property (nonatomic, retain) NSString * Nameset;
@property (nonatomic, retain) NSString * MAD;
@property (nonatomic, retain) NSString * Description;

+ (BOOL) deleteWhere:(NSInteger)uid;
+ (void) deleteAllItems;

+ (id) fetch:(sqlite3_stmt *)dbStmt;

+ (NSMutableArray*) getAllItems;
+ (NSMutableArray*) getItemsWhere:(NSString*)custNum;
+ (NSString*) getItemDesc:(NSString*)ItemNo;



+ (NSInteger) insertInto:(Item*) data;


@end
