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


//MARK: NSCoding implementations
-(id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        self.userId = [[aDecoder decodeObjectForKey:JSON_KEY_USER_ID] intValue] ;
        self.name = [aDecoder decodeObjectForKey:JSON_KEY_NAME];
        self.phone = [aDecoder decodeObjectForKey:JSON_KEY_PHONE];
        self.username = [aDecoder decodeObjectForKey:JSON_KEY_USERNAME];
        self.email = [aDecoder decodeObjectForKey:JSON_KEY_EMAIL];
        self.password = [aDecoder decodeObjectForKey:JSON_KEY_PASSWORD];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.userId] forKey:JSON_KEY_USER_ID];
    [aCoder encodeObject:self.name forKey:JSON_KEY_NAME];
    [aCoder encodeObject:self.phone forKey:JSON_KEY_PHONE];
    [aCoder encodeObject:self.username forKey:JSON_KEY_USERNAME];
    [aCoder encodeObject:self.email forKey:JSON_KEY_EMAIL];
    [aCoder encodeObject:self.password forKey:JSON_KEY_PASSWORD];
    
}

@end
