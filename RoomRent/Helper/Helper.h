//
//  Helper.h
//  RoomRent
//
//  Created by Bishal Heuju on 5/3/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Constants.h"

#import "User.h"

@interface Helper : NSObject

+(Helper*)sharedInstance;


-(NSURL*)generateGetImageURLFromFilename:(NSString*)filename;


-(User*)getUserFromUserDefaults;
-(void)setUserToUserDefaults:(User*)user;


@end
