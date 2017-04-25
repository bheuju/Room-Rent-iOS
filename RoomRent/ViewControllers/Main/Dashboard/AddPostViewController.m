//
//  AddPostViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/12/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "AddPostViewController.h"

@interface AddPostViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

@property (weak, nonatomic) IBOutlet UITextField *postTitle;
@property (weak, nonatomic) IBOutlet UITextField *postDescription;
@property (weak, nonatomic) IBOutlet UITextField *postNoOfRooms;
@property (weak, nonatomic) IBOutlet UITextField *postPrice;
@property (weak, nonatomic) IBOutlet UILabel *postAddress;

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
    self.postTitle.text = @"Free room";
    self.postDescription.text = @"Free room for someone";
    self.postNoOfRooms.text = @"3";
    self.postPrice.text = @"10";
    //self.postAddress.text = @"";
    
    
    self.postPrice.delegate = self;
    
}


-(void)onCancel {
    [self dismissViewControllerAnimated:true completion:nil];
}


//Button click methods
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
    post.postPrice = self.postPrice.text;
    post.postAddress = self.postAddress.text;
    
    //float lat = post.postAddressCoordinates.latitude;
    //float lon = post.postAddressCoordinates.longitude;
    
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
                                 JSON_KEY_POST_ADDRESS_LATITUDE : [NSNumber numberWithDouble:post.postAddressCoordinates.latitude],
                                 JSON_KEY_POST_ADDRESS_LONGITUDE : [NSNumber numberWithDouble:post.postAddressCoordinates.longitude],
                                 JSON_KEY_POST_TYPE : post.postType
                                 };
    
    [[APICaller sharedInstance] callApi:POST_POST_PATH parameters:parameters imageArray:post.postImageArray successBlock:^(id responseObject) {
        
        
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
    
    cell.layer.borderColor = [UIColor greenColor].CGColor;
    cell.layer.borderWidth = 2.0f;
    
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
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:geoLocation.latitude longitude:geoLocation.longitude];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
        NSLog(@"locality %@",placemark.locality);
        NSLog(@"sublocality %@",placemark.subLocality);
        NSLog(@"throughfare %@",placemark.thoroughfare);
        NSLog(@"subThroughfare %@",placemark.subThoroughfare);
        NSLog(@"postalCode %@",placemark.postalCode);
        
        [self.postAddress setText:placemark.ISOcountryCode];
        
    }];
    
    //[self.postAddress setText:@"Some address"];
    
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
