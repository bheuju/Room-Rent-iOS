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

-(void)callApi:(NSString*)url parameters:(NSDictionary*)param successBlock:(void (^)(id responseObject))successBlock {
    
    [manager POST:[BASE_URL stringByAppendingString:url] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Complete, Respose: %@", responseObject);
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Fail, Respose: %@", error);
        
        //[[Alerter sharedInstance] createAlert:@"Server Error" message:@"Server is offline! \nSorry for the inconvenience. \nPlease try again later." viewController:self completion:^{}];

        NSLog(@"Server is offline! \nSorry for the inconvenience. \nPlease try again later.");
        
    }];
}


-(void)callApiForImageUpload:(NSString*)url image:(UIImage*)image {
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    [manager POST:[BASE_URL stringByAppendingString:url] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"userFile" fileName:@"image.png" mimeType:@"image/png"];
    } progress: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
}


@end
