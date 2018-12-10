//
//  DBManager.h
//  wayne mobile
//
//  Created by Chenggong Huang on 7/19/13.
//  Copyright (c) 2013 Daniel Slabaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define		DOCUMENTS_DIRECTORY_PATH    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define		LOCAL_DATABASE_PATH		[DOCUMENTS_DIRECTORY_PATH stringByAppendingPathComponent:@"app.sqlite"]

@interface DBManager : NSObject

+ (BOOL) initDatabase;
+ (sqlite3*) sharedManager;

@end
