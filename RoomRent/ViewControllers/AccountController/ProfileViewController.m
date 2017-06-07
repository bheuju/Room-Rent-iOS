//
//  ProfileViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 5/29/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet MyCircularUIButton *profileImageButton;
@property (weak, nonatomic) IBOutlet UIButton *userPostsOffersButton;
@property (weak, nonatomic) IBOutlet UIButton *userPostsRequestsButton;
@property (weak, nonatomic) IBOutlet UILabel *userEmail;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userUsername;


@end


@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel)];
    cancel.tintColor = [UIColor whiteColor];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEdit)];
    edit.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = cancel;
    self.navigationItem.rightBarButtonItem = edit;
    
    //Transparent navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    //self.navigationController.view.backgroundColor = [UIColor clearColor];
    //self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    if (self.user != nil) {
        [self initProfile];
    }
}


-(void) initProfile {
    
    [self.profileImageButton sd_setImageWithURL:[[Helper sharedInstance] generateGetImageURLFromFilename:self.user.profileImageUrl] forState:UIControlStateNormal];
    self.userName.text = self.user.name;
    self.userUsername.text = self.user.username;
    self.userPhone.text = self.user.phone;
    self.userEmail.text = self.user.email;
    
    //TODO: get Offers and Asks Counts and set
    NSString *offersCount = @"5";
    NSString *requestsCount = @"7";
    [self.userPostsOffersButton setTitle:[offersCount stringByAppendingString:@" Offers"] forState:UIControlStateNormal];
    [self.userPostsRequestsButton setTitle:[requestsCount stringByAppendingString:@" Requests"] forState:UIControlStateNormal];
    
}


//MARK: Methods
-(void)onEdit {
    //Open EditProfileVC
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Account" bundle:nil];
    
    UIViewController *editProfileVC = [story instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    ((EditProfileViewController*)editProfileVC).user = [[Helper sharedInstance] getUserFromUserDefaults];
    
    //UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:editProfileVC];
    
    [self.navigationController pushViewController:editProfileVC animated:true];
}

-(void)onCancel {
    [self dismissViewControllerAnimated:true completion:nil];
}


//MARK: Button Click Events
- (IBAction)onUserPostsOffersClicked:(UIButton *)sender {
    //Navigate to user dashboard : OFFERS
}

- (IBAction)onUserPostsRequestsClicked:(UIButton *)sender {
    //Navigate to user dasboard : REQUESTS
}

@end
