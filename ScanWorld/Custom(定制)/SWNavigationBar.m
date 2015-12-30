//
//  SWNavigationBar.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/16.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "SWNavigationBar.h"

@implementation SWNavigationBar

- (instancetype)init {
    self = [super init];
    if (self) {
        UIView *backView = [[UIView alloc]initWithFrame:self.bounds];
        backView.backgroundColor = SWColor(103, 146, 219, 1);
        [self addSubview:backView];
    }
    return self;
}
@end
