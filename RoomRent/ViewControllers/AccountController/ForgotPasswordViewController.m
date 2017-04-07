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
    
    NSDictionary *parameters = @{
                                 KEY_EMAIL: email
                                 };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:[BASE_URL stringByAppendingString:FORGOT_PASSWORD_PATH] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Complete, Respose: %@", responseObject);
        
        
        //TODO: Implement ResponseHandler here
        //parse validation messages from server and append to "message" to be shown in alerter 
        
        //TODO: Parse JSON response and Set user data
        NSDictionary *jsonDictionary = (NSDictionary *)responseObject;
        
        NSString *code = [jsonDictionary valueForKey:JSON_KEY_CODE];
        NSString *message = [jsonDictionary valueForKey:JSON_KEY_MESSAGE];
        
        
        if ([code isEqualToString:PASSWORD_RESET_LINK_SENT]) {
            
            [[Alerter sharedInstance] createAlert:@"Success" message:message viewController:self completion:^{
                
                //Switch to login view
                [self dismissViewControllerAnimated:true completion:nil];
                
            }];
            
            NSLog(@"Register Success");
            
        } else {
            [[Alerter sharedInstance] createAlert:@"Failure" message:message viewController:self completion:^{}];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Fail, Respose: %@", error);
        
        //NSString *message = [error valueForKey:@"message"];
        
        [[Alerter sharedInstance] createAlert:@"Server Error" message:@"Server is offline! \nSorry for the inconvenience. \nPlease try again later." viewController:self completion:^{}];
        
    }];
}

- (void)onCancel {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
