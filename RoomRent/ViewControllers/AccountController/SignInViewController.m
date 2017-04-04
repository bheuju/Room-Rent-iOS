//
//  SignInViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 3/31/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end


@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.emailAddress.text = @"admin@admin.com";
    //self.password.text = @"password";
    
    self.emailAddress.delegate = self;
    self.password.delegate = self;
    
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    
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
    
    //Switch to tabBarViewController
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UITabBarController *mainTabBarController = [mainStory instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    
    [window setRootViewController:mainTabBarController];
    [window makeKeyAndVisible];
    
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:true];
}

//MARK: Keyboard notifications handling
-(void)keyboardWillShow:(NSNotification*)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    int h = self.view.frame.size.height;
    int w = self.view.frame.size.width;
    
    CGRect viewFrame = CGRectMake(0, -keyboardSize.height, w, h);
    [self.view setFrame:viewFrame];
    
}

-(void)keyboardWillHide:(NSNotification*)notification {
    
    int h = self.view.frame.size.height;
    int w = self.view.frame.size.width;
    
    CGRect viewFrame = CGRectMake(0, 0, w, h);
    [self.view setFrame:viewFrame];
}

//MARK: TextFieldDelegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return true;
}


@end
