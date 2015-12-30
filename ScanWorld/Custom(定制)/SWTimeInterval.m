//
//  SWTimeInterval.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/17.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "SWTimeInterval.h"

@implementation SWTimeInterval

+ (NSString *)timeInterval:(NSString *)sourceTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];

    NSTimeInterval createTime = [sourceTime doubleValue];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    
    NSInteger time =fabs(currentTime - createTime);
    if (time < 24*60*60) {
        int hour = (int)time/3600;
        int min = ((int)time%3600)/60;
        if (hour == 0) {
            if (min < 5) {
                return  @"刚刚";
            }
            else{
                return  [NSString stringWithFormat:@"%d分钟前",min];
            }
        }
        else {
            return  [NSString stringWithFormat:@"%d小时前",hour];
        }
    }
    else
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970: [sourceTime doubleValue]];
        NSString *dataString = [formatter stringFromDate:date];
        NSLog(@"str = %@",dataString);
       return  [NSString stringWithFormat:@"%@",[dataString substringWithRange:NSMakeRange(5, 11)]];
    }
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    formatter.dateFormat = @"MM-dd HH:mm";
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:createTime];
//    NSString *dateString  = [formatter stringFromDate:date];
//    return dateString;
}

@end
