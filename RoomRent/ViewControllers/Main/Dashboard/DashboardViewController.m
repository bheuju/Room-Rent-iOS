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
    
    
}

- (IBAction)onAddRequest:(UIButton *)sender {
    
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *addRequestVC = [mainStory instantiateViewControllerWithIdentifier:@"AddRequestViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addRequestVC];
    
    [self presentViewController:navController animated:true completion:nil];
    
}

- (IBAction)onAdd:(UIButton*)sender {
   
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *addPostVC = [mainStory instantiateViewControllerWithIdentifier:@"AddPostViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addPostVC];
    
    [self presentViewController:navController animated:true completion:nil];
    
}

@end
