//
//  APICaller.h
//  RoomRent
//
//  Created by Bishal Heuju on 4/6/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#import "Constants.h"

@interface APICaller : NSObject

+(APICaller*)sharedInstance;
-(APICaller*)initAPICaller;

-(void)callApi:(NSString*)url parameters:(NSDictionary*)param successBlock:(void (^)(id responseObject))successBlock;
-(void)callApi:(NSString*)url parameters:(NSDictionary*)param image:(UIImage*)image successBlock:(void (^)(id responseObject))successBlock;
-(void)callApi:(NSString*)url parameters:(NSDictionary*)param imageArray:(NSArray*)imageArray successBlock:(void (^)(id responseObject))successBlock;

-(void)callApiForImageRequest:(NSString*)urla successBlock:(void (^)(id responseObject))successBlock;


@end
