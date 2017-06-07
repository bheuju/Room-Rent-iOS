//
//  SidebarImplementedViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/17/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "SidebarImplementedViewController.h"

@interface SidebarImplementedViewController ()

@end

@implementation SidebarImplementedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Reveal View
    SWRevealViewController *revealVC = self.revealViewController;
    
    revealVC.delegate = self;
    
    if (revealVC) {
        
        //[self.sidebarButton setTarget:self.revealViewController];
        //[self.sidebarButton setAction:@selector(revealToggle:)];
        
        UIBarButtonItem *sidebarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-icon"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
        
        self.navigationItem.leftBarButtonItem = sidebarButton;
        
        
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
    
    //Customizing revealViewController
    self.revealViewController.rearViewRevealWidth = SIDEBAR_WIDTH;
    self.revealViewController.rearViewRevealOverdraw = 0.0f;
    
    
    
    UIBarButtonItem *mapsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"grey-location-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(maps)];
    self.navigationItem.rightBarButtonItem = mapsButton;
    
    
    //Preload Data into database
    [self preloadData];
    
}

//MARK: Methods
-(void)maps {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *allMapsVC = [story instantiateViewControllerWithIdentifier:@"AllPostsMapViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:allMapsVC];
    
    //[self.navigationController pushViewController:navController animated:true];
    [self presentViewController:navController animated:true completion:nil];
                       
}


-(void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position {
    
    if (position == FrontViewPositionLeft) {
        [revealController.frontViewController.view setUserInteractionEnabled:true];
    } else {
        [revealController.frontViewController.view setUserInteractionEnabled:false];
        [revealController.frontViewController.revealViewController tapGestureRecognizer];
    }
}


-(void)preloadData {
    [[DBManager sharedInstance] createDatabase];
    [[DBManager sharedInstance] createTable];
    
}


@end
