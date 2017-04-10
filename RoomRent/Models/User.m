//
//  User.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/4/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "User.h"

@implementation User

static NSString *userApiToken = nil;

- (User*)initUser:(int)userId name:(NSString*)name phone:(NSString*)phone username:(NSString*)username email:(NSString*)email password:(NSString*)password {
    
    self.name = name;
    self.phone = phone;
    self.username = username;
    self.email = email;
    self.password = password;
    
    return self;
}

-(User*)initUserFromJson:(id)userJson {
    
    NSDictionary *json = (NSDictionary*) userJson;
    
    self.userId = [[json valueForKey:JSON_KEY_USER_ID] intValue];
    self.name = [json valueForKey:JSON_KEY_NAME];
    self.phone = [json valueForKey:JSON_KEY_PHONE];
    self.username = [json valueForKey:JSON_KEY_USERNAME];
    self.email = [json valueForKey:JSON_KEY_EMAIL];
    
    //Overwrite API_TOKEN with new user api token
    userApiToken = [json valueForKey:JSON_KEY_API_TOKEN];
    
    return self;
}


+(NSString *)getUserApiToken {
    return userApiToken;
}

-(User*)getUser {
    
    return self;
    
}

@end
