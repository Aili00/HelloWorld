//
//  UserModel.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/20.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel


+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.emailStatus forKey:@"emailStatus"];
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.roles forKey:@"roles"];
    [aCoder encodeObject:self.screenName forKey:@"screenName"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.token forKey:@"token"];
}

//接档
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.emailStatus = [aDecoder decodeObjectForKey:@"emailStatus"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.roles = [aDecoder decodeObjectForKey:@"roles"];
        self.screenName = [aDecoder decodeObjectForKey:@"screenName"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
    }
    
    return self;
}

@end

//@implementation TokenModel
//
//+ (BOOL)propertyIsOptional:(NSString *)propertyName {
//    return YES;
//}
//
////归档
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:self.apikey forKey:@"apikey"];
//    [aCoder encodeObject:self.createdAt forKey:@"createdAt"];
//    [aCoder encodeObject:self.dailyRate forKey:@"dailyRate"];
//    [aCoder encodeObject:self.expiredAt forKey:@"expiredAt"];
//    [aCoder encodeObject:self.hourlyRate forKey:@"hourlyRate"];
//    [aCoder encodeObject:self.id forKey:@"id"];
//    [aCoder encodeObject:self.level forKey:@"level"];
//    [aCoder encodeObject:self.minutelyRate forKey:@"minutelyRate"];
//    [aCoder encodeObject:self.refreshedAt forKey:@"refreshedAt"];
//    [aCoder encodeObject:self.userId forKey:@"userId"];
//}
////接档
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super init]) {
//        self.apikey = [aDecoder decodeObjectForKey:@"apikey"];
//        self.createdAt = [aDecoder decodeObjectForKey:@"createdAt"];
//        self.dailyRate = [aDecoder decodeObjectForKey:@"dailyRate"];
//        self.expiredAt = [aDecoder decodeObjectForKey:@"expiredAt"];
//        self.hourlyRate = [aDecoder decodeObjectForKey:@"hourlyRate"];
//        self.id = [aDecoder decodeObjectForKey:@"id"];
//        self.level = [aDecoder decodeObjectForKey:@"level"];
//        self.minutelyRate = [aDecoder decodeObjectForKey:@"minutelyRate"];
//        self.refreshedAt = [aDecoder decodeObjectForKey:@"refreshedAt"];
//        self.userId = [aDecoder decodeObjectForKey:@"userId"];
//    }
//    return self;
//}

//@end