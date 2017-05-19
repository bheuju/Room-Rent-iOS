//
//  AddPostViewController.h
//  RoomRent
//
//  Created by Bishal Heuju on 4/12/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddressPickerViewController.h"
#import "APICaller.h"
#import "KeyboardAvoidingViewController.h"


#import "Post.h"

@interface AddPostViewController : KeyboardAvoidingViewController <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UICollectionViewDelegateFlowLayout, AddressPickerDelegeate, UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *postPhotoCollectionViewLabel;

@property (weak, nonatomic) IBOutlet UITextField *postTitle;
@property (weak, nonatomic) IBOutlet UITextField *postDescription;
@property (weak, nonatomic) IBOutlet UITextField *postNoOfRooms;
@property (weak, nonatomic) IBOutlet UITextField *postPrice;
@property (weak, nonatomic) IBOutlet UILabel *postAddress;


-(void)populatePhotoCollectionViewWithImage:(UIImage*)image;

@end
