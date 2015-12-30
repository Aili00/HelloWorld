//
//  CommentModel.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/21.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "SWNewDetailModel.h"

@implementation SWNewDetailModel



+ (NSDictionary *)objectClassInArray{
    return @{@"connections" : [ConnectionsModel class], @"categories" : [NewsDetailCategoriesModel class]};
}
@end
@implementation NewsDetailCommentsModel

@end


@implementation NewsDetailUserModel

@end


@implementation NewsDetailTextModel

@end


@implementation ConnectionsModel

@end


@implementation NewsDetailCategoriesModel

@end


