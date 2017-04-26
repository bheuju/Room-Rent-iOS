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

User *user = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //PROTOTYPE: Data
    self.emailAddress.text = @"zeros";
    self.password.text = @"zeros";
    
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
- (void)checkLogin:(NSString*)usernameOrEmail password:(NSString*)password {
    
    NSDictionary *parameters = @{
                                 JSON_KEY_IDENTITY: usernameOrEmail,
                                 JSON_KEY_PASSWORD: password,
                                 JSON_KEY_DEVICE_TYPE: DEVICE_TYPE,
                                 JSON_KEY_DEVICE_TOKEN: DEVICE_TOKEN
                                 };
    
    //Call API
    [[APICaller sharedInstance] callApi:LOGIN_PATH parameters:parameters sendToken:false successBlock:^(id responseObject) {
        
        //[[ResponseHandler sharedInstance] handleResponse:responseObject];
        
        NSString *code = [responseObject valueForKey:JSON_KEY_CODE];
        NSString *message = [responseObject valueForKey:JSON_KEY_MESSAGE];
        
        if ([code isEqualToString:CODE_LOGIN_SUCCESS]) {
            
            //Alert user and do login activities
            [[Alerter sharedInstance] createAlert:@"Success" message:message viewController:self completion:^{
                
                //Switch to tabBarViewController
                UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
                UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UITabBarController *mainTabBarController = [mainStory instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                
                UIViewController *sidebarVC = [mainStory instantiateViewControllerWithIdentifier:@"SidebarViewController"];
                
                //UINavigationController *mainVC = [[UINavigationController alloc] initWithRootViewController:mainTabBarController];
                SWRevealViewController *revealVC = [[SWRevealViewController alloc] initWithRearViewController:sidebarVC frontViewController:mainTabBarController];
                
                [window setRootViewController:revealVC];
                [window makeKeyAndVisible];
            }];
            
            
            //Extract and init USER
            id userJson = [responseObject valueForKey:JSON_KEY_USER_OBJECT];
            
            //set userdata
            user = [[User alloc] initUserFromJson:userJson];
            
            //MARK: Temporary for test
            //user.profileImageUrl = [responseObject valueForKey:JSON_KEY_PROFILE_IMAGE_URL];
            //User *tempUser = user;
            
            
            //Save userdata to NSUserDefaults
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
            [userDefaults setObject:userData forKey:JSON_KEY_USER_OBJECT];
            [userDefaults synchronize];
            
            //set userApiToken
            NSString *userApiToken = [responseObject valueForKey:JSON_KEY_API_TOKEN];
            [userDefaults setObject:userApiToken forKey:JSON_KEY_API_TOKEN];
            
            //Reading userdata from NSUserDefaults
            //NSData *data = [userDefaults objectForKey:JSON_KEY_USER_OBJECT];
            //User *u = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            //int x = 5;
            
        } else {
            [[Alerter sharedInstance] createAlert:@"Failure" message:message viewController:self completion:^{}];
        }
        
    }];
    
}


@end
