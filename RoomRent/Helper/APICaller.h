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
#import "Alerter.h"

@interface APICaller : NSObject

@property UIViewController* VC;

+(APICaller*)sharedInstance:(UIViewController*)VC;
-(APICaller*)initAPICaller;

//MARK: GET
/**
 GET: Request
 
 @param url             Partial URL without base url.
 @param param           Request paramteres.
 @param sendToken       Bool send api token or not
 @param successBlock    Success block
 */
-(void)callApiForGET:(NSString*)url parameters:(NSDictionary*)param sendToken:(BOOL)sendToken successBlock:(void (^)(id responseObject))successBlock;

/**
 GET: Request RAW url
 
 @param url             Full URL.
 @param param           Request paramteres.
 @param successBlock    Success block
 */
-(void)callApiForGETRawUrl:(NSString*)url parameters:(NSDictionary*)param successBlock:(void (^)(id responseObject))successBlock;



//MARK: POST
/**
 POST: Request with token.
 
 @param url             Partial URL without base url.
 @param param           Request paramteres.
 @param sendToken       Bool send api token or not
 @param successBlock    Success block
 */
-(void)callApiForPOST:(NSString*)url parameters:(NSDictionary*)param sendToken:(BOOL)sendToken successBlock:(void (^)(id responseObject))successBlock;

/**
 POST: Request with Single Image
 
 @param url             Partial URL without base url.
 @param param           Request paramteres.
 @param image           Single UIImage
 @param successBlock    Success block
 */
-(void)callApi:(NSString*)url parameters:(NSDictionary*)param image:(UIImage*)image successBlock:(void (^)(id responseObject))successBlock;

/**
 POST: Request with imageArray
 
 @param url             Partial URL without base url.
 @param param           Request paramteres.
 @param imageArray      UIImage Array []
 @param successBlock    Success block
 */
-(void)callApi:(NSString*)url parameters:(NSDictionary*)param imageArray:(NSArray*)imageArray successBlock:(void (^)(id responseObject))successBlock;



//MARK: PUT

/**
 PUT: Request with token
 
 @param url             Partial URL without base url.
 @param param           Request paramteres.
 @param sendToken       Bool send api token or not
 @param successBlock    Success block
 */
-(void)callApiForPUT:(NSString*)url parameters:(NSDictionary*)param sendToken:(BOOL)sendToken successBlock:(void (^)(id responseObject))successBlock;



//MARK: DELETE
/**
 DELETE: Request with token
 
 @param url             Partial URL without base url.
 @param param           Request paramteres.
 @param sendToken       Bool send api token or not
 @param successBlock    Success block
 */
-(void)callApiForDELETE:(NSString*)url parameters:(NSDictionary*)param sendToken:(BOOL)sendToken successBlock:(void (^)(id responseObject))successBlock;



/**
 GET: Image
 Depracated
 */
-(void)callApiForImageRequest:(NSString*)urla successBlock:(void (^)(id responseObject))successBlock;


@end
