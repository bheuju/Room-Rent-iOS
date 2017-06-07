//
//  DBManager.h
//  RoomRent
//
//  Created by Bishal Heuju on 6/7/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FMDB/FMDB.h>

@interface DBManager : NSObject

@property NSString *databaseName;
@property NSString *pathToDatabase;
@property FMDatabase *db;

+(DBManager*)sharedInstance;
-(DBManager*)initDBManager;

-(void)createDatabase;

@end
