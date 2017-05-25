//
//  PostPartial.m
//  RoomRent
//
//  Created by Bishal Heuju on 5/19/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "PostPartial.h"

@implementation PostPartial

-(PostPartial*)initPostWithJson:(id)postJson {
    
    self.postId = [postJson valueForKey:JSON_KEY_POST_ID];
    self.postTitle = [postJson valueForKey:JSON_KEY_POST_TITLE];
    self.postDescription = [postJson valueForKey:JSON_KEY_POST_DESCRIPTION];
    self.postSlug = [postJson valueForKey:JSON_KEY_POST_SLUG];
    self.postUser = [postJson objectForKey:JSON_KEY_USER_OBJECT];
    self.postImage = [postJson valueForKey:JSON_KEY_POST_IMAGE];
    
    
    self.postNoOfRooms = [postJson valueForKey:JSON_KEY_POST_NO_OF_ROOMS];
    self.postPrice = [postJson valueForKey:JSON_KEY_POST_PRICE];
    self.postAddress = [postJson valueForKey:JSON_KEY_POST_ADDRESS];
    
    //PostPartial *p = self;
    
    return self;
}

@end
