//
//  Alerter.h
//  RoomRent
//
//  Created by Bishal Heuju on 4/4/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Alerter : NSObject

+ (Alerter*)sharedInstance;

- (void)createAlert: (NSString*)alertTitle message:(NSString*)alertMessage viewController:(UIViewController*)VC completion:(void (^)(void))completionBlock;
-(void)createActions:(NSString*)alertTitle message:(NSString*)alertMessage viewController:(UIViewController*) VC action1:(NSString*)actionTitle1 actionCompletion1:(void (^)(void))actionCompletion1 action2:(NSString*)actionTitle2 actionCompletion2:(void (^)(void))actionCompletion2;

@end
