//
//  SignInViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 3/31/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet MyCustomUITextField *emailAddress;
@property (weak, nonatomic) IBOutlet MyCustomUITextField *password;

@end


@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //PROTOTYPE: Data
    self.emailAddress.text = @"zeros";
    self.password.text = @"zeros";
    
    self.emailAddress.delegate = self;
    self.password.delegate = self;
    
    //Textfields validation setup
    [self.emailAddress addRegex:@"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" withValidationMsg:@"Invalid email address"];
    [self.password addRegex:@"^.{3,50}$" withValidationMsg:@"PAssword should be at least 3 characters"];
    
    //Transparent navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    //self.navigationController.view.backgroundColor = [UIColor clearColor];
    //self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}


//MARK: Button Actions

- (IBAction)onSignIn:(UIButton *)sender {
    
    //TODO: Validiation of fields
    
    [self checkLogin];
    
    //Switch to tabBarViewController
    //    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    //
    //
    //    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //
    //    UITabBarController *mainTabBarController = [mainStory instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    //
    //    [window setRootViewController:mainTabBarController];
    //    [window makeKeyAndVisible];
    
}

- (IBAction)onForgotPassword:(UIButton*)sender {
    
    UIViewController *forgotPasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    
    //[self.navigationController pushViewController:forgotPasswordVC animated:true];
    
    //UIBarButtonItem cancelButton = UIBarButtonSystemItemCancel
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:forgotPasswordVC];
    
    [self.navigationController presentViewController:navController animated:true completion:nil];
    
}

- (IBAction)onSignUp:(UIButton *)sender {
    
    UIViewController *signUpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    
    //[self.navigationController pushViewController:forgotPasswordVC animated:true];
    
    //UIBarButtonItem cancelButton = UIBarButtonSystemItemCancel
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:signUpVC];
    
    [self.navigationController presentViewController:navController animated:true completion:nil];
    
}


//MARK: Extras
- (void)checkLogin {
    
    //Get Form entries
    NSString* usernameOrEmail = self.emailAddress.text;
    NSString* password = self.password.text;
    
    NSDictionary *parameters = @{
                                 @"identity": usernameOrEmail,
                                 @"password": password,
                                 @"device_type": DEVICE_TYPE,
                                 @"device_token": DEVICE_TOKEN
                                 };
    
    
    //[[APICaller sharedInstance] callApi:LOGIN_PATH parameters:parameters successBlock:^{
        //JsonResponse;
        
    //}];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:[BASE_URL stringByAppendingString:LOGIN_PATH] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Complete, Respose: %@", responseObject);
        
        //TODO: Parse JSON response and Set user data
        NSDictionary *jsonDictionary = (NSDictionary *)responseObject;
        
        NSString *code = [jsonDictionary valueForKey:@"code"];
        NSString *message = [jsonDictionary valueForKey:@"message"];
        
        if ([code isEqualToString:LOGIN_SUCCESS]) {
            
            [[Alerter sharedInstance] createAlert:@"Success" message:message viewController:self completion:^{
                
                //Switch to tabBarViewController
                UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
                UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UITabBarController *mainTabBarController = [mainStory instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                [window setRootViewController:mainTabBarController];
                [window makeKeyAndVisible];
                
                id userJson = [jsonDictionary valueForKey:@"user"];
                
                //Init User
                User *user = [[User alloc] initUserFromJson:userJson];
                
                
                //TODO: Save userdata to NSUserDefaults
                
            }];
            
            NSLog(@"Login Success");
            
        } else if ([code isEqualToString:LOGIN_ERROR]) {
            [[Alerter sharedInstance] createAlert:@"Failure" message:message viewController:self completion:^{}];
        } else {
            [[Alerter sharedInstance] createAlert:@"Failure" message:message viewController:self completion:^{}];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Fail, Respose: %@", error);
        
        //NSString *message = [error valueForKey:@"message"];
        
        [[Alerter sharedInstance] createAlert:@"Server Error" message:@"Server is offline! \nSorry for the inconvenience. \nPlease try again later." viewController:self completion:^{}];
        
    }];
    
    
}


@end
