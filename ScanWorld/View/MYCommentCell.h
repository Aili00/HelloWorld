//
//  MYCommentCell.h
//  ScanWorld
//
//  Created by qianfeng on 15/12/23.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCommentModel.h"

@interface MYCommentCell : UITableViewCell

- (void)updateWithData:(MYCommentsModel *)model;

@end
