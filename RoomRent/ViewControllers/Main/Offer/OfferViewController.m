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

NSArray *itemsArray;

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.offerTableView.dataSource = self;
    self.offerTableView.delegate = self;
    
    //Register OfferTableViewCell
    [self.offerTableView registerNib:[UINib nibWithNibName:@"OfferTableViewCell" bundle:nil] forCellReuseIdentifier:@"offerTableViewCell"];
 
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

- (IBAction)onForceClearUserDefaults:(UIButton *)sender {
    
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    
}



@end
