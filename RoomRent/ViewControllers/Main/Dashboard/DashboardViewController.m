//
//  DashboardViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/4/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "DashboardViewController.h"

@interface DashboardViewController ()

@property (weak, nonatomic) IBOutlet UITableView *dashboardTableView;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UISegmentedControl *offerOrRequestSegmentedControl;

@property NSString *getPostType;


@property NSMutableArray *postsArray;

@property NSMutableArray *selectedPostsArrayIndexPath;

@property UIRefreshControl *refreshControl;
@property int offsetValue;
@property bool postAdded;     //Flag to prevent multiple calling of getData from scrollViewDidScroll
@property bool isLastPage;

@property BOOL isEditing;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set tableview delegates and datasource
    self.dashboardTableView.delegate = self;
    self.dashboardTableView.dataSource = self;
    
    //Register cell nib
    [self.dashboardTableView registerNib:[UINib nibWithNibName:@"OfferTableViewCell" bundle:nil] forCellReuseIdentifier:@"offerTableViewCell"];
    [self.dashboardTableView registerNib:[UINib nibWithNibName:@"RequestTableViewCell" bundle:nil] forCellReuseIdentifier:@"requestTableViewCell"];
    
    self.dashboardTableView.rowHeight = UITableViewAutomaticDimension;
    self.dashboardTableView.estimatedRowHeight = 200.0f;
    
    //Floating action button
    UIButton *addPostButton = [[UIButton alloc] initWithFrame:CGRectMake(self.dashboardTableView.frame.size.width - 75, self.dashboardTableView.frame.size.height - 75, 50, 50)];
    [addPostButton setBackgroundImage:[UIImage imageNamed:@"addPost"] forState:UIControlStateNormal];
    [addPostButton addTarget:self action:@selector(addPost) forControlEvents:UIControlEventTouchUpInside];
    [self.container addSubview:addPostButton];
    [self.container bringSubviewToFront:addPostButton];
    
    //Pull to refresh init for TableView
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor greenColor];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Reloading posts"];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.dashboardTableView addSubview:self.refreshControl];
    
    
    //Init defaults
    //self.getPostType = OFFER;
    self.postsArray = [[NSMutableArray alloc] init];
    self.selectedPostsArrayIndexPath = [[NSMutableArray alloc] init];
    
    //For tableview rows select
    self.isEditing = false;
    
    //Implicitly set initial state for segmentedControl
    [self offerOrRequestSegmentedControlSelect:self.offerOrRequestSegmentedControl];
    
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.dashboardTableView addGestureRecognizer:lpgr];
}


-(void)cancelEditing {
    self.isEditing = false;
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.selectedPostsArrayIndexPath removeAllObjects];
    [self.dashboardTableView reloadData];
}

-(void)handleLongPress:(UILongPressGestureRecognizer*) gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        return;
    }
    
    //CGPoint touchPoint = [gestureRecognizer locationInView:self.requestsTableView];
    //NSIndexPath *indexPath = [self.requestsTableView indexPathForRowAtPoint:touchPoint];
    
    self.isEditing = true;
    
    if (self.isEditing) {
        UIBarButtonItem *cancelEditing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEditing)];
        self.navigationItem.rightBarButtonItem = cancelEditing;
    }
}

//MARK: IBActions
- (IBAction)offerOrRequestSegmentedControlSelect:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            //My Offers
            //Load offers
            self.getPostType = POSTS_OFFER_STRING;
            break;
            
        case 1:
            //My Requests
            //Load Requests
            self.getPostType = POSTS_REQUEST_STRING;
            break;
            
        default:
            self.getPostType = nil;
            return;
    }
    
    [self refreshData];
    
}

-(void)refreshData {
    self.offsetValue = 0;
    [self.postsArray removeAllObjects];
    [self getData];
}

