//
//  DBManager.h
//  RoomRent
//
//  Created by Bishal Heuju on 6/7/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FMDB/FMDB.h>

#import "Post.h"

@interface DBManager : NSObject

@property FMDatabase *db;

+(DBManager*)sharedInstance;
-(DBManager*)initDBManager;

-(BOOL)createDatabase;
-(BOOL)createTable;

-(BOOL)addPost:(Post*)post;

@end
