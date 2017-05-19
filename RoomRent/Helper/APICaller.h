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

/**
 * POST Request with token
 */

-(void)callApiForPOST:(NSString*)url parameters:(NSDictionary*)param sendToken:(BOOL)sendToken successBlock:(void (^)(id responseObject))successBlock;

/**
 * POST Request with Single Image
 */

-(void)callApi:(NSString*)url parameters:(NSDictionary*)param image:(UIImage*)image successBlock:(void (^)(id responseObject))successBlock;

/**
 * POST Request with imageArray
 */

-(void)callApi:(NSString*)url parameters:(NSDictionary*)param imageArray:(NSArray*)imageArray successBlock:(void (^)(id responseObject))successBlock;

/**
 * GET Request
 */
-(void)callApiForGET:(NSString*)url parameters:(NSDictionary*)param sendToken:(BOOL)sendToken successBlock:(void (^)(id responseObject))successBlock;

/**
 * GET Request RAW url
 */
-(void)callApiForGETRawUrl:(NSString*)url parameters:(NSDictionary*)param successBlock:(void (^)(id responseObject))successBlock;

/**
 * Depracated
 */
-(void)callApiForImageRequest:(NSString*)urla successBlock:(void (^)(id responseObject))successBlock;


@end
