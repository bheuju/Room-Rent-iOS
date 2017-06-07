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
    
    self.pathToDatabase = [NSTemporaryDirectory() stringByAppendingString:@"tmp.db"];
    
    return self;
}


-(void)createDatabase {
    //NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.db"];
    self.db = [FMDatabase databaseWithPath:self.pathToDatabase];
}

@end
