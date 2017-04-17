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
    revealVC.rearViewRevealWidth = SIDEBAR_WIDTH;
    revealVC.rearViewRevealOverdraw = 0.0f;
    
}

-(void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position {
    
    if (position == FrontViewPositionLeft) {
        [revealController.frontViewController.view setUserInteractionEnabled:true];
    } else {
        [revealController.frontViewController.view setUserInteractionEnabled:false];
        [revealController.frontViewController.revealViewController tapGestureRecognizer];
    }
}

@end
