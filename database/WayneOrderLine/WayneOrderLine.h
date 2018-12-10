//
//  WayneOrderLine.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 8/7/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define  TBL_WAYNEORDERLINE     @"WayneOrderLine"
#define  FLD_WORDERNUM          @"OrderNo"
#define  FLD_QTYORDERED         @"QtyOrdered"
#define  FLD_QTYSHIPPED         @"QtyShipped"
#define  FLD_QTYBACKORDERED     @"QtyBackordered"
#define  FLD_WITEMNO            @"ItemNo"
#define  FLD_ITEMDESC           @"ItemDesc"
#define  FLD_PRICEPERPIECE      @"PricePerPiece"
#define  FLD_LINETOTAL          @"LineTotal"


@interface WayneOrderLine : NSObject
{
    NSInteger OrderNum;
    NSInteger QtyOrdered;
    NSInteger QtyShipped;
    NSInteger QtyBackordered;
    NSString * ItemNo;
    NSString * ItemDesc;
    float PricePerPiece;
    float LineTotal;

}

@property (nonatomic) NSInteger OrderNum;
@property (nonatomic) NSInteger QtyOrdered;
@property (nonatomic) NSInteger QtyShipped;
@property (nonatomic) NSInteger QtyBackordered;
@property (nonatomic, retain) NSString * ItemNo;
@property (nonatomic, retain) NSString * ItemDesc;
@property (nonatomic) float PricePerPiece;
@property (nonatomic) float LineTotal;


+ (void) deleteAllOrderLines;
+ (BOOL) deleteWhereOrderNum:(NSInteger)orderNum;


+ (id) fetch:(sqlite3_stmt *)dbStmt;

+ (NSMutableArray*) getAllOrderLines;
+ (NSMutableArray*) getOrderLinesWhere:(NSInteger)OrderNum;

+ (NSInteger) beginInsert;
+ (NSInteger) endInsert;
+ (NSInteger) insertInto:(WayneOrderLine*) data;




@end


