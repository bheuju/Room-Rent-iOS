//
//  User.h
//  RoomRent
//
//  Created by Bishal Heuju on 4/4/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property NSString *name;
@property NSString *username;
@property NSString *email;
@property NSString *password;
@property NSString *phone;

- (void)initUser:(NSString*)username name:(NSString*)name password:(NSString*)password;

- (User*)getUser;

@end
