//
//  ValidationHandler.h
//  RoomRent
//
//  Created by Bishal Heuju on 4/7/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MyCustomUITextField.h"

@interface ValidationHandler : NSObject

+(ValidationHandler*) sharedInstance;


//-(void)addRegexFor:(MyCustomUITextField*)textField regex:(NSString*)regex withValidationMsg:(NSString*)validationMsg;
//-(BOOL)validateTextField:(MyCustomUITextField*)textField;

@end
