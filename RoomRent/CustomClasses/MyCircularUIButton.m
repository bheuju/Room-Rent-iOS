//
//  MyCircularUIButton.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/4/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "MyCircularUIButton.h"

@implementation MyCircularUIButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.layer.cornerRadius = self.frame.size.width/2;
    self.clipsToBounds = true;
    self.layer.masksToBounds = true;
    //self.layer.borderWidth = 2.0f;
    //self.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (![super pointInside:point withEvent:event]) {
        return false;
    }
    
    BOOL isInside = (pow((point.x-self.frame.size.width/2), 2) + pow((point.y - self.frame.size.height/2), 2) < pow((self.frame.size.width/2), 2)) ? true : false;
    
    [UIButton buttonWithType:UIButtonTypeSystem];
    
    self.layer.cornerRadius = self.frame.size.height/2;
    
    return isInside;
    
}


@end
