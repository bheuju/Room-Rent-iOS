//
//  RequestTableViewCell.m
//  RoomRent
//
//  Created by Bishal Heuju on 5/15/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "RequestTableViewCell.h"

@implementation RequestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    self.isSelected = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//Methods Implementation
-(void)configureCellWithData:(Post*)post {
    
    self.postTitle.text = [[[post.postId stringValue] stringByAppendingString:@": "] stringByAppendingString:post.postTitle];
    self.postNoOfRooms.text = [post.postNoOfRooms stringValue];
    self.postPrice.text = [post.postPrice stringValue];
    self.postUser.text = post.postUser.username;
    
}


@end
