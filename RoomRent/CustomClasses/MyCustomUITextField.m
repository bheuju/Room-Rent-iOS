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
    // Drawing code
    
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


//MARK: UITextFieldDelegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //if (textField == RETURN) {
        [self resignFirstResponder];
    //}
    return true;
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField {
    
    CGRect rect = [self.superview convertRect:textField.frame toView:[[[UIApplication sharedApplication] delegate] window]];
    
    //Pass activeTextField to KeyboardAvoidingVC for keyboard avoiding
    [KeyboardAvoidingViewController setActiveTextFieldPosition:rect.origin];
    
    return true;
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return true;
}

@end
