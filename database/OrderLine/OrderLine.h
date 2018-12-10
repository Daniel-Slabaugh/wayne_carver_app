//
//  OrderLine.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/24/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define  TBL_ORDERLINE      @"OrderLine"
#define  FLD_ORDERNUM       @"OrderNum"
#define  FLD_LITEMNO        @"ItemNo"
#define  FLD_NAMESET        @"Nameset"
#define  FLD_QUANTITY       @"Quantity"
#define  FLD_BADITEMS       @"BadItems"
#define  FLD_PDFPRICE       @"PDFPrice"
#define  FLD_PROGNAME       @"ProgName"

@interface OrderLine : NSObject
{
    NSInteger  OrderNum;
    NSString * ItemNo;
    NSString * Nameset;
    NSInteger  Quantity;
    NSInteger  BadItems;
    NSString * PDFPrice;
    NSString * ProgName;
}

@property (nonatomic) NSInteger OrderNum;
@property (nonatomic, retain) NSString * ItemNo;
@property (nonatomic, retain) NSString * Nameset;
@property (nonatomic) NSInteger Quantity;
@property (nonatomic) NSInteger BadItems;
@property (nonatomic, retain) NSString * PDFPrice;
@property (nonatomic, retain) NSString * ProgName;



+ (BOOL) deleteWhere:(NSInteger)uid;
+ (BOOL) deleteWhere:(NSInteger)ordNum Item:(NSString*)item;
+ (void) deleteAllOrderLines;

+ (id) fetch:(sqlite3_stmt *)dbStmt;

+ (NSMutableArray*) getAllOrderLines;
+ (NSMutableArray*) getOrderLinesWhere:(NSInteger)OrderNum;


+ (NSInteger) insertInto:(OrderLine*) data;
+ (NSInteger) updateOrderLine:(OrderLine*)data;




@end
