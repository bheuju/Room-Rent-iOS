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
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionBlock();
    }];
    
    [alert addAction:actionOk];
    [VC presentViewController:alert animated:true completion:nil];
}

-(void)createAlertWithDefaultCancel:(NSString*)alertTitle message:(NSString*)alertMessage viewController:(UIViewController*)VC action:(NSString*)actionTitle actionCompletion:(void (^)(void))actionCompletion {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        actionCompletion();
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [VC dismissViewControllerAnimated:true completion:nil];
        
    }];
    
    [alert addAction:action];
    [alert addAction:cancel];
    
    [VC presentViewController:alert animated:true completion:nil];
    
}

-(void)createActions:(NSString*)alertTitle message:(NSString*)alertMessage viewController:(UIViewController*) VC action1:(NSString*)actionTitle1 actionCompletion1:(void (^)(void))actionCompletion1 action2:(NSString*)actionTitle2 actionCompletion2:(void (^)(void))actionCompletion2 {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:actionTitle1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        actionCompletion1();
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:actionTitle2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        actionCompletion2();
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [VC dismissViewControllerAnimated:true completion:nil];
        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [alert addAction:cancel];
    
    [VC presentViewController:alert animated:true completion:nil];
}

@end
