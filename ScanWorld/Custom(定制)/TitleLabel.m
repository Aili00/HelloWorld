//
//  TitleLabel.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/16.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "TitleLabel.h"

@implementation TitleLabel

//重写 设置 scale 方法
//设置颜色变化 及 text 大小
- (void)setScale:(CGFloat)scale {
    _scale = scale;
    
    
    CGFloat minScale = 0.7;
    CGFloat textScale = minScale + (1-minScale)*scale;
    self.transform = CGAffineTransformMakeScale(textScale,textScale);
    if (scale == 0) self.textColor = [UIColor colorWithRed:0 green:0 blue:scale alpha:1.0];
    else self.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:scale alpha:1.0];;
        
   }


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:17];
        self.userInteractionEnabled = YES;
        self.textColor = [UIColor yellowColor];
        self.scale = 0.0;
    }
    return self;
}

@end
