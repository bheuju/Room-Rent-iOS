//
//  AddressPickerViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/20/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "AddressPickerViewController.h"

@interface AddressPickerViewController ()

@end



@implementation AddressPickerViewController
@synthesize mapView;
//id delegate;

- (void)viewDidLoad {
    [super viewDidLoad];

    //CLLocationCoordinate2D noLocation = CLLocationCoordinate2DMake(27.70545067195189, 85.31774443228218);
    //MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 10000, 10000);
    //MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    //[self.mapView setRegion:adjustedRegion animated:YES];
    
    self.mapView.showsUserLocation = true;
    
    self.mapView.delegate = self;
    
    self.annot = [[MKPointAnnotation alloc] init];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(placePin:)];
    longPress.minimumPressDuration = 0.5; //sec
    [self.mapView addGestureRecognizer:longPress];
    
}

//MARK: Extras
-(void)placePin:(UIGestureRecognizer*) gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D mapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    //MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    [self.mapView removeAnnotation:self.annot];
    self.annot.coordinate = mapCoordinate;
    [self.mapView addAnnotation:self.annot];
    
}

//MARK: Button click methods
- (IBAction)onOkClicked:(UIButton *)sender {
    
    //Check if pin is placed or not
    if (self.annot.coordinate.latitude != 0 && self.annot.coordinate.longitude != 0) {
        
        [self.addressPickerDelegate setAddress:self.annot.coordinate];
        [self dismissViewControllerAnimated:true completion:nil];
        
    } else {
        [[Alerter sharedInstance] createAlert:@"Address not picked." message:@"Long press to pick a place." viewController:self completion:^{}];
    }
    
    
}

- (IBAction)onCancelClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

//MARK: MapKit Delegates
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    
    [self.mapView setRegion:adjustedRegion animated:true];
    
}


@end

