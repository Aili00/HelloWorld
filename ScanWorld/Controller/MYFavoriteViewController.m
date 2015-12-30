//
//  MYFavoriteViewController.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/23.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "MYFavoriteViewController.h"
#import "MYFavoriteCell.h"
#import "MyFavoriteModel.h"
#import "NewsDetailViewController.h"

@interface MYFavoriteViewController ()<UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *_dataArray;
    NSInteger _page;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MYFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [NSMutableArray new];
    [self customTableView];
}

- (instancetype)init {
    if (self = [super init]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self =  [storyBoard instantiateViewControllerWithIdentifier:@"MYFavoriteViewController"];
        
    }
    return self;
}

- (void)customTableView {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchDataFromNet:NO];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self fetchDataFromNet:YES];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)fetchDataFromNet:(BOOL)isMore {
    if (isMore) {
        if (_dataArray.count % 25 == 0) _page ++;
        else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
    }
    else _page = 0;
    
    UserInfoManager *userManager = [UserInfoManager shareManager];
    UserModel *userModel = userManager.userModel;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; 
    [manager.requestSerializer setValue:[NSString stringWithFormat:@" token %@",userModel.token[@"apikey"]] forHTTPHeaderField:@"Authorization"];
    NSString *urlString = [NSString stringWithFormat:SWNEWS_USER_FAVORITE_LIST, _page];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (!isMore) {
            [_dataArray removeAllObjects];
            [self.tableView reloadData];
        }
        MyFavoriteModel *model = [[MyFavoriteModel alloc]initWithDictionary:dict error:nil];
        
        [_dataArray addObjectsFromArray:model.results];
        [self.tableView reloadData];
        
        isMore?[self.tableView.mj_footer endRefreshing]:[self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"favorite_error-----%@",error);
        isMore?[self.tableView.mj_footer endRefreshing]:[self.tableView.mj_header endRefreshing];
        [CYTipView animationTipViewWithMessage:@"服务器开小差啦-_-#" duration:AnimationTime completion:nil];
    }];
  
    
}

#pragma  mark - 返回

- (IBAction)backAction:(id)sender {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MMDrawerController *drawerController = (MMDrawerController *)window.rootViewController;
    [self dismissViewControllerAnimated:YES completion:^{
        [drawerController closeDrawerAnimated:YES completion:nil];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MYFavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYFavoriteCellID" forIndexPath:indexPath];
    [cell updateWithData:_dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CResultModel *model = (CResultModel *)_dataArray[indexPath.row];
    NewsDetailViewController *newsDetailVC = [[NewsDetailViewController alloc]initWithNewsUrl:model.post.url];
    newsDetailVC.newsId = model.post.id;
    newsDetailVC.imageUrl = model.post.imageUrl;
    newsDetailVC.newsTitle = model.post.title;
    [self presentViewController:newsDetailVC animated:YES completion:nil];
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
