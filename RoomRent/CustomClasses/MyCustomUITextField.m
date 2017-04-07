//
//  MyCustomUITextField.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/3/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "MyCustomUITextField.h"

@implementation MyCustomUITextField

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    self.regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    self.validationMsg = @"";
    
    self.delegate = self;
    
}

//Chnage color of textfield placeholder
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
-(BOOL)validate {
    
    //NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    //self.regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *testRegex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.regex];
    
    if (![testRegex evaluateWithObject:self.text]) {
        
        //Invalid Entry
        
        //NSString *errorMsg = @"This is an error message";
        self.layer.backgroundColor = [[UIColor redColor]CGColor];
        
        return false;
    }
    
    return true;
}


//MARK: UITextFieldDelegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.layer.backgroundColor = [[UIColor clearColor]CGColor];
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
