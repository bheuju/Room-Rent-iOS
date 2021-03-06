//
//  Helper.m
//  RoomRent
//
//  Created by Bishal Heuju on 5/3/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "Helper.h"

@implementation Helper

static Helper *instance = nil;

+(Helper*)sharedInstance {
    if (instance == nil) {
        instance = [[Helper alloc] init];
        return instance;
    }
    return instance;
}

-(NSURL*)generateGetImageURLFromFilename:(NSString*)filename {
    
    NSURL *url = nil;
    
    if (filename.length > 0) {
        url = [NSURL URLWithString:[[BASE_URL stringByAppendingString:GETFILE_PATH] stringByAppendingString:filename]];
        //NSLog(@"%@", url);
    }
    
    return url;
}

-(User*)getUserFromUserDefaults {
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:JSON_KEY_USER_OBJECT];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    return user;
}

-(void)setUserToUserDefaults:(User*)user {
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:JSON_KEY_USER_OBJECT];
}


@end
