//
//  OfferViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/4/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "OfferViewController.h"

@interface OfferViewController ()

@property (weak, nonatomic) IBOutlet UITableView *offerTableView;

@property NSMutableArray *postsArray;

@property UIRefreshControl *refreshControl;
@property int offsetValue;
@property bool postAdded;     //Flag to prevent multiple calling of getData from scrollViewDidScroll
@property bool isLastPage;

@end

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.offerTableView.dataSource = self;
    self.offerTableView.delegate = self;
    
    //Register OfferTableViewCell
    [self.offerTableView registerNib:[UINib nibWithNibName:@"OfferTableViewCell" bundle:nil] forCellReuseIdentifier:@"offerTableViewCell"];
    self.offerTableView.rowHeight = UITableViewAutomaticDimension;
    self.offerTableView.estimatedRowHeight = 300.0f;
    
    //TableView configs
    //self.offerTableView.separatorColor = [UIColor redColor];
    
    //Pull to refresh init for TableView
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor greenColor];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Reloading posts"];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.offerTableView addSubview:self.refreshControl];
    
    //Init postsArray
    self.postsArray = [[NSMutableArray alloc] init];
    
    //Initial Data loading
    [self getData];
    
}

//Refresh tableView
//Clear previous data and reload new data
-(void)refreshData {
    self.offsetValue = 0;
    [self.postsArray removeAllObjects];
    [self getData];
}

//Server call for populating postsArray
-(void)getData {
    
    NSDictionary *parameters = @{
                                 @"type":POSTS_OFFER_STRING,
                                 @"offset":[NSNumber numberWithInt:self.offsetValue]
                                 };
    
    //GET: /posts ? type & offset
    [[APICaller sharedInstance:self] callApiForGET:POST_PATH parameters:parameters sendToken:true successBlock:^(id responseObject) {
        
        id data = [responseObject valueForKey:@"data"];
        
        for (id postJsonObject in data) {
            Post *post = [[Post alloc] initPostWithJson:postJsonObject];
            [self.postsArray addObject:post];
        }
        
        [self.offerTableView reloadData];
        
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
    
    //Reached bottom of list
    //load new posts only if notLastPage
    if (scrollPosition > (bottom - buffer) && self.postAdded && !self.isLastPage) {
        
        //Add more posts
        [self getData];
        
        self.postAdded = false;
    }
}

//MARK: TableView Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OfferTableViewCell *cell = (OfferTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"offerTableViewCell"];
    
    cell.collectionViewItemClickDelegate = self;
    
    if (self.postsArray.count > 0) {
        //Configure cell data
        [cell configureCellWithData:self.postsArray[indexPath.row]];
    }
    
    return cell;
    
}


//MARK: TableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Load single post view
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SinglePostViewController *singlePostVC = (SinglePostViewController*)[story instantiateViewControllerWithIdentifier:@"SinglePostViewController"];
    
    Post *p = self.postsArray[indexPath.row];
    
    //Set post details
    [singlePostVC initPostHavingPostId:p.postSlug];
    
    [self.navigationController pushViewController:singlePostVC animated:true];
    
}


//MARK: Button Click Methods
- (IBAction)onForceClearUserDefaults:(UIButton *)sender {
    
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    
    
    //Switch to SignInViewController
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIStoryboard *accountStory = [UIStoryboard storyboardWithName:@"Account" bundle:nil];
    
    UIViewController *signInVC = [accountStory instantiateViewControllerWithIdentifier:@"SignInViewController"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:signInVC];
    
    [window setRootViewController:navController];
    [window makeKeyAndVisible];
    
}


//MARK: CollectionViewItemClickedDelegate
-(void)collectionViewItemClicked:(NSString*)postSlug {
    //Load single post view
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SinglePostViewController *singlePostVC = (SinglePostViewController*)[story instantiateViewControllerWithIdentifier:@"SinglePostViewController"];
    
    //Set post details
    [singlePostVC initPostHavingPostId:postSlug];
    
    [self.navigationController pushViewController:singlePostVC animated:true];
}

@end
