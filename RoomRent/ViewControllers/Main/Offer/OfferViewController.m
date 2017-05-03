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

@end

NSMutableArray *postsArray;

@implementation OfferViewController


UIRefreshControl *refreshControl;
int offsetValue;
bool postAdded;
bool isLastPage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.offerTableView.dataSource = self;
    self.offerTableView.delegate = self;
    
    //Register OfferTableViewCell
    [self.offerTableView registerNib:[UINib nibWithNibName:@"OfferTableViewCell" bundle:nil] forCellReuseIdentifier:@"offerTableViewCell"];
    self.offerTableView.rowHeight = UITableViewAutomaticDimension;
    self.offerTableView.estimatedRowHeight = 300.0f;
    
    
    //Pull to refresh
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor greenColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Reloading posts"];
    [refreshControl addTarget:self action:@selector(getData) forControlEvents:UIControlEventValueChanged];
    [self.offerTableView addSubview:refreshControl];
    
    //    NSDictionary *parameters = @{
    //                                 @"offset":@"10",
    //                                 @"post_type":@"1",
    //                                 @"latitude":@"27.6869126",
    //                                 @"longitude":@"85.3128881",
    //                                 };
    //
    
    postsArray = [[NSMutableArray alloc] init];
    
    //Items loading
    postAdded = false;
    isLastPage = false;
    [self getData];
}

-(void)getData {
    
    [[APICaller sharedInstance] callApi:POST_GET_ALL_PATH parameters:nil sendToken:true successBlock:^(id responseObject) {
        
        [postsArray removeAllObjects];
        
        id data = [responseObject valueForKey:@"data"];
        
        for (id postJsonObject in data) {
            
            Post *post = [[Post alloc] initPostWithJson:postJsonObject];
            
            [postsArray addObject:post];
            //int x = 8;
        }
        
        [self.offerTableView reloadData];
        
        
        postAdded = true;
        
        //Set offset value
        offsetValue = [[responseObject valueForKey:JSON_KEY_POST_OFFSET] intValue];
        isLastPage = [[responseObject valueForKey:JSON_KEY_POST_IS_LAST_PAGE] boolValue];
        
        [refreshControl endRefreshing];
        
    }];
}

//MARK: TableView Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //int x = postsArray.count;
    return postsArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OfferTableViewCell *cell = (OfferTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"offerTableViewCell"];
    
    //[[cell textLabel] setText:@"Hello"];
    
    Post *post = postsArray[indexPath.row];
    
    cell.postTitle.text = [[post.postId stringValue] stringByAppendingString:post.postTitle];
    cell.postNoOfRooms.text = [post.postNoOfRooms stringValue];
    cell.postPrice.text = [post.postPrice stringValue];
    cell.postUser.text = post.postUser.username;
    //cell.textLabel = @"Hello";
    
    return cell;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float bottom = scrollView.contentSize.height - scrollView.frame.size.height;
    float buffer = 600.0f;
    float scrollPosition = scrollView.contentOffset.y;
    
    NSLog(@"%lu",(unsigned long)postsArray.count);
    
    //Reached bottom of list
    if (scrollPosition > (bottom - buffer) && postAdded && !isLastPage) {
        
        //Add more posts
        
        NSDictionary *parameters = @{
                                     @"offset":[NSNumber numberWithInt:offsetValue]
                                    };
        
        [[APICaller sharedInstance] callApi:POST_GET_ALL_PATH parameters:parameters sendToken:true successBlock:^(id responseObject) {
            
            id data = [responseObject valueForKey:@"data"];
            
            for (id postJsonObject in data) {
                
                Post *post = [[Post alloc] initPostWithJson:postJsonObject];
                
                [postsArray addObject:post];
            }
            
            [self.offerTableView reloadData];
            
            
            offsetValue = [[responseObject valueForKey:JSON_KEY_POST_OFFSET] intValue];
            isLastPage = [[responseObject valueForKey:JSON_KEY_POST_IS_LAST_PAGE] boolValue];
            
            
            [refreshControl endRefreshing];
            
        }];
    }
}


//MARK: TableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Load single post view
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SinglePostViewController *singlePostVC = (SinglePostViewController*)[story instantiateViewControllerWithIdentifier:@"SinglePostViewController"];
    
    Post *p = postsArray[indexPath.row];
    
    //Set post details
    [singlePostVC initPostHavingPostId:p.postId];
    
    [self.navigationController pushViewController:singlePostVC animated:true];
    
}


//MARK: Button Click Methods

- (IBAction)onForceClearUserDefaults:(UIButton *)sender {
    
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    
}



@end
