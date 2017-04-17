//
//  DashboardViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/4/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "DashboardViewController.h"

@interface DashboardViewController ()

//@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Reveal View
//    SWRevealViewController *revealVC = self.revealViewController;
//    if (revealVC) {
//        
//        [self.sidebarButton setTarget:self.revealViewController];
//        [self.sidebarButton setAction:@selector(revealToggle:)];
//        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//        
//    }
    
}

- (IBAction)onAdd:(UIButton*)sender {
    //TODO:
    
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *addPostVC = [mainStory instantiateViewControllerWithIdentifier:@"AddPostViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addPostVC];
    
    [self presentViewController:navController animated:true completion:nil];
    
}

@end
