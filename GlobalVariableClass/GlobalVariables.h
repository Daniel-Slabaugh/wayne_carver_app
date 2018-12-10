//
//  HeartwoodAppGlobalVariables.h
//  HeartwoodAppUsingJson
//
//  Created by Daniel Slabaugh on 6/11/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
//constants
//#define kLeftMargin				20.0
//#define kTopMargin				20.0
//#define kRightMargin			20.0
//#define kTweenMargin			6.0
//#define kTextFieldHeight		30.0


// ad id
extern NSString *advertisingIdentifier;

// seeing if heartwood wants to sync
extern NSString *needsSync;

//checking progress of order
extern NSString *orderSent;
extern NSString *editSubmitAsk;

//service rep order sent tracker
extern NSString *lastOrderSent;


@interface GlobalVariables : NSObject

// ad id
@property (retain, nonatomic) NSString *advertisingIdentifier;

// seeing if heartwood wants to sync
@property (retain, nonatomic) NSString *needsSync;

//checking progress of order
@property (retain, nonatomic) NSString *orderSent;
@property (retain, nonatomic) NSString *editSubmitAsk;

//service rep order sent tracker
@property (retain, nonatomic) NSString *lastOrderSent;


//date last synced variable
@property (retain, nonatomic) NSString *dateLastSynced;





@end
