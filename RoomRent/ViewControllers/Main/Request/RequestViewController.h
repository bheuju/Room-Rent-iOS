//
//  RequestViewController.h
//  RoomRent
//
//  Created by Bishal Heuju on 4/4/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWRevealViewController/SWRevealViewController.h>

#import "SidebarImplementedViewController.h"
#import "OfferTableViewCell.h"
#import "RequestTableViewCell.h"
#import "SinglePostViewController.h"
#import "APICaller.h"
#import "Constants.h"
#include "PostPartial.h"

@interface RequestViewController : SidebarImplementedViewController <UITableViewDelegate, UITableViewDataSource>

@end
