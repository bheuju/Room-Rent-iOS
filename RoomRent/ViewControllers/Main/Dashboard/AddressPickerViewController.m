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

MKPointAnnotation *annot;

@implementation AddressPickerViewController

//id delegate;

- (void)viewDidLoad {
    [super viewDidLoad];

    CLLocationCoordinate2D noLocation = CLLocationCoordinate2DMake(27.70545067195189, 85.31774443228218);
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 10000, 10000);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    self.mapView.showsUserLocation = true;
    
    self.mapView.delegate = self;
    
    annot = [[MKPointAnnotation alloc] init];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(placePin:)];
    longPress.minimumPressDuration = 1;
    [self.mapView addGestureRecognizer:longPress];
    
}

//MARK: Extras

//-(void)setDelegate:(id)newDelegate {
//    self.delegate = newDelegate;
//}

-(void)placePin:(UIGestureRecognizer*) gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D mapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    //MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    [self.mapView removeAnnotation:annot];
    annot.coordinate = mapCoordinate;
    [self.mapView addAnnotation:annot];
    
}


//MARK: Button click methods
- (IBAction)onOkClicked:(UIBarButtonItem *)sender {
    
    [self.delegate setAddress:annot.coordinate];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)onCancelClicked:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


@end

