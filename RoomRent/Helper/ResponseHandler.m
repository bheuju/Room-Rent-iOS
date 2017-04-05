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

- (void) check:(NSString*)code {
    
}

@end
