//
//  Post.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/21/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "Post.h"

@implementation Post

-(Post*)initPostWithJson:(id)postJson {
    
    self.postType = [postJson valueForKey:JSON_KEY_POST_TYPE];
    
    self.postId = [postJson valueForKey:JSON_KEY_POST_ID];
    self.postTitle = [postJson valueForKey:JSON_KEY_POST_TITLE];
    self.postSlug = [postJson valueForKey:JSON_KEY_POST_SLUG];
    self.postDescription = [postJson valueForKey:JSON_KEY_POST_DESCRIPTION];
    
    self.postUser = [[User alloc] initUserFromJson:[postJson objectForKey:JSON_KEY_USER_OBJECT]];
    
    
    
    self.postNoOfRooms = [postJson valueForKey:JSON_KEY_POST_NO_OF_ROOMS];
    self.postPrice = [postJson valueForKey:JSON_KEY_POST_PRICE];
    self.postAddress = [postJson valueForKey:JSON_KEY_POST_ADDRESS];
    
    double lat = [[postJson valueForKey:JSON_KEY_POST_ADDRESS_LATITUDE] doubleValue];
    double lon = [[postJson valueForKey:JSON_KEY_POST_ADDRESS_LONGITUDE] doubleValue];
    self.postAddressCoordinates = CLLocationCoordinate2DMake(lat, lon);
    
    
    self.postImageArray = [NSMutableArray arrayWithArray:[[postJson valueForKey:JSON_KEY_POST_IMAGES] allObjects]];
    
    
    
    Post *p = self;
    
    return self;
}

@end
