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

+(APICaller*)sharedInstance:(UIViewController*)VC {
    
    [ProgressHUD showProgressHUDAddedToView:VC.view];
    
    if (instance == nil) {
        instance = [[APICaller alloc] initAPICaller];
        
        instance.VC = VC;
        
        return instance;
    }
    
    instance.VC = VC;
    
    return instance;
}

-(APICaller*)initAPICaller {
    
    manager = [AFHTTPSessionManager manager];
    
    return self;
}

//no image
-(void)callApiForPOST:(NSString*)url parameters:(NSDictionary*)param sendToken:(BOOL)sendToken successBlock:(void (^)(id responseObject))successBlock {
    
    if (sendToken) {
        NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:JSON_KEY_API_TOKEN];
        [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    }
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:[BASE_URL stringByAppendingString:url] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Complete, Respose: %@", responseObject);
        [ProgressHUD hideProgressHUD];
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Fail, Respose: %@", error);
        [ProgressHUD hideProgressHUD];
        
        [[Alerter sharedInstance] createAlert:@"Server Error" message:@"Server is offline! \nSorry for the inconvenience. \nPlease try again later." viewController:self.VC completion:^{}];
        
        NSLog(@"Server is offline! \nSorry for the inconvenience. \nPlease try again later.");
        
    }];
}


-(void)callApiForGET:(NSString*)url parameters:(NSDictionary*)param sendToken:(BOOL)sendToken successBlock:(void (^)(id responseObject))successBlock {
    
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:param];
    
    if (sendToken) {
        NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:JSON_KEY_API_TOKEN];
        [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
        
        [parameters setObject:userApiToken forKey:@"api_token"];
    }
    
    [manager GET:[BASE_URL stringByAppendingString:url] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Complete, Respose: %@", responseObject);
        [ProgressHUD hideProgressHUD];
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Fail, Respose: %@", error);
        [ProgressHUD hideProgressHUD];
        
        [[Alerter sharedInstance] createAlert:@"Server Error" message:@"Server is offline! \nSorry for the inconvenience. \nPlease try again later." viewController:self.VC completion:^{}];
        
        NSLog(@"Server is offline! \nSorry for the inconvenience. \nPlease try again later.");
        
    }];
    
}

-(void)callApiForGETRawUrl:(NSString*)url parameters:(NSDictionary*)param successBlock:(void (^)(id responseObject))successBlock {
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:JSON_KEY_API_TOKEN];
    [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Complete, Respose: %@", responseObject);
        [ProgressHUD hideProgressHUD];
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Fail, Respose: %@", error);
        [ProgressHUD hideProgressHUD];
        
        [[Alerter sharedInstance] createAlert:@"Server Error" message:@"Server is offline! \nSorry for the inconvenience. \nPlease try again later." viewController:self.VC completion:^{}];
        
        NSLog(@"Server is offline! \nSorry for the inconvenience. \nPlease try again later.");
        
    }];
    
}



//image array named image[]
-(void)callApi:(NSString*)url parameters:(NSDictionary*)param imageArray:(NSArray*)imageArray successBlock:(void (^)(id responseObject))successBlock {
    
    manager.requestSerializer.timeoutInterval = 10.0;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:JSON_KEY_API_TOKEN];
    
    NSMutableDictionary *paramaters = [[NSMutableDictionary alloc] initWithDictionary:param];
    [paramaters setObject:userApiToken forKey:JSON_KEY_API_TOKEN];
    
    [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    
    [manager POST:[BASE_URL stringByAppendingString:url] parameters:paramaters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        int i = 0;
        for (UIImage *image in imageArray) {
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            [formData appendPartWithFileData:imageData name:JSON_KEY_POST_IMAGES_REQUEST fileName:[NSString stringWithFormat:@"image%d.jpg", i] mimeType:@"image/jpeg"];
            
            i++;
        }
        
    } progress: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Complete, Respose: %@", responseObject);
        [ProgressHUD hideProgressHUD];
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Fail, Respose: %@", error);
        [ProgressHUD hideProgressHUD];
        
        [[Alerter sharedInstance] createAlert:@"Server Error" message:@"Server is offline! \nSorry for the inconvenience. \nPlease try again later." viewController:self.VC completion:^{}];
        
    }];
}

