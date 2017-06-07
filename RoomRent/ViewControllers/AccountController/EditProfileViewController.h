//
//  EditProfileViewController.h
//  RoomRent
//
//  Created by Bishal Heuju on 6/6/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <SDWebImage/UIButton+WebCache.h>

#import "MyCustomUITextField.h"
#import "APICaller.h"
#import "Helper.h"

#import "User.h"

@interface EditProfileViewController : UIViewController <UIImagePickerControllerDelegate>

@property User* user;

@end
