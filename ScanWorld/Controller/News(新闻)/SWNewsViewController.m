//
//  SWNewsViewController.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/16.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "SWNewsViewController.h"
#import "SWAppModel.h"
#import "SWNewsCell.h"
#import "HYBLoopScrollView.h"
#import "NewsDetailViewController.h"

#define PAGECOUNT 25
#define REUSEDID @"identifity"

@interface SWNewsViewController () {
      BOOL _isGlobePage;
}

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *scrollData;
@property (nonatomic,strong) NSMutableArray *imagesArray;
@property (nonatomic,strong) NSMutableArray *banleTitles;
@property (nonatomic) NSInteger page;


@end

@implementation SWNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initData];
    [self customTableView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    _dataArray = [NSMutableArray new];
    _scrollData = [NSMutableArray new];
    _imagesArray = [NSMutableArray new];
    _banleTitles = [NSMutableArray new];
    _page = 1;
}

- (void)customTableView {
    if ([self.pageType isEqualToString:SWGLOBE_TYPE]) {
        [self customTableViewHeadView];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SWNewsCell" bundle:nil] forCellReuseIdentifier:REUSEDID];
    self.tableView.backgroundColor = SWContentColor;
    self.tableView.rowHeight = 84;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchDataFromNet:NO];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self fetchDataFromNet:YES];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark － 定制 头视图
- (void)customTableViewHeadView {
    [NetWorkingManager requestDataWithUrl:SWGLOBE_TITLE_URL pageType:SWGLOBE_HEADEREVIEW successBlock:^(id model) {
        SWAppModel *appModel = model;
        [_scrollData addObjectsFromArray:appModel.results];
        
        for (ResultModel *resultModel in _scrollData) {
            [_imagesArray addObject:resultModel.imageUrl];
            [_banleTitles addObject:resultModel.title];
        }
        
        HYBLoopScrollView *loopScrollView = [HYBLoopScrollView loopScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 200) imageUrls:_imagesArray timeInterval:10.0 didSelect:^(NSInteger atIndex, HYBLoadImageView *sender) {
            ResultModel *resultModel = _scrollData[atIndex];
            
            NewsDetailViewController *newsDetailVC = [[NewsDetailViewController alloc]initWithNewsUrl:resultModel.url];
            newsDetailVC.newsId = resultModel.id;
            newsDetailVC.imageUrl = resultModel.imageUrl;
            newsDetailVC.newsTitle = resultModel.title;
            [self presentViewController:newsDetailVC animated:YES completion:nil];
        } didScroll:^(NSInteger toIndex, HYBLoadImageView *sender) {
            
        }];
        loopScrollView.alignment = kPageControlAlignRight;
        loopScrollView.adTitles = _banleTitles;
        self.tableView.tableHeaderView = loopScrollView;
        
    } faildBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 请求数据
- (void)fetchDataFromNet:(BOOL)isMore {
    if (isMore) self.page ++;
    else _page = 1;
    
    NSString *urlString = [NSString stringWithFormat:self.requestUrl,self.page];
    
    [NetWorkingManager requestDataWithUrl:urlString pageType:nil successBlock:^(id model) {
        if (!isMore) {
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
        }
        SWAppModel *appModel = model;
        [self.dataArray addObjectsFromArray:appModel.results];
        [self.tableView reloadData];
        
        isMore?[self.tableView.mj_footer endRefreshing]:[self.tableView.mj_header endRefreshing];
    } faildBlock:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        isMore?[self.tableView.mj_footer endRefreshing]:[self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SWNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSEDID forIndexPath:indexPath];
    ResultModel *model = _dataArray[indexPath.row];
    [cell updateWithData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultModel *resultModel = _dataArray[indexPath.row];
    NewsDetailViewController *detailViewController = [[NewsDetailViewController alloc]initWithNewsUrl:resultModel.url];
    detailViewController.newsId = resultModel.id;
    detailViewController.imageUrl = resultModel.imageUrl;
    detailViewController.newsTitle = resultModel.title;
    [self presentViewController:detailViewController animated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
