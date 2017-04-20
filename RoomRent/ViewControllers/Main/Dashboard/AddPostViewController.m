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

@property (weak, nonatomic) IBOutlet UILabel *postAddress;


@end


@implementation AddPostViewController

NSMutableArray *photoList;
bool allowAddingImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(onCancel)];
    
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    photoList = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"addPhotosIcon"], nil];
    
    allowAddingImage = true;
    
    //FlowLayout
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.photoCollectionView.collectionViewLayout;
    [layout setItemSize:CGSizeMake(75, 75)];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self;
    
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
    
    if (photoList.count >5) {
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
}

@end
