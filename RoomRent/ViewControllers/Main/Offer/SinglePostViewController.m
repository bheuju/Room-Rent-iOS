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
    
    //Register nib file for collection view
    [self.imageSliderCollectionView registerNib:[UINib nibWithNibName:@"ImageSliderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"imageSlideCollectionViewCell"];
    
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
        
        [self.imageSliderCollectionView reloadData ];
        
    }];
    
}

-(void)initWithPost:(Post*)post {
    
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

//MARK: CollectionView Methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"Size: %lu", post.postImageArray.count);
    return post.postImageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageSliderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageSlideCollectionViewCell" forIndexPath:indexPath];
    
    //Configure Cell
    NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:JSON_KEY_API_TOKEN];
    SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
    [manager setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];

    
    NSURL *url = [NSURL URLWithString:[[BASE_URL stringByAppendingString:GETFILE_PATH] stringByAppendingString:post.postImageArray[indexPath.row]]];
    
    [cell .imageView sd_setImageWithURL:url];
    
    
    return cell;
}


@end
