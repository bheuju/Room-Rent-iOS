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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

NSArray *itemsArray;

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.offerTableView.dataSource = self;
    self.offerTableView.delegate = self;
    
    //Register OfferTableViewCell
    [self.offerTableView registerNib:[UINib nibWithNibName:@"OfferTableViewCell" bundle:nil] forCellReuseIdentifier:@"offerTableViewCell"];
    
    //Reveal View
    SWRevealViewController *revealVC = self.revealViewController;
    if (revealVC) {
        
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
}

//MARK: TableView Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OfferTableViewCell *cell = (OfferTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"offerTableViewCell"];
    
    [[cell textLabel] setText:@"Hello"];
    
    return cell;
    
}


//MARK: Button Click Methods
- (IBAction)onLogout:(UIButton *)sender {
    
    //TODO: Logout here
    
    NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:JSON_KEY_API_TOKEN];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    
    [manager POST:[BASE_URL stringByAppendingString:LOGOUT_PATH] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *code = [responseObject valueForKey:JSON_KEY_CODE];
        NSString *message = [responseObject valueForKey:JSON_KEY_MESSAGE];
        
        [[Alerter sharedInstance] createAlert:@"Logout" message:message viewController:self completion:^{
            
            //Switch to SignInViewController
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            UIStoryboard *accountStory = [UIStoryboard storyboardWithName:@"Account" bundle:nil];
            
            UIViewController *signInVC = [accountStory instantiateViewControllerWithIdentifier:@"SignInViewController"];
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:signInVC];
            
            [window setRootViewController:navController];
            [window makeKeyAndVisible];
        }];
        
        
        //TODO: Clear UserData
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:JSON_KEY_USER_OBJECT];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:JSON_KEY_API_TOKEN];
        
        
        NSLog(@"Success Response: %@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error Response: %@", error);
        
        [[Alerter sharedInstance] createAlert:@"Server Error" message:@"Server is offline! \nSorry for the inconvenience. \nPlease try again later." viewController:self completion:^{}];
        
    }];
}

- (IBAction)onForceClearUserDefaults:(UIButton *)sender {
    
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    
}



@end
