//
//  Post.h
//  RoomRent
//
//  Created by Bishal Heuju on 4/21/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "Constants.h"
#import "APICaller.h"

@interface Post : NSObject

@property NSNumber *postId;
@property NSNumber *postType;

@property NSString *postTitle;
@property NSString *postDescription;
@property NSNumber *postNoOfRooms;
@property NSNumber *postPrice;
@property NSString *postAddress;
@property CLLocationCoordinate2D postAddressCoordinates;
@property NSMutableArray *postImageArray;


-(Post*)initPostWithJson:(id)postJson;

@end
