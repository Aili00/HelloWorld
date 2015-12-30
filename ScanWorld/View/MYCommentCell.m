//
//  MYCommentCell.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/23.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "MYCommentCell.h"

@interface MYCommentCell ()

@property (weak, nonatomic) IBOutlet UILabel *NewsTitle;

@property (weak, nonatomic) IBOutlet UILabel *myComment;

@end


@implementation MYCommentCell

- (void)awakeFromNib {
    // Initialization code
  
}

- (void)updateWithData:(MYCommentsModel *)model {
    
    _myComment.text = [NSString stringWithFormat:@"我说：%@",model.content];
    _NewsTitle.text = [NSString stringWithFormat:@"原文：%@",model.article.title];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
