//
//  OfferTableViewCell.m
//  RoomRent
//
//  Created by Bishal Heuju on 4/12/17.
//  Copyright © 2017 Bishal Heuju. All rights reserved.
//

#import "OfferTableViewCell.h"

@implementation OfferTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.isSelected = false;
    
    self.postImagesCollectionView.delegate = self;
    self.postImagesCollectionView.dataSource = self;
    
    [self.postImagesCollectionView registerNib:[UINib nibWithNibName:@"ImageSliderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"imageSliderCollectionViewCell"];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*) self.postImagesCollectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(394.0f, 200.0f);
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
}


//Methods Implementation
-(void)configureCellWithData:(Post*)post {
    
    //Post Slug assign for delegate, onItemClicked
    self.postSlug = post.postSlug;
    
    self.postTitle.text = [[[post.postId stringValue] stringByAppendingString:@": "] stringByAppendingString:post.postTitle];
    self.postNoOfRooms.text = [post.postNoOfRooms stringValue];
    self.postPrice.text = [post.postPrice stringValue];
    self.postUser.text = post.postUser.username;
    
    self.postImagesNameArray = [[NSMutableArray alloc] initWithArray:post.postImageArray];
    
    [self.postImagesCollectionView reloadData];
}


//MARK: Collection view methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%lu", self.postImagesNameArray.count);
    return self.postImagesNameArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageSliderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageSliderCollectionViewCell" forIndexPath:indexPath];
    
//    NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:JSON_KEY_API_TOKEN];
//    SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
//    [manager setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];

    
    [cell.imageView sd_setImageWithURL:[[Helper sharedInstance] generateGetImageURLFromFilename:self.postImagesNameArray[indexPath.row]]  placeholderImage:[UIImage imageNamed:@"no-image"] options:SDWebImageRetryFailed];
    
    //UIImage *img = cell.imageView.image;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.collectionViewItemClickDelegate collectionViewItemClicked:self.postSlug];
    
}


@end
