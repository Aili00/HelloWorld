//
//  CommentCellFrame.h
//  ScanWorld
//
//  Created by qianfeng on 15/12/25.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OthersCommentModel.h"

@interface CommentCellFrame : NSObject

@property (nonatomic,assign) CGRect avatarImageFrame;
@property (nonatomic,assign) CGRect nameLableFrame;
@property (nonatomic,assign) CGRect contentLabelFrame;
@property (nonatomic,assign) CGRect timeLabelFrame;
@property (nonatomic,assign) CGRect upImageFrame;
@property (nonatomic,assign) CGRect upLabelFrame;
@property (nonatomic,assign) CGRect downImageFrame;
@property (nonatomic,assign) CGRect downLabalFrame;

@property (nonatomic,assign) CGFloat heightRow;
@property (nonatomic,strong) OthersCommentsDetailModel *model;

@end
