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
@property (weak, nonatomic) IBOutlet MyCircularUIButton *profileImageButton;

@end

NSArray *menuList;

@implementation SidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sidebarTableView.delegate = self;
    self.sidebarTableView.dataSource = self;
    
    menuList = @[@"Profile", @"Logout"];
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:JSON_KEY_USER_OBJECT];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    //Load and cache profileImage
    if (![user.profileImageUrl isEqual:[NSNull null]]) {
        
        NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:JSON_KEY_API_TOKEN];
        
        SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
        [manager setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
        
        NSURL *url = [NSURL URLWithString:[[BASE_URL stringByAppendingString:GETFILE_PATH] stringByAppendingString:user.profileImageUrl]];
        
        [self.profileImageButton sd_setImageWithURL:url forState:UIControlStateNormal];
        [self.profileImageButton setContentMode:UIViewContentModeScaleAspectFit];
        
        self.profileImageButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.profileImageButton.layer.borderWidth = 2.0f;
        
    }
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
    
    if ([item isEqualToString:@"Profile"]) {
        [self profile];
    } else if ([item isEqualToString:@"Logout"]) {
        //Logout from here
        [self logout];
    }
}


//MARK: Extras
-(void)logout {
    //TODO: Logout here
    
    NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:JSON_KEY_API_TOKEN];
    
    NSDictionary *parameters = @{JSON_KEY_API_TOKEN:userApiToken};
    
    //POST: /logout
    [[APICaller sharedInstance:self] callApiForDELETE:LOGOUT_PATH parameters:parameters sendToken:true successBlock:^(id responseObject) {
        NSString *code = [responseObject valueForKey:JSON_KEY_CODE];
        NSString *message = [responseObject valueForKey:JSON_KEY_MESSAGE];
        
                
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

-(void) profile {
    NSString *userApiToken = [[NSUserDefaults standardUserDefaults] valueForKey:JSON_KEY_API_TOKEN];
    NSLog(@"API TOKEN: Bearer %@", userApiToken);
}

@end
