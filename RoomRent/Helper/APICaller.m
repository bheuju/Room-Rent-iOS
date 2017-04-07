//
//  APICaller.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/6/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "APICaller.h"

@implementation APICaller

static APICaller* instance = nil;

//Variables
AFHTTPSessionManager *manager;

+(APICaller *)sharedInstance {
    
    if (instance == nil) {
        instance = [[APICaller alloc] initAPICaller];
        return instance;
    }
    
    return instance;
}

-(APICaller*)initAPICaller {
    
    manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    return self;
}

-(void)callApi:(NSString*)url parameters:(NSDictionary*)param successBlock:(void (^)(void))successBlock {
    
    [manager POST:[BASE_URL stringByAppendingString:url] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        successBlock();
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        
    }];
    
    
}


@end
