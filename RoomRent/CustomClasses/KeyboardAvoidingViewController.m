//
//  KeyboardAvoidingViewController.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/4/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "KeyboardAvoidingViewController.h"

@interface KeyboardAvoidingViewController ()


@end

@implementation KeyboardAvoidingViewController

static CGPoint activeTextFieldPosition;

+ (void)setActiveTextFieldPosition:(CGPoint)textFieldPosition {
    activeTextFieldPosition = textFieldPosition;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    
    
}

//Dismiss keyboard on outside touch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:true];
}

//MARK: Keyboard notifications handling
-(void)keyboardWillShow:(NSNotification*)notification {
    
    NSDictionary* userInfo = [notification userInfo];

    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    int h = self.view.frame.size.height;
    int w = self.view.frame.size.width;
    
    CGRect nonKeyboardRect = self.view.frame;
    nonKeyboardRect.size.height -= keyboardSize.height + 30;    //30 is offset
    
    //CGPoint p = activeTextFieldPosition;
    
    if (!CGRectContainsPoint(nonKeyboardRect, activeTextFieldPosition)) {
        
        CGRect viewFrame = CGRectMake(0, -keyboardSize.height, w, h);
        [self.view setFrame:viewFrame];
        
    }
}

-(void)keyboardWillHide:(NSNotification*)notification {
    
    int h = self.view.frame.size.height;
    int w = self.view.frame.size.width;
    
    CGRect viewFrame = CGRectMake(0, 0, w, h);
    [self.view setFrame:viewFrame];
}


@end
