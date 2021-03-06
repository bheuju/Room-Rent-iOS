//
//  MyCustomUITextField.h
//  RoomRent
//
//  Created by Bishal Heuju on 4/3/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KeyboardAvoidingViewController.h"
#import "Alerter.h"
#import "ValidationHandler.h"

@interface MyCustomUITextField : UITextField <UITextFieldDelegate>

@property NSString *regex;
@property NSString *validationMsg;
@property BOOL isRequired;

-(void)addRegex:(NSString*)regex withValidationMsg:(NSString*)validationMsg;
-(BOOL)validate;
-(void)setIsRequired;

@end
