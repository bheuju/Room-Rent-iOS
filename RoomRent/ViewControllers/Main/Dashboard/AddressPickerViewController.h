//
//  AddressPickerViewController.h
//  RoomRent
//
//  Created by Bishal Heuju on 4/20/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "Alerter.h"

@interface AddressPickerViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property MKPointAnnotation *annot;

@property (weak) id addressPickerDelegate;

@end



@protocol AddressPickerDelegeate

-(void)setAddress:(CLLocationCoordinate2D)geoLocation;

@end
