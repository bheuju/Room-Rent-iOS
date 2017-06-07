//
//  EditProfileViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 6/6/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()

@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;

@property (weak, nonatomic) IBOutlet MyCustomUITextField *textfieldName;
@property (weak, nonatomic) IBOutlet MyCustomUITextField *textfieldPhone;
@property (weak, nonatomic) IBOutlet MyCustomUITextField *textfieldUsername;
@property (weak, nonatomic) IBOutlet MyCustomUITextField *textfieldEmail;
@property (weak, nonatomic) IBOutlet MyCustomUITextField *textfieldPassword;
@property (weak, nonatomic) IBOutlet MyCustomUITextField *textfieldConfirmPassword;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textfieldName.text = self.user.name;
    self.textfieldPhone.text = self.user.phone;
    self.textfieldUsername.text = self.user.username;
    self.textfieldEmail.text = self.user.email;
    
    [self.profileImageButton sd_setImageWithURL:[[Helper sharedInstance] generateGetImageURLFromFilename:self.user.profileImageUrl] forState:UIControlStateNormal];
    
}

//MARK: Methods
-(void)updateProfileImage:(UIImage*)profileImage {
    if (profileImage != nil) {
        //POST: /updateavatar
        [[APICaller sharedInstance:self] callApi:UPDATE_AVATAR parameters:nil image:profileImage sendToken:true successBlock:^(id responseObject) {
            
            //Avatar updated successfully
            NSString *imageName = [responseObject valueForKey:@"data"];
            
            [self.profileImageButton sd_setImageWithURL:[[Helper sharedInstance] generateGetImageURLFromFilename:imageName] forState:UIControlStateNormal];
            
            //Also update userDefaults
            User *tempUser = [[Helper sharedInstance] getUserFromUserDefaults];
            tempUser.profileImageUrl = imageName;
            [[Helper sharedInstance] setUserToUserDefaults:tempUser];
            
        }];
    }
}

//MARK: Button Click Actions
- (IBAction)onProfileImageButtonClicked:(UIButton *)sender {
    //Update profile image
    
    //Choose image with imagepicker
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = true;
    
    //UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:picker];
    
    [self presentViewController:picker animated:true completion:nil];
    //[self presentViewController:navVC animated:true completion:nil];
}

- (IBAction)onUpdateProfileClicked:(UIButton *)sender {
    
    NSString *name = self.textfieldName.text;
    NSString *phone = self.textfieldPhone.text;
    NSString *username = self.textfieldUsername.text;
    NSString *email = self.textfieldEmail.text;
    NSString *password = self.textfieldPassword.text;
    NSString *confirmpassword = self.textfieldConfirmPassword.text;
    
    
    
    
    //Validation of fields
    //Explicit validation on clicking of submit button
    [self.textfieldName validate];
    [self.textfieldPhone validate];
    [self.textfieldUsername validate];
    [self.textfieldEmail validate];
    [self.textfieldPassword validate];
    [self.textfieldConfirmPassword validate];
    
    if (![password isEqualToString:confirmpassword]) {
        [[Alerter sharedInstance] createAlert:@"Error" message:@"Passwords do not match" viewController:self completion:^{}];
    }
    
    NSDictionary *parameters = @{
                                 JSON_KEY_NAME: name,
                                 JSON_KEY_PHONE: phone,
                                 JSON_KEY_PASSWORD: password,
                                 JSON_KEY_CONFIRM_PASSWORD: confirmpassword
                                 };
    
    if (![self.textfieldPassword hasText]) {
        parameters = @{
                       JSON_KEY_NAME: name,
                       JSON_KEY_PHONE: phone
                       };
    }
    
    [[APICaller sharedInstance:self] callApiForPUT:USER_PATH parameters:parameters sendToken:true successBlock:^(id responseObject) {
        
        User *user = [[Helper sharedInstance] getUserFromUserDefaults];
        
        user.name = name;
        user.phone = phone;
        
        [[Helper sharedInstance] setUserToUserDefaults:user];
        
        [self dismissViewControllerAnimated:true completion:^{
            
            
        }];
        
    }];
    
}


//MARK: ImagePicker Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    //Set picked image on button
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //Update profileImage
    [self updateProfileImage:selectedImage];
    
    [self dismissViewControllerAnimated:true completion:nil];
}



@end
