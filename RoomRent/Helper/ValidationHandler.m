//
//  ValidationHandler.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/7/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//


#import "ValidationHandler.h"

@implementation ValidationHandler: NSObject

static ValidationHandler* instance = nil;

+(ValidationHandler*) sharedInstance {
    
    if (instance == nil) {
        instance = [[ValidationHandler alloc] init];
        return instance;
    }
    return instance;
}



-(void)addRegexFor:(MyCustomUITextField *)textField regex:(NSString *)regex withValidationMsg:(NSString *)validationMsg {
    
    textField.regex = regex;
    textField.validationMsg = validationMsg;
}

-(BOOL)validateTextField:(MyCustomUITextField *)textField {

    //If no validation cases return
    if (textField.regex == nil) {
        return true;
    }
    
    
    NSPredicate *testRegex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", textField.regex];
    
    if (![testRegex evaluateWithObject:textField.text]) {
        
        //Invalid Entry
        textField.textColor = [UIColor redColor];
        
        UIButton *btnError=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [btnError addTarget:self action:@selector(tapOnError) forControlEvents:UIControlEventTouchUpInside];
        [btnError setBackgroundImage:[UIImage imageNamed:@"error.png"] forState:UIControlStateNormal];
        
        textField.rightView=btnError;
        //self.rightViewMode=UITextFieldViewModeAlways;
        textField.rightViewMode = UITextFieldViewModeUnlessEditing;
        
        return false;
    }
    
    return true;
    
}

-(void) tapOnError:(MyCustomUITextField*) textField {
    
    //
    
    NSLog(@"Validation Error: %@", textField.validationMsg);
}


@end

