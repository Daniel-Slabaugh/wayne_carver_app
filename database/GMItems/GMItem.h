//
//  GMItems.h
//  wayne mobile
//
//  Created by Delphi Dev Computer on 7/9/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


#define  TBL_GMITEM             @"GMItems"
#define  FLD_PKID               @"PKID"
#define  FLD_ITEMNUM            @"ItemNum"
#define  FLD_ITEMDESCRIPTION    @"ItemDescription"
#define  FLD_PRICESMALLQ        @"PriceSmallQ"
#define  FLD_PRICEMEDQ          @"PriceMedQ"
#define  FLD_PRICELARGEQ        @"PriceLargeQ"
#define  FLD_MINIMUM            @"Minimum"
#define  FLD_INCREMEMT          @"Increment"
#define  FLD_NAMEDROPONLY       @"NameDropOnly"


@interface GMItem : NSObject
{
    NSInteger PKID;
    NSString * ItemNum;
    NSString * ItemDescription;
    NSString * PriceSmallQ;
    NSString * PriceMedQ;
    NSString * PriceLargeQ;
    NSInteger Minimum;
    NSInteger Increment;
    NSInteger NameDropOnly;
}

@property (nonatomic) NSInteger PKID;
@property (nonatomic, retain) NSString * ItemNum;
@property (nonatomic, retain) NSString * ItemDescription;
@property (nonatomic, retain) NSString * PriceSmallQ;
@property (nonatomic, retain) NSString * PriceMedQ;
@property (nonatomic, retain) NSString * PriceLargeQ;
@property (nonatomic) NSInteger Minimum;
@property (nonatomic) NSInteger Increment;
@property (nonatomic) NSInteger NameDropOnly;


+ (BOOL) deleteWhere:(NSInteger)uid;
+ (void) deleteAllItems;

+ (id) fetch:(sqlite3_stmt *)dbStmt;

+ (NSMutableArray*) getAllItems;
+ (GMItem*) getItemWhere:(NSString*)itemNum;
+ (NSString*) getItemDesc:(NSString*)ItemNum;

+ (NSInteger) insertInto:(GMItem*) data;

@end
