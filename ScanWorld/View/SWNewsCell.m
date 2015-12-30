//
//  SWNewsCell.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/17.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "SWNewsCell.h"
#import "SWTimeInterval.h"


@interface SWNewsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *commonLabel;
@end



@implementation SWNewsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateWithData:(ResultModel *)resultModel {
//    [NSURL URLWithString:resultModel.imageUrl]
    [_icon sd_setImageWithURL:[NSURL URLWithString:resultModel.imageUrl] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    _titleLabel.text = resultModel.title;
    _timeLabel.text = [SWTimeInterval timeInterval:resultModel.createdAt];
    _commonLabel.text = resultModel.commentCount;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
