//
//  Helper.h
//  RoomRent
//
//  Created by Bishal Heuju on 5/3/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"

@interface Helper : NSObject

+(Helper*)sharedInstance;

-(NSURL*)generateGetImageURLFromFilename:(NSString*)filename;

@end
