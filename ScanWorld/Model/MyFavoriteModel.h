//
//  MyFavoriteModel.h
//  ScanWorld
//
//  Created by qianfeng on 15/12/23.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CPaginatorModle : JSONModel
@property (nonatomic,copy) NSString *total;
@property (nonatomic,copy) NSString *previous;
@property (nonatomic,copy) NSString *next;
@property (nonatomic,copy) NSString *last;
@end

@interface CUSerModel : JSONModel

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *screenName;

@end


@interface PostModel : JSONModel

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *codeType;
@property (nonatomic,copy) NSString *createdAt;
@property (nonatomic,copy) NSString *summary;
@property (nonatomic,copy) NSString *summaryHtml;
@property (nonatomic,copy) NSString *commentStatus;
@property (nonatomic,copy) NSString<Optional> *sourceName;
@property (nonatomic,copy) NSString<Optional> *sourceUrl;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,strong) CUSerModel<Optional> *user;

@end

@protocol CResultModel <NSObject>



@end

@interface CResultModel : JSONModel

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *createdAt;
@property (nonatomic,copy) PostModel *post;

@end
@interface MyFavoriteModel : JSONModel

@property (nonatomic,copy) CPaginatorModle *paginator;
@property (nonatomic,strong) NSArray<CResultModel> *results;

@end
