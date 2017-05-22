//
//  RequestTableViewCell.h
//  RoomRent
//
//  Created by Bishal Heuju on 5/15/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Post.h"
//#import "PostPartial.h"

@interface RequestTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *postTitle;
@property (weak, nonatomic) IBOutlet UILabel *postNoOfRooms;
@property (weak, nonatomic) IBOutlet UILabel *postPrice;
@property (weak, nonatomic) IBOutlet UILabel *postUser;

@property (weak, nonatomic) IBOutlet UIButton *checkHiddenButton;


@property BOOL isSelected;


-(void)configureCellWithData:(Post*)post;

@end
