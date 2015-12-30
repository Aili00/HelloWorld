//
//  MyFavoriteModel.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/23.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "MyFavoriteModel.h"


@implementation MyFavoriteModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end



@implementation PostModel

@synthesize id = _id;

@end

@implementation CPaginatorModle
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}


@end

@implementation CResultModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}


@end

@implementation CUSerModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
