//
//  SignInViewController.h
//  RoomRent
//
//  Created by Bishal Heuju on 3/31/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <SWRevealViewController/SWRevealViewController.h>

#import "SidebarViewController.h"
#import "KeyboardAvoidingViewController.h"
#import "Constants.h"
#import "Alerter.h"
#import "APICaller.h"
#import "MyCustomUITextField.h"
#import "ProgressHUD.h"

#import "User.h"

@interface SignInViewController : KeyboardAvoidingViewController

-(void)checkLogin:(NSString*)usernameOrEmail password:(NSString*)password;

@end
