//
//  DashboardViewController.h
//  RoomRent
//
//  Created by Bishal Heuju on 4/4/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWRevealViewController/SWRevealViewController.h>

#import "SidebarImplementedViewController.h"
#import "OfferTableViewCell.h"
#import "AddPostViewController.h"
#import "RequestTableViewCell.h"
#import "Alerter.h"
#import "APICaller.h"
#import "Constants.h"
#import "SinglePostViewController.h"

#import "Post.h"

@interface DashboardViewController : SidebarImplementedViewController <UITableViewDelegate, UITableViewDataSource, PostDeleteCompletedDelegate, CollectionViewItemClicked>

@end
