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

@property NSNumber *userId;
@property NSString *name;
@property NSString *phone;
@property NSString *username;
@property NSString *email;
@property NSString *profileImageUrl;

-(User*)initUserFromJson:(id)userJson;

@end
