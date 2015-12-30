//
//  UserInfoManager.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/20.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager

+ (UserInfoManager *)shareManager {
  static  UserInfoManager *manager = nil;
    if (manager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [UserInfoManager new];
            manager.userModel = [UserModel new];
            
        });
    }
    return manager;
}



@end
