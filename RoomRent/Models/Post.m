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
    //    "id": 1,
    //    "title": "Room at EB",
    //    "description": "Rooms at EB Pearls are available for rent",
    //    "no_of_rooms": 5,
    //    "price": 25000,
    //    "address": "Kupondole, Lalitpur",
    //    "latitude": "213.45670500",
    //    "longitude": "987.65432101",
    //    "images": [
    //
    //               "7wi6UJd18YeEYGHyDosCd6JaxphpKxy2el.jpg",
    //               "7wi6UJd18YeEYGHyDosCd6JaxphpKxy2el.jpg"
    //
    //               ],
    //    "post_type": "offer",
    
    
    self.postId = [postJson valueForKey:JSON_KEY_POST_ID];
    self.postType = [postJson valueForKey:JSON_KEY_POST_TYPE];
    
    self.postTitle = [postJson valueForKey:JSON_KEY_POST_TITLE];
    self.postDescription = [postJson valueForKey:JSON_KEY_POST_DESCRIPTION];
    self.postNoOfRooms = [postJson valueForKey:JSON_KEY_POST_NO_OF_ROOMS];
    self.postPrice = [postJson valueForKey:JSON_KEY_POST_PRICE];
    self.postAddress = [postJson valueForKey:JSON_KEY_POST_ADDRESS];
    
    double lat = [[postJson valueForKey:JSON_KEY_POST_ADDRESS_LATITUDE] doubleValue];
    double lon = [[postJson valueForKey:JSON_KEY_POST_ADDRESS_LONGITUDE] doubleValue];
    self.postAddressCoordinates = CLLocationCoordinate2DMake(lat, lon);
    
    NSArray *imageNames = [[postJson valueForKey:JSON_KEY_POST_IMAGES] allObjects];
    
    for (NSString *imageName in imageNames) {
        //self.postImageArray = [postJson valueForKey:JSON_KEY_POST_ID];
        
        [[APICaller sharedInstance] callApiForImageRequest:imageName successBlock:^(id responseObject) {
            
            UIImage *image = responseObject;
            [self.postImageArray addObject:image];
            
        }];
    }
    
    //Post *p = self;
    
    return self;
}

@end
