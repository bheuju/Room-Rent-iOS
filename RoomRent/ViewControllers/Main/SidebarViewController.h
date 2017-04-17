//
//  SidebarViewController.h
//  RoomRent
//
//  Created by Bishal Heuju on 4/13/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

#import "Constants.h"
#import "Alerter.h"
#import "APICaller.h"


@interface SidebarViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


-(void)logout;

@end
