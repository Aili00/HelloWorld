//
//  RightViewController.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/16.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "RightViewController.h"
#import "UserViewController.h"
#import "UserInfoManager.h"
#import "LoginViewController.h"
#import "MYCommentViewController.h"
#import "MYFavoriteViewController.h"

@interface RightViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customUI];
    
    //注册登录成功的观察
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:LOGINSUCCESSNOTIFICATION object:nil];
    //注册 头像上传成功 的观察
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(avatarPostSuccsee:) name:AVATARPOSTSUCCESSNOTIFICATION object:nil];
}

- (instancetype)init {
    if (self = [super init]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self = [storyBoard instantiateViewControllerWithIdentifier:@"RightViewController"];
    }
    return self;
}

- (void)customUI {
    self.iconView.clipsToBounds = YES;
    self.iconView.layer.cornerRadius = _iconView.frame.size.width/2;
    self.iconView.userInteractionEnabled = YES;
    //设置头像
    NSString *avaterString = [UserInfoManager shareManager].userModel.avatar;
    (avaterString == nil)?[self.iconView setImage:[UIImage imageNamed:@"login_portrait_ph"]]:([self.iconView sd_setImageWithURL:[NSURL URLWithString:avaterString]]);
    //头像 添加单机手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.iconView addGestureRecognizer:tap];
    
    NSString *name = [UserInfoManager shareManager].userModel.username;
    ( name == nil)?(self.userName.text = @"未登录"):(self.userName.text = name);
}

#pragma mark - 点击 头像 上传头像/登录
- (void)tapAction:(UITapGestureRecognizer *)tap {
    UserInfoManager *userManager = [UserInfoManager shareManager];
    //登录
    if (userManager.userModel.token == nil) {
        LoginViewController *loginVC = [LoginViewController new];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    // 上传头像
    else {
        UserViewController *userVC = [[UserViewController alloc]initWithImage:self.iconView.image];
        [self presentViewController:userVC animated:YES completion:nil];
    }
}

#pragma mark - 登录成功的回调
- (void)loginSuccess:(NSNotification *)notification {
    NSURL *iconUrl = [NSURL URLWithString:[UserInfoManager shareManager].userModel.avatar];
    [self.iconView sd_setImageWithURL:iconUrl];
    
    self.userName.text = [UserInfoManager shareManager].userModel.username;
}

#pragma mark - 头像上传成功的回调
- (void)avatarPostSuccsee:(NSNotification *)notification {
    UIImage *image = (UIImage *)notification.object;
    self.iconView.image = image;
}

#pragma mark - 我的评论
- (IBAction)commonAction:(id)sender {
    if ([UserInfoManager shareManager].userModel.token == nil) {
        [CYTipView animationTipViewWithMessage:@"请先登录" duration:AnimationTime completion:nil];
    }else{
        MYCommentViewController *myCommentVC = [MYCommentViewController new];
        [self presentViewController:myCommentVC animated:YES completion:nil];
    }
}

#pragma mark - 退出登录

- (IBAction)loginOutAction:(UIButton *)sender {
    
    UIAlertController *alerContr = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出登录" preferredStyle:UIAlertControllerStyleActionSheet];
    [alerContr addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [UserInfoManager shareManager].userModel = nil;
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:USER_INFO];
        [[NSNotificationCenter defaultCenter] postNotificationName:LOGINOUTNOTIFICATION object: nil];
        
        self.iconView.image = [UIImage imageNamed:@"login_portrait_ph"];
        self.userName.text = @"未登录";
    }]];
    
    [alerContr addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alerContr animated:YES completion:nil];
    
}


#pragma  mark - 我的收藏
- (IBAction)favAction:(id)sender {
    if ([UserInfoManager shareManager].userModel.token == nil) {
        [CYTipView animationTipViewWithMessage:@"请先登录" duration:AnimationTime completion:nil];
    }else {
        MYFavoriteViewController *myFavoriteVC = [MYFavoriteViewController new];
        [self presentViewController:myFavoriteVC animated:YES completion:nil];
    }
}


- (IBAction)clearAction:(UIButton *)sender {
    
    NSString *message = [NSString stringWithFormat:@"缓存大小%@",[self getCacheSize]];
    
    UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleActionSheet];
    [alertContr addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteCache];
    }]];
    
    [alertContr addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertContr animated:YES completion:nil];
}

#pragma mark - 获取缓存大小
- (NSString *)getCacheSize {
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    CGFloat fileSize = 0;
    NSString *filePath = [array firstObject];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSArray *fileNames = [fileManger subpathsAtPath:filePath];
    for (NSString *fileName in fileNames) {
        NSString *fullPath = [filePath stringByAppendingPathComponent:fileName];
        fileSize += [[fileManger attributesOfItemAtPath:fullPath error:nil] fileSize];
    }
    
    SDImageCache *cache = [SDImageCache sharedImageCache];
     fileSize += (CGFloat)[cache getSize];
    
    fileSize = fileSize/1024/1024;
    
    return [NSString stringWithFormat:@"%.2fMB",fileSize];
}

#pragma mark - 清除缓存
- (void)deleteCache {
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.labelText = @"清除缓存中...";
    progressHUD.removeFromSuperViewOnHide = YES;
    [progressHUD hide:YES afterDelay:AnimationTime];
    
    SDImageCache *cache = [SDImageCache sharedImageCache];
    [cache cleanDisk];
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *filePath = [array firstObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileNames = [fileManager subpathsAtPath:filePath];
    for (NSString *fileName in fileNames) {
        NSString *fullPath = [filePath stringByAppendingPathComponent:fileName];
        [fileManager removeItemAtPath:fullPath error:nil];
    }
    
}

#pragma mark - 移除观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
