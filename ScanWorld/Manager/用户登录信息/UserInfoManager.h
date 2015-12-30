//
//  UserInfoManager.h
//  ScanWorld
//
//  Created by qianfeng on 15/12/20.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface UserInfoManager : NSObject

+ (UserInfoManager *)shareManager;

@property (nonatomic,strong) UserModel *userModel;

@end
