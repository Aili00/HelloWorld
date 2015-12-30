//
//  NetWorkingManager.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/17.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "NetWorkingManager.h"
#import "SWAppModel.h"
#import "SWNewDetailModel.h"
#import "OthersCommentModel.h"



@implementation NetWorkingManager

+ (void)requestDataWithUrl:(NSString *)urlString pageType:(NSString *)pageType successBlock:(SuccessBlock)success faildBlock:(FaildBlock)faild {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //评论页面
        if ([pageType isEqualToString:SWCOMMENT_TYPE]) {
            if (success) success(dict);
            }
        //评论详情页
        else if ([pageType isEqualToString:SWCOMMENT_DETAIL_TYPE]) {
            OthersCommentModel *commentModel = [[OthersCommentModel alloc]initWithDictionary:dict error:nil];
            if (success) success(commentModel);
        }
       //新闻首页
        else {
        SWAppModel *model = [[SWAppModel alloc]initWithDictionary:dict error:nil];
        if (success) success(model);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        faild(error);
    }];
}

@end
