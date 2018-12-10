//
//  PDFRenderer.m
//  PDFRenderer
//
//  Created by Yuichi Fujiki on 3/28/12.
//  Copyright (c) 2012 Daniel Slabaugh. All rights reserved.
//

#import "PDFRenderer.h"
#import "User.h"
#import "OrderLine.h"
#import "OrderDetail.h"
#import "Address.h"
#import "Customer.h"
#import "Item.h"
#import "WayneOrderLine.h"
#import "GMOrderLine.h"
#import "GMItem.h"


@implementation PDFRenderer

+(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frame fontName:(NSString *)fontName fontSize:(int) fontSize {
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
    
    // Prepare the text using a Core Text Framesetter.
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)fontName, fontSize, NULL);
    CFStringRef keys[] = { kCTFontAttributeName };
    CFTypeRef values[] = { font };
    CFDictionaryRef attr = CFDictionaryCreate(NULL, (const void **)&keys, (const void **)&values,
                                              sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, attr);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(currentText);
    
    CGRect frameRect = (CGRect){frame.origin.x, -1 * frame.origin.y, frame.size};
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    // CGContextTranslateCTM(currentContext, 0, 100);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    // Revert coordinate
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(frameSetter);
}

+(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 3.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    //    CGFloat components[] = {0.2, 0.2, 0.2, 0.3};
    //    CGColorCreate(colorspace, components);
    
    
    CGColorRef color = [[[UIColor alloc] initWithRed:5.0 / 255 green:63.0 / 255 blue:65.0 / 255 alpha:1.0]CGColor];
    
    CGContextSetStrokeColorWithColor(context, color);
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
//    CGColorRelease(color);
    
}

+(void)drawImage:(UIImage*)image inRect:(CGRect)rect {
    [image drawInRect:rect];
}

