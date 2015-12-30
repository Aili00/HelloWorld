//
//  CYTipView.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/20.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "CYTipView.h"

@implementation CYTipView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (void)animationTipViewWithMessage:(NSString *)message duration:(NSTimeInterval)duration completion:(completionBlock)completion{
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    
    UIView *tipView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 40)];
    tipView.clipsToBounds = YES;
    tipView.layer.cornerRadius = 4;
    
    //tipView.center = keyWindow.center;
    tipView.backgroundColor = SWColor(89, 146, 254, 1);
    [keyWindow addSubview:tipView];
    [keyWindow bringSubviewToFront:tipView];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:tipView.bounds];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.numberOfLines = 0;
    tipLabel.text = message;
    [tipView addSubview:tipLabel];
    
    [UIView animateWithDuration:duration animations:^{
        tipView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [tipView removeFromSuperview];
        
        if (completion) completion(YES);
    }];
    
}

@end
