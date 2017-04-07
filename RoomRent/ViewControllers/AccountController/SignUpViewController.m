//
//  SignUpViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 3/31/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController () <UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnImagePicker;

@property (weak, nonatomic) IBOutlet UITextField *textfieldName;
@property (weak, nonatomic) IBOutlet UITextField *textfieldPhone;
@property (weak, nonatomic) IBOutlet UITextField *textfieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textfieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textfieldPassword;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.textfieldName.text = @"test";
    self.textfieldPhone.text = @"test";
    self.textfieldUsername.text = @"test";
    self.textfieldEmail.text = @"test@test.com";
    self.textfieldPassword.text = @"test";
    
    
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
- (IBAction)onImagePickerClicked:(UIButton*)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = true;
    [self presentViewController:picker animated:true completion:nil];
}

- (IBAction)onCreateNewAccount:(UIButton *)sender {
    
    NSString *name = self.textfieldName.text;
    NSString *phone = self.textfieldPhone.text;
    NSString *username = self.textfieldUsername.text;
    NSString *email = self.textfieldEmail.text;
    NSString *password = self.textfieldPassword.text;
    
    
    //TODO: Validation of fields
    
    
    
    
    
    
    User *user = [[User alloc] initUser:0 name:name phone:phone username:username email:email password:password];
    
    NSDictionary *parameters = @{
                                 KEY_NAME: name,
                                 KEY_PHONE: phone,
                                 KEY_USERNAME: username,
                                 KEY_EMAIL: email,
                                 KEY_PASSWORD: password
                                 };
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:[BASE_URL stringByAppendingString:SIGNUP_PATH] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *code = [responseObject valueForKey:JSON_KEY_CODE];
        
        if ([code isEqualToString:REGISTER_SUCCESS]) {
            
            //Alert account created successful
            [[Alerter sharedInstance] createAlert:@"Success" message:@"Account created" viewController:self completion:^{
                
                //Dismiss to login view
                [self dismissViewControllerAnimated:true completion:nil];
            }];
            
        } else {
            NSString *message = [responseObject valueForKey:JSON_KEY_MESSAGE];
            [[Alerter sharedInstance] createAlert:@"Error" message:message viewController:self completion:^{}];
        }
        
        NSLog(@"Success: %@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Failure: %@", error);
        
    }];
}


//MARK: Extras
- (void)onCancel {
    [self dismissViewControllerAnimated:true completion:nil];
}


//MARK: UIImagePickerContollerDelegate Methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    //Set picked image on button
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.btnImagePicker setImage:selectedImage forState:UIControlStateNormal];
    [self.btnImagePicker setContentMode:UIViewContentModeScaleAspectFit];
    
    //Image border and color
    
    //self.btnImagePicker.clipsToBounds = true;
    //self.btnImagePicker.layer.masksToBounds = true;
    //self.btnImagePicker.layer.cornerRadius = self.btnImagePicker.layer.frame.size.width / 2;
    self.btnImagePicker.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnImagePicker.layer.borderWidth = 2.0f;
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}

@end
