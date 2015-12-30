//
//  CYTipView.h
//  ScanWorld
//
//  Created by qianfeng on 15/12/20.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completionBlock)(BOOL finished);

@interface CYTipView : UIView

+ (void)animationTipViewWithMessage:(NSString *)message duration:(NSTimeInterval)duration completion:(completionBlock)completion;
@end
