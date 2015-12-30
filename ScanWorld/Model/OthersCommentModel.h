//
//  OthersCommentModel.h
//  ScanWorld
//
//  Created by qianfeng on 15/12/21.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class OthersThreadModel,OthersCommentsDetailModel,OthersUserModel;



@interface OthersThreadModel : JSONModel

@property (nonatomic, copy) NSString *channel;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *commentStatus;

@property (nonatomic, copy) NSString *numComments;

@property (nonatomic, copy) NSString *permalink;

@property (nonatomic, copy) NSString *lastCommentAt;

@end



@interface  ParentModel: JSONModel

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *upVotes;

@property (nonatomic, copy) NSString *downVotes;

@property (nonatomic, copy) NSString *createdAt;

@property (nonatomic, strong) OthersUserModel *user;

@end



@protocol OthersCommentsDetailModel

@end

@interface OthersCommentsDetailModel : JSONModel

@property (nonatomic, copy) ParentModel<Optional> *parent;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger isExcellent;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, assign) BOOL isHighlight;

@property (nonatomic, copy) NSString *upVotes;

@property (nonatomic, assign) NSInteger report;

@property (nonatomic, copy) NSString *downVotes;

@property (nonatomic, copy) NSString *createdAt;

@property (nonatomic, strong) OthersUserModel *user;

@end



@protocol CommentTagModel <NSObject>
@end
@interface CommentTagModel : JSONModel
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *tagName;
@end


@interface OthersUserModel : JSONModel

@property (nonatomic, copy) NSString *id;

@property (nonatomic, strong) NSArray<Optional,CommentTagModel> *tags;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *avatar;

@end


@interface OthersCommentModel : JSONModel

@property (nonatomic, copy) NSString *threadId;

@property (nonatomic, strong) OthersThreadModel *thread;

@property (nonatomic, strong) NSArray<OthersCommentsDetailModel> *comments;

@end
