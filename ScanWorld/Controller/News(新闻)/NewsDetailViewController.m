 //
//  NewsDetailViewController.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/17.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "NewsDetailViewController.h"
#import <WebKit/WebKit.h>
#import "CYButtonFactory.h"
#import "LoginViewController.h"
#import "CommonViewController.h"
#import "UserInfoManager.h"
#import "CYTipView.h"
#import "DBManager.h"
#import "MyFavoriteModel.h"

@interface NewsDetailViewController ()<WKNavigationDelegate,UMSocialUIDelegate> {
    WKWebView *_webView;
    NSArray *_favoriteArray;
    MBProgressHUD *_progressHUD;
    }
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,assign) BOOL isFavorited;
@property (nonatomic,strong) CYButtonFactory *favButton;
@property (nonatomic,strong) CYButtonFactory *shareButton;
@property (nonatomic,strong) CYButtonFactory *commentButton;
@property (nonatomic,strong) CYButtonFactory *backButton;


@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = SWContentColor;
    _progressHUD = [MBProgressHUD new];
    [self createWebView];
    [self customNaviBar];
}

- (void)viewWillAppear:(BOOL)animated {
    //判断是否是收藏数据
    [self isFavoriteData];
}

- (instancetype)initWithNewsUrl:(NSString *)newsUrl {
    self = [super init];
    if (self) {
        _newsUrl = newsUrl;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)customNaviBar {
    
    UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavHeight)];
    barView.backgroundColor = SWBaseColor;
    [self.view addSubview:barView];
    
    CGFloat buttonW = 40;
    CGFloat buttonH = 40;
    CGFloat buttonY = 20;
    CGFloat trailing = 8;
    //返回
    _backButton = [[CYButtonFactory alloc]initWithFrame:CGRectMake(0, buttonY, buttonW, buttonH) title:@"" font:[UIFont systemFontOfSize:17] titleColor:[UIColor whiteColor] normalImage:[UIImage imageNamed:@"normalback_subscription"] selectedImage:nil];
    [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:_backButton];
    
    //评论
    _commentButton =  [[CYButtonFactory alloc]initWithFrame:CGRectMake(ScreenWidth-trailing-buttonW, buttonY, buttonW, buttonH) title:nil font:nil titleColor:nil normalImage:[UIImage imageNamed:@"commen_blue"] selectedImage:nil];
    [_commentButton addTarget:self action:@selector(commonAction) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:_commentButton];
    
    //分享
    _shareButton = [[CYButtonFactory alloc]initWithFrame:CGRectMake(CGRectGetMinX(_commentButton.frame)-trailing-buttonW,buttonY , buttonW, buttonH) title:nil font:nil titleColor:nil normalImage:[UIImage imageNamed:@"fenxiang"] selectedImage:[UIImage imageNamed:@"fenxiang"]];
    [_shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:_shareButton];
    
    //收藏
    _favButton = [[CYButtonFactory alloc]initWithFrame:CGRectMake(CGRectGetMinX(_shareButton.frame)-trailing-buttonW, buttonY, buttonW, buttonH) title:nil font:nil titleColor:nil normalImage:[UIImage imageNamed:@"mcollect"] selectedImage:nil];
    [self isFavoriteData];
    [_favButton addTarget:self action:@selector(favAction) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:_favButton];
}

/**
 *  点击分享 不编辑 直接分享
 *
 *  @return <#return value description#>
 */
- (BOOL)isDirectShareInIconActionSheet {
    return YES;
}

#pragma mark － 返回
- (void)backAction {
    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - 获取收藏数据
- (void)isFavoriteData {
    UserInfoManager *userManger = [UserInfoManager shareManager];
    UserModel *userModel = userManger.userModel;
    //未登录
    if (userModel.token == nil) {
        return;
    }
    //已登录
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@" token %@",userModel.token[@"apikey"]] forHTTPHeaderField:@"Authorization"];
    NSString *urlString = [NSString stringWithFormat:SWNEWS_USER_FAVORITE_ALL,1];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        MyFavoriteModel *model = [[MyFavoriteModel alloc]initWithDictionary:dict error:nil];
        _favoriteArray = model.results;
        
        for (CResultModel *cmodel in _favoriteArray) {
            if ([_newsId isEqualToString: cmodel.post.id]) {
                [ _favButton setImage:[UIImage imageNamed:@"mcollect_selected"] forState:UIControlStateNormal];
                return ;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"favorite_error-----%@",error);
        [CYTipView animationTipViewWithMessage:@"服务器开小差啦-_-#" duration:AnimationTime completion:nil];
    }];
}

#pragma mark - 评论
- (void)commonAction {
    //取本地数据
    UserModel *userModel = [UserInfoManager shareManager].userModel;
    //当前用户未登录
    if (userModel.token == nil) {
        //登陆  注册
        LoginViewController *loginViewController = [LoginViewController new];
        loginViewController.newsId = _newsId;
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
    //已登录
    else {
        
        CommonViewController *commonVC = [[CommonViewController alloc]initWithNewsId:_newsId];
        [self presentViewController:commonVC animated:YES completion:nil];
    }
}

#pragma mark - 分享
- (void)shareAction {
    if ([ UserInfoManager shareManager].userModel.token == nil) {
        [CYTipView animationTipViewWithMessage:@"未登录，请先登录" duration:AnimationTime completion:nil];
    }
    else {
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = _newsUrl;
        NSString *shareString = [NSString stringWithFormat:@"%@%@",self.newsTitle,self.newsUrl];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 40, 30)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [UMSocialSnsService presentSnsIconSheetView:self appKey:@"5674ae48e0f55a5c04006675" shareText:shareString shareImage:image shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatTimeline,nil] delegate:self];
        }];
    }
}

