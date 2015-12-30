//
//  OpinionViewController.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/23.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "OpinionViewController.h"
#import "CYTipView.h"


@interface OpinionViewController ()<UITextViewDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextView *opinionTextView;

@property (weak, nonatomic) IBOutlet UILabel *placeholdLabel;


@end

@implementation OpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
}

- (instancetype)init {
    if (self = [super init]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self = [storyBoard instantiateViewControllerWithIdentifier:@"OpinionViewController"];
    }
    return self;
}

#pragma mark - 返回
- (IBAction)backAction:(id)sender {
    [self dismissSelf];
}

- (void)dismissSelf {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    MMDrawerController *drawController =(MMDrawerController *) keyWindow.rootViewController;
    
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        [drawController closeDrawerAnimated:YES completion:nil];
    }];
}

#pragma mark - 判断邮箱及手机号码格式
- (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)isValidatePhoneNumber:(NSString *)phoneNumber {
     NSString * phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *predTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [predTest evaluateWithObject:phoneNumber];
}

#pragma mark - 提交
- (IBAction)submitAction:(id)sender {
   
    if (self.opinionTextView.text.length <=0) {
        [CYTipView animationTipViewWithMessage:@"请输入您的意见" duration:AnimationTime completion:nil];
    }else {
        self.opinionTextView.text = @"";
        [CYTipView animationTipViewWithMessage:@"正在提交" duration:AnimationTime completion:^(BOOL finished) {
            [CYTipView animationTipViewWithMessage:@"提交成功！我们会根据您所反映的情况尽快处理！" duration:AnimationTime completion:^(BOOL finished) {
                [self dismissSelf];
            }];
        }];
    }
}


#pragma mark - 
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    _placeholdLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (_opinionTextView.text == nil) _placeholdLabel.hidden = NO;
}


#pragma  mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
