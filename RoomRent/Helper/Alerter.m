//
//  Alerter.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/4/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "Alerter.h"

@implementation Alerter

static Alerter *instance = nil;

+ (Alerter*)sharedInstance {
    if (instance == nil) {
        instance = [[self alloc] init];
        return instance;
    }
    return instance;
}

-(void)createAlert:(NSString*)alertTitle message:(NSString*)alertMessage viewController:(UIViewController*)VC  completion:(void (^)(void))completionBlock {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionBlock();
    }];
    
    [alert addAction:actionOk];
    [VC presentViewController:alert animated:true completion:nil];
}

@end
