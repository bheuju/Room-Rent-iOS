//
//  MapViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 5/1/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    int zoomDistance = 1000;
    
    //TODO: Check for location to be initalized
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.location, zoomDistance, zoomDistance);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion];
    
    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    annot.coordinate = self.location;
    
    annot.title = @"Room Rent";
    annot.subtitle = @"Need a room?";
    
    [self.mapView addAnnotation:annot];
    
}



@end
