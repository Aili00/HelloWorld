//
//  SWNewsCell.h
//  ScanWorld
//
//  Created by qianfeng on 15/12/17.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWAppModel.h"

@interface SWNewsCell : UITableViewCell

- (void)updateWithData:(ResultModel *)resultModel;

@end
