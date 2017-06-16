//
//  ProgressHUD.m
//  RoomRent
//
//  Created by Bishal Heuju on 6/1/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "ProgressHUD.h"

@implementation ProgressHUD

static ProgressHUD *instance = nil;

UIActivityIndicatorView *indicator;
UIView *hud;
UIView *parentView;

+(ProgressHUD*)sharedInstance {
    if (instance == nil) {
        instance = [[ProgressHUD alloc] init];
        return instance;
    }
    return instance;
}

-(void)showProgressHUDAddedToView:(UIView*)view {
    
    parentView = view;
    
    hud = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
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
    
    //   return ;
}


-(void)hideProgressHUD {
    
    [indicator stopAnimating];
    [hud setHidden:true];
    [hud removeFromSuperview];
    
    //Enable background view
    parentView.userInteractionEnabled = true;
    parentView.alpha = 1.0f;
    
}


@end
