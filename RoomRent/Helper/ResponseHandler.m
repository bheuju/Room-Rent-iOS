//
//  ResponseHandler.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/5/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "ResponseHandler.h"

@implementation ResponseHandler

static ResponseHandler *instance = nil;

+ (ResponseHandler*)sharedInstance {
    if (instance == nil) {
        instance = [[ResponseHandler alloc] init];
        return instance;
    }
    return instance;
}


-(void)handleResponse:(id)jsonData {
    
    NSString *code = [jsonData valueForKey:JSON_KEY_CODE];
    NSString *message = [jsonData valueForKey:JSON_KEY_MESSAGE];
    
    [self check:code];
    
}


- (void) check:(NSString*)code {
    
    if ([code isEqualToString:CODE_LOGIN_SUCCESS]) {
        
        //NSLog(@"Login Success");
        
    } else if ([code isEqualToString:CODE_VALIDATION_ERROR]) {
        //[[Alerter sharedInstance] createAlert:@"Failure" message:message viewController:self completion:^{}];
    } else {
        //[[Alerter sharedInstance] createAlert:@"Failure" message:message viewController:self completion:^{}];
    }
    
}

@end
