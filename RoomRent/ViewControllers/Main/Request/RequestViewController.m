//
//  RequestViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/4/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "RequestViewController.h"

@interface RequestViewController ()

@property (weak, nonatomic) IBOutlet UITableView *requestsTableView;


@property NSMutableArray *postsArray;
@property NSMutableArray *selectedPostsArrayIndexPath;

@property UIRefreshControl *refreshControl;
@property int offsetValue;
@property BOOL postAdded;     //Flag to prevent multiple calling of getData from scrollViewDidScroll
@property BOOL isLastPage;

@property BOOL isEditing;

@end

@implementation RequestViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set tableview datasource and delegates
    self.requestsTableView.delegate = self;
    self.requestsTableView.dataSource = self;
    
    self.requestsTableView.rowHeight = UITableViewAutomaticDimension;
    self.requestsTableView.estimatedRowHeight = 200.0f;
    
    //Register nib for tableview cell
    [self.requestsTableView registerNib:[UINib nibWithNibName:@"RequestTableViewCell" bundle:nil] forCellReuseIdentifier:@"requestTableViewCell"];
    
    //Pull to refresh init for TableView
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor greenColor];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Reloading posts"];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.requestsTableView addSubview:self.refreshControl];
    
    
    self.postsArray = [[NSMutableArray alloc] init];
    self.selectedPostsArrayIndexPath = [[NSMutableArray alloc] init];
    self.offsetValue = 0;
    self.postAdded = false;
    self.isLastPage = false;
    
    //For tableview rows select
    self.isEditing = false;
    
    [self getData];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.requestsTableView addGestureRecognizer:lpgr];
    
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

-(void)cancelEditing {
    self.isEditing = false;
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.selectedPostsArrayIndexPath removeAllObjects];
    [self.requestsTableView reloadData];
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
    
    //GET: /posts ? type & offset
    [[APICaller sharedInstance] callApiForGET:POST_PATH parameters:parameters sendToken:true successBlock:^(id responseObject) {
        
        id data = [responseObject valueForKey:@"data"];
        
        for (id postJsonObject in data) {
            PostPartial *post = [[PostPartial alloc] initPostWithJson:postJsonObject];
            [self.postsArray addObject:post];
        }
        
        [self.requestsTableView reloadData];
        
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


//MARK: TableView Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RequestTableViewCell *cell = (RequestTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"requestTableViewCell"];
    
    [cell configureCellWithData:self.postsArray[indexPath.row]];
    
    if ([self.selectedPostsArrayIndexPath containsObject:[NSString stringWithFormat:@"%ld", (long)indexPath.row]]) {
        cell.checkHiddenButton.hidden = false;
    } else {
        cell.checkHiddenButton.hidden = true;
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
        
        PostPartial *p = self.postsArray[indexPath.row];
        
        //Set post details
        [singlePostVC initPostHavingPostId:p.postSlug];
        
        [self.navigationController pushViewController:singlePostVC animated:true];
    }
}

@end
