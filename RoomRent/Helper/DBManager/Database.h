//
//  Database.h
//  RoomRent
//
//  Created by Bishal Heuju on 6/14/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FMDB/FMDB.h>

@interface Database : NSObject


@property NSString *TABLE_NAME;


@property FMDatabase *db;

-(BOOL)createTable;

-(BOOL)createItem:(id)item;
-(id)readItem;
-(void)updateItem;
-(void)deleteItem;

@end