+(void)summaryPDF:(NSString*)filePath forOrder:(OrderHeader *)orderHeader includePrice:(BOOL)price {
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPage();
    
    // insert wayne carver header
    UIImage* logo = [UIImage imageNamed:@"logo.png"];
    CGRect frame = CGRectMake(20, 20, 592, 120);
    [PDFRenderer drawImage:logo inRect:frame];
    
    // get customer to use
    Customer *customer = [Customer getCustomerWhereCustomerNumber:orderHeader.CustNum];
    
    [PDFRenderer drawText:@"Proposed Order" inFrame:CGRectMake(30, 140, 400, -50) fontName:@"TimesNewRomanPSMT" fontSize:36];
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"Created: %@", orderHeader.DateCreated] inFrame:CGRectMake(30, 180, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:15];
    
    [PDFRenderer drawText:@"NOT AN INVOICE" inFrame:CGRectMake(290, 163, 400, -50) fontName:@"TimesNewRomanPSMT" fontSize:36];

    
    // draw box lines
    CGPoint from = CGPointMake(20, 200);
    CGPoint to = CGPointMake(592, 200);
    [PDFRenderer drawLineFromPoint:from toPoint:to];
    CGPoint from1 = CGPointMake(306, 200);
    CGPoint to1 = CGPointMake(306, 320);
    [PDFRenderer drawLineFromPoint:from1 toPoint:to1];
    CGPoint from2 = CGPointMake(20, 200);
    CGPoint to2 = CGPointMake(20, 320);
    [PDFRenderer drawLineFromPoint:from2 toPoint:to2];
    CGPoint from3 = CGPointMake(592, 200);
    CGPoint to3 = CGPointMake(592, 320);
    [PDFRenderer drawLineFromPoint:from3 toPoint:to3];
    CGPoint from4 = CGPointMake(20, 320);
    CGPoint to4 = CGPointMake(592, 320);
    [PDFRenderer drawLineFromPoint:from4 toPoint:to4];
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"Sold To: %@", customer.CustName] inFrame:CGRectMake(30, 210, 300, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    //get user from database if there is one
    NSMutableArray *usersArray = [User getAllUsers];
    if ([usersArray count] != 0) {
        User *user = [usersArray objectAtIndex:0];
        [PDFRenderer drawText:[NSString stringWithFormat:@"Salesman: %@%@", user.FirstName, user.LastName] inFrame:CGRectMake(30, 225, 300, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    }
    
    if (![orderHeader.ShipMethod isEqual:@"(null)"]) {
        [PDFRenderer drawText:[NSString stringWithFormat:@"Ship Via: %@", orderHeader.ShipMethod] inFrame:CGRectMake(30, 240, 300, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    }
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"Requested Ship Date: %@", orderHeader.DateToShip] inFrame:CGRectMake(30, 255, 400, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"P.O. Number: %@", orderHeader.PONum] inFrame:CGRectMake(30, 270, 400, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    
    
    if ([orderHeader.StoreID isEqual:@"(null)"]) {
        [PDFRenderer drawText:[NSString stringWithFormat:@"Ship To: \n No Destination Selected"] inFrame:CGRectMake(336, 210, 300, -150) fontName:@"TimesNewRomanPSMT" fontSize:12];
    } else {
        Address *address = [Address getAddressWhereStore:orderHeader.StoreID];
        if ([address.Addr2 isEqual:@"<null>"]) {
            address.Addr2 = @"";
        }
        [PDFRenderer drawText:[NSString stringWithFormat:@"Ship To: \n%@\n%@, %@\n%@\n%@ %@", orderHeader.StoreID, address.Addr1, address.Addr2, address.City, address.State, address.Zip] inFrame:CGRectMake(330, 210, 300, -150) fontName:@"TimesNewRomanPSMT" fontSize:12];
    }
    
    // draw notes lines
    CGPoint from5 = CGPointMake(20, 420);
    CGPoint to5 = CGPointMake(592, 420);
    [PDFRenderer drawLineFromPoint:from5 toPoint:to5];
    CGPoint from6 = CGPointMake(20, 320);
    CGPoint to6 = CGPointMake(20, 420);
    [PDFRenderer drawLineFromPoint:from6 toPoint:to6];
    CGPoint from7 = CGPointMake(592, 320);
    CGPoint to7 = CGPointMake(592, 420);
    [PDFRenderer drawLineFromPoint:from7 toPoint:to7];
    
    
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
    if ((NSNull *)orderHeader.Notes != [NSNull null]) {
        orderHeader.Notes = [[orderHeader.Notes componentsSeparatedByCharactersInSet:charactersToRemove ]
                             componentsJoinedByString:@", "];
    }
    [PDFRenderer drawText:[NSString stringWithFormat:@"Notes: %@", orderHeader.Notes] inFrame:CGRectMake(30, 325, 530, -100) fontName:@"TimesNewRomanPSMT" fontSize:12];
    
    int x = 440;
    
    
    [PDFRenderer drawText:@"Item #" inFrame:CGRectMake(30, x, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    [PDFRenderer drawText:@"Item Description" inFrame:CGRectMake(100, x, 250, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    [PDFRenderer drawText:@"Qty Ordered" inFrame:CGRectMake(340, x, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    if (price) {
        [PDFRenderer drawText:@"Price" inFrame:CGRectMake(430, x, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
        [PDFRenderer drawText:@"Amount" inFrame:CGRectMake(520, x, 300, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    }

    x += 17;
    
    // draw notes lines
    CGPoint from8 = CGPointMake(30, x);
    CGPoint to8 = CGPointMake(70, x);
    [PDFRenderer drawLineFromPoint:from8 toPoint:to8];
    CGPoint from9 = CGPointMake(100, x);
    CGPoint to9 = CGPointMake(205, x);
    [PDFRenderer drawLineFromPoint:from9 toPoint:to9];
    CGPoint froma = CGPointMake(340, x);
    CGPoint toa = CGPointMake(420, x);
    [PDFRenderer drawLineFromPoint:froma toPoint:toa];
    CGPoint fromb = CGPointMake(430, x);
    CGPoint tob = CGPointMake(510, x);
    [PDFRenderer drawLineFromPoint:fromb toPoint:tob];
    CGPoint fromc = CGPointMake(520, x);
    CGPoint toc = CGPointMake(590, x);
    [PDFRenderer drawLineFromPoint:fromc toPoint:toc];
    
    x += 13;
    
    // get order lines
    NSMutableArray *orderLines = [OrderLine getOrderLinesWhere:orderHeader.OrderNum];
    float count = 0;
    for (OrderLine* orderline in orderLines)
    {
        [PDFRenderer drawText:[NSString stringWithFormat:@"%@", orderline.ItemNo] inFrame:CGRectMake(30, x, 70, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        NSString *desc = [Item getItemDesc:orderline.ItemNo];
        [PDFRenderer drawText:[NSString stringWithFormat:@"%@", desc] inFrame:CGRectMake(100, x, 240, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        [PDFRenderer drawText:[NSString stringWithFormat:@"%ld", (long)orderline.Quantity] inFrame:CGRectMake(340, x, 65, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        if (price) {
            [PDFRenderer drawText:[NSString stringWithFormat:@"%.2f", [orderline.PDFPrice doubleValue]] inFrame:CGRectMake(430, x, 65, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
            [PDFRenderer drawText:[NSString stringWithFormat:@"%.2f", ([orderline.PDFPrice doubleValue] * orderline.Quantity)] inFrame:CGRectMake(520, x, 65, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        }
    
        count +=  orderline.Quantity * [orderline.PDFPrice doubleValue];
        x += 20;
        
        if (x > 750) {
            
            x = 30;
            
            [PDFRenderer drawText:@"Item #" inFrame:CGRectMake(30, x, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            [PDFRenderer drawText:@"Item Description" inFrame:CGRectMake(100, x, 250, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            [PDFRenderer drawText:@"Qty Ordered" inFrame:CGRectMake(340, x, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            if (price) {
                [PDFRenderer drawText:@"Price" inFrame:CGRectMake(430, x, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
                [PDFRenderer drawText:@"Amount" inFrame:CGRectMake(520, x, 300, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            }

            
            x += 17;
            
            // draw notes lines
            CGPoint from8 = CGPointMake(30, x);
            CGPoint to8 = CGPointMake(70, x);
            [PDFRenderer drawLineFromPoint:from8 toPoint:to8];
            CGPoint from9 = CGPointMake(100, x);
            CGPoint to9 = CGPointMake(205, x);
            [PDFRenderer drawLineFromPoint:from9 toPoint:to9];
            CGPoint froma = CGPointMake(340, x);
            CGPoint toa = CGPointMake(420, x);
            [PDFRenderer drawLineFromPoint:froma toPoint:toa];
            CGPoint fromb = CGPointMake(430, x);
            CGPoint tob = CGPointMake(510, x);
            [PDFRenderer drawLineFromPoint:fromb toPoint:tob];
            CGPoint fromc = CGPointMake(520, x);
            CGPoint toc = CGPointMake(590, x);
            [PDFRenderer drawLineFromPoint:fromc toPoint:toc];
            
            x += 13;
        }
    }
    
    
    CGPoint fromd = CGPointMake(20, x-3);
    CGPoint tod = CGPointMake(592, x-3);
    [PDFRenderer drawLineFromPoint:fromd toPoint:tod];
    
    if (price) {
        [PDFRenderer drawText:[NSString stringWithFormat:@"Total: %.2f", count] inFrame:CGRectMake(467, x+10, 200, -25) fontName:@"TimesNewRomanPSMT" fontSize:20];
    }
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}

+(void)fullPDF:(NSString*)filePath forOrder:(OrderHeader *)orderHeader includePrice:(BOOL)price {
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPage();
    
    // insert wayne carver header
    UIImage* logo = [UIImage imageNamed:@"logo.png"];
    CGRect frame = CGRectMake(20, 20, 592, 120);
    [PDFRenderer drawImage:logo inRect:frame];
    
    // get customer to use
    Customer *customer = [Customer getCustomerWhereCustomerNumber:orderHeader.CustNum];
    
    [PDFRenderer drawText:@"Proposed Order" inFrame:CGRectMake(30, 140, 400, -50) fontName:@"TimesNewRomanPSMT" fontSize:36];
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"Created: %@", orderHeader.DateCreated] inFrame:CGRectMake(30, 180, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:15];
    
    [PDFRenderer drawText:@"NOT AN INVOICE" inFrame:CGRectMake(290, 163, 400, -50) fontName:@"TimesNewRomanPSMT" fontSize:36];
    
    
    // draw box lines
    CGPoint from = CGPointMake(20, 200);
    CGPoint to = CGPointMake(592, 200);
    [PDFRenderer drawLineFromPoint:from toPoint:to];
    CGPoint from1 = CGPointMake(306, 200);
    CGPoint to1 = CGPointMake(306, 320);
    [PDFRenderer drawLineFromPoint:from1 toPoint:to1];
    CGPoint from2 = CGPointMake(20, 200);
    CGPoint to2 = CGPointMake(20, 320);
    [PDFRenderer drawLineFromPoint:from2 toPoint:to2];
    CGPoint from3 = CGPointMake(592, 200);
    CGPoint to3 = CGPointMake(592, 320);
    [PDFRenderer drawLineFromPoint:from3 toPoint:to3];
    CGPoint from4 = CGPointMake(20, 320);
    CGPoint to4 = CGPointMake(592, 320);
    [PDFRenderer drawLineFromPoint:from4 toPoint:to4];
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"Sold To: %@", customer.CustName] inFrame:CGRectMake(30, 210, 300, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    //get user from database if there is one
    NSMutableArray *usersArray = [User getAllUsers];
    if ([usersArray count] != 0) {
        User *user = [usersArray objectAtIndex:0];
        [PDFRenderer drawText:[NSString stringWithFormat:@"Salesman: %@%@", user.FirstName, user.LastName] inFrame:CGRectMake(30, 225, 300, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    }
    
    if (![orderHeader.ShipMethod isEqual:@"(null)"]) {
        [PDFRenderer drawText:[NSString stringWithFormat:@"Ship Via: %@", orderHeader.ShipMethod] inFrame:CGRectMake(30, 240, 300, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    }
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"Requested Ship Date: %@", orderHeader.DateToShip] inFrame:CGRectMake(30, 255, 400, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"P.O. Number: %@", orderHeader.PONum] inFrame:CGRectMake(30, 270, 400, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    
    
    if ([orderHeader.StoreID isEqual:@"(null)"]) {
        [PDFRenderer drawText:[NSString stringWithFormat:@"Ship To: \n No Destination Selected"] inFrame:CGRectMake(336, 210, 300, -150) fontName:@"TimesNewRomanPSMT" fontSize:12];
    } else {
        Address *address = [Address getAddressWhereStore:orderHeader.StoreID];
        if ([address.Addr2 isEqual:@"<null>"]) {
            address.Addr2 = @"";
        }
        [PDFRenderer drawText:[NSString stringWithFormat:@"Ship To: \n%@\n%@, %@\n%@\n%@ %@", orderHeader.StoreID, address.Addr1, address.Addr2, address.City, address.State, address.Zip] inFrame:CGRectMake(330, 210, 300, -150) fontName:@"TimesNewRomanPSMT" fontSize:12];
    }
    
    // draw notes lines
    CGPoint from5 = CGPointMake(20, 420);
    CGPoint to5 = CGPointMake(592, 420);
    [PDFRenderer drawLineFromPoint:from5 toPoint:to5];
    CGPoint from6 = CGPointMake(20, 320);
    CGPoint to6 = CGPointMake(20, 420);
    [PDFRenderer drawLineFromPoint:from6 toPoint:to6];
    CGPoint from7 = CGPointMake(592, 320);
    CGPoint to7 = CGPointMake(592, 420);
    [PDFRenderer drawLineFromPoint:from7 toPoint:to7];
    
    
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
    if ((NSNull *)orderHeader.Notes != [NSNull null]) {
        orderHeader.Notes = [[orderHeader.Notes componentsSeparatedByCharactersInSet:charactersToRemove ]
                             componentsJoinedByString:@", "];
    }
    [PDFRenderer drawText:[NSString stringWithFormat:@"Notes: %@", orderHeader.Notes] inFrame:CGRectMake(30, 325, 530, -100) fontName:@"TimesNewRomanPSMT" fontSize:12];
    
    int x = 440;
    
    
    [PDFRenderer drawText:@"Item #" inFrame:CGRectMake(30, x, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    [PDFRenderer drawText:@"Item Description" inFrame:CGRectMake(100, x, 250, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    [PDFRenderer drawText:@"Qty Ordered" inFrame:CGRectMake(340, x, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    if (price) {
        [PDFRenderer drawText:@"Price" inFrame:CGRectMake(430, x, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
        [PDFRenderer drawText:@"Amount" inFrame:CGRectMake(520, x, 300, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    }
    
    x += 17;
    
    // draw notes lines
    CGPoint from8 = CGPointMake(30, x);
    CGPoint to8 = CGPointMake(70, x);
    [PDFRenderer drawLineFromPoint:from8 toPoint:to8];
    CGPoint from9 = CGPointMake(100, x);
    CGPoint to9 = CGPointMake(205, x);
    [PDFRenderer drawLineFromPoint:from9 toPoint:to9];
    CGPoint froma = CGPointMake(340, x);
    CGPoint toa = CGPointMake(420, x);
    [PDFRenderer drawLineFromPoint:froma toPoint:toa];
    CGPoint fromb = CGPointMake(430, x);
    CGPoint tob = CGPointMake(510, x);
    [PDFRenderer drawLineFromPoint:fromb toPoint:tob];
    CGPoint fromc = CGPointMake(520, x);
    CGPoint toc = CGPointMake(590, x);
    [PDFRenderer drawLineFromPoint:fromc toPoint:toc];
    
    x += 13;
    
    // get order lines
    NSMutableArray *orderLines = [OrderLine getOrderLinesWhere:orderHeader.OrderNum];
    float count = 0;
    for (OrderLine* orderline in orderLines)
    {
        [PDFRenderer drawText:[NSString stringWithFormat:@"%@", orderline.ItemNo] inFrame:CGRectMake(30, x, 70, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        NSString *desc = [Item getItemDesc:orderline.ItemNo];
        [PDFRenderer drawText:[NSString stringWithFormat:@"%@", desc] inFrame:CGRectMake(100, x, 240, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        [PDFRenderer drawText:[NSString stringWithFormat:@"%ld", (long)orderline.Quantity] inFrame:CGRectMake(340, x, 65, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        if (price) {
            [PDFRenderer drawText:[NSString stringWithFormat:@"%.2f", [orderline.PDFPrice doubleValue]] inFrame:CGRectMake(430, x, 65, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
            [PDFRenderer drawText:[NSString stringWithFormat:@"%.2f", ([orderline.PDFPrice doubleValue] * orderline.Quantity)] inFrame:CGRectMake(520, x, 65, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        }
        
        count +=  orderline.Quantity * [orderline.PDFPrice doubleValue];
        x += 20;
        
        if (x > 750) {
            
            x = 30;
            
            [PDFRenderer drawText:@"Item #" inFrame:CGRectMake(30, x, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            [PDFRenderer drawText:@"Item Description" inFrame:CGRectMake(100, x, 250, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            [PDFRenderer drawText:@"Qty Ordered" inFrame:CGRectMake(340, x, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            if (price) {
                [PDFRenderer drawText:@"Price" inFrame:CGRectMake(430, x, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
                [PDFRenderer drawText:@"Amount" inFrame:CGRectMake(520, x, 300, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            }
            
            
            x += 17;
            
            // draw notes lines
            CGPoint from8 = CGPointMake(30, x);
            CGPoint to8 = CGPointMake(70, x);
            [PDFRenderer drawLineFromPoint:from8 toPoint:to8];
            CGPoint from9 = CGPointMake(100, x);
            CGPoint to9 = CGPointMake(205, x);
            [PDFRenderer drawLineFromPoint:from9 toPoint:to9];
            CGPoint froma = CGPointMake(340, x);
            CGPoint toa = CGPointMake(420, x);
            [PDFRenderer drawLineFromPoint:froma toPoint:toa];
            CGPoint fromb = CGPointMake(430, x);
            CGPoint tob = CGPointMake(510, x);
            [PDFRenderer drawLineFromPoint:fromb toPoint:tob];
            CGPoint fromc = CGPointMake(520, x);
            CGPoint toc = CGPointMake(590, x);
            [PDFRenderer drawLineFromPoint:fromc toPoint:toc];
            
            x += 13;
        }
    }
    
    
    CGPoint fromd = CGPointMake(20, x-3);
    CGPoint tod = CGPointMake(592, x-3);
    [PDFRenderer drawLineFromPoint:fromd toPoint:tod];
    
    if (price) {
        [PDFRenderer drawText:[NSString stringWithFormat:@"Total: %.2f", count] inFrame:CGRectMake(467, x+10, 200, -25) fontName:@"TimesNewRomanPSMT" fontSize:20];
    }

    
    for (OrderLine * orderLine in orderLines) {
        UIGraphicsBeginPDFPage();
        
        
        
        [PDFRenderer drawText:@"Proposed Order" inFrame:CGRectMake(30, 30, 400, -50) fontName:@"TimesNewRomanPSMT" fontSize:36];
        [PDFRenderer drawText:[NSString stringWithFormat:@"%@", orderLine.ItemNo] inFrame:CGRectMake(30, 80, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:20];
        
        // create x and y coodinates to use for names
        int x = 30;
        int y = 100;
        
        // create count for all orderdetails
        int countNames = 2;
        int countLines = 1;
        
        [PDFRenderer drawText:@"Name" inFrame:CGRectMake(x, y, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
        [PDFRenderer drawText:@"Qty" inFrame:CGRectMake(x+100, y, 50, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
        y += 20;
        
        NSMutableArray *orderDetails = [OrderDetail getOrderDetailsWhereOrder:orderLine];
        
        
        for (OrderDetail * orderDetail in orderDetails) {
            if (orderDetail.QtyOrdered > 0) {
                
                [PDFRenderer drawText:[NSString stringWithFormat:@"%@", orderDetail.Name] inFrame:CGRectMake(x, y, 95, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
                [PDFRenderer drawText:[NSString stringWithFormat:@"%ld", (long)orderDetail.QtyOrdered] inFrame:CGRectMake(x+100, y, 50, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
                
                countNames += 1;
                y += 15;
                
                if (countNames == 45) {
                    if (countLines == 4) {
                        UIGraphicsBeginPDFPage();
                        [PDFRenderer drawText:@"Proposed Order" inFrame:CGRectMake(30, 30, 400, -50) fontName:@"TimesNewRomanPSMT" fontSize:36];
                        [PDFRenderer drawText:[NSString stringWithFormat:@"%@", orderLine.ItemNo] inFrame:CGRectMake(30, 80, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:20];
                        
                        // create x and y coodinates to use for names
                        x = 30;
                        y = 100;
                        
                        // create count for all orderdetails
                        countNames = 2;
                        countLines = 1;
                        
                        [PDFRenderer drawText:@"Name" inFrame:CGRectMake(x, y, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
                        [PDFRenderer drawText:@"Qty" inFrame:CGRectMake(x+100, y, 50, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
                        y += 20;
                    } else {
                        // update x and y coodinates for next line
                        x += 150;
                        y = 75;
                        
                        [PDFRenderer drawText:@"Name" inFrame:CGRectMake(x, y, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
                        [PDFRenderer drawText:@"Qty" inFrame:CGRectMake(x+100, y, 50, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
                        y += 20;
                        countNames = 0;
                        countLines++;
                    }
                }
            }
        }
        
    }
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}

+(void)postedPDF:(NSString*)filePath forOrder:(OrderHeader *)orderHeader includePrice:(BOOL)price {
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPage();
    
    // insert wayne carver header
    UIImage* logo = [UIImage imageNamed:@"logo.png"];
    CGRect frame = CGRectMake(20, 20, 592, 120);
    [PDFRenderer drawImage:logo inRect:frame];
    
    // get customer to use
    Customer *customer = [Customer getCustomerWhereCustomerNumber:orderHeader.CustNum];
    
    [PDFRenderer drawText:@"iPad History Order" inFrame:CGRectMake(30, 140, 400, -50) fontName:@"TimesNewRomanPSMT" fontSize:36];
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"Created: %@", orderHeader.DateCreated] inFrame:CGRectMake(30, 180, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:15];
    
    [PDFRenderer drawText:@"NOT AN INVOICE" inFrame:CGRectMake(290, 163, 400, -50) fontName:@"TimesNewRomanPSMT" fontSize:36];
    
    [PDFRenderer drawText:@"(Possible Duplicate)" inFrame:CGRectMake(290, 163, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:36];
    
    
    // draw box lines
    CGPoint from = CGPointMake(20, 200);
    CGPoint to = CGPointMake(592, 200);
    [PDFRenderer drawLineFromPoint:from toPoint:to];
    CGPoint from1 = CGPointMake(306, 200);
    CGPoint to1 = CGPointMake(306, 320);
    [PDFRenderer drawLineFromPoint:from1 toPoint:to1];
    CGPoint from2 = CGPointMake(20, 200);
    CGPoint to2 = CGPointMake(20, 320);
    [PDFRenderer drawLineFromPoint:from2 toPoint:to2];
    CGPoint from3 = CGPointMake(592, 200);
    CGPoint to3 = CGPointMake(592, 320);
    [PDFRenderer drawLineFromPoint:from3 toPoint:to3];
    CGPoint from4 = CGPointMake(20, 320);
    CGPoint to4 = CGPointMake(592, 320);
    [PDFRenderer drawLineFromPoint:from4 toPoint:to4];
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"Sold To: %@", customer.CustName] inFrame:CGRectMake(30, 210, 300, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    //get user from database if there is one
    NSMutableArray *usersArray = [User getAllUsers];
    if ([usersArray count] != 0) {
        User *user = [usersArray objectAtIndex:0];
        [PDFRenderer drawText:[NSString stringWithFormat:@"Salesman: %@%@", user.FirstName, user.LastName] inFrame:CGRectMake(30, 225, 300, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    }
    
    if (![orderHeader.ShipMethod isEqual:@"(null)"]) {
        [PDFRenderer drawText:[NSString stringWithFormat:@"Ship Via: %@", orderHeader.ShipMethod] inFrame:CGRectMake(30, 240, 300, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    }
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"Requested Ship Date: %@", orderHeader.DateToShip] inFrame:CGRectMake(30, 255, 400, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"P.O. Number: %@", orderHeader.PONum] inFrame:CGRectMake(30, 270, 400, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    
    
    if ([orderHeader.StoreID isEqual:@"(null)"]) {
        [PDFRenderer drawText:[NSString stringWithFormat:@"Ship To: \n No Destination Selected"] inFrame:CGRectMake(336, 210, 300, -150) fontName:@"TimesNewRomanPSMT" fontSize:12];
    } else {
        Address *address = [Address getAddressWhereStore:orderHeader.StoreID];
        if ([address.Addr2 isEqual:@"<null>"]) {
            address.Addr2 = @"";
        }
        [PDFRenderer drawText:[NSString stringWithFormat:@"Ship To: \n%@\n%@, %@\n%@\n%@ %@", orderHeader.StoreID, address.Addr1, address.Addr2, address.City, address.State, address.Zip] inFrame:CGRectMake(330, 210, 300, -150) fontName:@"TimesNewRomanPSMT" fontSize:12];
    }
    
    // draw notes lines
    CGPoint from5 = CGPointMake(20, 420);
    CGPoint to5 = CGPointMake(592, 420);
    [PDFRenderer drawLineFromPoint:from5 toPoint:to5];
    CGPoint from6 = CGPointMake(20, 320);
    CGPoint to6 = CGPointMake(20, 420);
    [PDFRenderer drawLineFromPoint:from6 toPoint:to6];
    CGPoint from7 = CGPointMake(592, 320);
    CGPoint to7 = CGPointMake(592, 420);
    [PDFRenderer drawLineFromPoint:from7 toPoint:to7];
    
    
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
    if ((NSNull *)orderHeader.Notes != [NSNull null]) {
        orderHeader.Notes = [[orderHeader.Notes componentsSeparatedByCharactersInSet:charactersToRemove ]
                             componentsJoinedByString:@", "];
    }
    [PDFRenderer drawText:[NSString stringWithFormat:@"Notes: %@", orderHeader.Notes] inFrame:CGRectMake(30, 325, 530, -100) fontName:@"TimesNewRomanPSMT" fontSize:12];
    
    int x = 440;
    
    
    [PDFRenderer drawText:@"Item #" inFrame:CGRectMake(30, x, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    [PDFRenderer drawText:@"Item Description" inFrame:CGRectMake(100, x, 250, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    [PDFRenderer drawText:@"Qty Ordered" inFrame:CGRectMake(340, x, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    if (price) {
        [PDFRenderer drawText:@"Price" inFrame:CGRectMake(430, x, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
        [PDFRenderer drawText:@"Amount" inFrame:CGRectMake(520, x, 300, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    }
    
    x += 17;
    
    // draw notes lines
    CGPoint from8 = CGPointMake(30, x);
    CGPoint to8 = CGPointMake(70, x);
    [PDFRenderer drawLineFromPoint:from8 toPoint:to8];
    CGPoint from9 = CGPointMake(100, x);
    CGPoint to9 = CGPointMake(205, x);
    [PDFRenderer drawLineFromPoint:from9 toPoint:to9];
    CGPoint froma = CGPointMake(340, x);
    CGPoint toa = CGPointMake(420, x);
    [PDFRenderer drawLineFromPoint:froma toPoint:toa];
    CGPoint fromb = CGPointMake(430, x);
    CGPoint tob = CGPointMake(510, x);
    [PDFRenderer drawLineFromPoint:fromb toPoint:tob];
    CGPoint fromc = CGPointMake(520, x);
    CGPoint toc = CGPointMake(590, x);
    [PDFRenderer drawLineFromPoint:fromc toPoint:toc];
    
    x += 13;
    
    // get order lines
    NSMutableArray *orderLines = [OrderLine getOrderLinesWhere:orderHeader.OrderNum];
    float count = 0;
    for (OrderLine* orderline in orderLines)
    {
        [PDFRenderer drawText:[NSString stringWithFormat:@"%@", orderline.ItemNo] inFrame:CGRectMake(30, x, 70, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        NSString *desc = [Item getItemDesc:orderline.ItemNo];
        [PDFRenderer drawText:[NSString stringWithFormat:@"%@", desc] inFrame:CGRectMake(100, x, 240, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        [PDFRenderer drawText:[NSString stringWithFormat:@"%ld", (long)orderline.Quantity] inFrame:CGRectMake(340, x, 65, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        if (price) {
            [PDFRenderer drawText:[NSString stringWithFormat:@"%.2f", [orderline.PDFPrice doubleValue]] inFrame:CGRectMake(430, x, 65, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
            [PDFRenderer drawText:[NSString stringWithFormat:@"%.2f", ([orderline.PDFPrice doubleValue] * orderline.Quantity)] inFrame:CGRectMake(520, x, 65, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        }
        
        count +=  orderline.Quantity * [orderline.PDFPrice doubleValue];
        x += 20;
        
        if (x > 750) {
            
            x = 30;
            
            [PDFRenderer drawText:@"Item #" inFrame:CGRectMake(30, x, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            [PDFRenderer drawText:@"Item Description" inFrame:CGRectMake(100, x, 250, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            [PDFRenderer drawText:@"Qty Ordered" inFrame:CGRectMake(340, x, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            if (price) {
                [PDFRenderer drawText:@"Price" inFrame:CGRectMake(430, x, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
                [PDFRenderer drawText:@"Amount" inFrame:CGRectMake(520, x, 300, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            }
            
            
            x += 17;
            
            // draw notes lines
            CGPoint from8 = CGPointMake(30, x);
            CGPoint to8 = CGPointMake(70, x);
            [PDFRenderer drawLineFromPoint:from8 toPoint:to8];
            CGPoint from9 = CGPointMake(100, x);
            CGPoint to9 = CGPointMake(205, x);
            [PDFRenderer drawLineFromPoint:from9 toPoint:to9];
            CGPoint froma = CGPointMake(340, x);
            CGPoint toa = CGPointMake(420, x);
            [PDFRenderer drawLineFromPoint:froma toPoint:toa];
            CGPoint fromb = CGPointMake(430, x);
            CGPoint tob = CGPointMake(510, x);
            [PDFRenderer drawLineFromPoint:fromb toPoint:tob];
            CGPoint fromc = CGPointMake(520, x);
            CGPoint toc = CGPointMake(590, x);
            [PDFRenderer drawLineFromPoint:fromc toPoint:toc];
            
            x += 13;
        }
    }
    
    
    CGPoint fromd = CGPointMake(20, x-3);
    CGPoint tod = CGPointMake(592, x-3);
    [PDFRenderer drawLineFromPoint:fromd toPoint:tod];
    
    if (price) {
        [PDFRenderer drawText:[NSString stringWithFormat:@"Total: %.2f", count] inFrame:CGRectMake(467, x+10, 200, -25) fontName:@"TimesNewRomanPSMT" fontSize:20];
    }
    
    
    for (OrderLine * orderLine in orderLines) {
        UIGraphicsBeginPDFPage();
        
        
        
        [PDFRenderer drawText:@"Proposed Order" inFrame:CGRectMake(30, 30, 400, -50) fontName:@"TimesNewRomanPSMT" fontSize:36];
        [PDFRenderer drawText:[NSString stringWithFormat:@"%@", orderLine.ItemNo] inFrame:CGRectMake(30, 80, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:20];
        
        // create x and y coodinates to use for names
        int x = 30;
        int y = 100;
        
        // create count for all orderdetails
        int countNames = 2;
        int countLines = 1;
        
        [PDFRenderer drawText:@"Name" inFrame:CGRectMake(x, y, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
        [PDFRenderer drawText:@"Qty" inFrame:CGRectMake(x+100, y, 50, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
        y += 20;
        
        NSMutableArray *orderDetails = [OrderDetail getOrderDetailsWhereOrder:orderLine];
        
        
        for (OrderDetail * orderDetail in orderDetails) {
            if (orderDetail.QtyOrdered > 0) {
                
                [PDFRenderer drawText:[NSString stringWithFormat:@"%@", orderDetail.Name] inFrame:CGRectMake(x, y, 95, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
                [PDFRenderer drawText:[NSString stringWithFormat:@"%ld", (long)orderDetail.QtyOrdered] inFrame:CGRectMake(x+100, y, 50, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
                
                countNames += 1;
                y += 15;
                
                if (countNames == 45) {
                    if (countLines == 4) {
                        UIGraphicsBeginPDFPage();
                        [PDFRenderer drawText:@"Proposed Order" inFrame:CGRectMake(30, 30, 400, -50) fontName:@"TimesNewRomanPSMT" fontSize:36];
                        [PDFRenderer drawText:[NSString stringWithFormat:@"%@", orderLine.ItemNo] inFrame:CGRectMake(30, 80, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:20];
                        
                        // create x and y coodinates to use for names
                        x = 30;
                        y = 100;
                        
                        // create count for all orderdetails
                        countNames = 2;
                        countLines = 1;
                        
                        [PDFRenderer drawText:@"Name" inFrame:CGRectMake(x, y, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
                        [PDFRenderer drawText:@"Qty" inFrame:CGRectMake(x+100, y, 50, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
                        y += 20;
                    } else {
                        // update x and y coodinates for next line
                        x += 150;
                        y = 75;
                        
                        [PDFRenderer drawText:@"Name" inFrame:CGRectMake(x, y, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
                        [PDFRenderer drawText:@"Qty" inFrame:CGRectMake(x+100, y, 50, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
                        y += 20;
                        countNames = 0;
                        countLines++;
                    }
                }
            }
        }
        
    }
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}

+(void)waynePDF:(NSString*)filePath forOrder:(WayneOrderHeader *)wayneOrderHeader {
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPage();
    
    // insert wayne carver header
    UIImage* logo = [UIImage imageNamed:@"logo.png"];
    CGRect frame = CGRectMake(20, 20, 592, 120);
    [PDFRenderer drawImage:logo inRect:frame];
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"Order: %ld", (long)wayneOrderHeader.OrderNum] inFrame:CGRectMake(30, 140, 400, -50) fontName:@"TimesNewRomanPSMT" fontSize:36];
    if ([wayneOrderHeader.SAPShipDate isEqual:@"<null>"]) {
        wayneOrderHeader.SAPShipDate = @"";
    }
    [PDFRenderer drawText:[NSString stringWithFormat:@"Ship Date: %@", wayneOrderHeader.SAPShipDate] inFrame:CGRectMake(30, 180, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:15];
    
    [PDFRenderer drawText:@"NOT AN INVOICE" inFrame:CGRectMake(290, 163, 400, -50) fontName:@"TimesNewRomanPSMT" fontSize:36];

    
    // draw box lines
    CGPoint from = CGPointMake(20, 200);
    CGPoint to = CGPointMake(592, 200);
    [PDFRenderer drawLineFromPoint:from toPoint:to];
    CGPoint from1 = CGPointMake(306, 200);
    CGPoint to1 = CGPointMake(306, 320);
    [PDFRenderer drawLineFromPoint:from1 toPoint:to1];
    CGPoint from2 = CGPointMake(20, 200);
    CGPoint to2 = CGPointMake(20, 320);
    [PDFRenderer drawLineFromPoint:from2 toPoint:to2];
    CGPoint from3 = CGPointMake(592, 200);
    CGPoint to3 = CGPointMake(592, 320);
    [PDFRenderer drawLineFromPoint:from3 toPoint:to3];
    CGPoint from4 = CGPointMake(20, 320);
    CGPoint to4 = CGPointMake(592, 320);
    [PDFRenderer drawLineFromPoint:from4 toPoint:to4];
    
//    [PDFRenderer drawText:[NSString stringWithFormat:@"Sold To: %@", wayneOrderHeader.CustName] inFrame:CGRectMake(30, 210, 300, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
//    //get user from database if there is one
//    NSMutableArray *usersArray = [User getAllUsers];
//    if ([usersArray count] != 0) {
//        User *user = [usersArray objectAtIndex:0];
//        [PDFRenderer drawText:[NSString stringWithFormat:@"Salesman: %@%@", user.FirstName, user.LastName] inFrame:CGRectMake(30, 225, 300, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
//    }
    
    if ([wayneOrderHeader.BillADDR1 isEqual:@"<null>"]) {
        wayneOrderHeader.BillADDR1 = @"";
    }
    if ([wayneOrderHeader.BillADDR2 isEqual:@"<null>"]) {
        wayneOrderHeader.BillADDR2 = @"";
    }
    if ([wayneOrderHeader.StoreADDR1 isEqual:@"<null>"]) {
        wayneOrderHeader.StoreADDR1 = @"";
    }
    if ([wayneOrderHeader.StoreADDR2 isEqual:@"<null>"]) {
        wayneOrderHeader.StoreADDR2 = @"";
    }
    if ([wayneOrderHeader.PONum isEqual:@"<null>"]) {
        wayneOrderHeader.PONum = @"";
    }
    if ([wayneOrderHeader.Terms isEqual:@"<null>"]) {
        wayneOrderHeader.Terms = @"";
    }
    
    
    if ([wayneOrderHeader.BillName isEqual:@"(null)"]) {
        [PDFRenderer drawText:[NSString stringWithFormat:@"Sold To: \n No Destination Selected"] inFrame:CGRectMake(30, 210, 230, -150) fontName:@"TimesNewRomanPSMT" fontSize:12];
    } else {
        [PDFRenderer drawText:[NSString stringWithFormat:@"Sold To: \n%@\n%@\n%@\n%@\n%@ %@", wayneOrderHeader.BillName, wayneOrderHeader.BillADDR1, wayneOrderHeader.BillADDR2, wayneOrderHeader.BillCity, wayneOrderHeader.BillState, wayneOrderHeader.BillZip] inFrame:CGRectMake(30, 210, 300, -150) fontName:@"TimesNewRomanPSMT" fontSize:12];
    }
    
    
    
    if ([wayneOrderHeader.StoreName isEqual:@"(null)"]) {
        [PDFRenderer drawText:[NSString stringWithFormat:@"Ship To: \n No Destination Selected"] inFrame:CGRectMake(336, 210, 230, -150) fontName:@"TimesNewRomanPSMT" fontSize:12];
    } else {
        [PDFRenderer drawText:[NSString stringWithFormat:@"Ship To: \n%@\n%@\n%@\n%@\n%@ %@", wayneOrderHeader.StoreName, wayneOrderHeader.StoreADDR1, wayneOrderHeader.StoreADDR2, wayneOrderHeader.StoreCity, wayneOrderHeader.StoreState, wayneOrderHeader.StoreZip] inFrame:CGRectMake(336, 210, 300, -150) fontName:@"TimesNewRomanPSMT" fontSize:12];
    }
    
    
    
    // draw lines
    CGPoint from5 = CGPointMake(20, 420);
    CGPoint to5 = CGPointMake(592, 420);
    [PDFRenderer drawLineFromPoint:from5 toPoint:to5];
    CGPoint from6 = CGPointMake(20, 320);
    CGPoint to6 = CGPointMake(20, 420);
    [PDFRenderer drawLineFromPoint:from6 toPoint:to6];
    CGPoint from7 = CGPointMake(592, 320);
    CGPoint to7 = CGPointMake(592, 420);
    [PDFRenderer drawLineFromPoint:from7 toPoint:to7];
    
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"Account #: %@", wayneOrderHeader.CustNum] inFrame:CGRectMake(30, 345, 230, -20) fontName:@"TimesNewRomanPSMT" fontSize:14];
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"Terms: %@", wayneOrderHeader.Terms] inFrame:CGRectMake(30, 365, 230, -20) fontName:@"TimesNewRomanPSMT" fontSize:14];
    
    if (![wayneOrderHeader.ShipMethod isEqual:@"(null)"]) {
        [PDFRenderer drawText:[NSString stringWithFormat:@"Ship Via: %@", wayneOrderHeader.ShipMethod] inFrame:CGRectMake(336, 345, 230, -20) fontName:@"TimesNewRomanPSMT" fontSize:14];
    }
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"P.O. Number: %@", wayneOrderHeader.PONum] inFrame:CGRectMake(336, 365, 230, -20) fontName:@"TimesNewRomanPSMT" fontSize:14];
    
    

    
    // get order lines
    NSMutableArray *wayneOrderLines = [WayneOrderLine getOrderLinesWhere:wayneOrderHeader.OrderNum];
    // keep track of x coordinate;
    int x = 425;
    
    [PDFRenderer drawText:@"Qty \nOrd" inFrame:CGRectMake(30, x, 400, -35) fontName:@"TimesNewRomanPSMT" fontSize:14];
    [PDFRenderer drawText:@"Qty \nShip" inFrame:CGRectMake(80, x, 400, -35) fontName:@"TimesNewRomanPSMT" fontSize:14];
    [PDFRenderer drawText:@"Qty \nB/O" inFrame:CGRectMake(130, x, 400, -35) fontName:@"TimesNewRomanPSMT" fontSize:14];
    [PDFRenderer drawText:@"Item #" inFrame:CGRectMake(180, x+15, 100, -35) fontName:@"TimesNewRomanPSMT" fontSize:14];
    [PDFRenderer drawText:@"Item Description" inFrame:CGRectMake(250, x+15, 230, -35) fontName:@"TimesNewRomanPSMT" fontSize:14];
    [PDFRenderer drawText:@"Price" inFrame:CGRectMake(480, x+15, 100, -35) fontName:@"TimesNewRomanPSMT" fontSize:14];
    [PDFRenderer drawText:@"Amount" inFrame:CGRectMake(540, x+15, 300, -35) fontName:@"TimesNewRomanPSMT" fontSize:14];
    
    x += 32;
    
    CGPoint from8 = CGPointMake(30, x);
    CGPoint to8 = CGPointMake(50, x);
    [PDFRenderer drawLineFromPoint:from8 toPoint:to8];
    CGPoint from9 = CGPointMake(80, x);
    CGPoint to9 = CGPointMake(100, x);
    [PDFRenderer drawLineFromPoint:from9 toPoint:to9];
    CGPoint froma = CGPointMake(130, x);
    CGPoint toa = CGPointMake(150, x);
    [PDFRenderer drawLineFromPoint:froma toPoint:toa];
    CGPoint fromb = CGPointMake(180, x);
    CGPoint tob = CGPointMake(220, x);
    [PDFRenderer drawLineFromPoint:fromb toPoint:tob];
    CGPoint fromc = CGPointMake(250, x);
    CGPoint toc = CGPointMake(355, x);
    [PDFRenderer drawLineFromPoint:fromc toPoint:toc];
    CGPoint frome = CGPointMake(480, x);
    CGPoint toe = CGPointMake(520, x);
    [PDFRenderer drawLineFromPoint:frome toPoint:toe];
    CGPoint fromf = CGPointMake(540, x);
    CGPoint tof = CGPointMake(590, x);
    [PDFRenderer drawLineFromPoint:fromf toPoint:tof];
    
    x += 13;
    
    for (WayneOrderLine* orderline in wayneOrderLines)
    {
        [PDFRenderer drawText:[NSString stringWithFormat:@"%ld", (long)orderline.QtyOrdered] inFrame:CGRectMake(30, x, 65, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        [PDFRenderer drawText:[NSString stringWithFormat:@"%ld", (long)orderline.QtyShipped] inFrame:CGRectMake(80, x, 65, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        [PDFRenderer drawText:[NSString stringWithFormat:@"%ld", (long)orderline.QtyBackordered] inFrame:CGRectMake(130, x, 65, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        [PDFRenderer drawText:[NSString stringWithFormat:@"%@", orderline.ItemNo] inFrame:CGRectMake(180, x, 70, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        [PDFRenderer drawText:[NSString stringWithFormat:@"%@", orderline.ItemDesc] inFrame:CGRectMake(250, x, 240, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        [PDFRenderer drawText:[NSString stringWithFormat:@"%.2f", orderline.PricePerPiece] inFrame:CGRectMake(480, x, 65, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        [PDFRenderer drawText:[NSString stringWithFormat:@"%.2f", orderline.LineTotal] inFrame:CGRectMake(540, x, 65, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        x += 20;
        
        if (x > 750) {
            UIGraphicsBeginPDFPage();
            // top of page
            x = 30;
            
            [PDFRenderer drawText:@"Qty \nOrd" inFrame:CGRectMake(30, x, 400, -35) fontName:@"TimesNewRomanPSMT" fontSize:14];
            [PDFRenderer drawText:@"Qty \nShip" inFrame:CGRectMake(80, x, 400, -35) fontName:@"TimesNewRomanPSMT" fontSize:14];
            [PDFRenderer drawText:@"Qty \nB/O" inFrame:CGRectMake(130, x, 400, -35) fontName:@"TimesNewRomanPSMT" fontSize:14];
            [PDFRenderer drawText:@"Item #" inFrame:CGRectMake(180, x+15, 100, -35) fontName:@"TimesNewRomanPSMT" fontSize:14];
            [PDFRenderer drawText:@"Item Description" inFrame:CGRectMake(250, x+15, 230, -35) fontName:@"TimesNewRomanPSMT" fontSize:14];
            [PDFRenderer drawText:@"Price" inFrame:CGRectMake(480, x+15, 100, -35) fontName:@"TimesNewRomanPSMT" fontSize:14];
            [PDFRenderer drawText:@"Amount" inFrame:CGRectMake(540, x+15, 300, -35) fontName:@"TimesNewRomanPSMT" fontSize:14];
            
            // go down proper length
            x += 32;
            
            CGPoint from8 = CGPointMake(30, x);
            CGPoint to8 = CGPointMake(50, x);
            [PDFRenderer drawLineFromPoint:from8 toPoint:to8];
            CGPoint from9 = CGPointMake(80, x);
            CGPoint to9 = CGPointMake(100, x);
            [PDFRenderer drawLineFromPoint:from9 toPoint:to9];
            CGPoint froma = CGPointMake(130, x);
            CGPoint toa = CGPointMake(150, x);
            [PDFRenderer drawLineFromPoint:froma toPoint:toa];
            CGPoint fromb = CGPointMake(180, x);
            CGPoint tob = CGPointMake(220, x);
            [PDFRenderer drawLineFromPoint:fromb toPoint:tob];
            CGPoint fromc = CGPointMake(250, x);
            CGPoint toc = CGPointMake(355, x);
            [PDFRenderer drawLineFromPoint:fromc toPoint:toc];
            CGPoint frome = CGPointMake(480, x);
            CGPoint toe = CGPointMake(520, x);
            [PDFRenderer drawLineFromPoint:frome toPoint:toe];
            CGPoint fromf = CGPointMake(540, x);
            CGPoint tof = CGPointMake(590, x);
            [PDFRenderer drawLineFromPoint:fromf toPoint:tof];
            
            x += 13;
        }
        
    }
    
    CGPoint fromd = CGPointMake(20, x-3);
    CGPoint tod = CGPointMake(592, x-3);
    [PDFRenderer drawLineFromPoint:fromd toPoint:tod];
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"Total: %.2f", wayneOrderHeader.TotalAmt] inFrame:CGRectMake(477, x+10, 200, -25) fontName:@"TimesNewRomanPSMT" fontSize:20];
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}

+(void)gmPDF:(NSString*)filePath forOrder:(GMOrderHeader *)orderHeader includePrice:(BOOL)price {
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPage();
    
    // insert wayne carver header
    UIImage* logo = [UIImage imageNamed:@"logo.png"];
    CGRect frame = CGRectMake(20, 20, 592, 120);
    [PDFRenderer drawImage:logo inRect:frame];
    
    [PDFRenderer drawText:@"Proposed Order" inFrame:CGRectMake(30, 140, 400, -50) fontName:@"TimesNewRomanPSMT" fontSize:36];
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"Created: %@", orderHeader.DateCreated] inFrame:CGRectMake(30, 180, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:15];
    
    [PDFRenderer drawText:@"NOT AN INVOICE" inFrame:CGRectMake(290, 163, 400, -50) fontName:@"TimesNewRomanPSMT" fontSize:36];
    
    
    // draw box lines
    CGPoint from = CGPointMake(20, 200);
    CGPoint to = CGPointMake(592, 200);
    [PDFRenderer drawLineFromPoint:from toPoint:to];
    CGPoint from1 = CGPointMake(306, 200);
    CGPoint to1 = CGPointMake(306, 320);
    [PDFRenderer drawLineFromPoint:from1 toPoint:to1];
    CGPoint from2 = CGPointMake(20, 200);
    CGPoint to2 = CGPointMake(20, 320);
    [PDFRenderer drawLineFromPoint:from2 toPoint:to2];
    CGPoint from3 = CGPointMake(592, 200);
    CGPoint to3 = CGPointMake(592, 320);
    [PDFRenderer drawLineFromPoint:from3 toPoint:to3];
    CGPoint from4 = CGPointMake(20, 320);
    CGPoint to4 = CGPointMake(592, 320);
    [PDFRenderer drawLineFromPoint:from4 toPoint:to4];
    
    if ([orderHeader.BillTo isEqualToString:@"(null)"]) {
        orderHeader.BillTo = @"";
    }
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"Sold To: %@", orderHeader.BillTo] inFrame:CGRectMake(30, 210, 300, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    //get user from database if there is one
    NSMutableArray *usersArray = [User getAllUsers];
    if ([usersArray count] != 0) {
        User *user = [usersArray objectAtIndex:0];
        [PDFRenderer drawText:[NSString stringWithFormat:@"Salesman: %@%@", user.FirstName, user.LastName] inFrame:CGRectMake(30, 225, 300, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    }
    
    if (![orderHeader.ShipMethod isEqual:@"(null)"]) {
        [PDFRenderer drawText:[NSString stringWithFormat:@"Ship Via: %@", orderHeader.ShipMethod] inFrame:CGRectMake(30, 240, 300, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    }
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"Requested Ship Date: %@", orderHeader.DateToShip] inFrame:CGRectMake(30, 255, 400, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"P.O. Number: %@", orderHeader.PONum] inFrame:CGRectMake(30, 270, 400, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    
    
    if ([orderHeader.ShipTo isEqual:@"(null)"]) {
        [PDFRenderer drawText:[NSString stringWithFormat:@"Ship To: \n No Destination Selected"] inFrame:CGRectMake(336, 210, 300, -150) fontName:@"TimesNewRomanPSMT" fontSize:12];
    } else {
        if ([orderHeader.SAddress isEqual:@"<null>"]) {
            orderHeader.SAddress = @"";
        }
        if ([orderHeader.SCity isEqual:@"<null>"]) {
            orderHeader.SState = @"";
        }
        if ([orderHeader.SAddress isEqual:@"<null>"]) {
            orderHeader.SZip = @"";
        }
        [PDFRenderer drawText:[NSString stringWithFormat:@"Ship To: \n%@, %@\n%@\n%@ %@", orderHeader.ShipTo, orderHeader.SAddress, orderHeader.SCity, orderHeader.SState, orderHeader.SZip] inFrame:CGRectMake(330, 210, 300, -150) fontName:@"TimesNewRomanPSMT" fontSize:12];
    }
    
    // draw notes lines
    CGPoint from5 = CGPointMake(20, 420);
    CGPoint to5 = CGPointMake(592, 420);
    [PDFRenderer drawLineFromPoint:from5 toPoint:to5];
    CGPoint from6 = CGPointMake(20, 320);
    CGPoint to6 = CGPointMake(20, 420);
    [PDFRenderer drawLineFromPoint:from6 toPoint:to6];
    CGPoint from7 = CGPointMake(592, 320);
    CGPoint to7 = CGPointMake(592, 420);
    [PDFRenderer drawLineFromPoint:from7 toPoint:to7];
    
    
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
    if ((NSNull *)orderHeader.Notes != [NSNull null]) {
        orderHeader.Notes = [[orderHeader.Notes componentsSeparatedByCharactersInSet:charactersToRemove ]
                             componentsJoinedByString:@", "];
    }
    [PDFRenderer drawText:[NSString stringWithFormat:@"Notes: %@", orderHeader.Notes] inFrame:CGRectMake(30, 325, 530, -100) fontName:@"TimesNewRomanPSMT" fontSize:12];
    
    int x = 440;
    
    
    [PDFRenderer drawText:@"Item #" inFrame:CGRectMake(30, x, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    [PDFRenderer drawText:@"Item Description" inFrame:CGRectMake(100, x, 250, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    [PDFRenderer drawText:@"Qty Ordered" inFrame:CGRectMake(340, x, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    if (price) {
        [PDFRenderer drawText:@"Price" inFrame:CGRectMake(430, x, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
        [PDFRenderer drawText:@"Amount" inFrame:CGRectMake(520, x, 300, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    }
    
    x += 17;
    
    // draw notes lines
    CGPoint from8 = CGPointMake(30, x);
    CGPoint to8 = CGPointMake(70, x);
    [PDFRenderer drawLineFromPoint:from8 toPoint:to8];
    CGPoint from9 = CGPointMake(100, x);
    CGPoint to9 = CGPointMake(205, x);
    [PDFRenderer drawLineFromPoint:from9 toPoint:to9];
    CGPoint froma = CGPointMake(340, x);
    CGPoint toa = CGPointMake(420, x);
    [PDFRenderer drawLineFromPoint:froma toPoint:toa];
    CGPoint fromb = CGPointMake(430, x);
    CGPoint tob = CGPointMake(510, x);
    [PDFRenderer drawLineFromPoint:fromb toPoint:tob];
    CGPoint fromc = CGPointMake(520, x);
    CGPoint toc = CGPointMake(590, x);
    [PDFRenderer drawLineFromPoint:fromc toPoint:toc];
    
    x += 13;
    
    // get order lines
    NSMutableArray *orderLines = [GMOrderLine getOrderLinesWhere:orderHeader.OrderNum];
    float count = 0;
    for (GMOrderLine* orderLine in orderLines)
    {
        [PDFRenderer drawText:[NSString stringWithFormat:@"%@", orderLine.ItemNum] inFrame:CGRectMake(30, x, 70, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        NSString *desc = [GMItem getItemDesc:orderLine.ItemNum];
        [PDFRenderer drawText:[NSString stringWithFormat:@"%@", desc] inFrame:CGRectMake(100, x, 240, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        [PDFRenderer drawText:[NSString stringWithFormat:@"%ld", (long)orderLine.Quantity] inFrame:CGRectMake(340, x, 65, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        if (price) {
            if ([orderLine.PDFPrice doubleValue] == 0.0) {
                int tmpCount = 0;
                GMItem *tmpItem = [GMItem getItemWhere:orderLine.ItemNum];
                for (GMOrderLine* tmpOrderLine in orderLines) {
                    if ([tmpOrderLine.ItemNum isEqualToString:tmpItem.ItemNum]) {
                        tmpCount += tmpOrderLine.Quantity;
                    }
                }
                
                if (tmpItem.Increment == 6) {
                    if (tmpCount >= 6 && tmpCount < 12) {
                        orderLine.PDFPrice = tmpItem.PriceSmallQ;
                    } else if (tmpCount >= 12 && tmpCount < 24) {
                        orderLine.PDFPrice = tmpItem.PriceMedQ;
                    } else {
                        orderLine.PDFPrice = tmpItem.PriceLargeQ;
                    }
                    
                } else if (tmpItem.Increment  == 12) {
                    if (tmpCount >= 12 && tmpCount < 48) {
                        orderLine.PDFPrice = tmpItem.PriceSmallQ;
                    } else if (tmpCount >= 48 && tmpCount < 144) {
                        orderLine.PDFPrice = tmpItem.PriceMedQ;
                    } else {
                        orderLine.PDFPrice = tmpItem.PriceLargeQ;
                    }
                } else {
                    orderLine.PDFPrice = tmpItem.PriceSmallQ;
                }
            }
            [PDFRenderer drawText:[NSString stringWithFormat:@"%.2f", [orderLine.PDFPrice doubleValue]] inFrame:CGRectMake(430, x, 65, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
            [PDFRenderer drawText:[NSString stringWithFormat:@"%.2f", ([orderLine.PDFPrice doubleValue] * orderLine.Quantity)] inFrame:CGRectMake(520, x, 65, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        }
        
        count +=  orderLine.Quantity * [orderLine.PDFPrice doubleValue];
        x += 20;
        
        if (x > 750) {
            UIGraphicsBeginPDFPage();
            // top of page
            x = 30;
            
            [PDFRenderer drawText:@"Item #" inFrame:CGRectMake(30, x, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            [PDFRenderer drawText:@"Item Description" inFrame:CGRectMake(100, x, 250, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            [PDFRenderer drawText:@"Qty Ordered" inFrame:CGRectMake(340, x, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            if (price) {
                [PDFRenderer drawText:@"Price" inFrame:CGRectMake(430, x, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
                [PDFRenderer drawText:@"Amount" inFrame:CGRectMake(520, x, 300, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            }
            
            x += 17;
            
            // draw notes lines
            CGPoint from8 = CGPointMake(30, x);
            CGPoint to8 = CGPointMake(70, x);
            [PDFRenderer drawLineFromPoint:from8 toPoint:to8];
            CGPoint from9 = CGPointMake(100, x);
            CGPoint to9 = CGPointMake(205, x);
            [PDFRenderer drawLineFromPoint:from9 toPoint:to9];
            CGPoint froma = CGPointMake(340, x);
            CGPoint toa = CGPointMake(420, x);
            [PDFRenderer drawLineFromPoint:froma toPoint:toa];
            CGPoint fromb = CGPointMake(430, x);
            CGPoint tob = CGPointMake(510, x);
            [PDFRenderer drawLineFromPoint:fromb toPoint:tob];
            CGPoint fromc = CGPointMake(520, x);
            CGPoint toc = CGPointMake(590, x);
            [PDFRenderer drawLineFromPoint:fromc toPoint:toc];
            
            x += 13;
        }
    }
    
    
    CGPoint fromd = CGPointMake(20, x-3);
    CGPoint tod = CGPointMake(592, x-3);
    [PDFRenderer drawLineFromPoint:fromd toPoint:tod];
    
    if (price) {
        [PDFRenderer drawText:[NSString stringWithFormat:@"Total: %.2f", count] inFrame:CGRectMake(467, x+10, 200, -25) fontName:@"TimesNewRomanPSMT" fontSize:20];
    }
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}

+(void)gmPostedPDF:(NSString*)filePath forOrder:(GMOrderHeader *)orderHeader includePrice:(BOOL)price {
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPage();
    
    // insert wayne carver header
    UIImage* logo = [UIImage imageNamed:@"logo.png"];
    CGRect frame = CGRectMake(20, 20, 592, 120);
    [PDFRenderer drawImage:logo inRect:frame];
    
    [PDFRenderer drawText:@"iPad History Order" inFrame:CGRectMake(30, 140, 400, -50) fontName:@"TimesNewRomanPSMT" fontSize:36];
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"Created: %@", orderHeader.DateCreated] inFrame:CGRectMake(30, 180, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:15];
    
    [PDFRenderer drawText:@"NOT AN INVOICE" inFrame:CGRectMake(290, 163, 400, -50) fontName:@"TimesNewRomanPSMT" fontSize:36];
    
    [PDFRenderer drawText:@"(Possible Duplicate)" inFrame:CGRectMake(290, 163, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:36];
    
    
    // draw box lines
    CGPoint from = CGPointMake(20, 200);
    CGPoint to = CGPointMake(592, 200);
    [PDFRenderer drawLineFromPoint:from toPoint:to];
    CGPoint from1 = CGPointMake(306, 200);
    CGPoint to1 = CGPointMake(306, 320);
    [PDFRenderer drawLineFromPoint:from1 toPoint:to1];
    CGPoint from2 = CGPointMake(20, 200);
    CGPoint to2 = CGPointMake(20, 320);
    [PDFRenderer drawLineFromPoint:from2 toPoint:to2];
    CGPoint from3 = CGPointMake(592, 200);
    CGPoint to3 = CGPointMake(592, 320);
    [PDFRenderer drawLineFromPoint:from3 toPoint:to3];
    CGPoint from4 = CGPointMake(20, 320);
    CGPoint to4 = CGPointMake(592, 320);
    [PDFRenderer drawLineFromPoint:from4 toPoint:to4];
    
    if ([orderHeader.BillTo isEqualToString:@"(null)"]) {
        orderHeader.BillTo = @"";
    }
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"Sold To: %@", orderHeader.BillTo] inFrame:CGRectMake(30, 210, 300, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    //get user from database if there is one
    NSMutableArray *usersArray = [User getAllUsers];
    if ([usersArray count] != 0) {
        User *user = [usersArray objectAtIndex:0];
        [PDFRenderer drawText:[NSString stringWithFormat:@"Salesman: %@%@", user.FirstName, user.LastName] inFrame:CGRectMake(30, 225, 300, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    }
    
    if (![orderHeader.ShipMethod isEqual:@"(null)"]) {
        [PDFRenderer drawText:[NSString stringWithFormat:@"Ship Via: %@", orderHeader.ShipMethod] inFrame:CGRectMake(30, 240, 300, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    }
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"Requested Ship Date: %@", orderHeader.DateToShip] inFrame:CGRectMake(30, 255, 400, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    
    [PDFRenderer drawText:[NSString stringWithFormat:@"P.O. Number: %@", orderHeader.PONum] inFrame:CGRectMake(30, 270, 400, -15) fontName:@"TimesNewRomanPSMT" fontSize:12];
    
    
    if ([orderHeader.ShipTo isEqual:@"(null)"]) {
        [PDFRenderer drawText:[NSString stringWithFormat:@"Ship To: \n No Destination Selected"] inFrame:CGRectMake(336, 210, 300, -150) fontName:@"TimesNewRomanPSMT" fontSize:12];
    } else {
        if ([orderHeader.SAddress isEqual:@"<null>"]) {
            orderHeader.SAddress = @"";
        }
        if ([orderHeader.SCity isEqual:@"<null>"]) {
            orderHeader.SState = @"";
        }
        if ([orderHeader.SAddress isEqual:@"<null>"]) {
            orderHeader.SZip = @"";
        }
        [PDFRenderer drawText:[NSString stringWithFormat:@"Ship To: \n%@, %@\n%@\n%@ %@", orderHeader.ShipTo, orderHeader.SAddress, orderHeader.SCity, orderHeader.SState, orderHeader.SZip] inFrame:CGRectMake(330, 210, 300, -150) fontName:@"TimesNewRomanPSMT" fontSize:12];
    }
    
    // draw notes lines
    CGPoint from5 = CGPointMake(20, 420);
    CGPoint to5 = CGPointMake(592, 420);
    [PDFRenderer drawLineFromPoint:from5 toPoint:to5];
    CGPoint from6 = CGPointMake(20, 320);
    CGPoint to6 = CGPointMake(20, 420);
    [PDFRenderer drawLineFromPoint:from6 toPoint:to6];
    CGPoint from7 = CGPointMake(592, 320);
    CGPoint to7 = CGPointMake(592, 420);
    [PDFRenderer drawLineFromPoint:from7 toPoint:to7];
    
    
    NSCharacterSet *charactersToRemove = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
    if ((NSNull *)orderHeader.Notes != [NSNull null]) {
        orderHeader.Notes = [[orderHeader.Notes componentsSeparatedByCharactersInSet:charactersToRemove ]
                             componentsJoinedByString:@", "];
    }
    [PDFRenderer drawText:[NSString stringWithFormat:@"Notes: %@", orderHeader.Notes] inFrame:CGRectMake(30, 325, 530, -100) fontName:@"TimesNewRomanPSMT" fontSize:12];
    
    int x = 440;
    
    
    [PDFRenderer drawText:@"Item #" inFrame:CGRectMake(30, x, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    [PDFRenderer drawText:@"Item Description" inFrame:CGRectMake(100, x, 250, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    [PDFRenderer drawText:@"Qty Ordered" inFrame:CGRectMake(340, x, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    [PDFRenderer drawText:@"Art #" inFrame:CGRectMake(430, x, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    [PDFRenderer drawText:@"Name Drop" inFrame:CGRectMake(520, x, 300, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
    
    x += 17;
    
    // draw notes lines
    CGPoint from8 = CGPointMake(30, x);
    CGPoint to8 = CGPointMake(70, x);
    [PDFRenderer drawLineFromPoint:from8 toPoint:to8];
    CGPoint from9 = CGPointMake(100, x);
    CGPoint to9 = CGPointMake(205, x);
    [PDFRenderer drawLineFromPoint:from9 toPoint:to9];
    CGPoint froma = CGPointMake(340, x);
    CGPoint toa = CGPointMake(420, x);
    [PDFRenderer drawLineFromPoint:froma toPoint:toa];
    CGPoint fromb = CGPointMake(430, x);
    CGPoint tob = CGPointMake(510, x);
    [PDFRenderer drawLineFromPoint:fromb toPoint:tob];
    CGPoint fromc = CGPointMake(520, x);
    CGPoint toc = CGPointMake(590, x);
    [PDFRenderer drawLineFromPoint:fromc toPoint:toc];
    
    x += 13;
    
    // get order lines
    NSMutableArray *orderLines = [GMOrderLine getOrderLinesWhere:orderHeader.OrderNum];
//    NSLog(@"ORD NUM: %ld, Count: %ld", (long)orderHeader.OrderNum, (long)orderLines.count);
    float count = 0;
    for (GMOrderLine* orderLine in orderLines)
    {
        [PDFRenderer drawText:[NSString stringWithFormat:@"%@", orderLine.ItemNum] inFrame:CGRectMake(30, x, 70, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        NSString *desc = [GMItem getItemDesc:orderLine.ItemNum];
        [PDFRenderer drawText:[NSString stringWithFormat:@"%@", desc] inFrame:CGRectMake(100, x, 240, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        [PDFRenderer drawText:[NSString stringWithFormat:@"%ld", (long)orderLine.Quantity] inFrame:CGRectMake(340, x, 65, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        [PDFRenderer drawText:[NSString stringWithFormat:@"%@", orderLine.ArtNum] inFrame:CGRectMake(430, x, 65, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];
        [PDFRenderer drawText:[NSString stringWithFormat:@"%@", orderLine.NameDrop] inFrame:CGRectMake(520, x, 65, -20) fontName:@"TimesNewRomanPSMT" fontSize:16];

        
        count +=  orderLine.Quantity * [orderLine.PDFPrice doubleValue];
        x += 20;
        
        if (x > 750) {
            UIGraphicsBeginPDFPage();
            // top of page
            x = 30;
            
            [PDFRenderer drawText:@"Item #" inFrame:CGRectMake(30, x, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            [PDFRenderer drawText:@"Item Description" inFrame:CGRectMake(100, x, 250, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            [PDFRenderer drawText:@"Qty Ordered" inFrame:CGRectMake(340, x, 400, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            [PDFRenderer drawText:@"Art #" inFrame:CGRectMake(430, x, 100, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            [PDFRenderer drawText:@"Name Drop" inFrame:CGRectMake(520, x, 300, -25) fontName:@"TimesNewRomanPSMT" fontSize:16];
            
            x += 17;
            
            // draw notes lines
            CGPoint from8 = CGPointMake(30, x);
            CGPoint to8 = CGPointMake(70, x);
            [PDFRenderer drawLineFromPoint:from8 toPoint:to8];
            CGPoint from9 = CGPointMake(100, x);
            CGPoint to9 = CGPointMake(205, x);
            [PDFRenderer drawLineFromPoint:from9 toPoint:to9];
            CGPoint froma = CGPointMake(340, x);
            CGPoint toa = CGPointMake(420, x);
            [PDFRenderer drawLineFromPoint:froma toPoint:toa];
            CGPoint fromb = CGPointMake(430, x);
            CGPoint tob = CGPointMake(510, x);
            [PDFRenderer drawLineFromPoint:fromb toPoint:tob];
            CGPoint fromc = CGPointMake(520, x);
            CGPoint toc = CGPointMake(590, x);
            [PDFRenderer drawLineFromPoint:fromc toPoint:toc];
            
            x += 13;
        }
    }
    
    
    CGPoint fromd = CGPointMake(20, x-3);
    CGPoint tod = CGPointMake(592, x-3);
    [PDFRenderer drawLineFromPoint:fromd toPoint:tod];
    
    if (price) {
        [PDFRenderer drawText:[NSString stringWithFormat:@"Total: %.2f", count] inFrame:CGRectMake(467, x+10, 200, -25) fontName:@"TimesNewRomanPSMT" fontSize:20];
    }
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}

//+(void)editPDF:(NSString*)filePath templateFilePath:(NSString*) templatePath
//{
//    // Create the PDF context using the default page size of 612 x 792.
//    UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
//    // Mark the beginning of a new page.
//    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
//
//    //open template file
//    CFURLRef url = CFURLCreateWithFileSystemPath (NULL, (__bridge CFStringRef)templatePath, kCFURLPOSIXPathStyle, 0);
//    CGPDFDocumentRef templateDocument = CGPDFDocumentCreateWithURL(url);
//    CFRelease(url);
//
//    //get bounds of template page
//    CGPDFPageRef templatePage = CGPDFDocumentGetPage(templateDocument, 1);
//    CGRect templatePageBounds = CGPDFPageGetBoxRect(templatePage, kCGPDFCropBox);
//
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    //flip context due to different origins
//    CGContextTranslateCTM(context, 0.0, templatePageBounds.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//
//    //copy content of template page on the corresponding page in new file
//    CGContextDrawPDFPage(context, templatePage);
//
//    //flip context back
//    CGContextTranslateCTM(context, 0.0, templatePageBounds.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//
//    // Edit body
//    [PDFRenderer drawText:@"Hello World" inFrame:CGRectMake(150, 550, 300, 50) fontName:@"TimesNewRomanPSMT" fontSize:36];
//
//    CGPoint from = CGPointMake(0, 400);
//    CGPoint to = CGPointMake(200, 700);
//    [PDFRenderer drawLineFromPoint:from toPoint:to];
//
//    UIImage* logo = [UIImage imageNamed:@"apple-icon.png"];
//    CGRect frame = CGRectMake(20, 500, 60, 60);
//
//    [PDFRenderer drawImage:logo inRect:frame];
//
//
//    CGPDFDocumentRelease(templateDocument);
//
//    // Close the PDF context and write the contents out.
//    UIGraphicsEndPDFContext();
//}

//// Create the PDF context using the default page size of 612 x 792.
//UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
//// Mark the beginning of a new page.
//UIGraphicsBeginPDFPage();
////    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
//
//
//for (int i = 0; i < 100; i++) {
//    [PDFRenderer drawText:@"Hello World" inFrame:CGRectMake(150, 150+(50*i), 300, 50) fontName:@"TimesNewRomanPSMT" fontSize:12];
//}
//
//
//CGPoint from = CGPointMake(0, 280);
//CGPoint to = CGPointMake(1000, 280);
//[PDFRenderer drawLineFromPoint:from toPoint:to];
//
//UIImage* logo = [UIImage imageNamed:@"logo.png"];
//CGRect frame = CGRectMake(20, 20, 592, 100);
//
//[PDFRenderer drawImage:logo inRect:frame];
//
////    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 794, 612, 792), nil);
//
//UIGraphicsBeginPDFPage();
//
//
//for (int i = 0; i < 100; i++) {
//    [PDFRenderer drawText:@"Hello World" inFrame:CGRectMake(150, 150+(50*i), 300, 50) fontName:@"TimesNewRomanPSMT" fontSize:36];
//}
//
//
//
//// Close the PDF context and write the contents out.
//UIGraphicsEndPDFContext();

@end
