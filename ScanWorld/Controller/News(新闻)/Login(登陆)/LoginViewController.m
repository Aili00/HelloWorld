//
//  LoginViewController.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/19.
//  Copyright © 2015年 Aili. All rights reserved.
//
/**
 *  登录错误提示
    状态码     错误
    10001   Password is too short. Minimum 6 characters
    10000   ERR_USER_PASSWORD_WRONG
    10000   ERR_USER_NOT_EXIST
 
 *
 *
 */

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UserInfoManager.h"
#import "CommonViewController.h"
#import "CYTipView.h"

@interface LoginViewController ()<NSURLConnectionDataDelegate> {
    NSMutableData *_mutableData;
}

@property (weak, nonatomic) IBOutlet UITextField *userName;

@property (weak, nonatomic) IBOutlet UITextField *userPassword;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setLoginButtonBackground];
    
}

- (instancetype)init {
    if (self = [super init]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self = [storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    }
    return self;
}



- (void)initData {
    _mutableData = [NSMutableData new];
}

#pragma mark - 添加屏幕点击事件 收回键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}


#pragma mark - 设置登录按钮背景 按像素拉伸
- (void)setLoginButtonBackground {
    
    UIImage *backImage = [UIImage imageNamed:@"adsmogo_btnbg"];
    backImage = [backImage stretchableImageWithLeftCapWidth:backImage.size.width/2 topCapHeight:backImage.size.height/2];
    [self.loginButton setBackgroundImage:backImage forState:UIControlStateNormal];
}
#pragma mark - 取消按钮
- (IBAction)closeAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}

#pragma mark - 注册
- (IBAction)registerAction:(UIButton *)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  
    RegisterViewController *registerViewController = [RegisterViewController  new];
    registerViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:registerViewController animated:YES completion:^{
        
    }];
}

#pragma mark - 登录
- (IBAction)loginAction:(UIButton *)sender {
    //重新编码 请求urlString
    NSString *strTmp = [SW_USER_LOGIN stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strTmp];
    //请求对象
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:url];
    //请求参数
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:_userName.text,LOGIN_NAME,_userPassword.text,USER_PASSWORD, nil];
    //请求参数 二进制流
      NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    //请求头格式 设置
       [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //请求头长度 设置
       [urlRequest setValue:[NSString stringWithFormat:@"%lu",(unsigned long)data.length] forHTTPHeaderField:@"Content-Length"];
    //请求体 设置
    [urlRequest setHTTPBody:data];
    //请求 方法
    [urlRequest setHTTPMethod:@"POST"];
    
    //开始 登录请求
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    
}

#pragma mark - 错误提示框
- (void)animationTipViewWithMessage:(NSString *)message duration:(NSTimeInterval)duration completionAction:(SEL)completionAction{
    UIView *tipView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 150)];
    tipView.center = self.view.center;
    tipView.backgroundColor = [UIColor whiteColor];
    tipView.alpha = 0.5;
    [self.view addSubview:tipView];
    [self.view bringSubviewToFront:tipView];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:tipView.bounds];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor blackColor];
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.numberOfLines = 0;
    tipLabel.text = message;
    [tipView addSubview:tipLabel];

    [UIView animateWithDuration:duration animations:^{
        tipView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [tipView removeFromSuperview];
    }];
    
}

#pragma mark - NSURLConnectionDataDelegate
#pragma mark - 服务器端有应答
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [_mutableData setLength:0];
    NSLog(@"服务器开始应答。。。。。。");
}

#pragma mark - 开始接收到收据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_mutableData appendData:data];
    NSLog(@"开始接收数据。。。。。。");
}

#pragma mark - 接收数据完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"数据接收完成");
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:_mutableData options:NSJSONReadingMutableContainers error:nil];
   NSLog(@"%@",dict);
    NSArray *errors = [dict objectForKey:@"errors"];
    //输入信息有误／用户不存在
    if (errors.count>0) {
        NSString *message = errors.firstObject[@"message"];
        NSLog(@"%@",message);
        NSString *resultString = nil;
        if ([message isEqualToString:@"Password is too short. Minimum 6 characters"]) resultString = @"请输入六位以上密码";
        else if ([message isEqualToString:@"ERR_USER_NOT_EXIST"]) resultString = @"用户名不存在";
        else if ([message isEqualToString:@"ERR_USER_NOT_ACTIVED"]) resultString = @"该用户未激活";
        else if ([message isEqualToString:@"ERR_USER_PASSWORD_WRONG"]) resultString = @"用户密码错误";
        
        [CYTipView animationTipViewWithMessage:resultString duration:AnimationTime completion:nil];
    }
    //登录成功 给userModel 赋值
    else {
        if ([UserInfoManager shareManager].userModel == nil) {
            [UserInfoManager shareManager].userModel = [[UserModel alloc]init];
        }
        [[UserInfoManager shareManager].userModel setValuesForKeysWithDictionary:dict];
        //发送登录成功的消息
        [[NSNotificationCenter defaultCenter]postNotificationName:LOGINSUCCESSNOTIFICATION object:nil];
        //登录信息写入到userdefault 并更新到磁盘
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[UserInfoManager shareManager].userModel];
        
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:USER_INFO];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self dismissViewControllerAnimated:YES completion:^{
            CommonViewController *commentVC = [[CommonViewController alloc]initWithNewsId:_newsId];
            [self presentViewController:commentVC animated:YES completion:^{
                
            }];
        }];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
