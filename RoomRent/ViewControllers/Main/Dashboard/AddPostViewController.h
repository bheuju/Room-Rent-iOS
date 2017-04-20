//
//  AddPostViewController.h
//  RoomRent
//
//  Created by Bishal Heuju on 4/12/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddressPickerViewController.h"

@interface AddPostViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UICollectionViewDelegateFlowLayout, AddressPickerDelegeate>

-(void)populatePhotoCollectionViewWithImage:(UIImage*)image;

@end
