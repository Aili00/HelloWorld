//
//  CommentModel.h
//  ScanWorld
//
//  Created by qianfeng on 15/12/21.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class NewsDetailCommentsModel,NewsDetailUserModel,NewsDetailTextModel,ConnectionsModel,NewsDetailCategoriesModel;

@interface SWNewDetailModel : JSONModel
@property (nonatomic, copy) NSString *slug;

@property (nonatomic, copy) NSString *codeType;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *summary;

@property (nonatomic, strong) NSArray<Optional> *tags;

@property (nonatomic, strong) NSArray<ConnectionsModel *> *connections;

@property (nonatomic, copy) NSString *count;

@property (nonatomic, copy) NSString *createdAt;

@property (nonatomic, copy) NSString *summaryHtml;

@property (nonatomic, copy) NSString<Optional> *sourceName;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString<Optional> *sourceUrl;

@property (nonatomic, strong) NewsDetailUserModel *user;

@property (nonatomic, copy) NSString *commentStatus;

@property (nonatomic, assign) BOOL star;

@property (nonatomic, strong) NewsDetailTextModel *text;

@property (nonatomic, strong) NewsDetailCommentsModel *comments;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) NSArray<NewsDetailCategoriesModel *> *categories;
@end



@interface NewsDetailCommentsModel : JSONModel

@property (nonatomic, copy) NSString *channel;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *commentStatus;

@property (nonatomic, copy) NSString *numComments;

@property (nonatomic, copy) NSString *permalink;

@property (nonatomic, copy) NSString *lastCommentAt;

@end



@interface NewsDetailUserModel : JSONModel

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *screenName;

@property (nonatomic, copy) NSString *avatar;

@end



@interface NewsDetailTextModel : JSONModel

@property (nonatomic, copy) NSString *content;

@end



@interface ConnectionsModel : JSONModel

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *slug;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *createdAt;

@end



@interface NewsDetailCategoriesModel : JSONModel

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *categoryName;

@end



