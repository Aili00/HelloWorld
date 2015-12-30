//
//  MYCommentViewController.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/23.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "MYCommentViewController.h"
#import "UserInfoManager.h"
#import "MYCommentCell.h"
#import "MyCommentModel.h"
#import "NewsDetailViewController.h"


@interface MYCommentViewController ()<UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *_dataArray;
    NSInteger _count;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MYCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [NSMutableArray new];
    _count = 20;
    [self customTableView];
}

- (instancetype)init {
    if (self = [super init]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self = [storyBoard instantiateViewControllerWithIdentifier:@"MYCommentViewController"];
    }
    return self;
}

#pragma mark - 设置TableView
- (void)customTableView {
    self.tableView.rowHeight = 64;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchDataFromNet:NO];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self fetchDataFromNet:YES];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma  mark - 网络请求数据
- (void)fetchDataFromNet:(BOOL)isMore {
    //是否加载更多
    if (isMore) {
        if (_dataArray.count % 20 == 0) _count +=20;
        else {
           [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
    }
    else _count = 20;
    
    UserInfoManager *userManager = [UserInfoManager shareManager];
    UserModel *userModel = userManager.userModel;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@" token %@",userModel.token[@"apikey"]] forHTTPHeaderField:@"Authorization"];
   // [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSString *urlString = [NSString stringWithFormat:SW_USER_COMMON,_count];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (!isMore) {
            [_dataArray removeAllObjects];
            [self.tableView reloadData];
        }
        
        MyCommentModel *model = [[MyCommentModel alloc]initWithDictionary:dict error:nil];
        [_dataArray addObjectsFromArray:model.comments];
        [self.tableView reloadData];
        
        isMore?[self.tableView.mj_footer endRefreshing]:[self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"MYCOMMENT_ERROR%@",error);
         isMore?[self.tableView.mj_footer endRefreshing]:[self.tableView.mj_header endRefreshing];
        [CYTipView animationTipViewWithMessage:@"服务器开小差啦-_-#" duration:AnimationTime completion:nil];
        
    }];
    
    
    
}

#pragma mark - 返回
- (IBAction)backAction:(id)sender {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MMDrawerController *drawController = (MMDrawerController *)window.rootViewController;
    
    [self dismissViewControllerAnimated:YES completion:^{
        [drawController closeDrawerAnimated:YES completion:nil];
    }];
    
}



#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MYCommentsModel *model = _dataArray[indexPath.row];
    MYCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYCommentCellID" forIndexPath:indexPath];
    
    [cell updateWithData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MYCommentsModel *model = _dataArray[indexPath.row];
    NewsDetailViewController *newDetailVC = [[NewsDetailViewController alloc]initWithNewsUrl:model.article.permalink];
    newDetailVC.newsId = model.article.id;
    newDetailVC.newsTitle = model.article.title;
    [self presentViewController:newDetailVC animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
