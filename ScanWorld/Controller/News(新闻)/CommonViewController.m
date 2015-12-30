//
//  CommonViewController.m
//  ScanWorld
//
//  Created by qianfeng on 15/12/19.
//  Copyright © 2015年 Aili. All rights reserved.
//

#import "CommonViewController.h"
#import "CommentCell.h"
#import "SWNewDetailModel.h"
#import "OthersCommentModel.h"
#import "CYTipView.h"
#import "CommentCellFrame.h"

@interface CommonViewController ()<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate> {
    NSString *_newsId;
    SWNewDetailModel *_newsDetailModel;
    NSMutableArray *_dataArray;
    NSString *_threadId;
    OthersCommentModel *_othersCommentModel;
    NSMutableData *_mutableData;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@end

@implementation CommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   //监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    _dataArray = [NSMutableArray new];
    _mutableData = [NSMutableData new];
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.backgroundColor = SWContentColor;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchDataFromNet];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
 
    self.tableView.estimatedRowHeight = 200;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 初始化
- (instancetype)initWithNewsId:(NSString *)newsId {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (self = [super init]) {
        self = [storyBoard instantiateViewControllerWithIdentifier:@"CommonViewController"];
        _newsId = newsId;
    }
    return self;
}

#pragma mark - 请求数据
- (void)fetchDataFromNet {
    NSString *urlString = [NSString stringWithFormat:SWNEWS_DETAIL_URL,_newsId];
    [NetWorkingManager requestDataWithUrl:urlString pageType:SWCOMMENT_TYPE successBlock:^(id model) {
       // _newsDetailModel = model;
        NSDictionary *comments=  [(NSDictionary *)model objectForKey:@"comments"];
        _threadId = comments[@"id"];
        NSLog(@"_threadId:%@",_threadId);
         
        NSString *commentUrl = [NSString stringWithFormat:SWNEWS_DETAIL_COMMON_URL,_threadId];
        
        [NetWorkingManager requestDataWithUrl:commentUrl pageType:SWCOMMENT_DETAIL_TYPE successBlock:^(id model) {
            _othersCommentModel = model;
            [_dataArray removeAllObjects];
            [self.tableView reloadData];
            
             [_dataArray addObjectsFromArray:_othersCommentModel.comments];
            [self.tableView reloadData];
        } faildBlock:^(NSError *error) {
            [CYTipView animationTipViewWithMessage:@"服务器小差啦-_-#" duration:AnimationTime completion:nil];
            NSLog(@"comment_error:%@",error.localizedDescription);
        }];
      
        [self.tableView.mj_header endRefreshing];
    } faildBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        NSLog(@"threadID_error:%@",error.localizedDescription);
    }];
}


#pragma mark - 监听键盘弹出
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    CGFloat duration = [dict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frameEnd = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, frameEnd.origin.y - ScreenHeight);
    }];
}

#pragma mark - 发送评论
- (IBAction)sendAciton:(id)sender {
    if (self.inputTextField.text.length <= 0) {
        [CYTipView animationTipViewWithMessage:@"请输入评论内容" duration:AnimationTime completion:nil];
    }
    else{
//        NSString *strTmp = [SWNEWS_COMMENT_POST stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:SWNEWS_COMMENT_POST]];
        NSString *content = [NSString stringWithString:[self.inputTextField.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSDictionary *parameters = @{@"content":content,@"threadId":_threadId,@"parentId":@"0"};
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content_type"];
        
        [urlRequest setValue:[NSString stringWithFormat:@"%lu",(unsigned long)data.length] forHTTPHeaderField:@"Content_length"];
        [urlRequest setValue:[NSString stringWithFormat:@" token %@",[UserInfoManager shareManager].userModel.token[@"apikey"]] forHTTPHeaderField:@"Authorization"];
        [urlRequest setHTTPBody:data];
        [urlRequest setHTTPMethod:@"POST"];
        
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
        [connection start];
    }
}

#pragma  mark - 返回
- (IBAction)backAction:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = SWContentColor;
    [cell UpdateWithModelData:_dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - NSURLConnectionDataDelegate
#pragma mark - 服务器端有应答
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [_mutableData setLength:0];
    NSLog(@"服务器开始应答。。。。。。");
}

#pragma mark - 开始接收到收据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_mutableData appendData:data];
    NSLog(@"开始接收数据。。。。。。");
}

#pragma mark - 服务器端响应失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"error:%@",error);
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    NSLog(@"response:%@",response);
    return request;
}
#pragma mark - 接收数据完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"数据接收完成");
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:_mutableData options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"dict%@",dict);
    
    self.inputTextField.text = @"";
    [self.inputTextField resignFirstResponder];
   [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - 移除观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
