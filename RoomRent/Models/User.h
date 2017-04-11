//
//  User.h
//  RoomRent
//
//  Created by Bishal Heuju on 4/4/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface User : NSObject <NSCoding>

@property int userId;
@property NSString *name;
@property NSString *phone;
@property NSString *username;
@property NSString *email;
@property NSString *password;

+ (NSString*) getUserApiToken;

- (User*)initUser:(int)userId name:(NSString*)name phone:(NSString*)phone username:(NSString*)username email:(NSString*)email password:(NSString*)password;

- (User*)initUserFromJson:(id)userJson;

- (User*)getUser;

@end
