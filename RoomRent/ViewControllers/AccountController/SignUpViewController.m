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


@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];

    
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
    
    //TODO: Validation of fields
    
    Alerter *alert = [[Alerter alloc] init];
    [alert createAlert:@"Success" message:@"Account created" viewController:self];
    
    //Dismiss to login view
    //[self dismissViewControllerAnimated:true completion:nil];
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

@end
