//
//  User.h
//  HeartwoodApp
//
//  Created by Chenggong Huang on 6/26/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define  TBL_USER                   @"Users"
#define  FLD_USERID                 @"UserID"
#define  FLD_FNAME                  @"FirstName"
#define  FLD_LNAME                  @"LastName"
#define  FLD_CNAME                  @"CompanyName"
#define  FLD_MADDR1                 @"MailADDR1"
#define  FLD_MADDR2                 @"MailADDR2"
#define  FLD_MCITY                  @"MailCity"
#define  FLD_MSTATE                 @"MailState"
#define  FLD_MZIP                   @"MailZip"
#define  FLD_MCOUNTRY               @"MailCountry"
#define  FLD_SADDR1                 @"ShipADDR1"
#define  FLD_SADDR2                 @"ShipADDR2"
#define  FLD_SCITY                  @"ShipCity"
#define  FLD_SSTATE                 @"ShipState"
#define  FLD_SZIP                   @"ShipZip"
#define  FLD_SCOUNTRY               @"ShipCountry"
#define  FLD_PHONE                  @"Phone"
#define  FLD_FAX                    @"FAX"
#define  FLD_CELL                   @"Cell"
#define  FLD_EMAIL                  @"Email"
#define  FLD_PASSWORD               @"Password"
#define  FLD_USERACTIVE             @"UserActive"
#define  FLD_USERREMOTEENABLED      @"UserRemoteEnabled"
#define  FLD_RECORDNEEDSTRANSFER    @"RecordNeedsTransfer"
#define  FLD_COMMCHECKDEST          @"CommCheckDest"
#define  FLD_TERRITORIES            @"Territories"

@interface User : NSObject
{
    NSString * UserID;
    NSString * FirstName;
    NSString * LastName;
    NSString * CompanyName;
    NSString * MailADDR1;
    NSString * MailADDR2;
    NSString * MailCity;
    NSString * MailState;
    NSString * MailZip;
    NSString * MailCountry;
    NSString * ShipADDR1;
    NSString * ShipADDR2;
    NSString * ShipCity;
    NSString * ShipState;
    NSString * ShipZip;
    NSString * ShipCountry;
    NSString * Phone;
    NSString * FAX;
    NSString * Cell;
    NSString * Email;
    NSString * Password;
    
    BOOL UserActive;
    BOOL UserRemoteEnabled;
    BOOL RecordNeedsTransfer;
    BOOL CommCheckDest;
    NSString * Territories;
}

@property (nonatomic, retain) NSString * UserID;
@property (nonatomic, retain) NSString * FirstName;
@property (nonatomic, retain) NSString * LastName;
@property (nonatomic, retain) NSString * CompanyName;
@property (nonatomic, retain) NSString * MailADDR1;
@property (nonatomic, retain) NSString * MailADDR2;
@property (nonatomic, retain) NSString * MailCity;
@property (nonatomic, retain) NSString * MailState;
@property (nonatomic, retain) NSString * MailZip;
@property (nonatomic, retain) NSString * MailCountry;
@property (nonatomic, retain) NSString * ShipADDR1;
@property (nonatomic, retain) NSString * ShipADDR2;
@property (nonatomic, retain) NSString * ShipCity;
@property (nonatomic, retain) NSString * ShipState;
@property (nonatomic, retain) NSString * ShipZip;
@property (nonatomic, retain) NSString * ShipCountry;
@property (nonatomic, retain) NSString * Phone;
@property (nonatomic, retain) NSString * FAX;
@property (nonatomic, retain) NSString * Cell;
@property (nonatomic, retain) NSString * Email;
@property (nonatomic, retain) NSString * Password;

@property (nonatomic) BOOL UserActive;
@property (nonatomic) BOOL UserRemoteEnabled;
@property (nonatomic) BOOL RecordNeedsTransfer;
@property (nonatomic) BOOL CommCheckDest;
@property (nonatomic,retain) NSString * Territories;



+ (BOOL) deleteWhere:(NSInteger)uid;
+ (void) deleteAllUsers;

+ (id) fetch:(sqlite3_stmt *)dbStmt;

+ (NSMutableArray*) getAllUsers;

+ (NSInteger) insertInto:(User*) data;

+ (User*) getUser;





@end