-(void)getData {
    
    NSDictionary *parameters = @{
                                 @"type":POSTS_REQUEST_STRING,
                                 @"offset":[NSNumber numberWithInt:self.offsetValue]
                                 };
    
    //GET: /user/posts/{type}
    [[APICaller sharedInstance] callApiForGET:MY_POST_PATH parameters:parameters sendToken:true successBlock:^(id responseObject) {
        
        id data = [responseObject valueForKey:@"data"];
        
        for (id postJsonObject in data) {
            Post *post = [[Post alloc] initPostWithJson:postJsonObject];
            [self.postsArray addObject:post];
        }
        
        [self.dashboardTableView reloadData];
        
        NSLog(@"Posts count: %lu",(unsigned long)self.postsArray.count);
        
        self.postAdded = true;
        
        //Set offset value
        self.offsetValue = [[responseObject valueForKey:JSON_KEY_POST_OFFSET] intValue];
        self.isLastPage = [[responseObject valueForKey:JSON_KEY_POST_IS_LAST_PAGE] boolValue];
        
        [self.refreshControl endRefreshing];
        
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float bottom = scrollView.contentSize.height - scrollView.frame.size.height;
    float buffer = 600.0f;
    float scrollPosition = scrollView.contentOffset.y;
    
    //NSLog(@"%lu",(unsigned long)postsArray.count);
    
    //Reached bottom of list
    //load new posts only if notLastPage
    if (scrollPosition > (bottom - buffer) && self.postAdded && !self.isLastPage) {
        
        //Add more posts
        [self getData];
        
        self.postAdded = false;
    }
}

//MARK: TableViewMethods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (self.getPostType == POSTS_OFFER_STRING) {
        cell = (OfferTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"offerTableViewCell" forIndexPath:indexPath];
        [(OfferTableViewCell*)cell configureCellWithData:self.postsArray[indexPath.row]];
    } else if (self.getPostType == POSTS_REQUEST_STRING){
        cell = (RequestTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"requestTableViewCell" forIndexPath:indexPath];
        [(RequestTableViewCell*)cell configureCellWithData:self.postsArray[indexPath.row]];
    }
    
    if ([self.selectedPostsArrayIndexPath containsObject:[NSString stringWithFormat:@"%ld", (long)indexPath.row]]) {
        ((RequestTableViewCell*)cell).checkHiddenButton.hidden = false;
    } else {
        ((RequestTableViewCell*)cell).checkHiddenButton.hidden = true;
    }
    
    return cell;
}

//MARK: TableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isEditing) {
        RequestTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.isSelected ^= true;
        
        NSLog(@"%d", cell.isSelected);
        
        if (cell.isSelected) {
            [self.selectedPostsArrayIndexPath addObject:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
            cell.checkHiddenButton.hidden = false;
            NSLog(@"selected");
        } else {
            [self.selectedPostsArrayIndexPath removeObject:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
            cell.checkHiddenButton.hidden = true;
            NSLog(@"not-selected");
        }
        
    } else {
        //Load single post view
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SinglePostViewController *singlePostVC = (SinglePostViewController*)[story instantiateViewControllerWithIdentifier:@"SinglePostViewController"];
        
        Post *p = self.postsArray[indexPath.row];
        
        //Set post details
        [singlePostVC initPostHavingPostId:p.postSlug];
        
        [self.navigationController pushViewController:singlePostVC animated:true];
    }
}


//Mark: Methods
- (void)addPost {
    
    [[Alerter sharedInstance] createActions:@"Add offer / request ?" message:@"Please select an option" viewController:self action1:@"Offer" actionCompletion1:^{
        
        UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *addPostVC = [mainStory instantiateViewControllerWithIdentifier:@"AddPostViewController"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addPostVC];
        
        [self presentViewController:navController animated:true completion:nil];
        
    } action2:@"Request" actionCompletion2:^{
        
        UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *addRequestVC = [mainStory instantiateViewControllerWithIdentifier:@"AddPostViewController"];
        
        //Hide photo selection views
        [((AddPostViewController*)addRequestVC).photoCollectionView setHidden:true];
        [((AddPostViewController*)addRequestVC).postPhotoCollectionViewLabel setHidden:true];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addRequestVC];
        
        [self presentViewController:navController animated:true completion:nil];
        
    }];
    
}

@end
