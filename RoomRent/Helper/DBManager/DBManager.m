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

NSArray *docspath;
NSString *docsDir;
NSString *path;



+(DBManager*)sharedInstance {
    
    if (instance == nil) {
        instance = [[DBManager alloc] initDBManager];
        return instance;
    }
    return instance;
}



-(DBManager*)initDBManager {
    
    //Initialize database defaults
    docspath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    docsDir = [docspath objectAtIndex:0];
    path = [docsDir stringByAppendingString:@"room.db"];
    
    NSLog(@"PATH: %@", path);
    
    //Create Database
    if ([self createDatabase]) {
        //Create Tables
        [self createTable];
    }
    
    return self;
}



-(BOOL)createDatabase {
    
    self.db = [FMDatabase databaseWithPath:path];
    
    if (self.db != nil) {
        
        if (![self.db open]) {
            self.db = nil;
            
            NSLog(@"Could not open database");
            
            return false;
        }
        
        //[self createTable];
    }
    
    return true;
}



-(BOOL)createTable {
    
    [self.db open];
    
    NSString *sql = @
    "create table if not exists posts (id integer primary key not null, title text not null, slug text not null, description text not null, user_id integer not null, no_of_rooms integer not null, price integer not null, address text not null, latitude decimal not null, longitude decimal not null, post_type integer not null);"
    "create table if not exists users (id integer primary key not null, name text not null, email text not null, username text not null, phone text not null);";
    
    BOOL successStatus = [self.db executeStatements:sql];
    
    [self.db close];
    
    return successStatus;
}



-(BOOL)addPost:(Post*)post {
    
    [self.db open];
    
    BOOL successStatus = [self.db executeUpdate:@"INSERT INTO posts (id, title, slug, description, no_of_rooms , price, latitude, longitude, address, user_id, post_type) VALUES (?,?,?,?,?,?,?,?,?,?,?)", post.postId, [NSString stringWithFormat:@"%@", post.postTitle], [NSString stringWithFormat:@"%@", post.postSlug], [NSString stringWithFormat:@"%@", post.postDescription], post.postNoOfRooms, post.postPrice, [NSNumber numberWithDouble:post.postAddressCoordinates.latitude] , [NSNumber numberWithDouble:post.postAddressCoordinates.longitude],[NSString stringWithFormat:@"%@", post.postAddress], [NSNumber numberWithInt: post.postUser.userId], post.postType];
    
    [self.db close];
    
    return successStatus;
}

-(BOOL)addUser:(User*)user {
    
    [self.db open];
    
    BOOL successStatus = [self.db executeUpdate:@"INSERT INTO users (id, name, email, username, phone) VALUES (?,?,?,?,?)", @(user.userId), user.name, user.email, user.username, user.phone];
    
    [self.db close];
    
    return successStatus;
}




@end
