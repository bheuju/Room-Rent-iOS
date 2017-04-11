//
//  OfferViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/4/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "OfferViewController.h"

@interface OfferViewController ()

@end

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onLogout:(UIButton *)sender {
    //TODO: Logout here
    
    NSString *userApiToken = [User getUserApiToken];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    
    [manager POST:[BASE_URL stringByAppendingString:LOGOUT_PATH] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *code = [responseObject valueForKey:JSON_KEY_CODE];
        NSString *message = [responseObject valueForKey:JSON_KEY_MESSAGE];
        
        [[Alerter sharedInstance] createAlert:@"Logout" message:message viewController:self completion:^{
            
            //Switch to SignInViewController
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            UIStoryboard *accountStory = [UIStoryboard storyboardWithName:@"Account" bundle:nil];
            
            UIViewController *signInVC = [accountStory instantiateViewControllerWithIdentifier:@"SignInViewController"];
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:signInVC];
            
            [window setRootViewController:navController];
            [window makeKeyAndVisible];
            
            
        }];
        
        
        //TODO: Clear UserData
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:JSON_KEY_USER_OBJECT];
        
        
        NSLog(@"Success Response: %@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error Response: %@", error);
        
    }];

    
    
    

}

@end
