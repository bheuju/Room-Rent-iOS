//
//  OfferTableViewCell.h
//  RoomRent
//
//  Created by Bishal Heuju on 4/12/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "ImageSliderCollectionViewCell.h"
#import "Helper.h"

#import "Post.h"
//#import "PostPartial.h"

@interface OfferTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *postImagesCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *postTitle;
@property (weak, nonatomic) IBOutlet UILabel *postNoOfRooms;
@property (weak, nonatomic) IBOutlet UILabel *postPrice;
@property (weak, nonatomic) IBOutlet UILabel *postUser;

@property (weak, nonatomic) IBOutlet UIButton *checkHiddenButton;

@property BOOL isSelected;
@property NSString *postSlug;

@property NSMutableArray *postImagesNameArray;


@property id collectionViewItemClickDelegate;


-(void)configureCellWithData:(Post*)post;

@end




@protocol CollectionViewItemClicked

-(void)collectionViewItemClicked:(NSString*)postSlug;

@end
