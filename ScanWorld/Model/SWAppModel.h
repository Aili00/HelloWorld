//
//  SWAppModel.h
//  ScanWorld
//
//  Created by qianfeng on 15/12/17.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import <JSONModel/JSONModel.h>


/*
 "id": "227539",
 "title": "美联储加息25基点 美股大涨 美元上涨后回落破98",
 "slug": "D0eQ37xc",
 "type": "news",
 
 "codeType": "html",
 "createdAt": "1450296288",
 "summary": "<p>北京时间凌晨3点，美联储12月FOMC会议宣布加息25个基点。消息公布后，美股持续上涨，标普涨幅突破1%；美元上涨后回落，再度跌破98关口；黄金震荡，整体看较声明公布前有所上涨；美债收益率下跌后上扬；离岸人民币兑美元先走低后上涨。</p>\r\n",
 "summaryHtml": "<p>北京时间凌晨3点，美联储12月FOMC会议宣布加息25个基点。消息公布后，美股持续上涨，标普涨幅突破1%；美元上涨后回落，再度跌破98关口；黄金震荡，整体看较声明公布前有所上涨；美债收益率下跌后上扬；离岸人民币兑美元先走低后上涨。</p>\r\n",
 
 "commentStatus": "open",
 "sourceName": "",
 "sourceUrl": "",
 "count": "142496",
 
 "commentCount": "57",
 "url": "http://wallstreetcn.com/node/227539",
 "imageUrl": "http://posts.cdn.wallstcn.com/73/92/57/-2.jpg",
 "tags":
 [
 
 {
 "id": "14682",
 "tagName": "美联储加息靴子落地"
 }
 
 ],
 "user":
 
 {
 "id": "66068",
 "username": "shuzi",
 "screenName": "张舒"
 }
 
 },
 */
/*createdAt = 1450767934;
 id = 1015847;
 post =             {
 codeType = html;
 commentStatus = "";
 createdAt = 1450767934;
 id = 227745;
 imageUrl = "http://posts.cdn.wallstcn.com/93/40/29/cfp455685655.jpg";
 sourceName = "";
 sourceUrl = "http://wallstreetcn.com/node/227745";
 summary = "<p>\U4e2d\U56fdA\U80a1\U6709\U8272\U7248\U5757\U5347\U52bf\U4e0d\U51cf\Uff0c\U672c\U5468\U4e8c\U5347\U81f3\U8fd1\U4e00\U4e2a\U6708\U9ad8\U4f4d\Uff0c\U9664\U4e86\U91d1\U5c5e\U4ef7\U683c\U4e0a\U626c\U548c\U653f\U7b56\U5c42\U9762\U5229\U597d\U7684\U77ed\U671f\U523a\U6fc0\Uff0c\U90e8\U5206\U5206\U6790\U5e08\U8ba4\U4e3a\U4e2d\U56fd\U7ecf\U6d4e\U7684\U5e93\U5b58\U5468\U671f\U5e95\U90e8\U6e10\U884c\U6e10\U8fd1\Uff0c\U4ee5\U6709\U8272\U3001\U5730\U4ea7\U7b49\U4e3a\U4ee3\U8868\U7684\U5468\U671f\U80a1\U5c06\U51fa\U73b0\U9006\U88ad\Uff0c\U8fd9\U662f\U6709\U8272\U7248\U5757\U4e0a\U6da8\U80cc\U540e\U7684\U5927\U903b\U8f91\U3002</p>
 \n";
 summaryHtml = "<p>\U4e2d\U56fdA\U80a1\U6709\U8272\U7248\U5757\U5347\U52bf\U4e0d\U51cf\Uff0c\U672c\U5468\U4e8c\U5347\U81f3\U8fd1\U4e00\U4e2a\U6708\U9ad8\U4f4d\Uff0c\U9664\U4e86\U91d1\U5c5e\U4ef7\U683c\U4e0a\U626c\U548c\U653f\U7b56\U5c42\U9762\U5229\U597d\U7684\U77ed\U671f\U523a\U6fc0\Uff0c\U90e8\U5206\U5206\U6790\U5e08\U8ba4\U4e3a\U4e2d\U56fd\U7ecf\U6d4e\U7684\U5e93\U5b58\U5468\U671f\U5e95\U90e8\U6e10\U884c\U6e10\U8fd1\Uff0c\U4ee5\U6709\U8272\U3001\U5730\U4ea7\U7b49\U4e3a\U4ee3\U8868\U7684\U5468\U671f\U80a1\U5c06\U51fa\U73b0\U9006\U88ad\Uff0c\U8fd9\U662f\U6709\U8272\U7248\U5757\U4e0a\U6da8\U80cc\U540e\U7684\U5927\U903b\U8f91\U3002</p>
 \n";
 title = "\U6709\U8272\U53cd\U5f39\U81f3\U4e00\U4e2a\U6708\U9ad8\U4f4d \U5468\U671f\U80a1\U6619\U82b1\U4e00\U73b0\U8fd8\U662f\U9006\U88ad\U4e34\U8fd1\Uff1f";
 type = "";
 url = "http://wallstreetcn.com/node/227745";
 user =                 {
 id = "";
 screenName = "";
 username = "";*/

@protocol TagModel <NSObject>
@end
@interface TagModel : JSONModel
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *tagName;
@end


@interface SWUserModel : JSONModel
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *screenName;
@end


@protocol ResultModel
@end
@interface ResultModel : JSONModel
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *slug;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *codeType;
@property (nonatomic,copy) NSString *createdAt;
@property (nonatomic,copy) NSString *summary;
@property (nonatomic,copy) NSString *summaryHtml;
@property (nonatomic,copy) NSString *commentStatus;
@property (nonatomic,copy) NSString *sourceName;
@property (nonatomic,copy) NSString *sourceUrl;
@property (nonatomic,copy) NSString *count;
@property (nonatomic,copy) NSString *commentCount;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,strong) NSArray<TagModel> *tags;
@property (nonatomic,strong) SWUserModel *user;
@property (nonatomic,strong) NSString *favTime;
@end


@interface PaginatorModle : JSONModel
@property (nonatomic,copy) NSString *total;
@property (nonatomic,copy) NSString *previous;
@property (nonatomic,copy) NSString *next;
@property (nonatomic,copy) NSString *last;
@end

@interface SWAppModel : JSONModel
@property (nonatomic,strong) PaginatorModle<Optional> *paginator;
@property (nonatomic,strong) NSArray<ResultModel> *results;

@end

