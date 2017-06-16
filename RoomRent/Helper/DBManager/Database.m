//
//  Database.m
//  RoomRent
//
//  Created by Bishal Heuju on 6/14/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "Database.h"

@implementation Database


-(instancetype)init {

    self = [super init];
    
    //Initialize database defaults
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
        
        [self createTable];
    }
    
    return self;

}


-(BOOL)createTable {
    //[self createTable];
    return false;
}



-(BOOL)createItem:(id)item {
    return false;
}

-(id)readItem {
    return nil;
}

-(void)updateItem {
    
}

-(void)deleteItem {
    
}

@end
