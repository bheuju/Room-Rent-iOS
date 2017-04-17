//
//  SidebarViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/13/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "SidebarViewController.h"

@interface SidebarViewController ()

@property (weak, nonatomic) IBOutlet UITableView *sidebarTableView;

@end

NSArray *menuList;

@implementation SidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sidebarTableView.delegate = self;
    self.sidebarTableView.dataSource = self;

    menuList = @[@"Profile",@"Logout"];
}


//MARK: UITableView Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menuList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuListCell"];
    
    [[cell textLabel] setText:menuList[indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    [[cell textLabel] setTextColor:[UIColor whiteColor]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *item = menuList[indexPath.row];
    
    if ([item isEqualToString:@"Logout"]) {
        //Logout from here
        [self logout];
    }
}


//MARK: Extras
-(void)logout {
    //TODO: Logout here
    
    NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:JSON_KEY_API_TOKEN];
    
    NSDictionary *parameters = @{JSON_KEY_API_TOKEN:userApiToken};
    
    [[APICaller sharedInstance] callApi:LOGOUT_PATH parameters:parameters successBlock:^(id responseObject) {
        NSString *code = [responseObject valueForKey:JSON_KEY_CODE];
        NSString *message = [responseObject valueForKey:JSON_KEY_MESSAGE];
        
        [[Alerter sharedInstance] createAlert:@"Logout" message:message viewController:self completion:^{}];
        
        //Switch to SignInViewController
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        UIStoryboard *accountStory = [UIStoryboard storyboardWithName:@"Account" bundle:nil];
        
        UIViewController *signInVC = [accountStory instantiateViewControllerWithIdentifier:@"SignInViewController"];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:signInVC];
        
        [window setRootViewController:navController];
        [window makeKeyAndVisible];
        
        //TODO: Clear UserData
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:JSON_KEY_USER_OBJECT];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:JSON_KEY_API_TOKEN];
    }];
}

@end
