//
//  ProgressHUD.h
//  RoomRent
//
//  Created by Bishal Heuju on 6/1/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressHUD : UIView

+(ProgressHUD*)showProgressHUDAddedToView:(UIView*)view;
+(void)hideProgressHUD;

@end
