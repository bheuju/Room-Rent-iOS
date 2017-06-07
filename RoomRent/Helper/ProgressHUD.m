//
//  ProgressHUD.m
//  RoomRent
//
//  Created by Bishal Heuju on 6/1/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "ProgressHUD.h"

@implementation ProgressHUD

UIActivityIndicatorView *indicator;
ProgressHUD *hud;
UIView *parentView;

+(ProgressHUD*)showProgressHUDAddedToView:(UIView*)view {
    
    parentView = view;
    
    hud = [[self alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    hud.layer.cornerRadius = 15.0f;
    [hud setBackgroundColor:[UIColor grayColor]];
    [view addSubview:hud];
    [hud bringSubviewToFront:view];
    
    
    //Activity progress
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame = CGRectMake(0.0, 0.0, 50.0, 50.0);
    indicator.center = hud.center;
    [hud addSubview:indicator];
    [indicator bringSubviewToFront:hud];
    
    [indicator startAnimating];
    
    hud.center = view.center;
    
    //Disable background view
    parentView.userInteractionEnabled = false;
    parentView.alpha = 0.8f;
    
    return hud;
}


+(void)hideProgressHUD {
    
    [indicator stopAnimating];
    [hud setHidden:true];
    
    //Enable background view
    parentView.userInteractionEnabled = true;
    parentView.alpha = 1.0f;
    
    
}


@end
