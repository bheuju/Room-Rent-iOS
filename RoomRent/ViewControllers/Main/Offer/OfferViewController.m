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

static NSMutableArray *postsArray;

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.offerTableView.dataSource = self;
    self.offerTableView.delegate = self;
    
    //Register OfferTableViewCell
    [self.offerTableView registerNib:[UINib nibWithNibName:@"OfferTableViewCell" bundle:nil] forCellReuseIdentifier:@"offerTableViewCell"];
    
//    NSDictionary *parameters = @{
//                                 @"offset":@"10",
//                                 @"post_type":@"1",
//                                 @"latitude":@"27.6869126",
//                                 @"longitude":@"85.3128881",
//                                 };
//
    
    postsArray = [[NSMutableArray alloc] init];
    
    //Items loading
    [[APICaller sharedInstance] callApi:POST_GET_ALL_PATH parameters:nil successBlock:^(id responseObject) {
        
        id data = [responseObject valueForKey:@"data"];
        
        for (id postJsonObject in data) {
            
            Post *post = [[Post alloc] initPostWithJson:postJsonObject];
            
            [postsArray addObject:post];
            int x = 8;
        }
        
        NSMutableArray *arr = postsArray;
        int x = 6;
        
    }];
    
}

//MARK: TableView Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return postsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OfferTableViewCell *cell = (OfferTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"offerTableViewCell"];
    
    //[[cell textLabel] setText:@"Hello"];
    
    return cell;
    
}


//MARK: Button Click Methods

- (IBAction)onForceClearUserDefaults:(UIButton *)sender {
    
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    
}



@end
