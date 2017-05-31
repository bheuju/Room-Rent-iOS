//
//  SidebarViewController.h
//  RoomRent
//
//  Created by Bishal Heuju on 4/13/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>

#import "Constants.h"
#import "Alerter.h"
#import "APICaller.h"
#import "MyCircularUIButton.h"

#import "ProfileViewController.h"

#import "User.h"


@interface SidebarViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate>


-(void)logout;

@end
