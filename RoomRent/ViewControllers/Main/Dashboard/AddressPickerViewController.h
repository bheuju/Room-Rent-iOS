//
//  AddressPickerViewController.h
//  RoomRent
//
//  Created by Bishal Heuju on 4/20/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AddressPickerViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property id delegate;

//-(void)setDelegate:(id)newDelegate;

@end



@protocol AddressPickerDelegeate

-(void)setAddress:(CLLocationCoordinate2D)geoLocation;

@end
