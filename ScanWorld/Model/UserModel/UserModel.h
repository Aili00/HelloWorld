//
//  UserModel.h
//  ScanWorld
//
//  Created by qianfeng on 15/12/20.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
 avatar = "http://avatar.cdn.wallstcn.com/default";
 email = "1024093964@qq.com";
 emailStatus = active;
 id = 872167;
 roles =     (
 USER
 );
 screenName = "<null>";
 status = active;
 token =     {
 apikey = B0dLHDsZ;
 createdAt = 1450615964;
 dailyRate = 5000;
 expiredAt = 0;
 hourlyRate = 4000;
 id = 368325;
 level = basic;
 minutelyRate = 60;
 refreshedAt = 0;
 userId = 872167;
 };
 username = Aili00;
 }

 */

//@interface TokenModel : JSONModel<NSCoding>
//
//@property (nonatomic,copy) NSString *apikey;
//@property (nonatomic,copy) NSString *createdAt;
//@property (nonatomic,copy) NSString *dailyRate;
//@property (nonatomic,copy) NSString *expiredAt;
//@property (nonatomic,copy) NSString *hourlyRate;
//@property (nonatomic,copy) NSString *id;
//@property (nonatomic,copy) NSString *level;
//@property (nonatomic,copy) NSString *minutelyRate;
//@property (nonatomic,copy) NSString *refreshedAt;
//@property (nonatomic,copy) NSString *userId;
//
//@end

@interface UserModel : JSONModel<NSCopying>
//头像
@property (nonatomic,copy) NSString *avatar;
//邮箱
@property (nonatomic,copy) NSString *email;
//邮箱状态
@property (nonatomic,copy) NSString *emailStatus;
//用户id
@property (nonatomic,copy) NSString *id;
//用户角色
@property (nonatomic,strong) NSArray *roles;
//显示名字
@property (nonatomic,copy) NSString<Optional> *screenName;
//当前状态
@property (nonatomic,copy) NSString *status;
//用户名
@property (nonatomic,copy) NSString *username;
//token
@property (nonatomic,strong) NSDictionary *token;

@end
