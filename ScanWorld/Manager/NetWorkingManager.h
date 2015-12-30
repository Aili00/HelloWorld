//
//  NetWorkingManager.h
//  ScanWorld
//
//  Created by qianfeng on 15/12/17.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id model);
typedef void(^FaildBlock)(NSError *error);


@interface NetWorkingManager : NSObject

+ (void)requestDataWithUrl:(NSString *)urlString pageType:(NSString *)pageType successBlock:(SuccessBlock)success faildBlock:(FaildBlock)faild;



@end
