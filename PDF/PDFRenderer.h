//
//  PDFRenderer.h
//  PDFRenderer
//
//  Created by Yuichi Fujiki on 3/28/12.
//  Copyright (c) 2012 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "OrderHeader.h"
#import "WayneOrderHeader.h"
#import "GMOrderHeader.h"

@interface PDFRenderer : NSObject

+ (void)drawText:(NSString*)text inFrame:(CGRect)frame fontName:(NSString *)fontName fontSize:(int) fontSize;

+(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;
    
+(void)drawImage:(UIImage*)image inRect:(CGRect)rect;

+(void)fullPDF:(NSString*)filePath forOrder:(OrderHeader *)orderHeader includePrice:(BOOL)price;

+(void)summaryPDF:(NSString*)filePath forOrder:(OrderHeader *)orderHeader includePrice:(BOOL)price;

+(void)waynePDF:(NSString*)filePath forOrder:(WayneOrderHeader *)orderHeader;

+(void)gmPDF:(NSString*)filePath forOrder:(GMOrderHeader *)orderHeader includePrice:(BOOL)price;

+(void)postedPDF:(NSString*)filePath forOrder:(OrderHeader *)orderHeader includePrice:(BOOL)price;

+(void)gmPostedPDF:(NSString*)filePath forOrder:(GMOrderHeader *)orderHeader includePrice:(BOOL)price;


//+(void)editPDF:(NSString*)filePath templateFilePath:(NSString*) templatePath;
@end
