//
//  CommentCell.h
//  ScanWorld
//
//  Created by qianfeng on 15/12/21.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OthersCommentModel.h"
#import "CommentCellFrame.h"
@interface CommentCell : UITableViewCell

//- (void)UpdateWithData:(CommentCellFrame *)cellFrame;

- (void)UpdateWithModelData:(OthersCommentsDetailModel *)model;

@end
