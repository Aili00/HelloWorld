//
//  AppDelegate.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/16.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "AppDelegate.h"
#import <MMDrawerController/MMDrawerController.h>
#import "RightViewController.h"
#import "CenterViewController.h"
#import "UMSocialWechatHandler.h"
#import "UserModel.h"
#import <WXApi.h>

#define LeftDrawerWidth 100;
#define RightDrawerWidth 200;

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //这是为了测试git提交添加的注释
    
    /**
     *  获取用户登录信息
     */
    [self fetchUserInfo];
    
    // Override point for customization after application launch.
    
    /**
     *  创建抽屉
     */
    //创建 左中右 视图控制器
    CenterViewController *centerController = [CenterViewController new];
    UINavigationController *centerNaviController = [[UINavigationController alloc]initWithRootViewController:centerController];
  //  LeftViewController *leftController = [LeftViewController new];
    RightViewController *rightController = [RightViewController new];
    //创建 抽屉 视图控制器
    //预留 左边抽屉
    MMDrawerController *drawController = [[MMDrawerController alloc]initWithCenterViewController:centerNaviController leftDrawerViewController:nil rightDrawerViewController:rightController];
    //拖动范围
    drawController.maximumLeftDrawerWidth = LeftDrawerWidth;
    drawController.maximumRightDrawerWidth = RightDrawerWidth;
    
    //drawController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    drawController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    //设置抽屉为 根视图
    self.window.rootViewController =  drawController;
    [self.window makeKeyAndVisible];
    
    /**
     *  设置 状态栏颜色
     */
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    /**
     *  友盟分享
     */
    [UMSocialData setAppKey:@"5674ae48e0f55a5c04006675"];
    
    /**
     *  添加 微信分享
     */
     [UMSocialWechatHandler setWXAppId:@"wxc49bac89b93b1400" appSecret:@"41ba52a59684dbf211d10273e6eab53c" url:nil];
    
    
    /**
     *  打印一下沙河目录 用来查看数据库
     */
    
//  NSLog(@"沙河目录：%@",NSHomeDirectory());
    return YES;
}

- (void)fetchUserInfo {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefault dataForKey:USER_INFO];
    UserModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    TokenModel *token = [[TokenModel alloc]initWithDictionary:model.token error:nil];
//    model.token = token;
   // NSLog(@"%@",model);
    //用户存在
    if (model) {
        [UserInfoManager shareManager].userModel = model;
       // NSLog(@"%@",[UserInfoManager shareManager].userModel);
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
