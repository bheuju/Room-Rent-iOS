//
//  SinglePostViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/27/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "SinglePostViewController.h"

@interface SinglePostViewController ()

@property (weak, nonatomic) IBOutlet UILabel *postTitle;
@property (weak, nonatomic) IBOutlet UILabel *postDescription;
@property (weak, nonatomic) IBOutlet UILabel *postAddress;
@property (weak, nonatomic) IBOutlet UILabel *postNoOfRooms;
@property (weak, nonatomic) IBOutlet UILabel *postPrice;
@property (weak, nonatomic) IBOutlet UILabel *postUser;
@property (weak, nonatomic) IBOutlet MKMapView *postAddressMap;

@property (weak, nonatomic) IBOutlet UICollectionView *imageSliderCollectionView;

@property (weak, nonatomic) IBOutlet UIScrollView *parentScrollView;

@end

@implementation SinglePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Initially hide all until post data is fetched from server
    self.parentScrollView.hidden = true;
    
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

//MARK: Selectors
-(void)editPost {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddPostViewController *editPost = [story instantiateViewControllerWithIdentifier:@"AddPostViewController"];
    
    editPost.isEditing = true;
    editPost.addPostType = [self.post.postType stringValue];
    editPost.post = self.post;
    
    editPost.postEditCompleteDelegate = self;
    
    [self.navigationController pushViewController:editPost animated:true];
    
}


-(void)deletePost {
    
    [[Alerter sharedInstance] createAlertWithDefaultCancel:@"Delete this post?" message:@"Are you sure?" viewController:self action:@"Ok" actionCompletion:^{
        
        //DELETE: /posts/{slug}
        NSString *path = [[POST_PATH stringByAppendingString:@"/"] stringByAppendingString:self.post.postSlug];
        [[APICaller sharedInstance:self] callApiForDELETE:path parameters:nil sendToken:true successBlock:^(id responseObject) {
            
            //TODO: Delete this post from array and Refresh tableView
            [self.postDeleteCompletedDelegate didFinishPostDelete];
            [self.navigationController popViewControllerAnimated:true];
            
        }];
    }];
    
}


-(void)handlePostAddressMapClick:(UITapGestureRecognizer*)gestureRecognizer {
    
    //Load Map in Full View
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MapViewController *mapVC = [story instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    //mapVC.location = self.post.postAddressCoordinates;
    mapVC.post = self.post;
    
    [self.navigationController pushViewController:mapVC animated:true];
    
}

//MARK: Custom Methods
-(void)initPostHavingPostId:(NSString*)postSlug {
    
    //GET: /posts/{slug}
    NSString *path = [[POST_PATH stringByAppendingString:@"/"] stringByAppendingString:postSlug];
    [[APICaller sharedInstance:self] callApiForGET:path parameters:nil sendToken:true successBlock:^(id responseObject) {
        
        self.post = [[Post alloc] initPostWithJson:[responseObject valueForKey:@"data"]];
        [self initWithPost:self.post];
        
        [self.imageSliderCollectionView reloadData];
        
        //Show details after post data has been loaded
        self.parentScrollView.hidden = false;
        
    }];
    
}

-(void)initWithPost:(Post*)post {
    
    //Init views
    self.postTitle.text = post.postTitle;
    self.postDescription.text = post.postDescription;
    self.postAddress.text = post.postAddress;
    self.postNoOfRooms.text = [post.postNoOfRooms stringValue];
    self.postPrice.text = [post.postPrice stringValue];
    self.postUser.text = post.postUser.name;
    
    //Init map here
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(post.postAddressCoordinates, 5000, 5000);
    MKCoordinateRegion adjustedRegion = [self.postAddressMap regionThatFits:viewRegion];
    
    //Check for valid coordinates
    if (adjustedRegion.center.latitude > -89 && adjustedRegion.center.latitude < 89 && adjustedRegion.center.longitude > -179 && adjustedRegion.center.longitude < 179) {
        [self.postAddressMap setRegion:adjustedRegion];
    }
    
    
    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    annot.coordinate = post.postAddressCoordinates;
    [self.postAddressMap addAnnotation:annot];
    
    //Check isUserPost
    //If isUserPost display edit and delete
    User *loggedInUser = [[Helper sharedInstance] getUserFromUserDefaults];
    
    if ([post.postUser.username isEqualToString:loggedInUser.username]) {
        
        //If is user's post, add options to delete and edit
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPost)];
        UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deletePost)];
        
        self.navigationItem.rightBarButtonItems = @[deleteButton, editButton];
    }
    
    if ([[post.postType stringValue] isEqual:REQUEST]) {
        [self.imageSliderCollectionView removeFromSuperview];
    }
    
}

//MARK: CollectionView Methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //NSLog(@"Size: %lu", self.post.postImageArray.count);
    return self.post.postImageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageSliderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageSlideCollectionViewCell" forIndexPath:indexPath];
    
    //Configure Cell
    [cell.imageView sd_setImageWithURL:[[Helper sharedInstance] generateGetImageURLFromFilename:self.post.postImageArray[indexPath.row]]  placeholderImage:[UIImage imageNamed:@"no-image"] options:SDWebImageRetryFailed];
    
    return cell;
}

//MARK: PostEditCompeletedDelegate
-(void)refreshView:(NSString*)postSlug {
    [self initPostHavingPostId:postSlug];
}

//MARK: IBActions
- (IBAction)onCall:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.post.postUser.phone]] options:@{} completionHandler:nil];
}

- (IBAction)onMessage:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", self.post.postUser.phone]] options:@{} completionHandler:nil];
}

- (IBAction)onUserInfo:(UIButton *)sender {
    //Load user info here
    [[Alerter sharedInstance] createAlert:@"User Details" message:[NSString stringWithFormat:@"Name: %@\nPhone: %@\nUsername: %@\nEmail: %@\n", self.post.postUser.name, self.post.postUser.phone, self.post.postUser.username, self.post.postUser.email] viewController:self completion:^{}];
}


@end
