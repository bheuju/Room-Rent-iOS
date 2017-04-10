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

@property (weak, nonatomic) IBOutlet MyCustomUITextField *textfieldName;
@property (weak, nonatomic) IBOutlet MyCustomUITextField *textfieldPhone;
@property (weak, nonatomic) IBOutlet MyCustomUITextField *textfieldUsername;
@property (weak, nonatomic) IBOutlet MyCustomUITextField *textfieldEmail;
@property (weak, nonatomic) IBOutlet MyCustomUITextField *textfieldPassword;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Textfields validation setup
    //[self.textfieldName addRegex:@"([A-Za-z]+),\\s+([A-Za-z]+)\\s+([A-Za-z]+)?$" withValidationMsg:@"Invalid name format"];
    [self.textfieldPhone addRegex:@"((\\+){0,1}977(\\s){0,1}(\\-){0,1}(\\s){0,1}){0,1}9[7-8](\\s){0,1}(\\-){0,1}(\\s){0,1}[0-9]{1}[0-9]{7}$" withValidationMsg:@"Invalid phone format"];
    [self.textfieldUsername addRegex:@"(?!.*[\\.\\-\\_]{2,})^[a-zA-Z0-9\\.\\-\\_]{3,24}$" withValidationMsg:@"Username can not contain special characters"];
    [self.textfieldEmail addRegex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}" withValidationMsg:@"Invalid email address"];
    [self.textfieldPassword addRegex:@"^.{4,50}$" withValidationMsg:@"Password should be at least 3 characters"];
    
    
    //PROTOTYPE: test data
    //self.textfieldName.text = @"test";
    //self.textfieldPhone.text = @"9845685945";
    //self.textfieldUsername.text = @"test";
    //self.textfieldEmail.text = @"test@test.com";
    //self.textfieldPassword.text = @"test";
    
    //Add cancel button to VC
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
    
    
    //Validation of fields
    //Explicit validation on clicking of submit button
    [self.textfieldName validate];
    [self.textfieldPhone validate];
    [self.textfieldUsername validate];
    [self.textfieldEmail validate];
    [self.textfieldPassword validate];
    
    //User *user = [[User alloc] initUser:0 name:name phone:phone username:username email:email password:password];
    
    NSDictionary *parameters = @{
                                 JSON_KEY_NAME: name,
                                 JSON_KEY_PHONE: phone,
                                 JSON_KEY_USERNAME: username,
                                 JSON_KEY_EMAIL: email,
                                 JSON_KEY_PASSWORD: password
                                 };
    
    
    [[APICaller sharedInstance] callApi:SIGNUP_PATH parameters:parameters successBlock:^(id responseObject) {
        
        NSString *code = [responseObject valueForKey:JSON_KEY_CODE];
        NSString *message = [responseObject valueForKey:JSON_KEY_MESSAGE];
        
        if ([code isEqualToString:CODE_REGISTER_SUCCESS]) {
            
            //Alert account created successful
            [[Alerter sharedInstance] createAlert:@"Success" message:message viewController:self completion:^{
                
                //Dismiss to login view
                [self dismissViewControllerAnimated:true completion:nil];
            }];
            
        } else if ([code isEqualToString:CODE_VALIDATION_ERROR]) {
            
            message = [message stringByAppendingString:@"\n"];
            
            //Extract all error messages to display in alerter
            NSDictionary *validationErrors = (NSDictionary*) [responseObject valueForKey:JSON_KEY_VALIDATION_ERROR];
            
            NSArray* keys = [validationErrors allKeys];
            for(NSString* key in keys) {
                
                //TODO: Crash here, msg is not returned as string
                //NSString *msg = [validationErrors valueForKey:key];
                
                NSArray* msgArray = [[validationErrors valueForKey:key] allObjects];
                for (NSString *msg in msgArray) {
                    
                    //NSLog(@"Message: %@", msg);
                    
                    message = [message stringByAppendingString:@"\n"];
                    message = [message stringByAppendingString:msg];
                }
            }
            
            [[Alerter sharedInstance] createAlert:@"Error" message:message viewController:self completion:^{}];
            
        } else {
            
            [[Alerter sharedInstance] createAlert:@"Error" message:message viewController:self completion:^{}];
        }
        
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
