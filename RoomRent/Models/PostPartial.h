//
//  PostPartial.h
//  RoomRent
//
//  Created by Bishal Heuju on 5/19/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"

@interface PostPartial : NSObject

@property NSNumber *postId;
@property NSString *postTitle;
@property NSString *postDescription;
@property NSString *postSlug;
@property NSString *postUser;
@property NSMutableArray *postImage;

@property NSNumber *postNoOfRooms;
@property NSNumber *postPrice;
@property NSString *postAddress;

-(PostPartial*)initPostWithJson:(id)postJson;


@end