//single image named profile_image
//For
-(void)callApi:(NSString*)url parameters:(NSDictionary*)param image:(UIImage*)image sendToken:(BOOL)sendToken successBlock:(void (^)(id responseObject))successBlock {
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    if (sendToken) {
        NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:JSON_KEY_API_TOKEN];
        [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    }
    
    [manager POST:[BASE_URL stringByAppendingString:url] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (image != nil) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            [formData appendPartWithFileData:imageData name:JSON_KEY_PROFILE_IMAGE_URL_REQUEST fileName:@"image.jpg" mimeType:@"image/jpeg"];
        }
    } progress: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Complete, Respose: %@", responseObject);
        [ProgressHUD hideProgressHUD];
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Fail, Respose: %@", error);
        [ProgressHUD hideProgressHUD];
        
        [[Alerter sharedInstance] createAlert:@"Server Error" message:@"Server is offline! \nSorry for the inconvenience. \nPlease try again later." viewController:self.VC completion:^{}];
        
    }];
}

-(void)callApiForDELETE:(NSString*)url parameters:(NSDictionary*)param sendToken:(BOOL)sendToken successBlock:(void (^)(id responseObject))successBlock {
    
    if (sendToken) {
        NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:JSON_KEY_API_TOKEN];
        [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    }
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager DELETE:[BASE_URL stringByAppendingString:url] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Complete, Respose: %@", responseObject);
        [ProgressHUD hideProgressHUD];
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Fail, Respose: %@", error);
        [ProgressHUD hideProgressHUD];
        
        [[Alerter sharedInstance] createAlert:@"Server Error" message:@"Server is offline! \nSorry for the inconvenience. \nPlease try again later." viewController:self.VC completion:^{}];
        
        NSLog(@"Server is offline! \nSorry for the inconvenience. \nPlease try again later.");
        
    }];
    
}

//PUT
-(void)callApiForPUT:(NSString*)url parameters:(NSDictionary*)param sendToken:(BOOL)sendToken successBlock:(void (^)(id responseObject))successBlock {
    
    if (sendToken) {
        NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:JSON_KEY_API_TOKEN];
        [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    }
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager PUT:[BASE_URL stringByAppendingString:url] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Complete, Respose: %@", responseObject);
        [ProgressHUD hideProgressHUD];
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Fail, Respose: %@", error);
        [ProgressHUD hideProgressHUD];
        
        [[Alerter sharedInstance] createAlert:@"Server Error" message:@"Server is offline! \nSorry for the inconvenience. \nPlease try again later." viewController:self.VC completion:^{}];
        
        NSLog(@"Server is offline! \nSorry for the inconvenience. \nPlease try again later.");
        
    }];
}


//image fetch with api_token
-(void)callApiForImageRequest:(NSString*)url successBlock:(void (^)(id responseObject))successBlock {
    
    //NSString *url = @"http://192.168.0.143:81/api/v1/getfile/akldshfiuo876879jfd877jhdsaf7.jpg";
    
    NSDictionary *param = @{JSON_KEY_API_TOKEN : [[NSUserDefaults standardUserDefaults] objectForKey:JSON_KEY_API_TOKEN]};
    
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:[[BASE_URL stringByAppendingString:GETFILE_PATH] stringByAppendingString:url] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        [ProgressHUD hideProgressHUD];
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Fail, Respose: %@", error);
        [ProgressHUD hideProgressHUD];
        
        [[Alerter sharedInstance] createAlert:@"Server Error" message:@"Server is offline! \nSorry for the inconvenience. \nPlease try again later." viewController:self.VC completion:^{}];
        
    }];
    
}

@end
