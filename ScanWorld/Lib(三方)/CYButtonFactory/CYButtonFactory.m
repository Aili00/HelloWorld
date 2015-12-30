//
//  CYButtonFactory.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/18.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "CYButtonFactory.h"

@implementation CYButtonFactory

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                         font:(UIFont *)font
                   titleColor:(UIColor *)titleColor
                  normalImage:(UIImage *)normalImage
                selectedImage:(UIImage *)selectedImage {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.text = title;
        self.titleLabel.font = font;
        self.titleLabel.textColor = titleColor;
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [self setImage:normalImage forState:UIControlStateNormal];
        [self setImage:selectedImage forState:UIControlStateSelected];
    }
    return self;
}

@end
