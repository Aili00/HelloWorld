//
//  RegisterViewController.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/20.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "RegisterViewController.h"
#import "CYTipView.h"

@interface RegisterViewController ()<NSURLConnectionDataDelegate> {
    NSMutableData *_mutableData;
}

@property (weak, nonatomic) IBOutlet UITextField *userName;


@property (weak, nonatomic) IBOutlet UITextField *mailboxCode;

@property (weak, nonatomic) IBOutlet UITextField *registerPassword;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mutableData  = [NSMutableData new];
    [self setRegisterButtonBackImage];
   
}

- (instancetype)init {
    if (self = [super init]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self = [storyBoard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    }
    return self;
}

#pragma mark - 设置登录按钮背景 按像素拉伸
- (void)setRegisterButtonBackImage {
    UIImage *backImage = [UIImage imageNamed:@"adsmogo_btnbg"];
    backImage = [backImage stretchableImageWithLeftCapWidth:backImage.size.width/2 topCapHeight:backImage.size.height/2];
    [self.registerButton setBackgroundImage:backImage forState:UIControlStateNormal];
}

#pragma mark - 添加屏幕点击事件 收回键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - 返回
- (IBAction)backAction:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}

#pragma  mark - 点击登录
- (IBAction)registerAction:(id)sender {
    if (self.userName.text && self.mailboxCode.text) {
        NSString *strTemp = [SW_UESR_REGIST stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:strTemp];
        NSMutableURLRequest *urlResult = [[NSMutableURLRequest alloc]initWithURL:url];
        NSDictionary *parameters = @{REGISTER_NAME:self.userName.text,USER_EMAIL:self.mailboxCode.text,USER_PASSWORD:self.registerPassword.text};
        NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        [urlResult setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [urlResult setValue:[NSString stringWithFormat:@"%lu",(unsigned long)data.length] forHTTPHeaderField:@"Content-Length"];
        [urlResult setHTTPBody:data];
        [urlResult setHTTPMethod:@"POST"];
        
        [NSURLConnection connectionWithRequest:urlResult delegate:self];
        
    }
    else [CYTipView animationTipViewWithMessage:@"用户名和注册邮箱不能为空" duration:3 completion:^(BOOL finished) {
        
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
    //注册失败
    if ([errors count]>0) {
        NSString *message = errors.firstObject[@"message"];
        NSLog(@"%@",message);
        NSString *resultString = nil;
        if ([message isEqualToString:@"Password is too short. Minimum 6 characters"]) resultString = @"请输入六位以上密码";
        else if ([message isEqualToString:@"Email is not valid"]) resultString = @"请输入正确的邮箱格式";
        else if ([message isEqualToString:@"Username is too short. Minimum 4 characters"]) resultString = @"请输入四位以上的用户名";
        else if ([message isEqualToString:@"ERR_USER_USERNAME_ALREADY_TAKEN"]) resultString = @"用户名已存在";
        else if ([message isEqualToString:@"ERR_USER_EMAIL_ALREADY_TAKEN"])  resultString = @"邮箱已经被注册过了";
        
        [CYTipView animationTipViewWithMessage:resultString duration:3 completion:^(BOOL finished) {
            
        }];
    }
    
    //注册成功
    else {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注册成功！" message:@"请登录邮箱进行验证" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [alertController addAction:actionConfirm];
    [self presentViewController:alertController animated:YES completion:^{
        
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
