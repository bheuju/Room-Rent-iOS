//
//  AddRequestViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/19/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "AddRequestViewController.h"

@interface AddRequestViewController ()

@end

@implementation AddRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(onCancel)];
    
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    //self.parentScrollView.contentSize = self.view.frame.size;
    
}

-(void)onCancel {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
