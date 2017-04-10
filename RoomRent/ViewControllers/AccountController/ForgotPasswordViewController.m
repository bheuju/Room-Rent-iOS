//
//  ForgotPasswordViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 3/31/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet MyCustomUITextField *textfieldEmail;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Textfields validation setup
    [self.textfieldEmail addRegex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}" withValidationMsg:@"Invalid email address"];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    cancelButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    //Transparent navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    //self.navigationController.view.backgroundColor = [UIColor clearColor];
    //self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
}

//MARK: Button Click Actions
- (IBAction)onForgotPassword:(UIButton *)sender {
    
    NSString* email = self.textfieldEmail.text;
    
    //Validation of fields
    //Explicit validation on clicking of submit button
    [self.textfieldEmail validate];
    
    NSDictionary *parameters = @{
                                 JSON_KEY_EMAIL: email
                                 };
    
    [[APICaller sharedInstance] callApi:FORGOT_PASSWORD_PATH parameters:parameters successBlock:^(id responseObject) {
               
        NSString *code = [responseObject valueForKey:JSON_KEY_CODE];
        NSString *message = [responseObject valueForKey:JSON_KEY_MESSAGE];
        
        
        if ([code isEqualToString:CODE_PASSWORD_RESET_LINK_SENT]) {
            
            [[Alerter sharedInstance] createAlert:@"Success" message:message viewController:self completion:^{
                
                //Switch to login view
                [self dismissViewControllerAnimated:true completion:nil];
                
            }];
            
            //NSLog(@"Forgot password Success");
            
        } else {
            [[Alerter sharedInstance] createAlert:@"Failure" message:message viewController:self completion:^{}];
        }
        
   
        
    }];
}

//MARK: Extras
- (void)onCancel {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
