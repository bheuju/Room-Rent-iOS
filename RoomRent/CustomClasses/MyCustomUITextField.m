//
//  MyCustomUITextField.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/3/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "MyCustomUITextField.h"

@implementation MyCustomUITextField {
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    self.delegate = self;
    
}

//Change color of textfield placeholder
-(void)drawPlaceholderInRect:(CGRect)rect {
    UIColor *color = [UIColor lightGrayColor];
    
    if ([self.placeholder respondsToSelector:@selector(drawInRect:withAttributes:)]) {
        // iOS7 and later
        NSDictionary *attributes = @{NSForegroundColorAttributeName: color, NSFontAttributeName: self.font};
        CGRect boundingRect = [self.placeholder boundingRectWithSize:rect.size options:0 attributes:attributes context:nil];
        [self.placeholder drawAtPoint:CGPointMake(0, (rect.size.height/2) - boundingRect.size.height/2) withAttributes:attributes];
    }
    else {
        // iOS 6
        [color setFill];
        [self.placeholder drawInRect:rect withFont:self.font lineBreakMode:NSLineBreakByTruncatingTail alignment:self.textAlignment];
    }
}


//MARK: Validation
-(void)addRegex:(NSString *)regex withValidationMsg:(NSString *)validationMsg {
    self.regex = regex;
    self.validationMsg = validationMsg;
}

-(BOOL)validate {
    
    //If no validation cases return
    if (self.regex == nil) {
        return true;
    }
    
    
    NSPredicate *testRegex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.regex];
    
    if (![testRegex evaluateWithObject:self.text]) {
        
        //Invalid Entry
        self.textColor = [UIColor redColor];
        
        UIButton *btnError=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [btnError addTarget:self action:@selector(tapOnError) forControlEvents:UIControlEventTouchUpInside];
        [btnError setBackgroundImage:[UIImage imageNamed:@"error.png"] forState:UIControlStateNormal];
        
        self.rightView=btnError;
        //self.rightViewMode=UITextFieldViewModeAlways;
        self.rightViewMode = UITextFieldViewModeUnlessEditing;
        
        return false;
    }
    
    return true;
}


-(void) tapOnError{
    NSLog(@"Validation Error: %@", self.validationMsg);
}


//MARK: UITextFieldDelegate Methods
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.textColor = [UIColor whiteColor];
    self.rightView = nil;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.returnKeyType == UIReturnKeyDone) {
        [self resignFirstResponder];
    } else if (textField.returnKeyType == UIReturnKeyNext) {
        [self resignFirstResponder];
        
    }
    return true;
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField {
    
    CGRect rect = [self.superview convertRect:textField.frame toView:[[[UIApplication sharedApplication] delegate] window]];
    //Pass activeTextField to KeyboardAvoidingVC for keyboard avoiding
    [KeyboardAvoidingViewController setActiveTextFieldPosition:rect.origin];
    
    return true;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    [self validate];
    
}

@end
