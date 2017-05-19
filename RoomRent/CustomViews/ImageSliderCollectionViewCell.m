//
//  ImageSliderCollectionViewCell.m
//  RoomRent
//
//  Created by Bishal Heuju on 5/3/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "ImageSliderCollectionViewCell.h"

@implementation ImageSliderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.imageView.layer.borderWidth = 1.0f;
}

@end
