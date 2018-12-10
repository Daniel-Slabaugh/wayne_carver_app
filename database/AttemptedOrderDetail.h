//
//  AttemptedOrderDetail.h
//  HeartwoodApp
//
//  Created by Daniel Slabaugh on 7/24/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "AttemptedOrderLine.h"

#define  TBL_ATTEMPTEDORDERDETAIL   @"AttemptedOrderDetail"
#define  FLD_ORDERNUM               @"OrderNum"
#define  FLD_DITEMNO                @"ItemNo"
#define  FLD_NAMESET                @"Nameset"
#define  FLD_PROGNAME               @"ProgName"
#define  FLD_NAME                   @"Name"
#define  FLD_NAMETYPE               @"NameType"
#define  FLD_QTYORDERED             @"QtyOrdered"



@interface AttemptedOrderDetail : NSObject
{
    NSInteger OrderNum;
    NSString * ItemNo;
    NSString * Nameset;
    NSString * ProgName;
    NSString * Name;
    NSString * NameType;
    NSInteger QtyOrdered;
}

@property (nonatomic) NSInteger OrderNum;
@property (nonatomic, retain) NSString * ItemNo;
@property (nonatomic, retain) NSString * Nameset;
@property (nonatomic, retain) NSString * ProgName;
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSString * NameType;
@property (nonatomic) NSInteger QtyOrdered;



+ (BOOL) deleteWhere:(NSInteger)uid;
+ (void) deleteAllOrderDetails;

+ (id) fetch:(sqlite3_stmt *)dbStmt;

+ (NSMutableArray*) getAllOrderDetails;
+ (NSMutableArray*) getOrderDetailsWhereOrder:(AttemptedOrderLine*)order;
+ (NSMutableArray*) getOrderDetailsWhereOrderNumber:(NSInteger)orderNum;


+ (NSInteger) beginOrderDetailInsert;
+ (NSInteger) endOrderDetailInsert;
+ (NSInteger) insertInto:(AttemptedOrderDetail*) data;
+ (NSInteger) updateOrderDetail:(AttemptedOrderDetail*) data;





@end
