//
//  Alerter.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/4/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "Alerter.h"

@implementation Alerter

-(void)createAlert:(NSString*)alertTitle message:(NSString*)alertMessage viewController:(UIViewController*)VC {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    
    [alert addAction:actionOk];
    [VC presentViewController:alert animated:true completion:nil];
}

@end
