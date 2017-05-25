//
//  AddPostViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/12/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "AddPostViewController.h"

@interface AddPostViewController ()


@end


@implementation AddPostViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(onCancel)];
    
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    self.photoList = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"addPhotosIcon"], nil];
    
    if (self.post == nil) {
        self.post = [[Post alloc] init];
    }
    
    self.allowAddingImage = true;
    
    //FlowLayout
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.photoCollectionView.collectionViewLayout;
    [layout setItemSize:CGSizeMake(75, 75)];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self;
    
    if (self.addPostType == REQUEST || self.isEditing) {
        [self.photoCollectionView removeFromSuperview];
        [self.postPhotoCollectionViewLabel removeFromSuperview];
    }
    
    if (self.isEditing) {
        self.postTitle.text = self.post.postTitle;
        self.postDescription.text = self.post.postDescription;
        self.postNoOfRooms.text = [self.post.postNoOfRooms stringValue];
        self.postPrice.text = [self.post.postPrice stringValue];
        self.postAddress.text = self.post.postAddress;
    }
    
    self.postPrice.delegate = self;
    
}

//MARK: Methods
-(void)onCancel {
    [self dismissViewControllerAnimated:true completion:nil];
    [self.navigationController popViewControllerAnimated:true];
}



//MARK: Button click methods
- (IBAction)onAddressPickerButtonClicked:(UIButton *)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressPickerViewController *addressPickerVC = (AddressPickerViewController*)[story instantiateViewControllerWithIdentifier:@"AddressPickerViewController"];
    
    addressPickerVC.addressPickerDelegate = self;
    
    [self presentViewController:addressPickerVC animated:true completion:nil];
}


- (IBAction)onPostSubmitClicked:(UIButton *)sender {
    
    //TODO: Validation
    
    self.post.postTitle = self.postTitle.text;
    self.post.postDescription = self.postDescription.text;
    self.post.postNoOfRooms = self.postNoOfRooms.text;
    self.post.postPrice = [self extractNumber:self.postPrice.text];
    self.post.postAddress = self.postAddress.text;
    
    float lat = self.post.postAddressCoordinates.latitude;
    float lon = self.post.postAddressCoordinates.longitude;
    
    self.post.postImageArray = self.photoList;
    if (self.allowAddingImage) {
        [self.post.postImageArray removeLastObject];
    }
    self.post.postType = self.addPostType;
    
    NSDictionary *parameters = @{
                                 JSON_KEY_POST_TITLE : self.post.postTitle,
                                 JSON_KEY_POST_DESCRIPTION : self.post.postDescription,
                                 JSON_KEY_POST_NO_OF_ROOMS : self.post.postNoOfRooms,
                                 JSON_KEY_POST_PRICE : self.post.postPrice,
                                 JSON_KEY_POST_ADDRESS : self.post.postAddress,
                                 JSON_KEY_POST_ADDRESS_LATITUDE : [NSNumber numberWithFloat:lat],
                                 JSON_KEY_POST_ADDRESS_LONGITUDE : [NSNumber numberWithFloat:lon],
                                 JSON_KEY_POST_TYPE : self.post.postType
                                 };
    
    if (!self.isEditing) {
        //POST: /posts
        [[APICaller sharedInstance:self] callApi:POST_PATH parameters:parameters imageArray:self.post.postImageArray successBlock:^(id responseObject) {
            
            [self dismissViewControllerAnimated:true completion:nil];
            
        }];
    } else if (self.isEditing){
        //PUT: /posts/{slug}
        NSString *path = [[POST_PATH stringByAppendingString:@"/"] stringByAppendingString:self.post.postSlug];
        [[APICaller sharedInstance:self] callApiForPUT:path parameters:parameters sendToken:true successBlock:^(id responseObject) {
            
            //[self dismissViewControllerAnimated:true completion:nil];
            [self.postEditCompleteDelegate refreshView:self.post.postSlug];
            [self.navigationController popViewControllerAnimated:true];
            
        }];
        
    }
}

//MARK: Collectionview Methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    CGRect imageRect = CGRectMake(0, 0 , 75, 75);
    UIImageView *photosImageView = [[UIImageView alloc] initWithFrame:imageRect];
    [cell.contentView addSubview:[photosImageView initWithImage:self.photoList[indexPath.row]]];
    
    //cell.layer.borderColor = [UIColor greenColor].CGColor;
    //cell.layer.borderWidth = 2.0f;
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger lastItemIndex = self.photoList.count - 1;
    
    NSLog(@"Image selected");
    
    //Allowing max 5 images
    if (self.allowAddingImage) {
        if (indexPath.row == lastItemIndex) {
            //Add photoIcon image selected
            
            //Implement imagePicker
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.allowsEditing = true;
            [self presentViewController:imagePicker animated:true completion:nil];
        }
    }
}

//MARK: ImagePicker methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self dismissViewControllerAnimated:true completion:nil];
    [self populatePhotoCollectionViewWithImage:selectedImage];
    
}

-(void)populatePhotoCollectionViewWithImage:(UIImage*)image {
    
    [self.photoList insertObject:image atIndex:0];
    
    if (self.photoList.count > 5) {
        [self.photoList removeLastObject];
        self.allowAddingImage = false;
    }
    
    [self.photoCollectionView reloadData];
    
}

//AddressPicker Delegate methods
-(void)setAddress:(CLLocationCoordinate2D)geoLocation {
    
    NSLog(@"setAddress Delegate method Called");
    
    NSNumber *lat = [NSNumber numberWithDouble:geoLocation.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:geoLocation.longitude];
    
    NSLog(@"Location Coordinates: %@, %@", lat, lon);
    
    NSDictionary *parameters = @{
                                 @"latlng":[NSString stringWithFormat:@"%@, %@", lat, lon]
                                 };
    
    // GET: http://maps.googleapis.com/maps/api/geocode/json?latlng=27.6770085916,%85.3717560112
    [[APICaller sharedInstance:self] callApiForGETRawUrl:@"http://maps.googleapis.com/maps/api/geocode/json" parameters:parameters successBlock:^(id responseObject) {
        
        id results = [responseObject valueForKey:@"results"];
        id formattedAddress = [results[0] valueForKey:@"formatted_address"];
        
        [self.postAddress setText:formattedAddress];
    }];
    
    self.post.postAddressCoordinates = geoLocation;
}

//UITextField Delegates
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.postPrice) {
        
        NSString *price = [self extractNumber:textField.text];
        
        textField.text = @"";
        
        if ([price length] > 0) {
            textField.text = [@"Rs. " stringByAppendingString:price];
        } else {
            
        }
    }
}

-(NSString*)extractNumber:(NSString*)text {
    
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [[text componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
    
}


@end
