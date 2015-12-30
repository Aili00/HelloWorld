//
//  MyCommentModel.h
//  ScanWorld
//
//  Created by qianfeng on 15/12/21.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class MYCommentsModel,MYArticleModel,MYUserModel;

@protocol MYCommentsModel <NSObject>

@end

@interface MYCommentsModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *parent;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger isExcellent;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, assign) BOOL isHighlight;

@property (nonatomic, copy) NSString *upVotes;

@property (nonatomic, strong) MYArticleModel *article;

@property (nonatomic, copy) NSString *downVotes;

@property (nonatomic, copy) NSString *createdAt;

@property (nonatomic, strong) MYUserModel *user;

@end

@interface MYArticleModel : JSONModel

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *channel;

@property (nonatomic, copy) NSString *commentStatus;

@property (nonatomic, copy) NSString *threadId;

@property (nonatomic, copy) NSString *permalink;

@end

@interface MYUserModel : JSONModel

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString<Optional> *tags;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *avatar;

@end


@interface MyCommentModel : JSONModel

@property (nonatomic, strong) NSArray<MYCommentsModel> *comments;

@end
