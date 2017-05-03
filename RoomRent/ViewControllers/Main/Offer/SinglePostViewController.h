//
//  SinglePostViewController.h
//  RoomRent
//
//  Created by Bishal Heuju on 4/27/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "MapViewController.h"

#import "Post.h"

@interface SinglePostViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

-(void)initPostHavingPostId:(NSNumber*)postId;

@end

