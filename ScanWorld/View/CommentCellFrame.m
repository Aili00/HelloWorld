
//
//  CommentCellFrame.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/25.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "CommentCellFrame.h"

@implementation CommentCellFrame

- (void)setModel:(OthersCommentsDetailModel *)model {
    _model = model;
    
    CGFloat padding = 8;
    CGFloat topping = 4;
    CGFloat imageW = 30;
    CGFloat imageH = 30;
    _avatarImageFrame = CGRectMake(padding, padding, imageW, imageH);
    
    CGFloat nameX = CGRectGetMaxX(_avatarImageFrame)+padding;
    CGFloat nameW = ScreenWidth - padding*3 - imageW;
    _nameLableFrame = CGRectMake(nameX, padding,nameW , 17);
    
    CGFloat contentY = CGRectGetMaxY(_nameLableFrame)+topping;
    CGFloat contentX = nameX;
    CGFloat contentW = nameW;
    CGSize contentSize = [model.content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    _contentLabelFrame = CGRectMake(contentX, contentY, contentSize.width, contentSize.height);
    
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(_contentLabelFrame)+topping;
    CGFloat timeW = 100;
    CGFloat timeH = 21;
    _timeLabelFrame = CGRectMake(timeX, timeY, timeW, timeH);
    
    CGFloat downLabelW = 30;
    CGFloat downLabelX = ScreenWidth - padding - downLabelW;
    CGFloat downLabelY = timeY;
    CGFloat downLabelH = timeH;
    _downLabalFrame = CGRectMake(downLabelX, downLabelY, downLabelW, downLabelH);
    
    CGFloat downImageH = 10;
    CGFloat downImageW = 13;
    CGFloat downImageX = CGRectGetMinX(_downLabalFrame) - padding - downImageW;
    _downImageFrame = CGRectMake(downImageX, downLabelY, downImageW, downImageH);
    
    CGFloat upLabelX = CGRectGetMinX(_downImageFrame) - padding - downLabelW;
    _upLabelFrame = CGRectMake(upLabelX, downLabelY, downLabelW, downLabelH);
    
    CGFloat upImageX = CGRectGetMinX(_upLabelFrame) - padding - downImageW;
    _upImageFrame = CGRectMake(upImageX, downLabelY, downImageW, downImageH);
    
    _heightRow = CGRectGetMaxY(_upImageFrame) + padding;

}



@end
