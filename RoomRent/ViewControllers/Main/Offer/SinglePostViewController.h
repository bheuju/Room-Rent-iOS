//
//  SinglePostViewController.h
//  RoomRent
//
//  Created by Bishal Heuju on 4/27/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "MapViewController.h"
#import "ImageSliderCollectionViewCell.h"
#import "Helper.h"
#import "Alerter.h"

#import "Post.h"

@interface SinglePostViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

-(void)initPostHavingPostId:(NSString*)postSlug;

@end

