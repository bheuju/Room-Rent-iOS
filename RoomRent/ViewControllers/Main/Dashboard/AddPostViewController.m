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

static NSMutableArray *photoList;
bool allowAddingImage;

Post *post;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(onCancel)];
    
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    photoList = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"addPhotosIcon"], nil];
    
    post = [[Post alloc] init];
    
    allowAddingImage = true;
    
    //FlowLayout
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.photoCollectionView.collectionViewLayout;
    [layout setItemSize:CGSizeMake(75, 75)];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self;
    
    
    //PROTOTYPE: test data
    self.postTitle.text = @"2 Bed Flat For Rent";
    self.postDescription.text = @"A fine example of a top floor two bedroom apartment in a sought after location within Honiton.";
    self.postNoOfRooms.text = @"2";
    self.postPrice.text = @"£150";
    self.postAddress.text = @"Pine Gardens, Honiton, EX14, Devon";
    
    
    self.postPrice.delegate = self;
    
}


-(void)onCancel {
    [self dismissViewControllerAnimated:true completion:nil];
}


//MARK: Button click methods
- (IBAction)onAddressPickerButtonClicked:(UIButton *)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddressPickerViewController *addressPickerVC = (AddressPickerViewController*)[story instantiateViewControllerWithIdentifier:@"AddressPickerViewController"];
    
    addressPickerVC.delegate = self;
    
    [self presentViewController:addressPickerVC animated:true completion:nil];
}


- (IBAction)onPostSubmitClicked:(UIButton *)sender {
    
    //TODO: Validation
    
    post.postTitle = self.postTitle.text;
    post.postDescription = self.postDescription.text;
    post.postNoOfRooms = self.postNoOfRooms.text;
    post.postPrice = [self extractNumber:self.postPrice.text];
    post.postAddress = self.postAddress.text;
    
    float lat = post.postAddressCoordinates.latitude;
    float lon = post.postAddressCoordinates.longitude;
    
    post.postImageArray = photoList;
    if (allowAddingImage) {
        [post.postImageArray removeLastObject];
    }
    post.postType = OFFER;
    
    //post.postAddress = @"NP";
    
    //Post *p = post;
    
    NSDictionary *parameters = @{
                                 JSON_KEY_POST_TITLE : post.postTitle,
                                 JSON_KEY_POST_DESCRIPTION : post.postDescription,
                                 JSON_KEY_POST_NO_OF_ROOMS : post.postNoOfRooms,
                                 JSON_KEY_POST_PRICE : post.postPrice,
                                 JSON_KEY_POST_ADDRESS : post.postAddress,
                                 JSON_KEY_POST_ADDRESS_LATITUDE : [NSNumber numberWithFloat:lat],
                                 JSON_KEY_POST_ADDRESS_LONGITUDE : [NSNumber numberWithFloat:lon],
                                 JSON_KEY_POST_TYPE : post.postType
                                 };
    
    //POST: /posts
    [[APICaller sharedInstance] callApi:POST_PATH parameters:parameters imageArray:post.postImageArray successBlock:^(id responseObject) {
        
        [self dismissViewControllerAnimated:true completion:nil];
        
    }];
    
}

//MARK: Collectionview Methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return photoList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    CGRect imageRect = CGRectMake(0, 0 , 75, 75);
    UIImageView *photosImageView = [[UIImageView alloc] initWithFrame:imageRect];
    [cell.contentView addSubview:[photosImageView initWithImage:photoList[indexPath.row]]];
    
    //cell.layer.borderColor = [UIColor greenColor].CGColor;
    //cell.layer.borderWidth = 2.0f;
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger lastItemIndex = photoList.count - 1;
    
    NSLog(@"Image selected");
    
    //Allowing max 5 images
    if (allowAddingImage) {
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
    
    [photoList insertObject:image atIndex:0];
    
    if (photoList.count > 5) {
        [photoList removeLastObject];
        allowAddingImage = false;
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
    
    // GET: http://maps.googleapis.com/maps/api/geocode/json?latlng=27.6770085916,%2085.3717560112
    [[APICaller sharedInstance] callApiForGETRawUrl:@"http://maps.googleapis.com/maps/api/geocode/json" parameters:parameters successBlock:^(id responseObject) {
        
        id results = [responseObject valueForKey:@"results"];
        id formattedAddress = [results[0] valueForKey:@"formatted_address"];
    
        [self.postAddress setText:formattedAddress];
    }];
    
    
    
    post.postAddressCoordinates = geoLocation;
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
