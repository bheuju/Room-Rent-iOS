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
       
    return self;
}


-(BOOL)createDatabase {
    //NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.db"];
    NSArray *docspath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    NSString *docsDir = [docspath objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingString:@"room.db"];
    
    NSLog(@"PATH: %@", path);
    
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
    
    NSArray *docspath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    NSString *docsDir = [docspath objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingString:@"room.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    //[self.db open];
    [db open];
    NSString *sql = @"create table posts (id integer primary key autoincrement not null, title text not null, slug text not null, description text not null, user_id integer not null, no_of_rooms integer not null, price integer not null, address text not null, latitude decimal not null, longitude decimal not null, post_type integer not null)";
    
    [self.db executeUpdate:sql];
    
    [self.db close];
    
    return true;
}

-(BOOL)addPost:(Post*)post {
    NSArray *docspath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    NSString *docsDir = [docspath objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingString:@"room.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    [db open];
    
    [db executeUpdate:@"INSERT INTO POST_TABLE (id, title, slug, description, no_of_rooms , price, latitude, longitude, address, user_id, post_type) VALUES (?,?,?,?,?,?,?,?,?,?, ?)",post.postId, [NSString stringWithFormat:@"%@", post.postTitle], [NSString stringWithFormat:@"%@", post.postSlug], [NSString stringWithFormat:@"%@", post.postDescription], post.postNoOfRooms, post.postPrice, [NSNumber numberWithDouble:post.postAddressCoordinates.latitude] , [NSNumber numberWithDouble:post.postAddressCoordinates.longitude],[NSString stringWithFormat:@"%@", post.postAddress], [NSNumber numberWithInt: post.postUser.userId], post.postType];
    
    //[db executeUpdate:sql];
    
    [db close];
    return true;
    
    //return [db executeQuery:sql];
}




@end
