//
//  PostDB.m
//  RoomRent
//
//  Created by Bishal Heuju on 6/14/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "PostDB.h"


@implementation PostDB


-(instancetype)init {
    
    self = [super init];
    
    self.TABLE_NAME = @"posts";
    
    return self;
}


-(BOOL)createTable {
    
    [self.db open];
    
//    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY NOT NULL, %@ TEXT NOT NULL, %@ TEXT NOT NULL, %@ TEXT NOT NULL, %@ INTEGER NOT NULL, %@ INTEGER NOT NULL, %@ INTEGER NOT NULL, %@ TEXT NOT NULL, %@ DECIMAL NOT NULL, %@ DECIMAL NOT NULL, %@ INTEGER NOT NULL)", self.TABLE_NAME, @"id", @"title", @"slug", @"description", @"user_id", @"no_of_rooms", @"price", @"address", @"latitude", @"longitude", @"post_type"];
    
    NSString *sql = @"create table if not exists posts (id integer primary key not null, title text not null, slug text not null, description text not null, user_id integer not null, no_of_rooms integer not null, price integer not null, address text not null, latitude decimal not null, longitude decimal not null, post_type integer not null)";
    
    BOOL successStatus = [self.db executeStatements:sql];
    
    [self.db close];
    
    return successStatus;
    
}


-(BOOL)createItem:(Post*)post {
    
    [self.db open];
    
    BOOL successStatus = [self.db executeUpdate:@"INSERT INTO posts (id, title, slug, description, no_of_rooms , price, latitude, longitude, address, user_id, post_type) VALUES (?,?,?,?,?,?,?,?,?,?,?)", post.postId, [NSString stringWithFormat:@"%@", post.postTitle], [NSString stringWithFormat:@"%@", post.postSlug], [NSString stringWithFormat:@"%@", post.postDescription], post.postNoOfRooms, post.postPrice, [NSNumber numberWithDouble:post.postAddressCoordinates.latitude] , [NSNumber numberWithDouble:post.postAddressCoordinates.longitude],[NSString stringWithFormat:@"%@", post.postAddress], [NSNumber numberWithInt: post.postUser.userId], post.postType];
    
    [self.db close];
    
    return successStatus;
    
}

-(id)readItem {
    
    [self.db open];
    
    FMResultSet *result = [self.db executeQuery:@"SELECT * FROM %@ WHERE id = %@", self.TABLE_NAME, @"52"];
    
    [self.db close];
    
    return result;
    
}

-(void)updateItem {
    
}

-(void)deleteItem {
    
}

@end
