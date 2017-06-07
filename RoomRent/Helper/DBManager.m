//
//  DBManager.m
//  RoomRent
//
//  Created by Bishal Heuju on 6/7/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

static DBManager* instance = nil;

+(DBManager*)sharedInstance {
    
    if (instance == nil) {
        instance = [[DBManager alloc] initDBManager];
        return instance;
    }
    return instance;
}

-(DBManager*)initDBManager {
    
    //self.pathToDatabase = [NSTemporaryDirectory() stringByAppendingString:@"tmp.db"];
    
    return self;
}


-(BOOL)createDatabase {
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.db"];
    self.db = [FMDatabase databaseWithPath:path];
    
    if (self.db != nil) {
        if (![self.db open]) {
            self.db = nil;
            NSLog(@"Could not open database");
            return false;
        }
    }
    
    return true;
}

-(BOOL)createTable {
    
    NSString *sql = @"create table posts (id integer primary key autoincrement not null, title text not null, slug text not null, description text not null, user_id integer not null, no_of_rooms integer not null, price integer not null, address text not null, latitude decimal not null, longitude decimal not null, post_type integer not null)";
    
    return [self.db executeQuery:sql];
}

-(BOOL)addPost:(Post*)post {
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO posts VALUES (%@, %@, %@, %@, %d, %@, %@, %@, %f, %f, %@)", post.postId, post.postTitle, post.postSlug, post.postDescription, post.postUser.userId, post.postNoOfRooms, post.postPrice, post.postAddress, post.postAddressCoordinates.latitude, post.postAddressCoordinates.longitude, post.postType];
    
    return [self.db executeQuery:sql];
}




@end
