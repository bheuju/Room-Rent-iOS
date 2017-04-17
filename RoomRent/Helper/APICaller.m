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
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    return self;
}

-(void)callApi:(NSString*)url parameters:(NSDictionary*)param successBlock:(void (^)(id responseObject))successBlock {
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:[BASE_URL stringByAppendingString:url] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Complete, Respose: %@", responseObject);
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Fail, Respose: %@", error);
        
        //[[Alerter sharedInstance] createAlert:@"Server Error" message:@"Server is offline! \nSorry for the inconvenience. \nPlease try again later." viewController:self completion:^{}];
        
        NSLog(@"Server is offline! \nSorry for the inconvenience. \nPlease try again later.");
        
    }];
}

//TODO:
-(void)callApiForImageUpload:(NSString*)url imageArray:(NSArray*)imageArray {
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:[BASE_URL stringByAppendingString:url] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        int i = 0;
        for (UIImage *image in imageArray) {
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            [formData appendPartWithFileData:imageData name:@"image[]" fileName:[NSString stringWithFormat:@"image%d.jpg", i] mimeType:@"image/jpeg"];
            
            i++;
        }
        
    } progress: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
}


-(void)callApi:(NSString*)url parameters:(NSDictionary*)param image:(UIImage*)image successBlock:(void (^)(id responseObject))successBlock {
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:[BASE_URL stringByAppendingString:url] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        
        [formData appendPartWithFileData:imageData name:@"profile_image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
        
    } progress: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Task: %@", task);
        NSLog(@"Complete, Respose: %@", responseObject);
        
        successBlock(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Fail, Respose: %@", error);
        
    }];
}

-(void)callApiForImageRequest:(NSString*)url successBlock:(void (^)(id responseObject))successBlock {
    
    //NSString *url = @"http://192.168.0.143:81/api/v1/getfile/akldshfiuo876879jfd877jhdsaf7.jpg";
    
    NSDictionary *param = @{JSON_KEY_API_TOKEN : [[NSUserDefaults standardUserDefaults] objectForKey:JSON_KEY_API_TOKEN]};
    
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
        successBlock(responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

@end