#pragma mark - 收藏
- (void)favAction {
    UserInfoManager *userManager = [UserInfoManager shareManager];
    AFHTTPSessionManager *managerAF = [AFHTTPSessionManager manager];
    //未登录
    if (userManager.userModel.token == nil) {
            LoginViewController *loginVC = [LoginViewController new];
            loginVC.newsId = _newsId;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else {
        managerAF.responseSerializer = [AFHTTPResponseSerializer serializer];
        managerAF.requestSerializer = [AFHTTPRequestSerializer serializer];
        [managerAF.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [managerAF.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Type"];
        [managerAF.requestSerializer setValue:[NSString stringWithFormat:@" token %@",userManager.userModel.token[@"apikey"]] forHTTPHeaderField:@"Authorization"];
        NSString *urlString = [NSString stringWithFormat:SWNEWS_FAVORITE_URL,self.newsId];
        //取消收藏
        if (_isFavorited) {
            //提示 是否确认取消收藏
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleAlert];
            //确认取消
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [managerAF DELETE:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    // NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    // NSLog(@"DELDE:%@",dict);
                    
                    [CYTipView animationTipViewWithMessage:@"取消收藏成功！" duration: AnimationTime completion:nil];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [CYTipView animationTipViewWithMessage:@"服务器开小差啦！取消失败！" duration:AnimationTime completion:nil];
                }];
                _isFavorited = !_isFavorited;
            }]];
            //不确认 取消
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }]];
        }
        //收藏
        else {
            [managerAF PUT:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                // NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                // NSLog(@"SUCCESS:%@",dict);
                
                [CYTipView animationTipViewWithMessage:@"收藏成功！" duration: AnimationTime completion:nil];
                [_favButton setImage:[UIImage imageNamed:@"mcollect_selected"] forState:UIControlStateNormal];
                _isFavorited = !_isFavorited;
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [CYTipView animationTipViewWithMessage:@"服务器开小差啦！收藏失败！" duration:AnimationTime completion:nil];
            }];
            
        }
    }
    
}

#pragma mark - 创建 webView
- (void)createWebView {
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _webView.backgroundColor = SWContentColor;
    _webView.scrollView.backgroundColor = SWContentColor;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    [MBProgressHUD showHUDAddedTo:_webView animated:YES];
    
    //我的收藏到详情页 先取到Url
    //if (self.newsUrl == nil) [self fetchNewsUrlFromNet];
 
    NSURL *url = [NSURL URLWithString:_newsUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
    
    /**
     *  打印一下 文档信息
     */
  /*  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
   // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"http/json",@"http/html",@"http/txt", nil];
   [manager GET:self.model.url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
       
   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       NSString *htmlString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
       NSLog(@"%@",htmlString);
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
   }];
   */
    
}

#pragma mark - 拼接newsUrl
- (void)fetchNewsUrlFromNet {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    NSString *urlString = [NSString stringWithFormat:SWNEWS_DETAIL_URL,_newsId];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        _newsUrl = dict[@"url"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


#pragma mark - －－－－－－－－－－－－WKWebViewDelegate

#define SWFINDAD_JS @"var SWAD = document.getElementsByClassName('%@')[0];"
#define SWDELETE_JS @"SWAD.parentNode.removeChild(SWAD);"

/**
 *  网页下载完后 删除广告
 *
 *  @param webView
 *  @param navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //隐藏进度指示器
    [MBProgressHUD hideHUDForView:_webView animated:YES];

    /**
     删除 头部 广告
     */
    NSMutableString *jsString = [[NSMutableString alloc]init];
    NSString *header_ad = [NSString stringWithFormat:SWFINDAD_JS,@"toolbar"];
    [jsString appendString:header_ad];
    [jsString appendString:SWDELETE_JS];
    
    /**
     *  删除 中间 下载app 内容
     */
    NSString *center_ad = [NSString stringWithFormat:SWFINDAD_JS,@"hide-for-app"];
    [jsString appendString:center_ad];
    [jsString appendString:SWDELETE_JS];
    
    /**
     *  删除评论
     */
    NSString *comments_ad = [NSString stringWithFormat:SWFINDAD_JS,@"hot-comments"];
    [jsString appendString:comments_ad];
    [jsString appendString:SWDELETE_JS];
    
    /**
     *  删除分享
     */
    NSString *share_ad = [NSString stringWithFormat:SWFINDAD_JS,@"sharebar"];
    [jsString appendString:share_ad];
    [jsString appendString:SWDELETE_JS];
    
    /**
     *  删除 宣传图
     */
    NSString *icon_ad = [NSString stringWithFormat:SWFINDAD_JS,@"ad"];
    [jsString appendString:icon_ad];
    [jsString appendString:SWDELETE_JS];
    
    [self deleteADFormWebview:webView jsString:jsString];
    
   
}

/**
 *  webView 处理删除语句
 *
 *  @param webView  <#webView description#>
 *  @param jsString <#jsString description#>
 */
- (void)deleteADFormWebview:(WKWebView *)webView jsString:(NSString *)jsString {
    [webView evaluateJavaScript:jsString completionHandler:^(id _Nullable action, NSError * _Nullable error) {
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
