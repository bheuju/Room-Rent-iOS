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
    "create table if not exists users (id integer primary key not null, name text not null, email text not null, username text not null, phone text not null);"
    "create table if not exists images (id integer not null, filename text not null, primary key (id, filename));";
    
    BOOL successStatus = [self.db executeStatements:sql];
    
    [self.db close];
    
    return successStatus;
}


-(BOOL)addPost:(Post*)post {
    
    [self.db open];
    
    BOOL successStatus = [self.db executeUpdate:@"INSERT INTO posts (id, title, slug, description, no_of_rooms , price, latitude, longitude, address, user_id, post_type) VALUES (?,?,?,?,?,?,?,?,?,?,?)", post.postId, post.postTitle, post.postSlug, post.postDescription, post.postNoOfRooms, post.postPrice, @(post.postAddressCoordinates.latitude), @(post.postAddressCoordinates.longitude), post.postAddress, post.postUser.userId, post.postType];
    
    [self.db close];
    
    return successStatus;
}

-(BOOL)addUser:(User*)user {
    
    [self.db open];
    
    BOOL successStatus = [self.db executeUpdate:@"INSERT INTO users (id, name, email, username, phone) VALUES (?,?,?,?,?)", user.userId, user.name, user.email, user.username, user.phone];
    
    [self.db close];
    
    return successStatus;
}

-(BOOL)addImage:(NSNumber*)id fileName:(NSString*)filename {
    
    [self.db open];
    
    BOOL successStatus = [self.db executeUpdate:@"INSERT INTO images (id, filename) VALUES (?,?)", id, filename];
    
    [self.db close];
    
    return successStatus;
}



-(NSMutableArray*)getPostsOfType:(NSString*)type forUserWithId:(NSNumber*)userId {
    
    NSMutableArray *postsArray = [[NSMutableArray alloc] init];
    
    [self.db open];
    
    FMResultSet *result;
    
    if ([type isEqualToString:OFFER] || [type isEqualToString:POSTS_OFFER_STRING]) {
        if (userId != nil) {
            result = [self.db executeQuery:@"SELECT * FROM posts WHERE post_type = ? AND user_id = ?", OFFER, userId];
        } else {
            result = [self.db executeQuery:@"SELECT * FROM posts WHERE post_type = ?", OFFER];
        }
    } else if ([type isEqualToString:REQUEST] || [type isEqualToString:POSTS_REQUEST_STRING]) {
        if (userId != nil) {
            result = [self.db executeQuery:@"SELECT * FROM posts WHERE post_type = ? AND user_id = ?", REQUEST, userId];
        } else {
            result = [self.db executeQuery:@"SELECT * FROM posts WHERE post_type = ?", REQUEST];
        }
    }
    
    
    
    if (result != nil) {
        
        while ([result next]) {
            NSDictionary *resultDict = [result resultDictionary];
            
            //Get post
            Post *post = [[Post alloc] initPostWithJson:resultDict];
            
            //Get imagesarray
            FMResultSet *images = [self.db executeQuery:@"SELECT * FROM images WHERE id = ?", post.postId];
            while ([images next]) {
                [post.postImageArray addObject:[images stringForColumn:@"filename"]];
            }
            
            //Get user
            NSNumber *userId = [resultDict valueForKey:@"user_id"];
            FMResultSet *user = [self.db executeQuery:@"SELECT * FROM users WHERE id = ?", userId];
            
            if ([user next]) {
                NSDictionary *userDict = [user resultDictionary];
                User *user = [[User alloc] initUserFromJson:userDict];
                post.postUser = user;
            }
            
            //[postsArray addObject:post];
            [postsArray insertObject:post atIndex:0];
        }
    }
    
    [self.db close];
    
    return postsArray;
}


-(Post*)getPostWithSlug:(NSString*)slug {
    
    //NSMutableArray *postsArray = [[NSMutableArray alloc] init];
    Post *post = [[Post alloc] init];
    
    [self.db open];
    
    FMResultSet *result;
    
    result = [self.db executeQuery:@"SELECT * FROM posts WHERE slug = ?", slug];
    
    if (result != nil) {
        
        while ([result next]) {
            NSDictionary *resultDict = [result resultDictionary];
            
            //Get post
            post = [[Post alloc] initPostWithJson:resultDict];
            
            //Get imagesarray
            FMResultSet *images = [self.db executeQuery:@"SELECT * FROM images WHERE id = ?", post.postId];
            while ([images next]) {
                [post.postImageArray addObject:[images stringForColumn:@"filename"]];
            }
            
            //Get user
            NSNumber *userId = [resultDict valueForKey:@"user_id"];
            FMResultSet *user = [self.db executeQuery:@"SELECT * FROM users WHERE id = ?", userId];
            
            if ([user next]) {
                NSDictionary *userDict = [user resultDictionary];
                User *user = [[User alloc] initUserFromJson:userDict];
                post.postUser = user;
            }
            
        }
    }
    
    [self.db close];
    
    return post;
}


-(BOOL)deletePostWithSlug:(NSString*)slug {
    
    [self.db open];
    
    //BOOL successStatus = [self.db executeUpdate:@"DELETE FROM posts WHERE slug = ?", id];
    
    [self.db close];
    
    //return successStatus;
    return false;

}




@end
