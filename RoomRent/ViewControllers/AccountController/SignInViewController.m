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

@property (weak, nonatomic) IBOutlet UIButton *signInButton;


@end


@implementation SignInViewController

User *user = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //PROTOTYPE: Data
    self.emailAddress.text = @"zero";
    //    self.password.text = @"zero";
    self.password.text = @"Ball1234";
    
    //Textfields validation setup
    //[self.emailAddress addRegex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}" withValidationMsg:@"Invalid email address"];
    //[self.password addRegex:@"^.{4,50}$" withValidationMsg:@"Password should be at least 4 characters"];
    [self.emailAddress setIsRequired];
    [self.password setIsRequired];
    
    
    //Transparent navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    //self.navigationController.view.backgroundColor = [UIColor clearColor];
    //self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}


//MARK: Button Actions

- (IBAction)onSignIn:(UIButton *)sender {
    
    //self.signInButton.enabled = false;
    //self.signInButton.alpha = 0.5;
    
    //Get Form entries
    NSString* usernameOrEmail = self.emailAddress.text;
    NSString* password = self.password.text;
    
    //Validation of fields
    //Explicit validation on clicking of submit button
    [self.emailAddress validate];
    [self.password validate];
    
    [self checkLogin:usernameOrEmail password:password];
    
}

- (IBAction)onForgotPassword:(UIButton*)sender {
    
    UIViewController *forgotPasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    
    
    //UIBarButtonItem cancelButton = UIBarButtonSystemItemCancel
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:forgotPasswordVC];
    
    [self.navigationController presentViewController:navController animated:true completion:nil];
    
}

- (IBAction)onSignUp:(UIButton *)sender {
    
    UIViewController *signUpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:signUpVC];
    
    [self.navigationController presentViewController:navController animated:true completion:nil];
    
}


//MARK: Extras
- (void)checkLogin:(NSString*)usernameOrEmail password:(NSString*)password {
    
    NSDictionary *parameters = @{
                                 JSON_KEY_IDENTITY: usernameOrEmail,
                                 JSON_KEY_PASSWORD: password,
                                 JSON_KEY_DEVICE_TYPE: DEVICE_TYPE,
                                 JSON_KEY_DEVICE_TOKEN: DEVICE_TOKEN
                                 };
    
    //POST: /login
    [[APICaller sharedInstance:self] callApiForPOST:LOGIN_PATH parameters:parameters sendToken:false successBlock:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:JSON_KEY_CODE];
        NSString *message = [responseObject valueForKey:JSON_KEY_MESSAGE];
        
        if ([code isEqualToString:CODE_LOGIN_SUCCESS]) {
            
            //Extract and init USER
            id userJson = [responseObject valueForKey:JSON_KEY_USER_OBJECT];
            
            //set userdata
            user = [[User alloc] initUserFromJson:userJson];
            
            
            //Save userdata to NSUserDefaults
            [[Helper sharedInstance] setUserToUserDefaults:user];
            
            //set userApiToken
            NSString *userApiToken = [responseObject valueForKey:JSON_KEY_API_TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:userApiToken forKey:JSON_KEY_API_TOKEN];
            
            //For SDWebImage Manager to send api_token in header (needed only once: appdelegate autologin/signin)
            SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
            [manager setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
            
            //Switch to tabBarViewController
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *mainTabBarController = [mainStory instantiateViewControllerWithIdentifier:@"MainTabBarController"];
            
            UIViewController *sidebarVC = [mainStory instantiateViewControllerWithIdentifier:@"SidebarViewController"];
            
            //UINavigationController *mainVC = [[UINavigationController alloc] initWithRootViewController:mainTabBarController];
            SWRevealViewController *revealVC = [[SWRevealViewController alloc] initWithRearViewController:sidebarVC frontViewController:mainTabBarController];
            
            [window setRootViewController:revealVC];
            [window makeKeyAndVisible];
            
        } else {
            [[Alerter sharedInstance] createAlert:@"Failure" message:message viewController:self completion:^{}];
        }
        
    }];
    
}


@end
