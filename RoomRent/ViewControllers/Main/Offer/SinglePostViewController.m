//
//  SinglePostViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/27/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "SinglePostViewController.h"

@interface SinglePostViewController ()

//@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *postTitle;
@property (weak, nonatomic) IBOutlet UILabel *postDescription;
@property (weak, nonatomic) IBOutlet UILabel *postAddress;
@property (weak, nonatomic) IBOutlet UILabel *postNoOfRooms;
@property (weak, nonatomic) IBOutlet UILabel *postPrice;
@property (weak, nonatomic) IBOutlet MKMapView *postAddressMap;

@property (weak, nonatomic) IBOutlet UICollectionView *imageSliderCollectionView;

@end

@implementation SinglePostViewController

static Post *post = nil;
static NSMutableArray *imageArray = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set collectionview delegates and datasource
    self.imageSliderCollectionView.delegate = self;
    self.imageSliderCollectionView.dataSource = self;
    
    self.imageSliderCollectionView.pagingEnabled = true;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*) self.imageSliderCollectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.frame.size.width, 300.0f);
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;
    
    //Tap gesture for mapView
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePostAddressMapClick:)];
    [self.postAddressMap addGestureRecognizer:tap];
    
}


-(void)handlePostAddressMapClick:(UITapGestureRecognizer*)gestureRecognizer {
    
    //Load Map in Full View
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MapViewController *mapVC = [story instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    mapVC.location = post.postAddressCoordinates;
    
    [self.navigationController pushViewController:mapVC animated:true];
    
}

-(void)initPostHavingPostId:(NSNumber*)postId {
    
    //GET: post/<id>
    [[APICaller sharedInstance] callApi:[POST_GET_SPECIFIC_POST_PATH stringByAppendingString:[postId stringValue]] parameters:nil successBlock:^(id responseObject) {
        
        post = [[Post alloc] initPostWithJson:[responseObject valueForKey:JSON_KEY_POST_OBJECT]];
        [self initWithPost:post];
        
    }];
    
}

-(void)initWithPost:(Post*)post {
    
    //Populate image slider collection view
    imageArray = [[NSMutableArray alloc] init];
    for (NSString *imageName in post.postImageArray) {
        
        [[APICaller sharedInstance] callApiForImageRequest:imageName successBlock:^(id responseObject) {
            
            [imageArray addObject:responseObject];
            
            [self.imageSliderCollectionView reloadData];
            
        }];
    }
    
    self.postTitle.text = post.postTitle;
    self.postDescription.text = post.postDescription;
    self.postAddress.text = post.postAddress;
    self.postNoOfRooms.text = [post.postNoOfRooms stringValue];
    self.postPrice.text = [post.postPrice stringValue];
    
    //TODO: Init map here
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(post.postAddressCoordinates, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.postAddressMap regionThatFits:viewRegion];
    [self.postAddressMap setRegion:adjustedRegion];
    
    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    annot.coordinate = post.postAddressCoordinates;
    [self.postAddressMap addAnnotation:annot];
    
}

//MARK: CollectionView Delegates
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return post.postImageArray.count;
    return imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageSlideCollectionViewCell" forIndexPath:indexPath];
    
    if (imageArray.count > 0) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:imageArray[indexPath.row]];
        [cell addSubview:imgView];
    }
    
    return cell;
}


@end
