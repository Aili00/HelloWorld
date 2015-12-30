//
//  MYFavoriteCell.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/23.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "MYFavoriteCell.h"

@interface MYFavoriteCell ()

@property (weak, nonatomic) IBOutlet UIImageView *newsAvatar;

@property (weak, nonatomic) IBOutlet UILabel *newsTitle;

@end


@implementation MYFavoriteCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateWithData:(CResultModel *)model {
    [self.newsAvatar sd_setImageWithURL:[NSURL URLWithString:model.post.imageUrl] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    self.newsTitle.text = model.post.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
