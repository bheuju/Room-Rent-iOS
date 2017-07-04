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

#import "ProgressHUD.h"
#import "MapViewController.h"
#import "ImageSliderCollectionViewCell.h"
#import "Helper.h"
#import "Alerter.h"
#import "DBManager.h"

#import "AddPostViewController.h"

#import "Post.h"

@interface SinglePostViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, PostEditCompletedDelegate>

@property Post *post;

@property (weak) id postDeleteCompletedDelegate;

-(void)initPostHavingPostId:(NSString*)postSlug;

@end



@protocol PostDeleteCompletedDelegate

-(void) didFinishPostDelete;

@end
