//
//  NewsDetailViewController.h
//  ScanWorld
//
//  Created by qianfeng on 15/12/17.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWAppModel.h"

@interface NewsDetailViewController : UIViewController

@property (nonatomic,copy) NSString *newsUrl;

@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,copy) NSString *newsId;

@property (nonatomic,copy) NSString *newsTitle;

- (instancetype)initWithNewsUrl:(NSString *)newsUrl;
@end
