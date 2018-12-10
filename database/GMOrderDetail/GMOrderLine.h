//
//  GMOrderLine.h
//  wayne mobile
//
//  Created by Delphi Dev Computer on 7/3/14.
//  Copyright (c) 2014 Daniel Slabaugh. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define  TBL_GMORDERLINE    @"GMOrderLine"
#define  FLD_PKID           @"PKID"
#define  FLD_ORDERNUM       @"OrderNum"
#define  FLD_LITEMNUM       @"ItemNum"
#define  FLD_QUANTITY       @"Quantity"
#define  FLD_BADITEMS       @"BadItems"
#define  FLD_PRICE          @"Price"
#define  FLD_ARTNUM         @"ArtNum"
#define  FLD_NAMEDROP       @"NameDrop"
#define  FLD_PDFPRICE       @"PDFPrice"

@interface GMOrderLine : NSObject
{
    NSInteger  PKID;
    NSInteger  OrderNum;
    NSString * ItemNum;
    NSInteger  Quantity;
    NSInteger  BadItems;
    NSString * Price;
    NSString * ArtNum;
    NSString * NameDrop;
    NSString * PDFPrice;

}

@property (nonatomic) NSInteger PKID;
@property (nonatomic) NSInteger OrderNum;
@property (nonatomic, retain) NSString * ItemNum;
@property (nonatomic) NSInteger Quantity;
@property (nonatomic) NSInteger BadItems;
@property (nonatomic, retain) NSString * Price;
@property (nonatomic, retain) NSString * ArtNum;
@property (nonatomic, retain) NSString * NameDrop;
@property (nonatomic, retain) NSString * PDFPrice;

+ (BOOL) deleteWhere:(NSInteger)uid;
+ (BOOL) deleteWhereLine:(NSInteger)PKID;
+ (void) deleteAllOrderLines;

+ (id) fetch:(sqlite3_stmt *)dbStmt;

+ (NSMutableArray*) getAllOrderLines;
+ (NSMutableArray*) getOrderLinesWhere:(NSInteger)OrderNum;


+ (NSInteger) insertInto:(GMOrderLine*) data;
+ (NSInteger) updateOrderLine:(GMOrderLine *)data;




@end
