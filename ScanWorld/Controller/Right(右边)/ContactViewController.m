//
//  ContactViewController.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/23.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "ContactViewController.h"


@interface ContactViewController ()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //_titleLabel.font = [UIFont fontWithName:@"华文琥珀" size:21.0];
    UIFont *font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:23];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@"掌读天下\nScanWorld"];
    [string addAttribute:NSForegroundColorAttributeName value:SWBaseColor  range:NSMakeRange(0, string.length)];
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    _titleLabel.attributedText = string;
}

- (instancetype)init {
    if (self = [super init]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self = [storyBoard instantiateViewControllerWithIdentifier:@"ContactViewController"];
    }
    return self;
}


- (IBAction)backAction:(id)sender {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MMDrawerController *drawerController = (MMDrawerController *)window.rootViewController;
    [self dismissViewControllerAnimated:YES completion:^{
        [drawerController closeDrawerAnimated:YES completion:nil];
    }];
    
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
