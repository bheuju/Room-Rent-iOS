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


-(void)populatePhotoCollectionViewWithImage:(UIImage*)image;

@end
