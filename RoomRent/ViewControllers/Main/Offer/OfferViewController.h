//
//  OfferViewController.h
//  RoomRent
//
//  Created by Bishal Heuju on 4/4/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AFNetworking/AFNetworking.h>
#import <SWRevealViewController/SWRevealViewController.h>

#import "SidebarImplementedViewController.h"
#import "SinglePostViewController.h"

#import "DBManager.h"
#import "Alerter.h"
#import "Constants.h"

#import "User.h"

#import "OfferTableViewCell.h"

@interface OfferViewController : SidebarImplementedViewController <UITableViewDelegate, UITableViewDataSource, CollectionViewItemClicked>

@end
