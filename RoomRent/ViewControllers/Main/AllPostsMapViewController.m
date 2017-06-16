//
//  AllPostsMapViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 5/29/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "AllPostsMapViewController.h"

@interface AllPostsMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property NSMutableArray *annotArray;
@property int annotIndex;

@end

@implementation AllPostsMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    //Init variables
    self.annotArray = [[NSMutableArray alloc] init];
    self.annotIndex = 0;
    
    //TODO: Call Api To get Locations of posts
    
    NSDictionary *parameters = @{
                                 @"offset":@"0",
                                 @"type":POSTS_ALL_STRING
                                 };
    
    //GET: /posts ? type & offset
    [[APICaller sharedInstance:self] callApiForGET:POST_PATH parameters:parameters sendToken:true successBlock:^(id responseObject) {
        
        id data = [responseObject valueForKey:@"data"];
        
        //For each location
        for (id postJsonObject in data) {
            
            Post *post = [[Post alloc] initPostWithJson:postJsonObject];
            
            MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
            
            annot.coordinate = post.postAddressCoordinates;
            annot.title = [[[post.postId stringValue] stringByAppendingString:@": " ] stringByAppendingString:post.postTitle];
            annot.subtitle = [NSString stringWithFormat:@"%@ rooms at Rs. %@ by %@", post.postNoOfRooms, post.postPrice, post.postUser.username];
            
            //TODO: annotation pin color
            //            MKPinAnnotationView *annotView = [[MKPinAnnotationView alloc] initWithAnnotation:annot reuseIdentifier:@"pin"];
            //            annotView.pinTintColor = [UIColor greenColor];
            
            
            
            [self.annotArray addObject:annot];
            [self.mapView addAnnotation:annot];
            
        }
        
        //Add annotations to map
        [self.mapView addAnnotations:self.annotArray];
        
        //Zoom to first annotation
        [self setCoordinate:self.annotIndex];
        
    }];
}

//MARK: Methods
-(void)onCancel {
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}

-(void)setCoordinate:(int)i {
    
    if (i < self.annotArray.count) {
        CLLocationCoordinate2D center = ((MKPointAnnotation*)self.annotArray[i]).coordinate;
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(center, 5000, 5000);
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        
        if( adjustedRegion.center.latitude > -89 && adjustedRegion.center.latitude < 89 && adjustedRegion.center.longitude > -179 && adjustedRegion.center.longitude < 179 ) {
            [self.mapView setRegion:adjustedRegion];
        }
    }
}


//MARK: Button Click Events
- (IBAction)onNext:(UIButton *)sender {
    self.annotIndex++;
    if (self.annotIndex > self.annotArray.count) {
        self.annotIndex = 0;
    }
    [self setCoordinate:self.annotIndex];
    
}

- (IBAction)onPrevious:(UIButton *)sender {
    self.annotIndex--;
    if (self.annotIndex < 0) {
        self.annotIndex = (int)self.annotArray.count - 1;
    }
    [self setCoordinate:self.annotIndex];
}



@end
